WITH Low_Tax_Unrelated_Income_TangibleAssets AS (
    SELECT 
        T1.ID,
        T1.PERIOD,
        T2.current_code,
        T3.ENTITY_NAME,
        T3.COUNTRY_ID,
        T5.COUNTRY_NAME,
        T1.DATA_NAME,
        T4.IS_LOWTAX,
        T4.TAX_RATE,
        CASE WHEN IS_LOWTAX = 'true' AND T1.VALUE != '0' THEN '1' 
        ELSE '0'
        END AS VALUE_NEW,
        CASE WHEN DATA_NAME = 'col_income_non_rel' THEN '低稅地區有非關係人收入'
        ELSE '低稅地區有有形資產'
        END AS TYPE
    FROM 
        [dbo].[TRS_FACT_COUNTRY_REPORT] T1
    LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE
    LEFT JOIN 
        V_TRS_DIM_COUNTRY T5 ON T4.COUNTRY_CODE = T5.COUNTRY_ID AND T5.FR_LOCALE='zh_TW'
    WHERE 
        T1.REPORT_NAME = 'report1'
        AND T3.FR_LOCALE='zh_TW'
        AND DATA_NAME IN ('col_income_non_rel', 'col_tangible_asset')
),
NonHoldingFunctionsLowTax AS (
    --低稅地區具有『控股』以外功能
    --位於台灣國稅局公布低稅區名單及法定稅率低於15%之國家地區，且國別報告表二的持有股份或其他權益工具以外功能有勾選
    SELECT 
        T1.ID,
        T1.PERIOD,
        T2.current_code,
        T3.ENTITY_NAME,
        T3.COUNTRY_ID,
        T5.COUNTRY_NAME,
        T1.DATA_NAME,
        T4.IS_LOWTAX,
        T4.TAX_RATE,
        CASE 
            WHEN IS_LOWTAX = 'true' AND (
                (DATA_NAME = 'col_res_and_dev' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_hold_int_property' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_purchase' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_manufacture' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_sales_mkt_distrbn' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_admin_mgnt_sup' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_provide_serv_to_nrp' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_int_grp_fin' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_regu_fin_serv' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_insurance' AND T1.VALUE != '0') OR
                (DATA_NAME = 'col_others' AND T1.VALUE != '0')
            ) THEN '1' 
            ELSE '0'
        END AS VALUE_NEW,
         '低稅地區具有『控股』以外功能' AS TYPE
    FROM 
        [dbo].[TRS_FACT_COUNTRY_REPORT] T1
    LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE
    LEFT JOIN 
        V_TRS_DIM_COUNTRY T5 ON T4.COUNTRY_CODE = T5.COUNTRY_ID AND T5.FR_LOCALE='zh_TW'
    WHERE 
        T1.REPORT_NAME = 'report2'
        AND T3.FR_LOCALE='zh_TW'),
    IS_MAN AS (
    --國別報告表二之製造功能、銷售行銷或配銷、對非關係人提供服務、行政、研究發展、收入有勾選
    SELECT 
        T1.ID,
        T1.PERIOD,
        T2.current_code,
        T3.ENTITY_NAME,
        T3.COUNTRY_ID,
        T5.COUNTRY_NAME,
        T1.DATA_NAME,
        T4.IS_LOWTAX,
        T4.TAX_RATE,
        T1.VALUE AS VALUE_MAN
    FROM 
        [dbo].[TRS_FACT_COUNTRY_REPORT] T1
    LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE
    LEFT JOIN 
        V_TRS_DIM_COUNTRY T5 ON T4.COUNTRY_CODE = T5.COUNTRY_ID AND T5.FR_LOCALE='zh_TW'
    WHERE 
        T1.REPORT_NAME = 'report2'
        AND T3.FR_LOCALE='zh_TW'
        AND DATA_NAME IN ('col_manufacture','col_sales_mkt_distrbn','col_provide_serv_to_nrp','col_admin_mgnt_sup','col_res_and_dev','col_income_non_rel'))
    ,IS_EMPLOYEE AS (
    -- 判斷國別報告1的員工人數是否為0
    SELECT 
        T1.ID,
        T1.PERIOD,
        T2.current_code,
        T3.ENTITY_NAME,
        T3.COUNTRY_ID,
        T5.COUNTRY_NAME,
        T1.DATA_NAME,
        T4.IS_LOWTAX,
        T4.TAX_RATE,
        T1.VALUE AS VALUE_NUM
    FROM 
        [dbo].[TRS_FACT_COUNTRY_REPORT] T1
    LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE
    LEFT JOIN 
        V_TRS_DIM_COUNTRY T5 ON T4.COUNTRY_CODE = T5.COUNTRY_ID AND T5.FR_LOCALE='zh_TW'
    WHERE 
        T1.REPORT_NAME = 'report1'
        AND T3.FR_LOCALE='zh_TW'
        AND DATA_NAME = 'col_num_of_emp'
        ), Manufacture_NoEmployees AS (
    --有『製造功能』但無員工人數
    --國別報告表二之製造功能有勾選，且國別報告表一的員工人數等於零
    SELECT 
        T1.ID,
        T1.PERIOD,
        T1.current_code,
        T1.ENTITY_NAME,
        T1.COUNTRY_ID,
        T1.COUNTRY_NAME,
        T1.DATA_NAME,
        T1.IS_LOWTAX,
        T1.TAX_RATE,
        CASE WHEN T1.VALUE_MAN = '1' AND ( T2.VALUE_NUM = '0' OR  T2.VALUE_NUM IS NULL ) THEN '1' ELSE '0'
        END AS VALUE_NEWA,
        '有『製造功能』但無員工人數' AS TYPE
    FROM IS_MAN T1
    LEFT JOIN IS_EMPLOYEE T2 ON T1.current_code = T2.current_code AND T1.PERIOD = T2.PERIOD
    WHERE T1.DATA_NAME = 'col_manufacture')
    , SALES_MKT_NoEmployees AS (      
    --有『行銷、銷售或配銷功能』但無員工人數
    --國別報告表二之銷售、行銷或配銷有勾選，且國別報告表一的員工人數等於零
    SELECT 
        T1.ID,
        T1.PERIOD,
        T1.current_code,
        T1.ENTITY_NAME,
        T1.COUNTRY_ID,
        T1.COUNTRY_NAME,
        T1.DATA_NAME,
        T1.IS_LOWTAX,
        T1.TAX_RATE,
        CASE WHEN T1.VALUE_MAN = '1' AND ( T2.VALUE_NUM = '0' OR  T2.VALUE_NUM IS NULL ) THEN '1' ELSE '0'
        END AS VALUE_NEWA,
        '有『行銷、銷售或配銷功能』但無員工人數' AS TYPE
    FROM IS_MAN T1
    LEFT JOIN IS_EMPLOYEE T2 ON T1.current_code = T2.current_code AND T1.PERIOD = T2.PERIOD
    WHERE T1.DATA_NAME = 'col_sales_mkt_distrbn'),
    PROVIDE_SERV_NoEmployees AS (      
    --有『對外提供服務功能』但無員工人數
    --國別報告表二之對非關係人提供服務有勾選，且國別報告表一的員工人數等於零
    SELECT 
        T1.ID,
        T1.PERIOD,
        T1.current_code,
        T1.ENTITY_NAME,
        T1.COUNTRY_ID,
        T1.COUNTRY_NAME,
        T1.DATA_NAME,
        T1.IS_LOWTAX,
        T1.TAX_RATE,
        CASE WHEN T1.VALUE_MAN = '1' AND ( T2.VALUE_NUM = '0' OR  T2.VALUE_NUM IS NULL ) THEN '1' ELSE '0'
        END AS VALUE_NEWA,
        '對非關係人提供服務' AS TYPE
    FROM IS_MAN T1
    LEFT JOIN IS_EMPLOYEE T2 ON T1.current_code = T2.current_code AND T1.PERIOD = T2.PERIOD
    WHERE T1.DATA_NAME = 'col_provide_serv_to_nrp'
),
    ADMIN_MGNT_NoEmployees AS (      
    --有『行政、管理或支援功能』但無員工人數 
    --國別報告表二之對行政、管理或支援服務有勾選，且國別報告表一的員工人數等於零
    SELECT 
        T1.ID,
        T1.PERIOD,
        T1.current_code,
        T1.ENTITY_NAME,
        T1.COUNTRY_ID,
        T1.COUNTRY_NAME,
        T1.DATA_NAME,
        T1.IS_LOWTAX,
        T1.TAX_RATE,
        CASE WHEN T1.VALUE_MAN = '1' AND ( T2.VALUE_NUM = '0' OR  T2.VALUE_NUM IS NULL ) THEN '1' ELSE '0'
        END AS VALUE_NEWA,
        '有『行政、管理或支援功能』但無員工人數' AS TYPE
    FROM IS_MAN T1
    LEFT JOIN IS_EMPLOYEE T2 ON T1.current_code = T2.current_code AND T1.PERIOD = T2.PERIOD
    WHERE T1.DATA_NAME = 'col_admin_mgnt_sup'
), RESEARCH_NoEmployees AS (      
    --有『研發功能』但無員工人數
    --國別報告表二之對研究與發展有勾選，且國別報告表一的員工人數等於零
    SELECT 
        T1.ID,
        T1.PERIOD,
        T1.current_code,
        T1.ENTITY_NAME,
        T1.COUNTRY_ID,
        T1.COUNTRY_NAME,
        T1.DATA_NAME,
        T1.IS_LOWTAX,
        T1.TAX_RATE,
        CASE WHEN T1.VALUE_MAN = '1' AND ( T2.VALUE_NUM = '0' OR  T2.VALUE_NUM IS NULL ) THEN '1' ELSE '0'
        END AS VALUE_NEWA,
        '有『研發功能』但無員工人數' AS TYPE
    FROM IS_MAN T1
    LEFT JOIN IS_EMPLOYEE T2 ON T1.current_code = T2.current_code AND T1.PERIOD = T2.PERIOD
    WHERE T1.DATA_NAME = 'col_res_and_dev'
), INCOME_NoEmployees AS (      
    --有『收入-非關係人』但無員工人數
    --國別報告表二之對收入非關係人有勾選，且國別報告表一的員工人數等於零
    SELECT 
        T1.ID,
        T1.PERIOD,
        T1.current_code,
        T1.ENTITY_NAME,
        T1.COUNTRY_ID,
        T1.COUNTRY_NAME,
        T1.DATA_NAME,
        T1.IS_LOWTAX,
        T1.TAX_RATE,
        CASE WHEN T1.VALUE_MAN = '1' AND ( T2.VALUE_NUM = '0' OR  T2.VALUE_NUM IS NULL ) THEN '1' ELSE '0'
        END AS VALUE_NEWA,
        '有『收入-非關係人』但無員工人數' AS TYPE
    FROM IS_MAN T1
    LEFT JOIN IS_EMPLOYEE T2 ON T1.current_code = T2.current_code AND T1.PERIOD = T2.PERIOD
    WHERE T1.DATA_NAME = 'col_income_non_rel'
)
SELECT DISTINCT TYPE FROM Low_Tax_Unrelated_Income_TangibleAssets
UNION ALL
SELECT DISTINCT TYPE FROM NonHoldingFunctionsLowTax
UNION ALL 
SELECT DISTINCT TYPE FROM Manufacture_NoEmployees
UNION ALL
SELECT DISTINCT TYPE FROM SALES_MKT_NoEmployees
UNION ALL 
SELECT DISTINCT TYPE FROM PROVIDE_SERV_NoEmployees
UNION ALL 
SELECT DISTINCT TYPE FROM ADMIN_MGNT_NoEmployees
UNION ALL
SELECT DISTINCT TYPE FROM RESEARCH_NoEmployees
UNION ALL 
SELECT DISTINCT TYPE FROM INCOME_NoEmployees

