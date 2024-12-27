-- 不是帶參數的，是帶日期以及WHL
CREATE   PROCEDURE P_CALC_MAX_LEVEL
AS
BEGIN
    SET NOCOUNT ON

    IF OBJECT_ID('tempdb..#TEMP2') IS NOT NULL 
    DROP TABLE #TEMP2
    
    CREATE TABLE #TEMP2 (
        ROUTES_ID       VARCHAR(255),
        STARTING_ENTITY VARCHAR(50),
        ENTITY          VARCHAR(50),
        INV_ENTITY      VARCHAR(50),
        RATIO           FLOAT,
        MULTIPLIER      FLOAT NULL,
        ACC_RATIO       FLOAT NULL,
        LEVELS          INT,
        MAX_INV_LEVEL   INT
    )

    -- 先插入第一層
    INSERT INTO #TEMP2 (ROUTES_ID, STARTING_ENTITY, ENTITY, INV_ENTITY, RATIO, MULTIPLIER, ACC_RATIO,LEVELS, MAX_INV_LEVEL)
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
    FROM TEMP1
    WHERE LEVELS=1
    -- 找出最大層級
    DECLARE @maxLevel INT
    SELECT @maxLevel = MAX(MAX_INV_LEVEL) FROM TEMP1

    -- 逐層遞迴
    DECLARE @currLevel INT = 2
    WHILE @currLevel <= @maxLevel
    BEGIN
        INSERT INTO #TEMP2
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
        FROM TEMP1 T1
        JOIN #TEMP2 T2 
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
    -- FROM #TEMP2
    -- ORDER BY INV_ENTITY,LEVELS
    WITH ENTITY_DIRECT AS (
    SELECT 
        ENTITY_CODE AS ENTITY,
        INV_ENTITY_CODE AS INV_ENTITY ,
        RATIO_HOLD AS ratio 
    FROM TRS_FACT_GROUP_INV_REL
    WHERE 
        CAST('2023-12-31' AS DATE) BETWEEN START_DATE AND END_DATE
        AND ENTITY_CODE = 'WHL'
    ), RES AS (
    SELECT DISTINCT  t1.STARTING_ENTITY, t1.inv_entity, t1.ACC_RATIO, t2.ratio AS DIRECT_RATIO 
    FROM INV t1
    JOIN ENTITY_DIRECT t2 ON t1.STARTING_ENTITY = t2.entity AND t1.INV_ENTITY = t2.INV_ENTITY
    WHERE LEVELS=MAX_INV_LEVEL
    )

SELECT  STARTING_ENTITY, INV_ENTITY, ACC_RATIO FROM RES


END;
