WITH TB1 AS (
    SELECT 
    T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T3.COUNTRY_ID,
    T1.DATA_NAME,
    TRY_CAST(T1.VALUE AS DECIMAL(38,2)) AS VALUE
    FROM 
    [dbo].[TRS_FACT_COUNTRY_REPORT] T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    WHERE T1.REPORT_TYPE = 'report1'
    AND T3.FR_LOCALE='${fr_locale}'
),T2 AS (
SELECT PERIOD, ENTITY_ID, ENTITY_NAME,COUNTRY_ID,
    ISNULL([col_income_non_rel], 0) as [col_income_non_rel],
    ISNULL([col_income_rel], 0) as [col_income_rel],
    ISNULL([col_income], 0) as [col_income],
    ISNULL([col_pre_tax_income], 0) as [col_pre_tax_income],
    ISNULL([col_tax_paid], 0) as [col_tax_paid],
    ISNULL([col_curr_tax_payable], 0) as [col_curr_tax_payable],
    ISNULL([col_paid_up_capital], 0) as [col_paid_up_capital],
    ISNULL([col_accu_surplus], 0) as [col_accu_surplus],
    ISNULL([col_num_of_emp], 0) as [col_num_of_emp],
    ISNULL([col_tangible_asset], 0) as [col_tangible_asset]
FROM TB1  
PIVOT (
    SUM(VALUE)
    FOR DATA_NAME IN (
        [col_income_non_rel], [col_income_rel], [col_income], 
        [col_pre_tax_income], [col_tax_paid], [col_curr_tax_payable], 
        [col_paid_up_capital], [col_accu_surplus], [col_num_of_emp], 
        [col_tangible_asset]
    )
) AS PivotTable)
SELECT 
PERIOD,
ENTITY_ID,
ENTITY_NAME,
COUNTRY_ID,
SUM([col_income]) AS [col_income],
SUM([col_pre_tax_income]) AS [col_pre_tax_incomee],
CASE 
    WHEN SUM([col_income]) = 0 THEN NULL 
    ELSE SUM([col_pre_tax_income])/ SUM([col_income]) 
END AS PROFIT_RATE
FROM T2
GROUP BY PERIOD, ENTITY_ID, ENTITY_NAME, COUNTRY_ID