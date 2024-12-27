-- 不是帶參數的，是帶日期以及WHL
CREATE   PROCEDURE P_CALC_MAX_LEVEL @PARA VARCHAR(255), @P_DATE DATE 
AS
BEGIN
    WITH parent as( 
        select INV_ENTITY_CODE AS entity,
        ENTITY_CODE AS parent,
        1 AS ratio FROM TRS_FACT_GROUP_INV_REL 
        WHERE RATIO_HOLD >=0.5
        --判斷是否為母公司
        AND @P_DATE BETWEEN START_DATE AND END_DATE
        --日期在起訖日間
        )
        ,PARENT_ROUTE(ROUTES_ID,STARTING_ENTITY, entity, PARENT, ratio, LEVELS) AS (
        SELECT 
        CAST(entity + '-' + PARENT AS VARCHAR(255)) AS ROUTES_ID,
        ENTITY AS STARTING_ENTITY,
        entity,
        PARENT,
        ratio,
        1 AS LEVELS
        FROM PARENT
        WHERE ENTITY = @PARA --用參數控制
        UNION ALL
        SELECT 
        CAST(ip.ROUTES_ID + '-' + i.PARENT AS VARCHAR(255)) AS ROUTES_ID ,
        ip.STARTING_ENTITY,
        i.entity,
        i.PARENT,
        i.ratio ,
        ip.levels + 1 AS LEVELS
        FROM PARENT i --持股事實表
        JOIN PARENT_ROUTE ip ON ip.PARENT = i.entity
        )--SELECT * FROM PARENT_ROUTE
        ,RELATIONS AS (
        SELECT 
        ENTITY_CODE  AS ENTITY,
        INV_ENTITY_CODE AS RELATION,
        CAST(1 AS DECIMAL(24,7)) AS RATIO
        FROM TRS_FACT_REL_PARTY_INFO 
        WHERE ENTITY_CODE = @PARA --用參數控制
        AND PERIOD = YEAR(@P_DATE)
        --  判斷當年度是否為關係人
        ) --SELECT * FROM RELATIONS
        ,INVEST1 AS(
        SELECT 
        CAST(t1.ENTITY_CODE AS VARCHAR(255)) AS ENTITY,
        CAST(t1.INV_ENTITY_CODE AS VARCHAR(255)) AS INV_ENTITY,
        --  避免VARCHAR和NVARCHAR不能UNION的問題
        t1.RATIO_HOLD AS RATIO
        FROM TRS_FACT_GROUP_INV_REL t1
        LEFT JOIN PARENT_ROUTE t2 ON t1.ENTITY_CODE = t2.PARENT AND t1.INV_ENTITY_CODE = t2.ENTITY
        WHERE t2.ENTITY IS NULL
        AND INV_ENTITY_CODE NOT IN (SELECT PARENT FROM PARENT_ROUTE)
        AND INV_ENTITY_CODE != @PARA
        AND @P_DATE BETWEEN START_DATE AND END_DATE
        UNION ALL
        SELECT 
        ENTITY,
        RELATION,
        RATIO
        FROM RELATIONS
        UNION ALL
        SELECT 
        CAST(ENTITY AS VARCHAR(255)),
        CAST(PARENT AS VARCHAR(255)),
        --  避免VARCHAR和NVARCHAR不能UNION的問題
        RATIO
        FROM PARENT_ROUTE)
        ,INVEST_ROUTE(ROUTES_ID,STARTING_ENTITY, entity, inv_entity, ratio, LEVELS) AS ( --遞迴一得到持股路徑
        SELECT 
        CAST(entity+'-'+inv_entity AS VARCHAR(255)) AS ROUTES_ID,
        entity AS STARTING_ENTITY,
        entity,
        inv_entity,
        ratio,
        1 AS LEVELS
        FROM INVEST1
        WHERE  ENTITY = @PARA --用參數控制
        UNION ALL
        SELECT 
        CAST(ip.ROUTES_ID+'-'+i.inv_entity AS VARCHAR(255)) AS ROUTES_ID ,
        ip.STARTING_ENTITY,
        i.entity,
        i.inv_entity,
        i.ratio ,
        ip.levels + 1 AS LEVELS
        FROM Invest1 i --持股事實表
        JOIN INVEST_ROUTE ip ON ip.inv_entity = i.entity
        )
        ,T1 AS( --找路徑最大層
        SELECT 
        ROUTES_ID,
        STARTING_ENTITY, 
        entity, 
        inv_entity, 
        ratio, 
        LEVELS,
        MAX(LEVELS)OVER(PARTITION BY starting_entity,entity,inv_entity) AS MAX_LEVEL,
        MAX(ROUTES_ID)OVER(PARTITION BY starting_entity,entity,inv_entity,LEVELS) AS MAX_ROUTE,
        CASE WHEN MAX(LEVELS)OVER(PARTITION BY starting_entity,entity,inv_entity) != LEVELS THEN 'N'
            WHEN MAX(LEVELS)OVER(PARTITION BY starting_entity,entity,inv_entity) = LEVELS AND MAX(ROUTES_ID)OVER(PARTITION BY starting_entity,entity,inv_entity,LEVELS) != ROUTES_ID THEN 'N'
            ELSE 'Y' END AS KEEP --判斷數據是否要留
        FROM INVEST_ROUTE
        ),T2 AS( --篩出保留路徑
        SELECT
        ROUTES_ID,
        starting_entity, 
        entity, 
        inv_entity, 
        ratio, 
        levels,
        MAX_LEVEL,
        MAX(LEVELS)OVER(PARTITION BY STARTING_ENTITY,INV_ENTITY) AS MAX_INV_LEVEL
        FROM T1
        WHERE 1=1
        AND KEEP = 'Y'
        )
        ,T2_DEFER(ROUTES_ID,STARTING_ENTITY, entity, inv_entity, ratio, LEVELS, MAX_INV_LEVEL) AS( --遞迴二 層級遞延切齊
        SELECT
        ROUTES_ID,
        STARTING_ENTITY, 
        entity, 
        inv_entity, 
        ratio, 
        LEVELS,
        MAX_INV_LEVEL
        FROM T2
        UNION ALL 
        SELECT
        CAST(ROUTES_ID + '-' + INV_ENTITY AS VARCHAR(255)) AS ROUTES_ID,
        STARTING_ENTITY, 
        inv_entity AS entity, 
        inv_entity, 
        ratio, 
        levels+1 AS LEVELS,
        MAX_INV_LEVEL
        FROM T2_DEFER
        WHERE LEVELS+1 <= MAX_INV_LEVEL
        )
    INSERT INTO TEMP_CALCULATE_INV_CONTROL1 (ROUTES_ID, STARTING_ENTITY, entity, inv_entity, ratio, LEVELS, MAX_INV_LEVEL)
    SELECT 
        ROUTES_ID,
        STARTING_ENTITY, 
        entity, 
        inv_entity, 
        ratio, 
        LEVELS,
        MAX_INV_LEVEL
    FROM T2_DEFER

    -- 先插入第一層
    INSERT INTO TEMP_CALCULATE_INV_CONTROL2 (ROUTES_ID, STARTING_ENTITY, ENTITY, INV_ENTITY, RATIO, MULTIPLIER, ACC_RATIO,LEVELS, MAX_INV_LEVEL)
    SELECT 
    ROUTES_ID,
    STARTING_ENTITY, 
    entity, 
    inv_entity, 
    CAST(ratio AS FLOAT) AS RATIO,
    CASE WHEN ratio>=0.5 THEN 1
    ELSE CAST(ratio AS FLOAT) END AS MULTIPLIER,
    CAST(ratio AS FLOAT) AS ACC_RATIO,
    LEVELS ,
    MAX_INV_LEVEL
    FROM TEMP_CALCULATE_INV_CONTROL1
    WHERE LEVELS=1
    -- 找出最大層級
    DECLARE @maxLevel INT
    SELECT @maxLevel = MAX(MAX_INV_LEVEL) FROM TEMP_CALCULATE_INV_CONTROL1

    -- 逐層遞迴
    DECLARE @currLevel INT = 2
    WHILE @currLevel <= @maxLevel
    BEGIN
        INSERT INTO TEMP_CALCULATE_INV_CONTROL2
        (
            ROUTES_ID,
            STARTING_ENTITY,
            ENTITY,
            INV_ENTITY,
            RATIO,
            MULTIPLIER,
            ACC_RATIO,
            LEVELS,
            MAX_INV_LEVEL
            
        )
        SELECT
            T1.ROUTES_ID,
            T1.STARTING_ENTITY,
            T1.ENTITY,
            T1.INV_ENTITY,
            CASE 
                WHEN T1.ENTITY = T1.INV_ENTITY 
                     THEN CAST(T1.RATIO AS FLOAT)
                ELSE CAST(T1.RATIO * T2.MULTIPLIER AS FLOAT)
            END AS RATIO,
            CASE WHEN 
                (
                  CASE WHEN T1.LEVELS = T1.MAX_INV_LEVEL 
                       THEN SUM(
                             CASE WHEN T1.ENTITY = T1.INV_ENTITY 
                                  THEN T1.RATIO 
                                  ELSE T1.RATIO * T2.MULTIPLIER 
                             END
                           ) OVER (PARTITION BY T1.STARTING_ENTITY, T1.INV_ENTITY)
                       WHEN T1.LEVELS != T1.MAX_INV_LEVEL 
                       THEN T1.RATIO 
                  END
                ) >= 0.5
                THEN 1
                ELSE 
                (
                  CASE WHEN T1.LEVELS = T1.MAX_INV_LEVEL 
                       THEN SUM(
                             CASE WHEN T1.ENTITY = T1.INV_ENTITY 
                                  THEN T1.RATIO 
                                  ELSE T1.RATIO * T2.MULTIPLIER 
                             END
                           ) OVER (PARTITION BY T1.STARTING_ENTITY, T1.INV_ENTITY)
                       WHEN T1.LEVELS != T1.MAX_INV_LEVEL 
                       THEN CAST(T1.RATIO AS FLOAT)
                  END
                )
            END AS MULTIPLIER,
            CASE WHEN T1.LEVELS = T1.MAX_INV_LEVEL 
                 THEN SUM(
                       CASE WHEN T1.ENTITY = T1.INV_ENTITY 
                            THEN T1.RATIO 
                            ELSE T1.RATIO * T2.MULTIPLIER 
                       END
                     ) OVER (PARTITION BY T1.STARTING_ENTITY, T1.INV_ENTITY)
                 WHEN T1.LEVELS != T1.MAX_INV_LEVEL 
                 THEN CAST(T1.RATIO AS FLOAT)
            END AS ACC_RATIO,
            T1.LEVELS,
            T1.MAX_INV_LEVEL
        FROM TEMP_CALCULATE_INV_CONTROL1 T1
        JOIN TEMP_CALCULATE_INV_CONTROL2 T2 
            ON  T1.LEVELS = @currLevel
        AND T2.LEVELS = @currLevel - 1
              -- 第一處
  		AND T1.STARTING_ENTITY COLLATE Chinese_Taiwan_Stroke_CI_AS
      			= T2.STARTING_ENTITY COLLATE Chinese_Taiwan_Stroke_CI_AS

		  -- 第二處
		  AND T1.ENTITY COLLATE Chinese_Taiwan_Stroke_CI_AS
		      = T2.INV_ENTITY COLLATE Chinese_Taiwan_Stroke_CI_AS
		
		  -- 第三處 (這裡涉及 ROUTES_ID、INV_ENTITY 同時)
		  AND T1.ROUTES_ID COLLATE Chinese_Taiwan_Stroke_CI_AS
		      = (
		          T2.ROUTES_ID COLLATE Chinese_Taiwan_Stroke_CI_AS 
		          + '-' 
		 + T1.INV_ENTITY COLLATE Chinese_Taiwan_Stroke_CI_AS
        )

        SET @currLevel = @currLevel + 1
    END;
    -- 查詢結果
    -- SELECT *
    -- FROM #TEMP_CALCULATE_INV_CONTROL2
    -- ORDER BY INV_ENTITY,LEVELS
    WITH ENTITY_DIRECT AS (
    SELECT 
        ENTITY_CODE AS ENTITY,
        INV_ENTITY_CODE AS INV_ENTITY ,
        RATIO_HOLD AS ratio 
    FROM TRS_FACT_GROUP_INV_REL
    WHERE 
        @P_DATE BETWEEN START_DATE AND END_DATE
        AND ENTITY_CODE = @PARA
    ), RES AS (
    SELECT DISTINCT  t1.STARTING_ENTITY, t1.inv_entity, t1.ACC_RATIO, t2.ratio AS DIRECT_RATIO 
    FROM INV t1
    JOIN ENTITY_DIRECT t2 ON t1.STARTING_ENTITY = t2.entity AND t1.INV_ENTITY = t2.INV_ENTITY
    WHERE LEVELS=MAX_INV_LEVEL
    )

SELECT  STARTING_ENTITY, INV_ENTITY, ACC_RATIO FROM RES
TRUNCATE TABLE TEMP_CALCULATE_INV_CONTROL1;
TRUNCATE TABLE TEMP_CALCULATE_INV_CONTROL2;
END;
