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
    AND T3.FR_LOCALE='en_US'
    WHERE 
    1=1
    AND T1.PERIOD = '${P_PERIOD}'
    AND
    T1.REPORT_NAME = 'report1'
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
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
SUM([col_pre_tax_income]) AS [col_pre_tax_incomee]
FROM T2
WHERE ENTITY_ID IS NOT NULL
GROUP BY PERIOD, ENTITY_ID, ENTITY_NAME, COUNTRY_ID