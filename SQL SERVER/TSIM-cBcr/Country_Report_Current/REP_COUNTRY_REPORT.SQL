WITH TB1 AS (
    SELECT 
    T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T3.COUNTRY_ID,
    T4.COUNTRY_NAME,
    T1.DATA_NAME,
    TRY_CAST(T1.VALUE AS DECIMAL(38,0)) AS VALUE
    FROM 
    [dbo].[TRS_FACT_COUNTRY_REPORT] T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    LEFT JOIN 
    V_TRS_DIM_COUNTRY T4 
    ON T3.COUNTRY_ID = T4.COUNTRY_CODE 
    AND T4.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND
    T1.REPORT_NAME = 'report1'
    AND T1.PERIOD = '${P_PERIOD}'
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
), FINAL AS (
SELECT PERIOD, ENTITY_ID, ENTITY_NAME,COUNTRY_ID, COUNTRY_NAME,
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
COUNTRY_NAME,
SUM(col_income_non_rel) AS col_income_non_rel,
SUM(col_income_rel) AS col_income_rel,
SUM(col_income) AS col_income,
SUM(col_pre_tax_income) AS col_pre_tax_income,
SUM(col_tax_paid) AS col_tax_paid,
SUM(col_curr_tax_payable) AS col_curr_tax_payable,
SUM(col_paid_up_capital) AS col_paid_up_capital,
SUM(col_accu_surplus) AS col_accu_surplus,
SUM(col_num_of_emp) AS col_num_of_emp,
SUM(col_tangible_asset) AS col_tangible_asset
FROM FINAL
GROUP BY PERIOD, ENTITY_ID, ENTITY_NAME, COUNTRY_ID, COUNTRY_NAME
ORDER BY COUNTRY_ID, ENTITY_NAME ASC