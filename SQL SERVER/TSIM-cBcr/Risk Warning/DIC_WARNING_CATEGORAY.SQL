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
	WHERE PERIOD = ''${P_PERIOD}'' ) AS D
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
CASE WHEN IS_LOWTAX = ''true'' AND col_income_non_rel != 0 THEN ''a''
	 WHEN IS_LOWTAX = ''true'' AND col_tangible_asset != 0 THEN ''b''
	 WHEN IS_LOWTAX = ''true'' AND COALESCE(col_res_and_dev, col_hold_int_property, col_purchase, col_manufacture, col_sales_mkt_distrbn, col_admin_mgnt_sup, col_provide_serv_to_nrp, col_int_grp_fin, col_regu_fin_serv, col_insurance, col_others,0) != 0 THEN ''c''
	 --有『製造功能』但無員工人數
	 WHEN col_manufacture != 0 AND col_num_of_emp = 0 THEN ''d''
     --有『行銷、銷售或配銷功能』但無員工人數
	 WHEN col_sales_mkt_distrbn != 0 AND col_num_of_emp = 0 THEN ''e''
	 --有『對外提供服務功能』但無員工人數
	 WHEN col_provide_serv_to_nrp != 0 AND col_num_of_emp = 0 THEN ''f''
     --有『行政、管理或支援功能』但無員工人數
	 WHEN col_admin_mgnt_sup != 0 AND col_num_of_emp = 0 THEN ''g''
     --有『研發功能』但無員工人數
	 WHEN col_res_and_dev != 0 AND col_num_of_emp = 0 THEN ''h''
	 --有『收入-非關係人』但無員工人數
	 WHEN col_income_non_rel != 0 AND col_num_of_emp = 0 THEN ''i''
     --稅前損益和所得稅應計情形不匹配，正負方向不一致
	 WHEN (col_pre_tax_income > 0  AND col_curr_tax_payable < 0) OR (col_pre_tax_income < 0  AND col_curr_tax_payable > 0) THEN ''j''
	 --CbCR有效稅率低於法定稅率
	 WHEN ISNULL(col_curr_tax_payable / NULLIF(col_pre_tax_income, 0), 0)  < TAX_RATE THEN ''k''
     --Pillar 2過渡性避風港收入高於1,000萬歐元，或稅前淨利高於100萬歐元，可能不符合豁免
     WHEN col_p2_income > 10000000 OR col_p2_pre_tax_income > 1000000 THEN ''l''
     --Pillar 2過渡性避風港有效稅率低於最低稅率*15%(2023與2024)、16%(2025)與17%(2026)可能不符合豁免
     WHEN LEFT(T1.Period,4)=''2023'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.15 THEN ''m''
     WHEN LEFT(T1.Period,4)=''2024'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.15 THEN ''m''
     WHEN LEFT(T1.Period,4)=''2025'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.16 THEN ''m''
     WHEN LEFT(T1.Period,4)=''2026'' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.17 THEN ''m''
     --Pillar 2過渡性避風港有稅前淨利且有員工人數或有有形資產，建議執行詳細計算
     WHEN col_p2_pre_tax_income != 0 AND col_num_of_emp !=0 THEN ''n''
     WHEN col_p2_pre_tax_income != 0 AND col_tangible_asset !=0 THEN ''n''
ELSE ''''
END AS TYPE
FROM PivotData T1
LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID 
	LEFT JOIN 
        V_TRS_DIM_COUNTRY T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE AND T4.FR_LOCALE=''zh_TW''
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T5 ON T4.COUNTRY_ID = T5.COUNTRY_CODE
WHERE T3.COUNTRY_ID IN (''${P_COUNTRY}'')
),COUNT_TYPE AS(
SELECT 
    TYPE,
    COUNT(*) as TypeCount
FROM RiskWarning
GROUP BY TYPE)
SELECT T1.*,
T2.TypeCount
FROM RiskWarning T1 LEFT JOIN COUNT_TYPE T2
ON T1.TYPE = T2.TYPE
;'
   

EXEC sp_executesql @Query