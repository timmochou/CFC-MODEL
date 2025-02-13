WITH PivotData AS(
SELECT 
    Period,
    ENTITY_ID,
    col_income_non_rel,
    col_tangible_asset,
    col_res_and_dev,
    col_hold_int_property,
    col_purchase,
    col_manufacture,
    col_sales_mkt_distrbn,
    col_admin_mgnt_sup,
    col_provide_serv_to_nrp,
    col_int_grp_fin,
    col_regu_fin_serv,
    col_insurance,
    col_others,
    col_num_of_emp,
    col_pre_tax_income,
    col_curr_tax_payable,
    col_p2_income,
    col_p2_pre_tax_income,
    col_p2_tax_exp,
    col_p2_payroll,
    col_p2_eur_to_twd_exch,
    col_p2_tangible_asset
FROM 
(
    SELECT 
    PERIOD,
    ENTITY_ID,
    DATA_NAME,
    CASE 
        WHEN ISNUMERIC(VALUE) = 1 AND TRY_CAST(VALUE AS DECIMAL(38,2)) IS NOT NULL 
        THEN TRY_CAST(VALUE AS DECIMAL(38,2))
        ELSE 0 
    	   END AS VALUE
FROM TRS_FACT_COUNTRY_REPORT
WHERE 1=1
AND (PERIOD = '${P_PERIOD}' OR PERIOD = CAST(CAST(SUBSTRING('${P_PERIOD}', 1, 4) AS INT) - 1 AS VARCHAR) + SUBSTRING('${P_PERIOD}', 5, 3))
${if(len(P_COMPANY) == 0,"","and ENTITY_ID IN ('" + P_COMPANY + "')")}
) AS SourceTable
PIVOT
(
    SUM(VALUE)
    FOR [DATA_NAME] IN (
        [col_income_non_rel],
        [col_tangible_asset],
        [col_res_and_dev],
        [col_hold_int_property],
        [col_purchase],
        [col_manufacture],
        [col_sales_mkt_distrbn],
        [col_admin_mgnt_sup],
        [col_provide_serv_to_nrp],
        [col_int_grp_fin],
        [col_regu_fin_serv],
        [col_insurance],
        [col_others],
        [col_num_of_emp],
        [col_pre_tax_income],
        [col_curr_tax_payable],
        [col_p2_income],
        [col_p2_pre_tax_income],
        [col_p2_tax_exp],
        [col_p2_payroll],
        [col_p2_eur_to_twd_exch],
        [col_p2_tangible_asset]
    )
) AS PVT
), RiskWarning AS (
SELECT 
T2.current_code,
T3.ENTITY_NAME,
T3.COUNTRY_ID,
T3.FR_LOCALE,
T4.COUNTRY_NAME,
T5.IS_LOWTAX,
T5.TAX_RATE,
T1.*,
STUFF((
    SELECT ',' + x.risk_type
    FROM (
        SELECT 'col_lowtax_income_non_rel' as risk_type WHERE IS_LOWTAX = 'true' AND T1.col_income_non_rel != 0
        UNION ALL SELECT 'col_lowtax_tangible_asset' WHERE IS_LOWTAX = 'true' AND T1.col_tangible_asset != 0
        UNION ALL SELECT 'col_lowtax_hold' WHERE IS_LOWTAX = 'true' AND (
            T1.col_res_and_dev = '1' OR 
            T1.col_hold_int_property = '1' OR 
            T1.col_purchase = '1' OR 
            T1.col_manufacture = '1' OR 
            T1.col_sales_mkt_distrbn = '1' OR 
            T1.col_admin_mgnt_sup = '1' OR 
            T1.col_provide_serv_to_nrp = '1' OR 
            T1.col_int_grp_fin = '1' OR 
            T1.col_regu_fin_serv = '1' OR 
            T1.col_insurance = '1' OR 
            T1.col_others = '1'
        )
        UNION ALL SELECT 'col_emp_manufacture' WHERE T1.col_manufacture != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_sales_mkt_distrbn' WHERE T1.col_sales_mkt_distrbn != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_provide_serv_to_nrp' WHERE T1.col_provide_serv_to_nrp != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_admin_mgnt_sup' WHERE T1.col_admin_mgnt_sup != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_res_and_dev' WHERE T1.col_res_and_dev != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_income_non_rel' WHERE T1.col_income_non_rel != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_unmatch' WHERE (T1.col_pre_tax_income > 0 AND T1.col_curr_tax_payable < 0) OR (T1.col_pre_tax_income < 0 AND T1.col_curr_tax_payable > 0)
        UNION ALL SELECT 'col_low_etr' WHERE ISNULL(T1.col_curr_tax_payable / NULLIF(T1.col_pre_tax_income, 0), 0) < T5.TAX_RATE
        --可能不符合Pillar 2過渡性避風港小型微利測試之豁免條件
        UNION ALL SELECT 'col_de_minimis' WHERE T1.col_p2_income > (10000000 * T1.col_p2_eur_to_twd_exch) OR T1.col_p2_pre_tax_income > ( 1000000 * T1.col_p2_eur_to_twd_exch ) 
        --可能不符合Pillar 2過渡性避風港簡易版有效稅率測試之豁免條件
        UNION ALL SELECT 'col_simplified_etr' WHERE 
            (LEFT(T1.Period,4)='2023' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)='2024' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)='2025' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.16) OR
            (LEFT(T1.Period,4)='2026' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.17)
        --可能不符合Pillar 2過渡性避風港例行利潤測試之豁免條件
        UNION ALL SELECT 'col_routine_profits' WHERE (ISNULL(T1.col_p2_pre_tax_income,0) - (((ISNULL(T6.col_p2_payroll,0) + ISNULL(T1.col_p2_payroll,0)) * 0.05)+ ((ISNULL(T6.col_p2_tangible_asset,0) + ISNULL(T1.col_p2_tangible_asset,0)) * 0.04)) >=0)
     ) x
        WHERE 1=1 
        ${if(len(P_CATEGORY) == 0,"","and risk_type IN ('" + P_CATEGORY + "')")}
    FOR XML PATH('')
), 1, 1, '') AS TYPE
FROM PivotData T1
-- T6 為上期資料 
LEFT JOIN PivotData T6 ON T1.ENTITY_ID = T6.ENTITY_ID 
    AND T6.Period = CAST(CAST(SUBSTRING('${P_PERIOD}', 1, 4) AS INT) - 1 AS VARCHAR) + SUBSTRING('${P_PERIOD}', 5, 3)
LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='${fr_locale}'
	LEFT JOIN 
        V_TRS_DIM_COUNTRY T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE AND T4.FR_LOCALE='${fr_locale}'
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T5 ON T4.COUNTRY_ID = T5.COUNTRY_CODE
WHERE 
1=1 
AND T1.Period = '${P_PERIOD}'
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
),COUNT_TYPE AS(
SELECT 
    TYPE,
    LEN(TYPE) - LEN(REPLACE(TYPE, ',', '')) + 1 AS TypeCount  -- 計算逗號數量來+1 獲得COL 數量
FROM RiskWarning
WHERE TYPE IS NOT NULL  -- 確保TYPE不為空
GROUP BY TYPE
)
SELECT 
    T1.*,
    ISNULL(T2.TypeCount, 0) as TypeCount  -- 如果TYPE為空,則返回0
FROM RiskWarning T1 
LEFT JOIN COUNT_TYPE T2 ON T1.TYPE = T2.TYPE
WHERE COUNTRY_ID IS NOT NULL
ORDER BY ENTITY_NAME ASC