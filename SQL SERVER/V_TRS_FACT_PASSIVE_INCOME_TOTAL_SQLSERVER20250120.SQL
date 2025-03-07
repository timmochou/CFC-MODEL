-- dbo.V_TRS_FACT_PASSIVE_INCOME_TOTAL source
CREATE VIEW V_TRS_FACT_PASSIVE_INCOME_TOTAL AS
WITH mv as(
SELECT
    T1.PERIOD_DATE AS PERIOD,
--    T1.MONTH,
    T1.CURRENT_CODE,
    T1.SCENARIO,
    T1.T5_CODE,
    T1.T5_NAME,
    T1.T4_CODE,
    T1.T4_NAME,
    T1.T5_DEBIT_CREDIT,
    T1.T4_DEBIT_CREDIT,
    T1.T3_CODE,
    T1.T3_NAME,
    T1.T3_DEBIT_CREDIT,
	CURRENCY_CODE,
    T1.ACCUMULATED_AMOUNT_ORI 
FROM MV_TRS_TB_ACTUAL_ACCOUNT_AMOUNT t1
JOIN TRS_FACT_CFC_ENTITY_VERSION_TAX t2 ON t1.COUNTRY_ID = t2.COUNTRY_ID   AND t1.PERIOD_DATE = T2.PERIOD
WHERE t2.IS_LOWTAX = 'true'
--INNER JOIN TRS_FACT_COUNTRY_TAX t2 ON t1.COUNTRY_ID = t2.COUNTRY_CODE AND t2.IS_LOWTAX = 'true'
)
,CTE0 AS (
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T5_CODE AS ACCOUNT_CODE,
	T5_NAME AS NAME,
	T5_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T5_CODE, 1) = '4'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T4_CODE AS ACCOUNT_CODE,
	T4_NAME AS NAME,
	T4_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv 
WHERE 
	LEFT(T4_CODE, 1) = '4'
	AND T5_CODE ='-1'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T3_CODE AS ACCOUNT_CODE,
	T3_NAME AS NAME,
	T3_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T3_CODE, 1) = '4'
	AND T4_CODE ='-1'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T5_CODE AS ACCOUNT_CODE,
	T5_NAME AS NAME,
	T5_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T5_CODE, 1) = '7'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T4_CODE AS ACCOUNT_CODE,
	T4_NAME AS NAME,
	T4_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T4_CODE, 1) = '7'
	AND T5_CODE ='-1'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T3_CODE AS ACCOUNT_CODE,
	T3_NAME AS NAME,
	T3_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T3_CODE, 1) = '7'
	AND T4_CODE ='-1'
),CTE AS(
SELECT
	CTE0.PERIOD,
	ENTITY_CODE,
    CTE0.SCENARIO,	
	ACCOUNT_CODE,
	NAME,
	DEBIT_CREDIT,
	CASE WHEN DEBIT_CREDIT = 'C' THEN ACCUMULATED_AMOUNT_ORI * -1 ELSE ACCUMULATED_AMOUNT_ORI END AS ACCUMULATED_AMOUNT_ORI
FROM CTE0
--LEFT JOIN V_TRS_FACT_EXCHANGE_BANKOFTW T3 ON CTE0.PERIOD = T3.PERIOD_DATE AND CTE0.CURRENCY_CODE = T3.CURRENCY_ID AND TARGET_CURRENCY_ID = 'NTD' AND CTE0.SCENARIO = T3.SCENARIO
),CTE2 AS (
SELECT
	PERIOD,
	ENTITY_CODE,
    SCENARIO,
	SUM(CASE WHEN ACCOUNT_CODE IN ('7011', '7232', '7235', '7240', '730A', '730B', '730C', '730D', '730E', '730F', '7350', '7360', '7361', '7370', '7375') THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS INV_INCOME,
	SUM(CASE WHEN ACCOUNT_CODE IN ('7130') THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS DIV_INCOME,
	SUM(CASE WHEN ACCOUNT_CODE IN ('7101', '7102', '7105', '7106', '7107') THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS INT_INCOME,
	SUM(CASE WHEN ACCOUNT_CODE IN ('7120', '651C') THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS ROY_INCOME,
	SUM(CASE WHEN ACCOUNT_CODE IN ('7110', '651A') THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS RENT_INCOME,
	SUM(CASE WHEN ACCOUNT_CODE IN ('7210', '7215', '7220', '7225', '7229', '651B') THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS SALE_ASSETS_GAIN
FROM CTE
GROUP BY PERIOD, SCENARIO, ENTITY_CODE
), CTE_INV_CONTROL AS (
SELECT
	T1.ID,
	T1.PERIOD,
	T2.CURRENT_CODE AS ENTITY_CODE,
	T3.CURRENT_CODE AS INV_ENTITY_CODE
FROM TRS_FACT_INV_CONTROL T1
INNER JOIN V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_CODE = T2.ENTITY_CODE
INNER JOIN V_TRS_DIM_ENTITY_CUR T3 ON T1.INV_ENTITY_CODE = T3.ENTITY_CODE
WHERE RATIO_DIRECT != 0
), HEAD AS (
SELECT
	t1.ID,
	t0.PERIOD,
	t0.ENTITY_CODE,
	t0.SCENARIO,
	t1.INV_ENTITY_CODE,
	t3.COUNTRY_ID,
	t4.IS_LOWTAX
	--t5.COUNTRY_ID AS COMPANY_COUNTRY
FROM V_TRS_FACT_CFC_ENTITY_VERSION t0
INNER JOIN CTE_INV_CONTROL t1 ON t0.PERIOD = t1.PERIOD AND t0.ENTITY_CODE = t1.ENTITY_CODE
LEFT JOIN TRS_DIM_COMPANY t3 ON t1.INV_ENTITY_CODE = t3.COMPANY_CODE
JOIN TRS_FACT_CFC_ENTITY_VERSION_TAX t4 ON t3.COUNTRY_ID = t4.COUNTRY_ID   AND t0.PERIOD = T4.PERIOD
--INNER JOIN TRS_DIM_ENTITY t5 ON t0.ENTITY_CODE = t5.ENTITY_CODE  AND t5.COUNTRY_ID = 'TW'
WHERE t4.IS_LOWTAX='true' AND t0.COUNTRY_ID='TW'
),
CTE3_0 AS (
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T5_CODE AS ACCOUNT_CODE,
	T5_NAME AS NAME,
	T5_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T5_CODE, 1) = '4'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T4_CODE AS ACCOUNT_CODE,
	T4_NAME AS NAME,
	T4_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T4_CODE, 1) = '4'
	AND T5_CODE ='-1'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T3_CODE AS ACCOUNT_CODE,
	T3_NAME AS NAME,
	T3_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T3_CODE, 1) = '4'
	AND T4_CODE ='-1'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T5_CODE AS ACCOUNT_CODE,
	T5_NAME AS NAME,
	T5_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T5_CODE, 1) = '7'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T4_CODE AS ACCOUNT_CODE,
	T4_NAME AS NAME,
	T4_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T4_CODE, 1) = '7'
	AND T5_CODE ='-1'
UNION ALL
SELECT
	PERIOD ,
--	MONTH,
	CURRENT_CODE AS ENTITY_CODE,
    SCENARIO,
	T3_CODE AS ACCOUNT_CODE,
	T3_NAME AS NAME,
	T3_DEBIT_CREDIT AS DEBIT_CREDIT,
	CURRENCY_CODE,
	ACCUMULATED_AMOUNT_ORI
FROM mv
WHERE 
	LEFT(T3_CODE, 1) = '7'
	AND T4_CODE ='-1'
),CTE3 AS (
SELECT
	CTE3_0.PERIOD,
	ENTITY_CODE,
    CTE3_0.SCENARIO,	
	ACCOUNT_CODE,
	NAME,
	DEBIT_CREDIT,
	CASE WHEN DEBIT_CREDIT = 'C' THEN ACCUMULATED_AMOUNT_ORI * -1 ELSE ACCUMULATED_AMOUNT_ORI END AS ACCUMULATED_AMOUNT_ORI
FROM CTE3_0
--LEFT JOIN V_TRS_FACT_EXCHANGE_BANKOFTW T3 ON CTE3_0.PERIOD  = T3.PERIOD_DATE AND CTE3_0.CURRENCY_CODE = T3.CURRENCY_ID AND TARGET_CURRENCY_ID = 'NTD' AND CTE3_0.SCENARIO = T3.SCENARIO
), TOTAL AS (
SELECT
	PERIOD,
	SCENARIO,
	ENTITY_CODE,
	SUM(CASE WHEN LEFT(ACCOUNT_CODE, 1) = '4' THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) AS TOTAL_OPE_INCOME,
	SUM(CASE WHEN LEFT(ACCOUNT_CODE, 1) = '7' AND DEBIT_CREDIT = 'C' AND ACCUMULATED_AMOUNT_ORI > 0 THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END) - SUM(CASE WHEN ACCOUNT_CODE IN ('7233', '7630') AND ACCUMULATED_AMOUNT_ORI < 0 THEN ACCUMULATED_AMOUNT_ORI ELSE 0 END)AS TOTAL_NONOPE_INCOME
FROM CTE3
GROUP BY PERIOD, SCENARIO, ENTITY_CODE
)
, TB_RES AS (
SELECT
	HEAD.ID,
	HEAD.COUNTRY_ID,
	HEAD.ENTITY_CODE,
	HEAD.IS_LOWTAX,
	HEAD.PERIOD,
    HEAD.SCENARIO,
	HEAD.INV_ENTITY_CODE,
	CTE2.INV_INCOME,
	CTE2.DIV_INCOME,
	CTE2.INT_INCOME,
	CTE2.ROY_INCOME,
	CTE2.RENT_INCOME,
	CTE2.SALE_ASSETS_GAIN,
    0 AS SELF_DEV_ROY,
    0 AS SELF_DEV_RENT,
    0 AS SELF_DEV_GAIN,
    CTE2.INV_INCOME + CTE2.DIV_INCOME + CTE2.INT_INCOME + CTE2.ROY_INCOME + CTE2.RENT_INCOME + CTE2.SALE_ASSETS_GAIN AS TOTAL_NUMERATOR,
    TOTAL.TOTAL_OPE_INCOME,
    TOTAL.TOTAL_NONOPE_INCOME,
    TOTAL.TOTAL_OPE_INCOME + TOTAL.TOTAL_NONOPE_INCOME AS TOTAL_DENOMINATOR
FROM HEAD
LEFT JOIN CTE2 ON HEAD.INV_ENTITY_CODE = CTE2.ENTITY_CODE AND HEAD.PERIOD = CTE2.PERIOD AND HEAD.SCENARIO = CTE2.SCENARIO
LEFT JOIN TOTAL ON HEAD.INV_ENTITY_CODE = TOTAL.ENTITY_CODE AND HEAD.PERIOD = TOTAL.PERIOD AND HEAD.SCENARIO = TOTAL.SCENARIO
),CTE_ADJ AS (
SELECT
	T1.PERIOD,
	T2.CURRENT_CODE AS CFC_ENTITY_CODE,
	T1.SCENARIO,
	T1.INV_INCOME,
	T1.DIV_INCOME,
	T1.INT_INCOME ,
	T1.ROY_INCOME ,
	T1.RENT_INCOME ,
	T1.SALE_ASSETS_GAIN ,
	T1.SELF_DEV_ROY ,
	T1.SELF_DEV_RENT ,
	T1.SELF_DEV_GAIN ,
	T1.TOTAL_NUMERATOR ,
	T1.TOTAL_OPE_INCOME ,
	T1.TOTAL_NONOPE_INCOME ,
	T1.TOTAL_DENOMINATOR 
FROM TRS_FACT_PASSIVE_INCOME_ADJ T1
LEFT JOIN V_TRS_DIM_ENTITY_CUR T2 ON T1.CFC_ENTITY_CODE = T2.ENTITY_CODE 
)
SELECT 
	T1.ID,
	T1.PERIOD,
	T1.SCENARIO,
	T1.IS_LOWTAX,
	T1.COUNTRY_ID,
	T1.ENTITY_CODE,
	T1.INV_ENTITY_CODE,
	T1.INV_INCOME,
	T1.DIV_INCOME,
	T1.INT_INCOME,
	T1.ROY_INCOME,
	T1.RENT_INCOME,
	T1.SALE_ASSETS_GAIN,
	T1.TOTAL_OPE_INCOME,
	T1.TOTAL_NONOPE_INCOME,
	T2.INV_INCOME AS INV_INCOME_ADJ,
	T2.DIV_INCOME AS DIV_INCOME_ADJ,
	T2.INT_INCOME AS INT_INCOME_ADJ,
	T2.ROY_INCOME AS ROY_INCOME_ADJ,
	T2.RENT_INCOME AS RENT_INCOME_ADJ,
	T2.SELF_DEV_ROY AS SELF_DEV_ROY_ADJ,
    T2.SELF_DEV_RENT AS SELF_DEV_RENT_ADJ,
    T2.SELF_DEV_GAIN AS SELF_DEV_GAIN_ADJ,
	T2.SALE_ASSETS_GAIN AS SALE_ASSETS_GAIN_ADJ,
	T2.TOTAL_OPE_INCOME AS TOTAL_OPE_INCOME_ADJ,
	T2.TOTAL_NONOPE_INCOME AS TOTAL_NONOPE_INCOME_ADJ,
	T1.INV_INCOME + isnull(T2.INV_INCOME, 0) AS INV_INCOME_TOTAL,
	T1.DIV_INCOME + isnull(T2.DIV_INCOME, 0) AS DIV_INCOME_TOTAL,
	T1.INT_INCOME + isnull(T2.INT_INCOME, 0) AS INT_INCOME_TOTAL, 
	T1.ROY_INCOME + isnull(T2.ROY_INCOME, 0) AS ROY_INCOME_TOTAL,
	T1.RENT_INCOME + isnull(T2.RENT_INCOME, 0) AS RENT_INCOME_TOTAL,
	T1.SALE_ASSETS_GAIN + isnull(T2.SALE_ASSETS_GAIN, 0) AS SALE_ASSETS_GAIN_TOTAL,
	T1.SELF_DEV_ROY + isnull(T2.SELF_DEV_ROY, 0) AS SELF_DEV_ROY_TOTAL,
	T1.SELF_DEV_RENT + isnull(T2.SELF_DEV_RENT, 0) AS SELF_DEV_RENT_TOTAL,
	T1.SELF_DEV_GAIN + isnull(T2.SELF_DEV_GAIN, 0) AS SELF_DEV_GAIN_TOTAL,
	T1.TOTAL_NUMERATOR + isnull(T2.TOTAL_NUMERATOR, 0) AS TOTAL_NUMERATOR_TOTAL,
	T1.TOTAL_OPE_INCOME + isnull(T2.TOTAL_OPE_INCOME, 0) AS TOTAL_OPE_INCOME_TOTAL,
	T1.TOTAL_NONOPE_INCOME +isnull(T2.TOTAL_NONOPE_INCOME, 0)AS TOTAL_NONOPE_INCOME_TOTAL,
	T1.TOTAL_DENOMINATOR +isnull(T2.TOTAL_DENOMINATOR, 0) AS TOTAL_DENOMINATOR_TOTAL,
	ROUND (CASE WHEN (T1.TOTAL_DENOMINATOR + isnull(T2.TOTAL_DENOMINATOR, 0)) IS NULL OR (T1.TOTAL_DENOMINATOR +isnull(T2.TOTAL_DENOMINATOR, 0)) = 0 THEN 1 ELSE
	(T1.TOTAL_NUMERATOR + isnull(T2.TOTAL_NUMERATOR, 0)) / (T1.TOTAL_DENOMINATOR + isnull(T2.TOTAL_DENOMINATOR, 0)) END , 4,1)AS PASSIVE_RATIO_TOTAL
FROM TB_RES T1
LEFT JOIN CTE_ADJ T2 ON T1.PERIOD = T2.PERIOD AND T1.INV_ENTITY_CODE = T2.CFC_ENTITY_CODE AND T1.SCENARIO = T2.SCENARIO;