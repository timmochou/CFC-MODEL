DECLARE @Query NVARCHAR(MAX),
        @Columns NVARCHAR(MAX)

SET @Columns = STUFF(
(
    SELECT DISTINCT ',' + QUOTENAME(DATA_NAME) AS DATA_NAME 
    FROM (
        SELECT 
        PERIOD,
        ENTITY_ID,
        DATA_NAME,
        CASE 
            WHEN ISNUMERIC(VALUE) = 1 THEN CAST(VALUE AS DECIMAL(18,2))
            ELSE NULL 
        END AS VALUE
        FROM TRS_FACT_COUNTRY_REPORT
    ) AS T1
    FOR XML PATH(''), TYPE
).value('.','NVARCHAR(MAX)'), 1, 1, '')

SET @Query = 
N'WITH PivotData AS (
    SELECT 
    Period,
    ENTITY_ID,
    ' + @Columns + '
FROM
(
    SELECT
        PERIOD,
        ENTITY_ID,
        DATA_NAME,
        CASE 
            WHEN ISNUMERIC(VALUE) = 1 THEN CAST(VALUE AS DECIMAL(18,2))
            ELSE NULL 
        END AS VALUE
    FROM TRS_FACT_COUNTRY_REPORT
    WHERE 1=1 
    AND PERIOD = ''${P_PERIOD}''
    ${if(len(P_COMPANY) == 0,"","and ENTITY_ID IN (''" + P_COMPANY + "'')")}
  
	 ) AS D
PIVOT
(
    MAX(VALUE)
    FOR [DATA_NAME] IN (' + @Columns + ')
) AS PVT
), RiskWarning AS (
SELECT 
T2.current_code,
T3.ENTITY_NAME,
T3.COUNTRY_ID,
T4.COUNTRY_NAME,
T5.IS_LOWTAX,
T5.TAX_RATE,
T1.*,
STUFF((
    SELECT '','' + x.risk_type
    FROM (
        SELECT ''a'' as risk_type WHERE IS_LOWTAX = ''true'' AND col_income_non_rel != 0
        UNION ALL SELECT ''b'' WHERE IS_LOWTAX = ''true'' AND col_tangible_asset != 0
        UNION ALL SELECT ''c'' WHERE IS_LOWTAX = ''true'' AND COALESCE(col_res_and_dev, col_hold_int_property, col_purchase, col_manufacture, col_sales_mkt_distrbn, col_admin_mgnt_sup, col_provide_serv_to_nrp, col_int_grp_fin, col_regu_fin_serv, col_insurance, col_others,0) != 0
        UNION ALL SELECT ''d'' WHERE col_manufacture != 0 AND col_num_of_emp = 0
        UNION ALL SELECT ''e'' WHERE col_sales_mkt_distrbn != 0 AND col_num_of_emp = 0
        UNION ALL SELECT ''f'' WHERE col_provide_serv_to_nrp != 0 AND col_num_of_emp = 0
        UNION ALL SELECT ''g'' WHERE col_admin_mgnt_sup != 0 AND col_num_of_emp = 0
        UNION ALL SELECT ''h'' WHERE col_res_and_dev != 0 AND col_num_of_emp = 0
        UNION ALL SELECT ''i'' WHERE col_income_non_rel != 0 AND col_num_of_emp = 0
        UNION ALL SELECT ''j'' WHERE (col_pre_tax_income > 0 AND col_curr_tax_payable < 0) OR (col_pre_tax_income < 0 AND col_curr_tax_payable > 0)
        UNION ALL SELECT ''k'' WHERE ISNULL(col_curr_tax_payable / NULLIF(col_pre_tax_income, 0), 0) < TAX_RATE
        UNION ALL SELECT ''l'' WHERE col_p2_income > (10000000 * col_p2_eur_to_twd_exch) OR col_p2_pre_tax_income > ( 1000000 * col_p2_eur_to_twd_exch ) 
        UNION ALL SELECT ''m'' WHERE 
            (LEFT(T1.Period,4)=''2023'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)=''2024'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)=''2025'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.16) OR
            (LEFT(T1.Period,4)=''2026'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.17)
        UNION ALL SELECT ''n'' WHERE (col_p2_pre_tax_income - ((col_p2_payroll * 0.1)+ (col_p2_tangible_asset * 0.08)) >= 0)
     ) x
        WHERE 1=1 ${if(len(P_CATEGORY) == 0,"","and risk_type IN (''" + P_CATEGORY + "'')")}
    FOR XML PATH('''')
), 1, 1, '''') AS TYPE
FROM PivotData T1
LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE=''zh_TW''
	LEFT JOIN 
        V_TRS_DIM_COUNTRY T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE AND T4.FR_LOCALE=''zh_TW''
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T5 ON T4.COUNTRY_ID = T5.COUNTRY_CODE
WHERE 
1=1 
--AND T3.COUNTRY_ID IN (''${P_COUNTRY}'')
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN (''" + P_COUNTRY + "'')")}


),COUNT_TYPE AS(
SELECT 
    TYPE,
    LEN(REPLACE(TYPE,'','','''')) as TypeCount
FROM RiskWarning
GROUP BY TYPE)
SELECT T1.*,
T2.TypeCount
FROM RiskWarning T1 LEFT JOIN COUNT_TYPE T2
ON T1.TYPE = T2.TYPE
ORDER BY ENTITY_NAME ASC
;'
   

EXEC sp_executesql @Query