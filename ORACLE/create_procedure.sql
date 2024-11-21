CREATE OR REPLACE PROCEDURE TRSDB.P_CALCULATE_INV_CONTROL(PARA VARCHAR2, P_DATE DATE) AS
BEGIN
INSERT INTO TRS_FACT_INV_CONTROL(ID, ENTITY_CODE, INV_ENTITY_CODE, RATIO_SUM, RATIO_DIRECT)
SELECT SYS_GUID(), STARTING_ENTITY, INV_ENTITY, TRUNC(ACC_RATIO,4), TRUNC(DIRECT_RATIO,4) FROM
(WITH parent as( 
select INV_ENTITY_CODE AS entity,
ENTITY_CODE AS parent,
1 AS ratio FROM TRS_FACT_GROUP_INV_REL 
WHERE RATIO_HOLD >=0.5
--判斷是否為母公司
AND P_DATE BETWEEN START_DATE AND END_DATE
--日期在起訖日間
)
,PARENT_ROUTE(ROUTES_ID,STARTING_ENTITY, entity, PARENT, ratio, LEVELS) AS (
SELECT 
  entity||'-'||PARENT AS ROUTES_ID,
  ENTITY AS STARTING_ENTITY,
  entity,
  PARENT,
  ratio,
  1 AS LEVELS
  FROM PARENT
  WHERE ENTITY = PARA --用參數控制
UNION ALL
  SELECT 
  ip.ROUTES_ID||'-'||i.PARENT AS ROUTES_ID ,
  ip.STARTING_ENTITY,
  i.entity,
  i.PARENT,
  i.ratio ,
  ip.levels + 1 AS LEVELS
  FROM PARENT i --持股事實表
  JOIN PARENT_ROUTE ip ON ip.PARENT = i.entity
  ),RELATIONS AS (
  SELECT 
  ENTITY_CODE  AS ENTITY,
  INV_ENTITY_CODE AS RELATION,
  CAST(1 AS NUMBER(24,7)) AS RATIO
  FROM TRS_FACT_REL_PARTY_INFO 
  WHERE ENTITY_CODE = PARA --用參數控制
  AND PERIOD = TO_CHAR(P_DATE,'YYYY')
--  判斷當年度是否為關係人
  ) ,INVEST1 AS(
  SELECT 
  CAST(t1.ENTITY_CODE AS NVARCHAR2(255)) AS ENTITY,
  CAST(t1.INV_ENTITY_CODE AS NVARCHAR2(255)) AS INV_ENTITY,
--  避免VARCHAR和NVARCHAR不能UNION的問題
  t1.RATIO_HOLD AS RATIO
  FROM TRS_FACT_GROUP_INV_REL t1
  LEFT JOIN PARENT_ROUTE t2 ON t1.ENTITY_CODE = t2.PARENT AND t1.INV_ENTITY_CODE = t2.ENTITY
  WHERE t2.ENTITY IS NULL
  AND INV_ENTITY_CODE NOT IN (SELECT PARENT FROM PARENT_ROUTE)
  AND INV_ENTITY_CODE != PARA
  AND P_DATE BETWEEN START_DATE AND END_DATE
   UNION ALL
  SELECT 
  ENTITY,
  RELATION,
  RATIO
  FROM RELATIONS
  UNION ALL
   SELECT 
  CAST(ENTITY AS NVARCHAR2(255)),
  CAST(PARENT AS NVARCHAR2(255)),
  --  避免VARCHAR和NVARCHAR不能UNION的問題
  RATIO
  FROM PARENT_ROUTE),INVEST_ROUTE(ROUTES_ID,STARTING_ENTITY, entity, inv_entity, ratio, LEVELS) AS ( --遞迴一得到持股路徑
  SELECT 
  entity||'-'||inv_entity AS ROUTES_ID,
  entity AS STARTING_ENTITY,
  entity,
  inv_entity,
  ratio,
  1 AS LEVELS
  FROM INVEST1
  WHERE  ENTITY = PARA --用參數控制
UNION ALL
SELECT 
  ip.ROUTES_ID||'-'||i.inv_entity AS ROUTES_ID ,
  ip.STARTING_ENTITY,
  i.entity,
  i.inv_entity,
  i.ratio ,
  ip.levels + 1 AS LEVELS
  FROM Invest1 i --持股事實表
  JOIN INVEST_ROUTE ip ON ip.inv_entity = i.entity
),T1 AS( --找路徑最大層
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
),T2_DEFER(ROUTES_ID,STARTING_ENTITY, entity, inv_entity, ratio, LEVELS, MAX_INV_LEVEL) AS( --遞迴二 層級遞延切齊
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
ROUTES_ID||'-'||INV_ENTITY AS ROUTES_ID,
STARTING_ENTITY, 
inv_entity AS entity, 
inv_entity, 
ratio, 
levels+1 AS LEVELS,
MAX_INV_LEVEL
FROM T2_DEFER
WHERE LEVELS+1 <= MAX_INV_LEVEL
),INV(ROUTES_ID,STARTING_ENTITY, entity, inv_entity, ratio,MULTIPLIER, ACC_RATIO, LEVELS,MAX_INV_LEVEL) AS( --遞迴三 逐層計算
SELECT 
ROUTES_ID,
STARTING_ENTITY, 
entity, 
inv_entity, 
ratio,
CASE WHEN ratio>=0.5 THEN 1
ELSE ratio END AS MULTIPLIER,
ratio AS ACC_RATIO,
LEVELS ,
MAX_INV_LEVEL
FROM T2_DEFER
WHERE LEVELS=1
UNION ALL
SELECT
T1.ROUTES_ID,
T1.STARTING_ENTITY, 
T1.entity, 
T1.inv_entity, 
CASE WHEN T1.entity=T1.inv_entity THEN t1.ratio
     WHEN T1.entity!=T1.inv_entity THEN t1.ratio*t2.MULTIPLIER
     END AS ratio,
CASE WHEN 
     (CASE WHEN t1.LEVELS = t1.MAX_INV_LEVEL THEN SUM(CASE WHEN T1.entity=T1.inv_entity THEN t1.ratio WHEN T1.entity!=T1.inv_entity THEN t1.ratio*t2.MULTIPLIER END)OVER(PARTITION BY T1.STARTING_ENTITY,T1.INV_ENTITY) 
     WHEN t1.LEVELS != t1.MAX_INV_LEVEL THEN t1.ratio END ) >=0.5 THEN 1
     ELSE (CASE WHEN t1.LEVELS = t1.MAX_INV_LEVEL THEN SUM(CASE WHEN T1.entity=T1.inv_entity THEN t1.ratio WHEN T1.entity!=T1.inv_entity THEN t1.ratio*t2.MULTIPLIER END)OVER(PARTITION BY T1.STARTING_ENTITY,T1.INV_ENTITY) 
     WHEN t1.LEVELS != t1.MAX_INV_LEVEL THEN t1.ratio END ) END AS MULTIPLIER,
CASE WHEN t1.LEVELS = t1.MAX_INV_LEVEL THEN SUM(CASE WHEN T1.entity=T1.inv_entity THEN t1.ratio WHEN T1.entity!=T1.inv_entity THEN t1.ratio*t2.MULTIPLIER END)OVER(PARTITION BY T1.STARTING_ENTITY,T1.INV_ENTITY) 
     WHEN t1.LEVELS != t1.MAX_INV_LEVEL THEN t1.ratio END AS ACC_RATIO,
T1.LEVELS ,
T1.MAX_INV_LEVEL
FROM T2_DEFER T1
JOIN INV T2 ON T1.LEVELS = T2.LEVELS+1 AND T1.STARTING_ENTITY = T2.STARTING_ENTITY AND T1.ENTITY = T2.INV_ENTITY AND T1.ROUTES_ID = T2.ROUTES_ID||'-'||T1.INV_ENTITY
), ENTITY_DIRECT AS (
SELECT 
ENTITY_CODE AS ENTITY,
INV_ENTITY_CODE AS INV_ENTITY ,
RATIO_HOLD AS ratio 
FROM TRS_FACT_GROUP_INV_REL
WHERE 
	P_DATE BETWEEN START_DATE AND END_DATE
	AND ENTITY_CODE = PARA
)
SELECT DISTINCT  t1.STARTING_ENTITY, t1.inv_entity, t1.ACC_RATIO, t2.ratio AS DIRECT_RATIO 
FROM INV t1
JOIN ENTITY_DIRECT t2 ON t1.STARTING_ENTITY = t2.entity AND t1.INV_ENTITY = t2.INV_ENTITY
WHERE LEVELS=MAX_INV_LEVEL);
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_CAL_RATIO_HOLD AS
BEGIN
		FOR rec IN (
		SELECT 
    	ID,
        t2.CURRENT_CODE AS CFC_ENTITY_CODE, 
        t3.CURRENT_CODE AS CFC_INV_ENTITY_CODE, 
        DECLARATION_DATE
    	FROM TRS_FACT_CFC_INV_DIVIDEND t1
   	 	LEFT JOIN V_TRS_DIM_ENTITY_CUR t2 ON t1.CFC_ENTITY_CODE = t2.ENTITY_CODE
    	LEFT JOIN V_TRS_DIM_ENTITY_CUR t3 ON t1.CFC_INV_ENTITY_CODE = t3.ENTITY_CODE
		)
		LOOP
		P_GET_RATIO_HOLD(rec.ID, rec.DECLARATION_DATE, rec.CFC_ENTITY_CODE, rec.CFC_INV_ENTITY_CODE);
		END LOOP;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_CAL_RATIO_HOLD_NONLOWTAX_ADJ AS
BEGIN
	FOR rec IN (
	SELECT 
        ID,
   		t2.CURRENT_CODE AS CFC_ENTITY_CODE, 
        t3.CURRENT_CODE AS INV_ENTITY_CODE, 
        DISPOSE_DATE, 
        t4.CURRENT_CODE AS SELL_COMPANY
    FROM TRS_FACT_CFC_NONLOW_ADJ t1
    LEFT JOIN V_TRS_DIM_ENTITY_CUR t2 ON t1.CFC_ENTITY_CODE = t2.ENTITY_CODE
    LEFT JOIN V_TRS_DIM_ENTITY_CUR t3 ON t1.INV_ENTITY_CODE = t3.ENTITY_CODE
    LEFT JOIN V_TRS_DIM_ENTITY_CUR t4 ON t1.SELL_COMPANY = t4.ENTITY_CODE
	)
	LOOP
	P_GET_RATIO_HOLD_NONLOWTAX_ADJ_1(rec.ID, rec.DISPOSE_DATE, rec.CFC_ENTITY_CODE, rec.INV_ENTITY_CODE);
	P_GET_RATIO_HOLD_NONLOWTAX_ADJ_2(rec.ID, rec.DISPOSE_DATE, rec.CFC_ENTITY_CODE, rec.SELL_COMPANY);
	END LOOP;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_CAL_RATIO_HOLD_REALIZED_LOSS AS
BEGIN
		FOR rec IN (
		SELECT 
    	ID,
        t2.CURRENT_CODE AS CFC_ENTITY_CODE, 
        t3.CURRENT_CODE AS INV_ENTITY_CODE, 
        LOSS_DATE
   		FROM TRS_FACT_CFC_REALIZED_LOSS t1
    	LEFT JOIN V_TRS_DIM_ENTITY_CUR t2 ON t1.CFC_ENTITY_CODE = t2.ENTITY_CODE
    	LEFT JOIN V_TRS_DIM_ENTITY_CUR t3 ON t1.INV_ENTITY_CODE = t3.ENTITY_CODE
		)
		LOOP
		P_GET_RATIO_HOLD_REALIZED_LOSS(rec.ID, rec.LOSS_DATE, rec.CFC_ENTITY_CODE, rec.INV_ENTITY_CODE);
		END LOOP;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_CFC_ENTITY_VERSION AS
BEGIN
EXECUTE IMMEDIATE 'TRUNCATE TABLE TRS_FACT_CFC_ENTITY_VERSION';
INSERT INTO TRS_FACT_CFC_ENTITY_VERSION(ID, PERIOD, ENTITY_CODE, SCENARIO, CREATED_TIME)
SELECT SYS_GUID(), PERIOD, ENTITY_CODE, SCENARIO, CREATED_TIME FROM 
(WITH CTE AS (
SELECT
	DISTINCT
	LAST_DAY(TO_DATE(t1.PERIOD || LPAD(MONTH, 2, 0), 'YYYY-MM')) AS PERIOD,
	t3.CURRENT_CODE AS ENTITY_CODE,
	t1.SCENARIO,
	MAX(t1.CREATED_TIME) OVER(PARTITION BY t1.PERIOD, t1.MONTH, t1.ENTITY_CODE, t1.SCENARIO) AS CREATED_TIME
FROM TRS_FACT_TRIAL_BALANCE t1
JOIN TRS_DIM_ENTITY t2 ON t1.ENTITY_CODE = t2.ENTITY_CODE AND t2.ENTITY_TYPE_ID = '003'
LEFT JOIN V_TRS_DIM_ENTITY_CUR t3 ON t1.ENTITY_CODE = t3.ENTITY_CODE
),CTE2 AS (
SELECT
	PERIOD,
	ENTITY_CODE,
	SCENARIO,
	CREATED_TIME,
	RANK() OVER(PARTITION BY PERIOD, ENTITY_CODE, SCENARIO ORDER BY CREATED_TIME) AS RW
FROM CTE
)
SELECT
	PERIOD,
	ENTITY_CODE,
	SCENARIO,
	CREATED_TIME
FROM CTE2
WHERE RW = 1
);
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_GET_RATIO_HOLD(
	P_ID IN VARCHAR2,	
	P_DATE IN DATE,
	P_COMPANY IN VARCHAR2,
	P_CFC IN VARCHAR2
	)
AS
BEGIN
UPDATE TRS_FACT_CFC_INV_DIVIDEND SET RATIO_HOLD = (SELECT RATIO FROM 
(
WITH CTE AS (
	SELECT
		ENTITY_CODE,
		INV_ENTITY_CODE,
		RATIO_HOLD
	FROM TRS_FACT_GROUP_INV_REL
	WHERE P_DATE BETWEEN START_DATE AND END_DATE
)
, stock_ratio (base_entity, inv_entity, ratio, path, depth) AS (
  --初始化所有基本關係
  SELECT ENTITY_CODE, INV_ENTITY_CODE, RATIO_HOLD, ENTITY_CODE || '->' || INV_ENTITY_CODE, 1
  FROM CTE
  UNION ALL
  -- 遞歸擴展關係
  SELECT t1.base_entity, t2.INV_ENTITY_CODE, t1.ratio * t2.RATIO_HOLD, 
         t1.path || '->' || t2.INV_ENTITY_CODE, t1.depth + 1
  FROM stock_ratio t1
  JOIN CTE t2 ON t1.inv_entity = t2.ENTITY_CODE
  WHERE t1.depth < 20 -- 限制遞歸深度以防止無限循環
)
,CTE2 AS (
SELECT * FROM stock_ratio
--ORDER BY base_entity, depth, path
)
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	TRUNC(SUM(RATIO), 4) AS RATIO
FROM CTE2
WHERE	 
	BASE_ENTITY = P_COMPANY
	AND INV_ENTITY = P_CFC
GROUP BY BASE_ENTITY, INV_ENTITY
ORDER BY BASE_ENTITY
))
WHERE ID = P_ID
/*CFC_INV_ENTITY_CODE = P_CFC
	AND CFC_ENTITY_CODE = P_COMPANY
	AND DECLARATION_DATE = P_DATE*/
;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_GET_RATIO_HOLD_NONLOWTAX_ADJ_1(
	P_ID IN VARCHAR2,	
	P_DATE IN DATE,
	P_COMPANY IN VARCHAR2,
	P_CFC IN VARCHAR2
	)
AS
BEGIN
UPDATE TRS_FACT_CFC_NONLOW_ADJ SET RATIO_HOLD = CASE WHEN CFC_ENTITY_CODE = SELL_COMPANY THEN 1 ELSE (SELECT RATIO FROM 
(
WITH CTE AS (
	SELECT
		ENTITY_CODE,
		INV_ENTITY_CODE,
		RATIO_HOLD
	FROM TRS_FACT_GROUP_INV_REL
	WHERE P_DATE BETWEEN START_DATE AND END_DATE
)
, stock_ratio (base_entity, inv_entity, ratio, path, depth) AS (
  --初始化所有基本關係
  SELECT ENTITY_CODE, INV_ENTITY_CODE, RATIO_HOLD, ENTITY_CODE || '->' || INV_ENTITY_CODE, 1
  FROM CTE
  UNION ALL
  -- 遞歸擴展關係
  SELECT t1.base_entity, t2.INV_ENTITY_CODE, t1.ratio * t2.RATIO_HOLD, 
         t1.path || '->' || t2.INV_ENTITY_CODE, t1.depth + 1
  FROM stock_ratio t1
  JOIN CTE t2 ON t1.inv_entity = t2.ENTITY_CODE
  WHERE t1.depth < 20 -- 限制遞歸深度以防止無限循環
)
,CTE2 AS (
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	RATIO
FROM stock_ratio
UNION ALL 
SELECT DISTINCT 
	BASE_ENTITY,
	BASE_ENTITY,
	1 AS RATIO
FROM stock_ratio
)
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	TRUNC(SUM(RATIO), 4) AS RATIO
FROM CTE2
WHERE	 
	BASE_ENTITY = P_COMPANY
	AND INV_ENTITY = P_CFC
GROUP BY BASE_ENTITY, INV_ENTITY
)) END
WHERE ID = P_ID
/*INV_ENTITY_CODE = P_CFC
	AND CFC_ENTITY_CODE = P_COMPANY
	AND DISPOSE_DATE = P_DATE*/
;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_GET_RATIO_HOLD_NONLOWTAX_ADJ_2(
	P_ID IN VARCHAR2,
	P_DATE IN DATE,
	P_COMPANY IN VARCHAR2,
	P_CFC IN VARCHAR2
	)
AS
BEGIN
UPDATE TRS_FACT_CFC_NONLOW_ADJ SET SELL_RATIO_HOLD = CASE WHEN CFC_ENTITY_CODE = SELL_COMPANY THEN 1 ELSE (SELECT RATIO FROM 
(
WITH CTE AS (
	SELECT
		ENTITY_CODE,
		INV_ENTITY_CODE,
		RATIO_HOLD
	FROM TRS_FACT_GROUP_INV_REL
	WHERE P_DATE BETWEEN START_DATE AND END_DATE
)
, stock_ratio (base_entity, inv_entity, ratio, path, depth) AS (
  --初始化所有基本關係
  SELECT ENTITY_CODE, INV_ENTITY_CODE, RATIO_HOLD, ENTITY_CODE || '->' || INV_ENTITY_CODE, 1
  FROM CTE
  UNION ALL
  -- 遞歸擴展關係
  SELECT t1.base_entity, t2.INV_ENTITY_CODE, t1.ratio * t2.RATIO_HOLD, 
         t1.path || '->' || t2.INV_ENTITY_CODE, t1.depth + 1
  FROM stock_ratio t1
  JOIN CTE t2 ON t1.inv_entity = t2.ENTITY_CODE
  WHERE t1.depth < 20 -- 限制遞歸深度以防止無限循環
)
,CTE2 AS (
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	RATIO
FROM stock_ratio
UNION ALL 
SELECT DISTINCT 
	BASE_ENTITY,
	BASE_ENTITY,
	1 AS RATIO
FROM stock_ratio
)
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	TRUNC(SUM(RATIO), 4) AS RATIO
FROM CTE2
WHERE	 
	BASE_ENTITY = P_COMPANY
	AND INV_ENTITY = P_CFC
GROUP BY BASE_ENTITY, INV_ENTITY
)) END
WHERE ID = P_ID
/*SELL_COMPANY = P_CFC
	AND CFC_ENTITY_CODE = P_COMPANY
	AND DISPOSE_DATE = P_DATE*/
;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_GET_RATIO_HOLD_REALIZED_LOSS(
	P_ID IN VARCHAR2,
	P_DATE IN DATE,
	P_COMPANY IN VARCHAR2,
	P_CFC IN VARCHAR2
	)
AS
BEGIN
UPDATE TRS_FACT_CFC_REALIZED_LOSS SET RATIO_HOLD =  CASE WHEN P_CFC=P_COMPANY THEN 1 ELSE 
(SELECT RATIO FROM 
(
WITH CTE AS (
	SELECT
		ENTITY_CODE,
		INV_ENTITY_CODE,
		RATIO_HOLD
	FROM TRS_FACT_GROUP_INV_REL
	WHERE P_DATE BETWEEN START_DATE AND END_DATE
)
, stock_ratio (base_entity, inv_entity, ratio, path, depth) AS (
  --初始化所有基本關係
  SELECT ENTITY_CODE, INV_ENTITY_CODE, RATIO_HOLD, ENTITY_CODE || '->' || INV_ENTITY_CODE, 1
  FROM CTE
  UNION ALL
  -- 遞歸擴展關係
  SELECT t1.base_entity, t2.INV_ENTITY_CODE, t1.ratio * t2.RATIO_HOLD, 
         t1.path || '->' || t2.INV_ENTITY_CODE, t1.depth + 1
  FROM stock_ratio t1
  JOIN CTE t2 ON t1.inv_entity = t2.ENTITY_CODE
  WHERE t1.depth < 20 -- 限制遞歸深度以防止無限循環
)
,CTE2 AS (
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	RATIO
FROM stock_ratio
UNION ALL 
SELECT DISTINCT 
	BASE_ENTITY,
	BASE_ENTITY,
	1 AS RATIO
FROM stock_ratio
)
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	TRUNC(SUM(RATIO), 4) AS RATIO
FROM CTE2
WHERE	 
	BASE_ENTITY = P_COMPANY
	AND INV_ENTITY = P_CFC
GROUP BY BASE_ENTITY, INV_ENTITY
)) END
WHERE ID = P_ID
/*INV_ENTITY_CODE = P_CFC
	AND CFC_ENTITY_CODE = P_COMPANY
	AND LOSS_DATE = P_DATE*/
;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_INV_CONTROL_LOOP_DATE IS
BEGIN
DECLARE
	P_DATE DATE := LAST_DAY(TO_DATE('2022-01-01', 'YYYY-MM-DD'));
--	設定計算起始日 ##可以修改##
	P_DATE_DIF NUMBER := FLOOR(MONTHS_BETWEEN(SYSDATE, LAST_DAY(TO_DATE('2022-01-01', 'YYYY-MM-DD'))));
BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE TRS_FACT_INV_CONTROL';
	FOR i IN 1..P_DATE_DIF + 48
--	計算1到12月
	LOOP
		FOR rec IN (
		SELECT DISTINCT ENTITY_CODE 
		FROM TRS_FACT_GROUP_INV_REL
		WHERE START_DATE <= P_DATE AND END_DATE >= P_DATE
		ORDER BY ENTITY_CODE                                    
		)
--	選擇在日期區間的資料
		LOOP
			TRSDB.P_CALCULATE_INV_CONTROL(rec.ENTITY_CODE, P_DATE);
		END LOOP;
--	使用PROCEDURE計算控制力和直接持股
	UPDATE TRS_FACT_INV_CONTROL
	SET PERIOD = P_DATE
	WHERE PERIOD IS NULL;
--	更新日期欄位為每月最後一天
--	DBMS_OUTPUT.PUT_LINE(P_DATE_DIF);
	P_DATE := LAST_DAY(P_DATE +1);
--	計算日期為下個月最後一天
	END LOOP;
	UPDATE TRS_FACT_INV_CONTROL
	SET RATIO_INDIRECT = RATIO_SUM - RATIO_DIRECT,
	UPDATED_TIME = SYSDATE;
--計算間接持股，更新最後編輯時間
END;
END;

CREATE OR REPLACE PROCEDURE TRSDB.P_RATIO_HOLD(
	P_DATE DATE,
	P_CFC VARCHAR2
	)
AS
BEGIN
DECLARE
--	P_DATE DATE := TO_DATE('2022-07-18', 'YYYY-MM-DD');
--	P_CFC VARCHAR(255) := 'A02';
	C_RES SYS_REFCURSOR;
BEGIN
OPEN C_RES FOR
--INSERT INTO TRS_FACT_CFC_INV_DIVIDEND(RATIO_HOLD)
--SELECT RATIO FROM (
WITH CTE AS (
	SELECT
		ENTITY_CODE,
		INV_ENTITY_CODE,
		RATIO_HOLD
	FROM TRS_FACT_GROUP_INV_REL
	WHERE P_DATE BETWEEN START_DATE AND END_DATE
	AND INV_ENTITY_CODE = P_CFC
)
, stock_ratio (base_entity, inv_entity, ratio, path, depth) AS (
  --初始化所有基本關係
  SELECT ENTITY_CODE, INV_ENTITY_CODE, RATIO_HOLD, ENTITY_CODE || '->' || INV_ENTITY_CODE, 1
  FROM CTE
  UNION ALL
  -- 遞歸擴展關係
  SELECT t1.base_entity, t2.INV_ENTITY_CODE, t1.ratio * t2.RATIO_HOLD, 
         t1.path || '->' || t2.INV_ENTITY_CODE, t1.depth + 1
  FROM stock_ratio t1
  JOIN CTE t2 ON t1.inv_entity = t2.ENTITY_CODE
  WHERE t1.depth < 20 -- 限制遞歸深度以防止無限循環
)
,CTE2 AS (
SELECT * FROM stock_ratio
--ORDER BY base_entity, depth, path
)
SELECT
	BASE_ENTITY,
	INV_ENTITY,
	SUM(RATIO) AS RATIO
FROM CTE2
GROUP BY BASE_ENTITY, INV_ENTITY
ORDER BY BASE_ENTITY;
--DBMS_SQL.RETURN_RESULT(C_RES);
--)
--WHERE CFC_INV_ENTITY_CODE = P_CFC;
END;
END;

CREATE OR REPLACE procedure TRSDB.P_TRS_RESET_TASK_SEQ AS
  n    NUMBER(10);
  tsql VARCHAR2(100);
begin
  EXECUTE IMMEDIATE 'select SEQ_TRS_TASK_NUMBER.nextval from dual'
    INTO n;
  n    := - (n);
  tsql := 'alter sequence SEQ_TRS_TASK_NUMBER increment by ' || n; -- 下一次增加的量(負數)
  EXECUTE IMMEDIATE tsql;
  EXECUTE IMMEDIATE 'select  SEQ_TRS_TASK_NUMBER.nextval from dual' -- 增加完回到0
    INTO n;
  tsql := 'alter sequence SEQ_TRS_TASK_NUMBER increment by 1'; -- 增加的量改回1
  EXECUTE IMMEDIATE tsql;
end;