WITH PivotData AS(
-- 將資料轉置，其中篩出cbCR風險預警會用到的資料欄位
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
AND PERIOD = '${P_PERIOD}'
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
)
SELECT 
T2.current_code,
T3.ENTITY_NAME,
T3.COUNTRY_ID,
T4.COUNTRY_NAME,
T5.IS_LOWTAX,
T5.TAX_RATE,
T1.*,
COALESCE(col_res_and_dev, col_hold_int_property, col_purchase, col_manufacture, col_sales_mkt_distrbn, col_admin_mgnt_sup, col_provide_serv_to_nrp, col_int_grp_fin, col_regu_fin_serv, col_insurance, col_others,0) AS test
FROM PivotData T1
LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        -- JOIN 公司資料，來取得公司名稱，並在這裡先篩選掉不同語言的公司名稱
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='${fr_locale}'
	LEFT JOIN 
        -- JOIN 國家資料，來取得國家名稱，並在這裡先篩選掉不同語言的國家名稱
        V_TRS_DIM_COUNTRY T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE AND T4.FR_LOCALE='${fr_locale}'
    -- JOIN 國家稅率資料，來判斷是否為低稅區以及稅率
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T5 ON T4.COUNTRY_ID = T5.COUNTRY_CODE
