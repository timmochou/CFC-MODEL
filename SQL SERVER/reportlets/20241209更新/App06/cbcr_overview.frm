<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20211223" releaseVersion="11.0.0">
<TableDataMap>
<TableData name="DIC_COMPANY" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY_"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD_"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
DISTINCT
T1.PERIOD,
T1.ENTITY_ID,
T3.ENTITY_NAME
FROM 
[dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
V_TRS_DIM_ENTITY T3
ON T2.ENTITY_CODE = T3.ENTITY_ID
AND T3.FR_LOCALE='${fr_locale}'
LEFT JOIN 
V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID
AND T4.FR_LOCALE='${fr_locale}'
WHERE 
1=1
AND REPORT_NAME = 'report1'
AND
T1.PERIOD = '${P_PERIOD_}'
${if(len(P_COUNTRY_) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY_ + "')")}
ORDER BY ENTITY_NAME ASC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_DATE" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
DISTINCT 
PERIOD 
FROM 
TRSDB.dbo.TRS_FACT_COUNTRY_REPORT
ORDER BY PERIOD ASC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_COUNTRY" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD_"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
DISTINCT
T1.PERIOD,
T3.COUNTRY_ID,
T4.COUNTRY_NAME,
T4.DEFAULT_CURRENCY_ID
FROM 
[dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID
AND T3.FR_LOCALE='${fr_locale}'
LEFT JOIN 
V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID 
AND T4.FR_LOCALE='${fr_locale}'
WHERE 
T1.PERIOD = '${P_PERIOD_}'
AND
T1.REPORT_NAME = 'report1'
ORDER BY COUNTRY_ID ASC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_COUNTRY_REPORT" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH TB1 AS (
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
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
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
    ISNULL([col_income_non_rel]A, 0) as [col_income_non_rel]A,
    ISNULL([col_income_rel]A, 0) as [col_income_rel]A,
    ISNULL([col_income]A, 0) as [col_income]A,
    ISNULL([col_pre_tax_income]A, 0) as [col_pre_tax_income]A,
    ISNULL([col_tax_paid]A, 0) as [col_tax_paid]A,
    ISNULL([col_curr_tax_payable]A, 0) as [col_curr_tax_payable]A,
    ISNULL([col_paid_up_capital]A, 0) as [col_paid_up_capital]A,
    ISNULL([col_accu_surplus]A, 0) as [col_accu_surplus]A,
    ISNULL([col_num_of_emp]A, 0) as [col_num_of_emp]A,
    ISNULL([col_tangible_asset]A, 0) as [col_tangible_asset]A
FROM TB1  
PIVOT (
    SUM(VALUE)
    FOR DATA_NAME IN (
        [col_income_non_rel]A, [col_income_rel]A, [col_income]A, 
        [col_pre_tax_income]A, [col_tax_paid]A, [col_curr_tax_payable]A, 
        [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A, 
        [col_tangible_asset]A
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
ORDER BY COUNTRY_ID, ENTITY_NAME ASC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="CHT_COUNTRY_REPORT1" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_CATEGORY1"/>
<O>
<![CDATA[col_pre_tax_income]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2025-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="BTN_TYPE"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH COUNTRY AS (SELECT 
    -- 尚未鑽取，series為國家欄位時，用來計算國家總和
    T1.PERIOD,
    T4.COUNTRY_ID AS ID1,
    T4.COUNTRY_NAME AS NAME,
    T1.DATA_NAME,
    -- 總和
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,2))) AS VALUE
    -- 百分比
   
FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
    V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='${fr_locale}'
LEFT JOIN 
    V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID AND T4.FR_LOCALE='${fr_locale}'
WHERE
1=1
AND
T1.REPORT_NAME = 'report1'
AND T3.FR_LOCALE='${fr_locale}'
AND T1.DATA_NAME = '${P_CATEGORY1}'
AND T1.PERIOD = '${P_PERIOD}'
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
GROUP BY 
    T1.PERIOD,
    T4.COUNTRY_ID,
    T4.COUNTRY_NAME,
    T1.DATA_NAME
), 
 COMPANY AS (
    -- 鑽取一層，series為公司欄位時，用來計算公司總和
    SELECT 
    --T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID AS ID1,
    T3.ENTITY_NAME AS NAME,
    T1.DATA_NAME,
    -- 總和
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,2))) AS VALUE
    
FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
    V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID
AND T3.FR_LOCALE='${fr_locale}'
WHERE
1=1 
AND 
T1.REPORT_NAME = 'report1'
AND T1.DATA_NAME = '${P_CATEGORY1}'
AND T1.PERIOD = '${P_PERIOD}'
${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID IN ('" + P_COMPANY + "')")}
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
GROUP BY
--T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T1.DATA_NAME
)
SELECT 
--ID,
PERIOD,
ID1,
NAME,
DATA_NAME,
VALUE,
SUM(VALUE)/SUM(VALUE) OVER() AS PERCENTAGE
FROM
${if(BTN_TYPE == '1' , "COMPANY",if(BTN_TYPE == '2',"COMPANY" ,"COUNTRY"))}
WHERE ID1 IS NOT NULL
GROUP BY PERIOD, ID1, NAME, DATA_NAME, VALUE
ORDER BY VALUE DESC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_EFFECTIVE_TAX" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH TB1 AS (
    SELECT 
    T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T3.COUNTRY_ID,
    T1.DATA_NAME,
    TRY_CAST(T1.VALUE AS DECIMAL(38,2)) AS VALUE
    FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND T1.PERIOD = '${P_PERIOD}'
    AND
    T1.REPORT_NAME = 'report1'
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
),T2 AS (
SELECT PERIOD, ENTITY_ID, ENTITY_NAME,COUNTRY_ID,
    ISNULL([col_income_non_rel]A, 0) as [col_income_non_rel]A,
    ISNULL([col_income_rel]A, 0) as [col_income_rel]A,
    ISNULL([col_income]A, 0) as [col_income]A,
    ISNULL([col_pre_tax_income]A, 0) as [col_pre_tax_income]A,
    ISNULL([col_tax_paid]A, 0) as [col_tax_paid]A,
    ISNULL([col_curr_tax_payable]A, 0) as [col_curr_tax_payable]A,
    ISNULL([col_paid_up_capital]A, 0) as [col_paid_up_capital]A,
    ISNULL([col_accu_surplus]A, 0) as [col_accu_surplus]A,
    ISNULL([col_num_of_emp]A, 0) as [col_num_of_emp]A,
    ISNULL([col_tangible_asset]A, 0) as [col_tangible_asset]A
FROM TB1  
PIVOT (
    SUM(VALUE)
    FOR DATA_NAME IN (
        [col_income_non_rel]A, [col_income_rel]A, [col_income]A, 
        [col_pre_tax_income]A, [col_tax_paid]A, [col_curr_tax_payable]A, 
        [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A, 
        [col_tangible_asset]A
    )
) AS PivotTable)
SELECT 
PERIOD,
ENTITY_ID,
ENTITY_NAME,
COUNTRY_ID,
SUM([col_curr_tax_payable]A) AS [col_curr_tax_payable]A,
SUM([col_pre_tax_income]A) AS [col_pre_tax_income]A
FROM T2
WHERE ENTITY_ID IS NOT NULL
GROUP BY PERIOD, ENTITY_ID, ENTITY_NAME, COUNTRY_ID]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_PRE_TAX_PROFIT" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH TB1 AS (
    SELECT 
    T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T3.COUNTRY_ID,
    T1.DATA_NAME,
    TRY_CAST(T1.VALUE AS DECIMAL(38,2)) AS VALUE
    FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND T1.PERIOD = '${P_PERIOD}'
    AND
    T1.REPORT_NAME = 'report1'
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
),T2 AS (
SELECT PERIOD, ENTITY_ID, ENTITY_NAME,COUNTRY_ID,
    ISNULL([col_income_non_rel]A, 0) as [col_income_non_rel]A,
    ISNULL([col_income_rel]A, 0) as [col_income_rel]A,
    ISNULL([col_income]A, 0) as [col_income]A,
    ISNULL([col_pre_tax_income]A, 0) as [col_pre_tax_income]A,
    ISNULL([col_tax_paid]A, 0) as [col_tax_paid]A,
    ISNULL([col_curr_tax_payable]A, 0) as [col_curr_tax_payable]A,
    ISNULL([col_paid_up_capital]A, 0) as [col_paid_up_capital]A,
    ISNULL([col_accu_surplus]A, 0) as [col_accu_surplus]A,
    ISNULL([col_num_of_emp]A, 0) as [col_num_of_emp]A,
    ISNULL([col_tangible_asset]A, 0) as [col_tangible_asset]A
FROM TB1  
PIVOT (
    SUM(VALUE)
    FOR DATA_NAME IN (
        [col_income_non_rel]A, [col_income_rel]A, [col_income]A, 
        [col_pre_tax_income]A, [col_tax_paid]A, [col_curr_tax_payable]A, 
        [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A, 
        [col_tangible_asset]A
    )
) AS PivotTable)
SELECT 
PERIOD,
ENTITY_ID,
ENTITY_NAME,
COUNTRY_ID,
SUM([col_income]A) AS [col_income]A,
SUM([col_pre_tax_income]A) AS [col_pre_tax_incomee]A
FROM T2
WHERE ENTITY_ID IS NOT NULL
GROUP BY PERIOD, ENTITY_ID, ENTITY_NAME, COUNTRY_ID]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="CHT_COUNTRY_REPORT2" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CATEGORY2"/>
<O>
<![CDATA[col_income_non_rel]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
<Parameter>
<Attributes name="BTN_TYPE"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH COUNTRY AS (SELECT 
    T1.PERIOD,
    T4.COUNTRY_ID AS ID1,
    T4.COUNTRY_NAME AS NAME,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,2))) AS VALUE  
FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
    V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='${fr_locale}'
LEFT JOIN 
    V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID AND T4.FR_LOCALE='${fr_locale}'
WHERE
1=1
AND
T1.REPORT_NAME = 'report1'
AND T3.FR_LOCALE='${fr_locale}'
AND T1.DATA_NAME = '${P_CATEGORY2}'
AND T1.PERIOD = '${P_PERIOD}'
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
GROUP BY 
T1.PERIOD,
    T4.COUNTRY_ID,
    T4.COUNTRY_NAME,
    T1.DATA_NAME
), COMPANY AS (
    SELECT 
    --T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID AS ID1,
    T3.ENTITY_NAME AS NAME,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,2))) AS VALUE  
FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
    V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID
AND T3.FR_LOCALE='${fr_locale}'
WHERE
1=1 
AND 
T1.REPORT_NAME = 'report1'
AND T1.DATA_NAME = '${P_CATEGORY2}'
AND T1.PERIOD = '${P_PERIOD}'
${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID IN ('" + P_COMPANY + "')")}
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
GROUP BY
--T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T1.DATA_NAME
)
SELECT 
--ID,
PERIOD,
ID1,
NAME,
DATA_NAME,
VALUE,
SUM(VALUE)/SUM(VALUE) OVER() AS PERCENTAGE
FROM
${if(BTN_TYPE == '1' , "COMPANY",if(BTN_TYPE == '2',"COMPANY" ,"COUNTRY"))}
WHERE ID1 IS NOT NULL
GROUP BY PERIOD, ID1, NAME, DATA_NAME, VALUE
ORDER BY VALUE DESC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="CHT_COUNTRY_REPORT3" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="BTN_TYPE"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CATEGORY3"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH COUNTRY AS (SELECT 
    T1.PERIOD,
    T4.COUNTRY_ID AS ID1,
    T4.COUNTRY_NAME AS NAME,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,2))) AS VALUE  
FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
    V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='${fr_locale}'
LEFT JOIN 
    V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID AND T4.FR_LOCALE='${fr_locale}'
WHERE
1=1
AND
T1.REPORT_NAME = 'report1'
AND T3.FR_LOCALE='${fr_locale}'
AND T1.DATA_NAME = '${P_CATEGORY3}'
AND T1.PERIOD = '${P_PERIOD}'
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
GROUP BY 
T1.PERIOD,
    T4.COUNTRY_ID,
    T4.COUNTRY_NAME,
    T1.DATA_NAME
), COMPANY AS (
    SELECT 
    --T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID AS ID1,
    T3.ENTITY_NAME AS NAME,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,2))) AS VALUE  
FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
ON T1.ENTITY_ID = T2.ENTITY_CODE 
LEFT JOIN 
    V_TRS_DIM_ENTITY T3
ON T1.ENTITY_ID = T3.ENTITY_ID
AND T3.FR_LOCALE='${fr_locale}'
WHERE
1=1 
AND 
T1.REPORT_NAME = 'report1'
AND T1.DATA_NAME = '${P_CATEGORY3}'
AND T1.PERIOD = '${P_PERIOD}'
${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID IN ('" + P_COMPANY + "')")}
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
GROUP BY
--T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T1.DATA_NAME
)
SELECT 
--ID,
PERIOD,
ID1,
NAME,
DATA_NAME,
VALUE,
SUM(VALUE)/SUM(VALUE) OVER() AS PERCENTAGE
FROM
${if(BTN_TYPE == '1' , "COMPANY",if(BTN_TYPE == '2',"COMPANY" ,"COUNTRY"))}
WHERE ID1 IS NOT NULL
GROUP BY PERIOD, ID1, NAME, DATA_NAME, VALUE
ORDER BY VALUE DESC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_CATEGORY" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT '1' AS ID, 'col_income_non_rel' AS TYPE
UNION ALL
SELECT '2' AS ID, 'col_income_rel' AS TYPE
UNION ALL
SELECT '3' AS ID, 'col_income' AS TYPE
UNION ALL
SELECT '4' AS ID, 'col_pre_tax_income' AS TYPE
UNION ALL
SELECT '5' AS ID, 'col_tax_paid' AS TYPE
UNION ALL
SELECT '6' AS ID, 'col_curr_tax_payable' AS TYPE
UNION ALL
SELECT '7' AS ID, 'col_paid_up_capital' AS TYPE
UNION ALL
SELECT '8' AS ID, 'col_accu_surplus' AS TYPE
UNION ALL
SELECT '9' AS ID, 'col_num_of_emp' AS TYPE
UNION ALL
SELECT '10' AS ID, 'col_tangible_asset' AS TYPE]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_COUNTRY_REPORT_SUM_ALL" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH TB1 AS (
    SELECT 
    T1.ID,
    T1.PERIOD,
    T1.ENTITY_ID,
    T3.ENTITY_NAME,
    T3.COUNTRY_ID,
    T1.DATA_NAME,
    TRY_CAST(T1.VALUE AS DECIMAL(38,0)) AS VALUE
    FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND
    T1.REPORT_NAME = 'report1'
    AND T1.PERIOD = '${P_PERIOD}'
    --AND T3.COUNTRY_ID IN ('${P_COUNTRY}')
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
), FINAL AS (
SELECT PERIOD, ENTITY_ID, ENTITY_NAME,COUNTRY_ID,
    ISNULL([col_income_non_rel]A, 0) as [col_income_non_rel]A,
    ISNULL([col_income_rel]A, 0) as [col_income_rel]A,
    ISNULL([col_income]A, 0) as [col_income]A,
    ISNULL([col_pre_tax_income]A, 0) as [col_pre_tax_income]A,
    ISNULL([col_tax_paid]A, 0) as [col_tax_paid]A,
    ISNULL([col_curr_tax_payable]A, 0) as [col_curr_tax_payable]A,
    ISNULL([col_paid_up_capital]A, 0) as [col_paid_up_capital]A,
    ISNULL([col_accu_surplus]A, 0) as [col_accu_surplus]A,
    ISNULL([col_num_of_emp]A, 0) as [col_num_of_emp]A,
    ISNULL([col_tangible_asset]A, 0) as [col_tangible_asset]A
FROM TB1  
PIVOT (
    SUM(VALUE)
    FOR DATA_NAME IN (
        [col_income_non_rel]A, [col_income_rel]A, [col_income]A, 
        [col_pre_tax_income]A, [col_tax_paid]A, [col_curr_tax_payable]A, 
        [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A, 
        [col_tangible_asset]A
    )
) AS PivotTable)
SELECT 
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
FROM FINAL]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_COUNTRY_REPORT_SUM1" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CATEGORY1"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
    T1.PERIOD,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,0))) AS VALUE
    FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND
    T1.REPORT_NAME = 'report1'
    AND T1.PERIOD = '${P_PERIOD}'
    --AND T3.COUNTRY_ID IN ('${P_COUNTRY}')
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
    AND T1.DATA_NAME = '${P_CATEGORY1}'
    GROUP BY T1.PERIOD, T1.DATA_NAME]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_COUNTRY_REPORT_SUM2" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CATEGORY2"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
    T1.PERIOD,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,0))) AS VALUE
    FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND
    T1.REPORT_NAME = 'report1'
    AND T1.PERIOD = '${P_PERIOD}'
    --AND T3.COUNTRY_ID IN ('${P_COUNTRY}')
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
    AND T1.DATA_NAME = '${P_CATEGORY2}'
    GROUP BY T1.PERIOD, T1.DATA_NAME]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_COUNTRY_REPORT_SUM3" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CATEGORY3"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
    T1.PERIOD,
    T1.DATA_NAME,
    SUM(TRY_CAST(T1.VALUE AS DECIMAL(38,0))) AS VALUE
    FROM 
    [dbo]A.[TRS_FACT_COUNTRY_REPORT]A T1
    LEFT JOIN
    TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2
    ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
    V_TRS_DIM_ENTITY T3
    ON T1.ENTITY_ID = T3.ENTITY_ID
    AND T3.FR_LOCALE='${fr_locale}'
    WHERE 
    1=1
    AND
    T1.REPORT_NAME = 'report1'
    AND T1.PERIOD = '${P_PERIOD}'
    --AND T3.COUNTRY_ID IN ('${P_COUNTRY}')
    ${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
    ${if(len(P_COMPANY) == 0,"","and T1.ENTITY_ID in ('" + P_COMPANY + "')")}
    AND T1.DATA_NAME = '${P_CATEGORY3}'
    GROUP BY T1.PERIOD, T1.DATA_NAME]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_DATE_MAX" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
DISTINCT
MAX(PERIOD) AS PERIOD
FROM 
TRSDB.dbo.TRS_FACT_COUNTRY_REPORT]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="1" fitFont="true" minFontSize="0"/>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false" appearRefresh="false" promptWhenLeaveWithoutSubmit="false" allowDoubleClickOrZoom="true"/>
</FormMobileAttr>
<Parameters/>
<Layout class="com.fr.form.ui.container.WBorderLayout">
<WidgetName name="form"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="form" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<ShowBookmarks showBookmarks="false"/>
<Center class="com.fr.form.ui.container.WFitLayout">
<WidgetName name="body"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WAbsoluteBodyLayout">
<Listener event="afterinit" name="初始化後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$('<link rel="stylesheet" type="text/css" href="${contextPath}/css/template.css"/>').appendTo('head');
$('<link rel="stylesheet" type="text/css" href="${contextPath}/css/datepicker.css"/>').appendTo('head');
$('<link rel="stylesheet" type="text/css" href="${contextPath}/css/scroll.css"/>').appendTo('head');]]></Content>
</JavaScript>
</Listener>
<WidgetName name="body"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1317147" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD"/>
<WidgetID widgetID="832b511e-63f5-4004-9a2f-659da43b11a8"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_PERIOD"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<DateAttr format="yyyy-MM"/>
<widgetValue>
<databinding>
<![CDATA[{Name:DIC_DATE_MAX,Key:PERIOD}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="452" y="5" width="180" height="15"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD_"/>
<WidgetID widgetID="832b511e-63f5-4004-9a2f-659da43b11a8"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_PERIOD_"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<DateAttr format="yyyy-MM"/>
<widgetValue>
<databinding>
<![CDATA[{Name:DIC_DATE_MAX,Key:PERIOD}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="475" y="80" width="200" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_PERIOD"/>
<WidgetID widgetID="8984286b-2315-40ef-bea1-895aa4755d9f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName="LABEL_PERIOD"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("period")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="475" y="46" width="200" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_ENTITY_NAME"/>
<WidgetID widgetID="60c85dce-6bdf-4cd4-bfb3-16c895813fad"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName="LABEL_DATE"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("entity_id")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="915" y="46" width="200" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_Country"/>
<WidgetID widgetID="d506761c-b875-4982-a6b0-53670ce8d233"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label3" frozen="false" index="-1" oldWidgetName="LABEL_CFC"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("country_id")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="695" y="46" width="200" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//var P_VERSION = _g().getWidgetByName('P_VERSION').getValue();
//var P_REC_YEAR = _g().getWidgetByName('P_REC_YEAR').getValue();
//var P_COMPANY = _g().getWidgetByName('P_COMPANY').getValue();
//var P_CFC = _g().getWidgetByName('P_CFC').getValue();
//var P_START_DATE = _g().getWidgetByName('P_START_DATE').getValue();
//var P_END_DATE = _g().getWidgetByName('P_END_DATE').getValue();
//var P_DUE_YEAR = _g().getWidgetByName('P_DUE_YEAR').getValue();
//alert(1)
//_g().getWidgetByName("REP_05").gotoPage(1, {
//	"P_VERSION": P_VERSION,
//	"P_REC_YEAR": P_REC_YEAR,
//	"P_COMPANY": P_COMPANY,
//	"P_CFC": P_CFC,
//	"P_START_DATE": P_START_DATE,
//	"P_END_DATE": P_END_DATE,
//	"P_DUE_YEAR": P_DUE_YEAR
//}, true);
////alert(2)
//_g().getWidgetByName("REP_01").gotoPage(1, {
//	"P_VERSION": P_VERSION,
//	"P_REC_YEAR": P_REC_YEAR,
//	"P_COMPANY": P_COMPANY,
//	"P_CFC": P_CFC,
//	"P_START_DATE": P_START_DATE,
//	"P_END_DATE": P_END_DATE,
//	"P_DUE_YEAR": P_DUE_YEAR
//}, false);
////alert(3)
//_g().getWidgetByName("REP_02").gotoPage(1, {
//	"P_VERSION": P_VERSION,
//	"P_REC_YEAR": P_REC_YEAR,
//	"P_COMPANY": P_COMPANY,
//	"P_CFC": P_CFC,
//	"P_START_DATE": P_START_DATE,
//	"P_END_DATE": P_END_DATE,
//	"P_DUE_YEAR": P_DUE_YEAR
//}, false);
////alert(4)
//_g().getWidgetByName("REP_03").gotoPage(1, {
//	"P_VERSION": P_VERSION,
//	"P_REC_YEAR": P_REC_YEAR,
//	"P_COMPANY": P_COMPANY,
//	"P_CFC": P_CFC,
//	"P_START_DATE": P_START_DATE,
//	"P_END_DATE": P_END_DATE,
//	"P_DUE_YEAR": P_DUE_YEAR
//}, false);
////alert(5)
//_g().getWidgetByName("REP_04").gotoPage(1, {
//	"P_VERSION": P_VERSION,
//	"P_REC_YEAR": P_REC_YEAR,
//	"P_COMPANY": P_COMPANY,
//	"P_CFC": P_CFC,
//	"P_START_DATE": P_START_DATE,
//	"P_END_DATE": P_END_DATE,
//	"P_DUE_YEAR": P_DUE_YEAR
//}, false);]]></Content>
</JavaScript>
</Listener>
<Listener event="click" name="點擊2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var P_COMPANY= _g().getWidgetByName("P_COMPANY_").getValue();
var P_COUNTRY= _g().getWidgetByName("P_COUNTRY_").getValue();
var P_PERIOD= _g().getWidgetByName("P_PERIOD_").getValue();
_g().getWidgetByName("P_COMPANY").setValue(P_COMPANY);
_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
_g().getWidgetByName("P_PERIOD").setValue(P_PERIOD);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_SUBMIT"/>
<WidgetID widgetID="a6e1a1b1-f4bf-4c1a-baef-5d263c30a6a0"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName="button0"/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("SUBMIT")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
<initial>
<Background name="ColorBackground">
<color>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</color>
</Background>
</initial>
<over>
<Background name="ColorBackground">
<color>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</color>
</Background>
</over>
<click>
<Background name="ColorBackground">
<color>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</color>
</Background>
</click>
<FRFont name="Microsoft JhengHei UI" style="0" size="80">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="1735" y="76" width="125" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_TITLE"/>
<WidgetID widgetID="db840ab4-6734-4b0b-964e-0982f426ae64"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABEL_TITLE"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("cbcr_overview")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="1" size="176">
<foreground>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="60" y="27" width="415" height="80"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<Listener event="afteredit" name="return false;">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_COUNTRY_"/>
<WidgetID widgetID="83d88d26-1320-4dcf-9131-79e4189cceda"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COUNTRY_"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COUNTRY_ID" viName="COUNTRY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_COUNTRY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="695" y="80" width="200" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<Listener event="afteredit" name="return false;">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[null]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_COMPANY_"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_CFC_"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ENTITY_ID" viName="ENTITY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_COMPANY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="915" y="80" width="200" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COMPANY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COMPANY__"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="INV_ENTITY_CODE" viName="COMPANY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_CFC]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="1244" y="1" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_PERIOD__"/>
<WidgetID widgetID="9ee11104-7808-4d22-8a62-8d496c308c41"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox4" frozen="false" index="-1" oldWidgetName="P_PERIOD__"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=RANGE(10)]]></FormulaDict>
<EFormulaDict>
<![CDATA[=$$$]]></EFormulaDict>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="840" y="1" width="140" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_TITLE1"/>
<WidgetID widgetID="db840ab4-6734-4b0b-964e-0982f426ae64"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABEL_TITLE1"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("UNIT") +" : TWD"]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="60" y="90" width="300" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COUNTRY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COUNTRY__"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="INV_ENTITY_CODE" viName="COMPANY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_CFC]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="968" y="0" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.PictureWidget">
<WidgetName name="BTN_RETURN03"/>
<WidgetID widgetID="7ef4a073-8e3e-4b29-8476-0724abfefd7c"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="picture0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<com.fr.plugin.widget.picture>
<FloatElementName name="C:\Users\Tim.Chou\Downloads\back.png"/>
<PrivilegeControl/>
<Location leftDistance="0" topDistance="0" width="3810000" height="3810000"/>
<O t="XMLable" class="com.fr.general.ImageWithSuffix">
<FineImage fm="png" imageId="__ImageCache__B8161F937A9A626FD84A979A4517A6A9">
<IM>
<![CDATA[I<p0$P[2rA\S&oQehSs'Zs&WhA1>\mBsWl+A=68>*]Ar&a><SpIZ=F7rG1nL4D:"NE/BP8nC^
D[MA^hj^GD=u#n,;SN_f/u+pKGjbY&gc#>dQ=P.(i_u2#oo:n=fg3!+5fqB,)KeqAK/+2ZQG
l%du?^$-iE,E2J*MZ1KDB"1g%iIfh6uf-JNY4oA(sO'?P6as?t=Ol\lQb7lHOWu"78LR6R/f
b!ob)p[1(a#V3P%V%2^eo'$f4^7\FCuVR@rBO=t_bBKXODd(D_XiNW>CPA=b8n6FHmnK=nt5
1E,uXeW:6P_ZTYLBBTd.>?._sB6B.W!(lg?n1=e;gXJ2qC.@r=c`W#J7/-=a4tfF5a[%B5s\
F?/.r*ED"GVfD!j&K&;4YVUW$/=dEe=2%Xj&K_:rg8.(-0[$=\5$t>P7"77OYeb='$UF9W$N
+%!NJSA7MQ(81aN$&NTGJE):>%Ig-U)hFg<oouT.lqiSd3WDh_>3f0r!>oek7)#9gKgr>D8M
0.]Ar0IE:c2<d;+F]A6hML#>Go%(aGes"5CAiV"1(Tqg'_Y/L#W\M$dG4#Z`I"(N2+o@$b&TuJ
K*rn5oS6?YIN:EgasQ8"p!fn@K$hd`cURLh58N6`Mll<2!9b;fPW]AFT*6B';MV3S%o2q@W[d
.S!>+!9%P7:@*?9L:O&5`o:Y^NtWI5&I)1r1b@PAra$A`F%M`LO$fM?`-gn9Ai8oHM@E#u=s
cP#79bSYV(&NQIRn)GS.7:8\c.l_%S/.Vbu-qrItfh3b`KJgC`TVg'YCBO/oB+sL?%bVX@gT
;l>X.]Agb2.R(\D=qkJdqC<Ek-;*Vp3!\*<JukLd$4tF=Zh;dZ]A%;RVEZ-K&=@Lt[1P2)"iW\
25k@4]A2C:X]A-=\l\+T!FFSNG79&;?En6$>"oG?S?GCNVju`q'HuHjf7ERi_p@b+\WU=;8.%d
$"A;[)4S`*>An>Z'S&/[E?:1Y[Fh.U%e"LX04NUcnoupQjf&CbkIkcJCud_G\i>SOPUYp/>'
+T?%Q`&&FJ>nOgop,eDqJIpN#p=RP7$T<&%(-,^pX3"opPneHLtBZoJfp2sqqZgW=OIE'^*e
o3m1e%#/qfn7p/\On-nQf#>-Y[+*667h<n?G)Z\+7aRXkrVdV)M6]A7$>iFsJ.0.Up=0oGb+K
VsU0&J/B&"B5X[MP^l,GVuI&5\Otj_8FJe)LSp0G+Xs-:i>u7ATqU+TbUak,Z=5Ek<`l8#bo
``6iuOj;)ah`UQS,=S4'Q,\*5d!H';LHgb;LmaNZq@S`YNBd#!%b:>Bd3>93pmbtpBCQu>1,
;>S48l)TTmOud^G$2d^bb;1)MT*+12XD]AcH0tM;M5,g4\KOl=YPq"Z9=WYhO%?gPp`"l2@;k
=G,hk3>n+5/Z/B*74,=&cmqle*aCH]A"DSB$-9ba$,4-]ASIR8EdM=dsi$V6g8i1)HP;u,+O;l
2i;t,mg-42iB$lA2c9B2fA%]AW$(OLF"b9*^=8^9copuOY:\-pa<M5+^9#54gZ'p$4H3(,#E$
Gg=K?Zn@R_"UM!>6;DHM=HIZhbi:HYX[1#r<AXLX7DnW4j9UYI;*OBh4K-iiupI:j8R)[[A;
ll_4&Z:jYtEgiFKi+@uibq\Fp-h9nsq'>FbUH6`(ob-,B&NX^Rm6-+5%hT$FED,]ABaE8\!n6
8jsO4<OohkCZt]A"_r7EAQ5N]ARbONS8Z++ih3%!tKe9)W$l6'6Tekk$[K]A-mGb4Q=8HINF6%"
W)0143JKbYdOJalQHRW)_tm'Y3N\((h!Y]A\Cqg"!07kki%mIH4_/CMDj9dUjQS^K_aOQMPGL
*gj']AY"ePFPGVarqbX%__OcrrW=I/m=/WT=k`bVVQ)134&0fg4ODL$kb&VWtj&W$+h0^8I(D
9cK,Q#9@BnIJ+aN/I7ku]A]A?lknMtGlO&o+>"4D[`@laW*[!>U;/2e:$H"XX-OQ-;+O_qio\D
VA8)eLEdoNY9_)j?kebTH<$^1naN^*mC9ASjp_SOJV<T8I+sh$.<9+4@l6Jl6>*s]A]A$@nMGZ
HGdH3S\m@/>9hS1tNbZ$D^_Nh3F]A[ku""kjH+2lm([P!=IQ+9F?b_Q`1C;g=t#N[SSX,V&G+
7PZ1<N0W?B@P+lZq7nuSu4I:R]Af$q?HL*rek'Z6TiNQFes@T&9t;FjmQm;Pn+hN!=ZF>q,L'
Wkh1P3l@%qn1J_"p:h*0Y<)+X`+jmNdOTW%9ai>SF>^f/+'?5lCZU$EjEK1!<r9SgchQfK<C
3`3Un\5e7T/;KKK`2&/(Ha#/Mk%8<9U\UT2)t$:A22K)CYnD[A`/h'$3me7$U+hUV=56T(\g
5IHSF[eMD'rUU[k9-4>s:g)\qg%b.<3)DML@h19@fT:#:ls4i)R,(<#Z?\9F[Aop.kN&iSSh
U>M0P<C"EZ%B3JJlsb?)KZf$L_mcD2=-7XPb0tb0eqCkZSO'POb>?t:0E@9Q^D&UZ$ZSmRoW
5db[nkoW$Qq%:CGp!jaedZ*_K_1+4rHLjc[^N>frR[Pa-3ra,N2Ugbj%?mdo!8$utW=H;&1>
!J><m8']A\9laa#%m75dZmG?n.X6mg='$WL2Km2VrEFOk`T;uuQr1daZWUo)i=d[i)G/[P?VR
YRL=U<D]AUNjo!+KONgDc36d1&A+US?Y]AUl:Z;N/Xe)A<]A;G&]A1>_t:!bDU(tMr^qVt)bReGm
@@l'J)Jja]AW.GE0%pR>ss-Qd.Xe<Ea&I9B_c=`n_5+!8a9HH]A7<Z1`.4'.VN[c3OtTI>Pa_+
t/KN?KX'WF`:0&42(3XLDER<bD!";c,QWm#:/D^#/PLeKrl8>gXP,WLo&/2=lrKZHt:\M`/K
"uLlnT=cB!o)U:5j%lk\r^=O=Y;fsI.\M@']AaH3E+/4m1NaQe#^7#`Nt!YGLM657JmKdW;LT
F*;0)n6E@&bCnSc4XY8nL5@2[/i\cbg`Pb-)1@lBb#'_W[)G'U!_qFKFP!Kh<n+)fo8O(LP6
1L<7dL6$cpTG-<Qs26HLKEQ$\"9j1dDEX;3m^Mcp@jVAKu\D6fnc*@b>",GT9=q?@`5>OR_(
03I_:ogOD<1=O8N'C?^("1;SKS3[OIHpf-L*\,\NR5_5b'4j9mMHo)IpIX#PTP3Yt,s8-:!I
/;^PD,tsXWWIW+KQ9k_e%R/GhLV+9T!:5_o[)5#D,EKfa+/=0-ooL&B=+MDn57Ar\U4\U>(?
^4'a2dtA7^38>.p9@`<DM")D+Pj-Y#^3G>e)=H5qFc-T$XgV78EPOsKNX=hldkpYsOLc$93>
I`8d1JQS?=^i/Y0f=)OKU<_tBF*Rqh5'bGkCutg8e;YIJoR6&`ri@+P(gTe`F>]ASK*tU5t3q
bT*e:sCg;FQf+Cg8.:9@XfUiss$(ME!4G0TAXJo/V/-gBbN]A:GFUSTT'g(:i?]Am8RpYC5R"D
,fA4$M(e,@lEF;uR^%)iA[&64fJk:)g^XV``5S@G6U;r5`IObB\q/m=$._qIX0bAaT700d5Z
K>XWr!N+^^PJtZIY%I)d!q>Br&ts6!A*u4AFG)@aIb6m+W);9e7^C`c03uf^TMi2]AlM6lN!4
k2OR-qrAc8ho+A!)[Tf5@V_0/Wiq>"cBq?*5t!3BSj.pPlc9Uo.CK&oCPfg!#A#:4?&565L^
22PeuF6OJ70'^Kk1FV-m$4kf8&O>]ATX/Vc(gl'XBFYIc!;OP06lfA3c5K5c`/tTl9r1:jH.K
Ap:1<]AG`SpRM#;i1fmfl]A/toIHB^oOBrkm#L/6Pos6KJE"O+moQf:b!2q7fq*0DT9ui7N,_%
#[VT!+Xg.K:^kqD*GpEbbdj$g+^*$T/J6&S:.Qe8BH?`?GkN)HuT*mO]AG)r(&,N);Ip5&Qj1
NK\okMOp$9nW'C6mi$^&71EY7;fN_3tduS?Q+?a8':1U3H$^PrH0e3T]A&Wq(-s_[\UEJ0$g/
RuY_B+\&0T.1a16S-+)IlQ:lg*8BP+uiC'js#>fF($5>'X7S4VU)?)f&tY89Ik<)`YG#3k+Z
Qm.U1n#9`Oep8HG3o]AsD_n[@*8M4nAa26Z[8K]ASj`*B0-R6C0J>EML.9<<i/PkS9576iW$T&
:Raa?KEo:RkNHAT;iAQ&01V"nEH)ku6q2M0/\uU[09?c9.3N#K[L"S[q+j45b!BBc(2<*N%,
<7tB`#R;6;KrtdA(hh>@2Y<`X.YY9Dt:"[jV(CalXk&&\hou[:,2#V*)a@rpLDGj/GPD]ARXQ
N5Cj:`Jh*m@dO?>qm;\:8(5ZGiV(0]A?\DlNdE>J:4+WQ\.'9krRd`A5D;O3O!oKr5H>!hjle
`mP4.%/bh%=\F5"YG#q:Cb?-dY\bs_;:0?$sC]ASMJr2\TZ@@<R$J(.,%8Z(TAj_uSB-mY753
/jqbQTZ_;n!-P:=@-qqKIK3/n%qXX55IF2c\G>$Wl^lc='_=4SipEDH`h6ePd2<Cdkc?\[D[
2?kn?G4ED&\(XV.jNf^YKY*DYRM1>9ufB_MQS8L]Afq-Q(&!_DRBfPl;I0m,/FN2)`pss$jaW
*!u0X!%E,3\EB)$*`A^oR]A+`OX)\t=fT]A'>&rfP/_+Wp/t6f_4)16.&NHNX_2IqEtSnek+;"
k9>&;.R'?+;*m"hQcUrI=O4k)l>tP5er*&QVE+?Vt*4U21:FD:^$mA?%JR\g5Q?]A@!EKCd3k
PF*_:%7JE_mUQ_n<p0NqSnMddX295YZpZ?Faf/&FgqPQp0FKgLa[-GY[<J.DnGD4*gk[_^\4
XFpWI';)!-PhDXPFmn6Rn%i9PdX^rkY1blD]A(EW?*mMM6KE,0oHB[1sZ3U0<QNNn+QUS-Np8
g7qaSpcdq5t*NH[EVbZWS+r8^f6LI+;4'2tm\WD'1&j3s;0_cj,`.lOca4s17<)Z`2j"?2\'
V/;+eFHI`_bKE0SPVXM!2NRE`N=GCOB$7Q.i:j<.-e$,Vo1%h;c<a!:9Z;4]A,%e^mF=\<sbK
@:1e0S&lCS[:':-\e7E3^l_t,V*9%!l[VB+__Rn$uoUC1@^57!16dT%h@#o3m!F8DPYe'o]A0
*$4eO/5]Ak\TO,8>n1O+;u0.ri>89*E!Cd+tI.#Sdl>B9PgEZG7KMQ7m)MY]A^)"o5E`7/V>S,
ngV]A_TK@Y]App-C0>)9O^\-gPAa%/!ZkH?KZ?jg)"TZYs"VO]Ap/ZQ/+E\dMgV(5D7KSXhJ2<C
DOop2_>d/rB`%<Cfnu!$J;Fo#g=o["4es!(c87?/[oRj/KaP`GKRb'_<7-;/`]AJe7eVY78rp
g-Q@lE?FGT$^8bR,Me!"3AYU8gHuF5".b8^UI.[KFRTDKCq^(SiGrZ4K=kH%2LXe98RO#i[o
RCW!-@JG%DOr6(CFd$NdN*j4^OnHukA0Zo'Y4TW+O*ODp`,SKKosq!r/,GHVq;-ETLJC@SlD
]A,02n;H?7^HPR(Js@$c%5k;]Akg4j?+ZQj+.t4P_\!hBRl_L85=LqL9L]A/]A'0m?GgC)6]A.+T)
(=Qmsd*]A&O]Ac?&nc5".U#E5p#DhZ"L@n(Wl3Q_S>k^n,YkVPiIia[u(UX;'R<.%q5^[W(.n*
$JSAKq3:j=/L8+G[WmkZ=OML]AeKdHT&P5]A"FEQf;'ib:o4u>oBrenDtA"G.98RR8KhIbJp\R
2ZR8Z/S5B45Hfm8>dUtD<)\@]AY&O8E5^C/iF_*(Fd_lALmE3-n:M$=MH=>dX7Au0SH:r]A76$
#!I3*$QO+;!5N[#\A0(jdaQG/,XRp4MsfYomZfS!h2V5C<8IQ'dDF24%i@W^7"Ynj)/]A`>A6
VM!q>C]A@Ea+G.j?,<:`h[GW]A+gk\2A)24G*GVa_a0p0uTKW\lm>sYF`SGc6lIjC1SO5(ds95
-W<):DJtbE"46>i3.s&$bYX_664_uSj^(SA@/Z5f&KI[bCR;,[OkgPilTq9c-;Q(Sh[XP]A4n
l@h,i<iG.A0L+TW/u^9;>g<FAN*-mrUlA,QR[,jf6!*B\n8bRuu$8k6O?NZoJg3Kh8V`-:d%
&l";broIE-!p/j4D'ES]A#Q7FBX=d?D>7A-Xi!1!$9KtnX)9P$g!<X"f5d6I.,/T2j[8lq!l%
LXiTjBo"o?e8eZFRiXk$-#J_5X6_>QIL;R_$r(fj7pI(p\mM;QRK.ToI<BG"Wiq`)IO=&X'N
R['4RI$cC>IUY,==JNCV1GF+H0lQbg<q#YdPf3#Z4ON72a%I;6A8?n<Z?[J>0gi42j[K#k-)
hVan/3A;s-G9PFM;GECj(XB(ZpEh-U7-:XL;+-<acl-*!JQT3nW_?1.qq_4`_bi(_;[8B3hu
si:_$!#lp1ab?=g#WQHPn1"4RJXdJt99q1-GpNSCOo0^uUk4eg>=UH:\.c,+AYf0"=e(%2_k
P0^:0>-(QAN'Q\)3fj._,f(3,PXQR9t>#c:F5ZkNAQ;gKO38.U^cS31cdBP9JoU/To\gQ'E)
a*ss?%E5gSt0pfL&!u<.olo]A(PZ8bQ__,7@,sJ.d#=oNl-i`f'gV>amfJrEi#VNQ"CEecTNQ
p'J7V=Ne<'lP*9p\i7mU6hPJuYEU+r4LF-05[BlY40A!dIA[V55<(9VI$d*-MnXfPRE:;X(,
^/="k)RYDCpuU&hZtLeLfj,Te?tj8"lh?HrJV)ODr&buTqfLUp`PG9Cpg-1>[@8^$WW&K&F>
>Q:p-Mob9&OA(aHuMA;%Wd+S4Z"N^e+I>)u`I7X5Or,3B,pAfN_.bN1/h9_5<.G^>eU-p!SM
C)a9b-3U0Whek>I<:(SP.7hS4:_@n,ShFZCXr6&_oWj8Js]A0U!'YC1P-rG*k2"jN*]AJT5T(Z
-cJb$Rm;9mQThrUcH5&a<3lGo6']AI'0FVa<!E/^mZAg"%/E\qoj,E3Eu,TkVi6U*^I^r?^Pf
+dctVh2>kQ]AH2A\F)a8ilU+]AH,.690c5H4Xr3'_qtE)$J-"Yu>^L^56`V=0r/USbZp8B$gQJ
c=7Z>Z(^X$\[UaW):9OjIBG$B5'h;scSE=)"E[tR\3E#nOmXaN,9.Hg-H]A'l:2(LR:DJU3_(
fW,/^q>'.4S.C@MqJ2R%NQ-c(jhRbj:5.Kc:VTKaeO(JP&H@[8Pq'H4KWa<kUY";=)HHY`6J
ZNb5%&HFGg5Hu>cFVpNF+O:mQ@2VNN4dno8FiT_&rFd07"HNup:rg`hXELk:AIL1lj9D(]AF-
lB4DisEH/gd;4*54!H[dX3lLqa_9FCX'I%>Id=,AdK((S;Y]A&;?1^>C#,&VMoS=MF_iCX\Qt
QpMFZe:3C,UWAr05#i,&&\gLS_*!T^A%=(#$-g1ImQKrLCd@0)E2a<LbM)#!JEA&e&4E_,tl
,&UK1JmrTN"NH?TRK+;Y-_Jl11$YGbB[Hat(AFNSD.Mb)A"4g+6OZ$_4tf[6o2T*Ff+XqCVc
<)QbZQ#WT%l'<htsJaM^<e$mQ@n\d%\c%H+Rrh\%Ca2MBOc>^^(ZMRO*RTR)RPAT@U#ZI.Z+
^e52?!]AM4=<T@OoL`Y0"UfUK$.*3j7DjKinHrNL.QoY=bO4LH$BWeNCj=OR.DQ1a2oL(2lT%
\%71^I_(?("q9L85mfPQGoWXc\HFXiZ@i%M!p#-8^qbGadh&:[2DYGq0d\+8[KaS?qkhV=."
<&m'Yr+BN<q.ki\Qo<O31"V8q';W`u(PEl>RF4!_$$cI^pF5?u$cl`DBqf;Gm;aCE!^;<1&l
Jm-/#XB4I6ChMQ<s17CkVbWu25g9PG^R9&Io,=?7W(2N#:%.!\d42]Ac^pp>fL"?Y/*CYbins
'O"p5etZHA>a`&he&JjS\T*[q%ma,(al:P?V\h^!c"*-/>YV@'XL$\GK\K)uEV;i/6o,`c8\
4jkXs@d\;VVc5T.?3eVP+VC\]A=!CoubF5[N&;6Q(V8oIW10eu'R$&H5(oAmk(_=*.bk>,SDb
&m?<oBXJIf#OOPMU"hu!N;8JQ^KeKiep-a/'HXo0\l5E#Ho@eANmp(mOE]A!a#1aB*RHKUOVt
%D6=B+QmJ%Bc.nLVQbsZmg;&G&oPo1$eLf!,1OF5<mTOWF4_A*BLM#!>]Aq"[-UI9g\ZJIt\[
6q<NIB_4I>Fi]A;:Aj(A9DQA#k7e_3[l&#)'[G$T+5$o2:+\RR1ei^FS?+`(AH$.XP<jV=,NW
;q<.5Z5g2?*'`8`50RZrjT%1Ki>!^I\f\NZSiCLd>8FH`di8pFFE!7gCW%oF9\u<di71WMla
KHP8bFhhaknLW>A<r=Q*dVU*QJ1#YS?)q0Sd$tP,B-Ttj9/d`%RUZ,V@p^HDLe<HI<[J=naM
)&0G<ln_O`O?sdP^>J>iZi+h[6%bKlIT(E#m).cgX16MfB`#'REP'.?-WB4%7P/<!`hc`mik
(K+HXW1&2)@`S("Z)crZ*J"AT`3J6uh;e0NpD$&u>,1&l\hD'g=7;4;Wm>37qiH$U2;8=<Od
m$FSKT(GkSGrn1K/dSatg@$9M2uE"U6K9;hV9U5hC&H1a92L-lJS%Zbk7dsrWnTr"Y]A"7rbR
:&(n/RU+ck[IqKdQ"T%*R60@nDN7E4l-K<LCnAI3ml8:o0cJ(dg^HEn%q=$a/0C)^n'$mA4H
]AH0/'PNkPDF@EVgW9BoKXL#Xdep;iN-fp;O7^*<+b-LWfqCYr8<YbP;jLG<K?-,eeD@Y>]A);
WM+IFD,8^!6^h"O7/&goVG[KmGhe)oT8b$Ti]A7nFm@$,&6aq`>V^.LB(BAI`)C[%O[0%_5F$
FC8\"d2N59W$jl>gdrHU2[_s=^M@`O_(1U"L!`Q7[hK?LF@]ASLN&SlfW6m.BE!I6V)Or#V`5
p_BoLlgSQlq:X:8>]A6A2ffqP]A57@m]A6jUG,Y9JF3,-]A9CMo&4E[J%+9$hEo.a\,O03(EV[@J
N\u">K5.UV.kQcp,3I#?C2LY`ll$8[\(ZHC5]AcTE\Ba[D&8O]ApJ-!'cS;+FH;C*A<l+r=:HV
Y6_*)?\k:qpqtX/t^CLCoF+S<[5=T85;&p&Q:u@f66)4;GJ[XYN,-[_kbkj&LcEJo)0Qn*(q
0Fj1InZs@pUbJl9n4?MlGa-!cc`K3JrGp(\K9ok'ORsCJaKWGRqG<,MSWA8YVP!S,,i@4V(n
0>V=/im)X3Ej*nc87m@kGcfaEmac=V(Pn8C"1[p@1VJBa,7cTY5IUHI'(c!WFu*De;dFaUmu
B"qr:4PA"mC$j+4]ABd<4LB'20g=GMJE';.7Jlp]AJaUK;<Qs4[?VBkS<YTUY>e,n0M\%bi;hB
8;Ks4sREb'hP2$mt!Y!fX7">n'd[<UNC@L;."1nM""elINs2r:Ps?d%29N$Egk^/DrndrEqK
7Q3fDqo-q[Vk3E\2Sh/iJ6/a-XVO@JJ$MQN&a(P^>]AWam.;"di:Y`iutH_]A?hcm>MNFtmjr,
14@-:.1bhM5cAOrtY"[r%[0]Ah1u-nVpc/o1*,\ZIKQ=I.H*B7e_tj*)tlbonl/29X"Q,B@N6
dW+p:):(a1,/:Gu:cp'LTrrl5eO:0=@8._hs'(uq4)hOTVhY(=UD\%U%'i-981n\qoRR$XC@
05I?f6tk9-?F"X?_-i,1Y)SQ*(idN_7)75Yc=83u*2C@ms)+&H14BcYg7o3Z`F]A<>0.Ub=W]A
CgglfFRl$"jUt4RkZf:N!]A3jUOD_6ljARo30kl'8O^_fq"KJ_0e.@p.a8I.D;2ilp?8gReZa
)-hj5Rs(lrO[^dHH*1V%ccsRiL7mK+\E]AmuII/MK$NeI\j>gT\4,TrBMSdBlfoBXEn*WKZ8/
aX\P@#95u-Uo0ZaUNK&A)_E\2Wl>h"?Y>_4MlK[lrr^'1]A40dTLT]A)HOU:_ro[ulOI?O!<nc
-pU.0pSG6%a@-)'f:b;l2>nCY%p#,Z[bJd<lAUFRI0(NTrM?6m0j25kMiYu+DNjK!Ab9b(N+
e,Zj3"DqE4K9S"!Df[dNb36Tt,)=1B7fAM)nDLC9s)I[lFJ#Lg'7$Gd;h!Dbgn;c>3uU(]A7H
uTCP:"b:mSlSV+Z;hJln<!h79$CC!)]A7HLi@cZQBDDPR'2LI3/`B9=AVrGX$S:.qDt\Ik&k`
*pf_2uNpZm\^Z)\2:4a#R[.K7b[i<L/(B.=[gu.*cL_4'@'fDM0p?SfK,.KDf+rmfs$N^ZWZ
q7Akj2i3&YF9/J&pA+O+19(Jck._!/PPW!Ro^O!fR/(aR2r_[#%?*:#l+P'Z^Z(FDMC)B&kG
@=TJ>2DcF9a\NTL6rk+bHF6d\eGk.X%5$=APQ+-<<s5(#!HrquCX?g8_lk+JG/]A9.jTDhNN>
:05s3L-f?K8'Rp0+A)Ic8:bhWOH[Z-3=NP1VFKE:OM!a'T.^aFp(F:JRJ7f3q"ht_&lb3:f%
c]A#$%")n-DDaYiKcTRrG*#DMR!L4jDe<NePZ9:ij#JT[FYZSOZ>Ai3RG<`=Y9!e=HT._DMQD
W89f:;$0U:1)nHl:Ff$PT%53$&@BWOML.O4MGUl9?UkO$=X>]A-oYa-NU,FiF_%liI]A.AVBJ4
BIg,h*4sP7Kb@RoPa?FK$X<Uq,(4Zm*I8S3'baW709%N:WqDqf+3l6R'TL6r=Vf=K]As!QXp-
-T_Hq\P-R&l*f">Akl_9BTeW,2R'>\8+DADck")-]ADo2s8b`oc#5Ij#O9A8*!0^=9gpkd%-V
?I9Eog0unZp,(C9r#_WqX'&LO!`"gT2/VSKTP=$4KZ:_`8RGe7E->1V9Ii7RE5Uel--MT&>H
%7O<8[slqD[<Alpf*>!)4p)lJ]Am$hCfp'kEQW%*rbou/th"t^BB/c0s`)7SmS%*!&,kG&uQW
#<cJ&Q_SqXm^oUE/IQt;ZT@lKhC;B<`gr4#W;192JIV:TWcN2C-2(;$WCg0g;c1f^bVZB(LT
$WQ!X8HR(k3Y7s39Zf+7=tbG\9ref8Wh_\eblH&^[7o3kCbX0e1ZJ6Qd\]AL"-`J3'EDNC'$f
un]APZdP$ZVX8GJY="oV(9Q2Cp$eXS0^$FM6ja>F,m0!(&$_8(%*_UPYl_6CdVi/,(4fi5l?A
HDFX/'(PtW:8KOY)ut/-Y(b2T=na,[*3O_'1U2"F0[BrY5j.``f3EBq2PfMPS.o6K!(n)nN6
u/tcdgM9cG/b[%KO9oPnoE6r*H\]Ag$\LTBO[.f9.Zc7J5m\21=kd7SPR?nb@i0d/r\q:k?3_
)*=94Dnf5cUp.Fb7lY=KIWJagR3:KS<p?f.A8,Q*/nU]AF>s2<]AgHg83!*Y8=edaBs(!iu.77
o/p`h6YG-H%dY6TZ)XZ,dI(H48SO-,nOng4ba2`#+\r"hRr$^7s3g*j_bn'&!As(`RCR+g8!
C2Nbc,)KErZA$A</-0Nh2&,VF<4WV_M`iMSRWbI"$SqU96oKB']AF4hf6o6=:3CC@H>fT!c30
q2UC#rP'$n+uO#"WusUqCZ5PbkPr$Ncss#2JV82Z2Z%]A[;[a1qCNV(I4'$G!7CGO,E)3<^k:
fRCbCEcOo,)\@WarmAjX&[mI=$0'6U-"]A3B_$#A&F'`:)5u'YOfJIAY&"rYkOhi?!cW<QoIu
s@Vp-*,5'\8o&u8Ac^sCuIQU[E$86QR;fgE37QcNQ3q7c66\L?9B`<B6Hf*>fkB>+RAP!!$<
.HW*3`pCO4eD)*IchmcFBZdkJG"5,:f,2nDp_#!i]AO\GPFGNBjR9:sC0Ki!n)$auaT\hO9$M
UAe`<1n.nS2QO2$0G%gtbR<]AT<XGG!"CTqpE#SssZeqst55@i?Lg&IPi.P)U-qk'o#l??(D$
puJIdHaAn%OaD2]AF2mVJSu;e@I?'8H)l,5L-6^W?';I\Q<N$uoRPQBBWHF2lVjnHG/ra(1.N
cWCc@1#(B%u6(G1m"T$,J]AI$P8?L&T(T\3ujnY>-]A=CR>lbppV:ab/mDGmb,Zb[E`39W7uX,
ACH-mHGKD'`jS#HcBY,j/,Rol>nFO3Ea51mQNMinu1uM7!U]Aq82;;:XAOLLm/P:%%C/3"^^k
tt@@JLqG!DIhg92<P;^*)>*]A&?b98lo5YrG-"':(G)>jOSa[/cZuO2e-\27DDSpt5';m'Y$8
k$C&GhcC_E+(/*:L@ZhKDAilR%oCCrsu)7sD;_u#>I#['Wceh1-006gAI,V$SM3[U.K&qrmT
Te*4XYFeA?c?#bPi-SF5LcogrrfpE20(2GYO,HBOYf<#)>oUIe_-R>OP*)KP;"H9#)83rbV]A
$6ueBoMsFW#;$.ACUG\akgq7Ttr@59/3qiIUn+8F_duK`"iOaikY$CZBW_`-KG18s]A]AaPPbn
?$1s(@mT`l\c;\;4k!H.co"[N;5C9%=OCLoL<$T(sq<H?$fI9aW([V`+e&0_]A'D$,8I863</
!M@idOR1ApN-h70'gd*q/D4,e%k]A.2&13>DdKB["nc07Z\^;UEbV5dQ+h`m>PDo9eg[fA]A!g
d<WI*6*]A$Z1n29++":<.urK%0lEH'X,5#GII=TU=1pG.`e>7%+)AhS#0;?9:C=g@1$0AUc+?
#:TI5]AQn!ZmDrCBgpVOHm<JM>=ZL)Io"U);l(8k'jl5YP<_/p*a0+JSBqL9T^O,OdjZWW2H#
^UQ_4OBf/NHT8D7K[%Z=iLV]AT'+gR(#)^R'TZ)aEt1n6]A0]AZ>2?4=D&F)R0mE#qqT)URK:P$
j]A0`)&>PHMEO)Ieq91*#4C!fSJ\i*1<O+g^8KIh*;JGK1+q^CY,*r~
]]></IM>
</FineImage>
</O>
<Style index="0"/>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
</com.fr.plugin.widget.picture>
<showType type="4" efficientMode="false"/>
<NameJavaScriptGroup>
<NameJavaScript name="隱藏">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "2" 代表現在顯示個別公司，退回公司列表的顯示
if(TYPE == "2"){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
// TYPE = "1" 代表現在顯示公司列表
else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(false);
	_g().getWidgetByName("BTN_RETURN02").setVisible(false);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(false);
    _g().getWidgetByName("BTN_TYPE").setValue("");
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("P_COUNTRY").setValue("");
	_g().getWidgetByName("P_COUNTRY_").setValue("");
    _g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else{

	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</InnerWidget>
<BoundsAttr x="1823" y="504" width="37" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.PictureWidget">
<WidgetName name="BTN_RETURN02"/>
<WidgetID widgetID="7ef4a073-8e3e-4b29-8476-0724abfefd7c"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="picture0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<com.fr.plugin.widget.picture>
<FloatElementName name="C:\Users\Tim.Chou\Downloads\back.png"/>
<PrivilegeControl/>
<Location leftDistance="0" topDistance="0" width="3810000" height="3810000"/>
<O t="XMLable" class="com.fr.general.ImageWithSuffix">
<FineImage fm="png" imageId="__ImageCache__B8161F937A9A626FD84A979A4517A6A9">
<IM>
<![CDATA[I<p0$P[2rA\S&oQehSs'Zs&WhA1>\mBsWl+A=68>*]Ar&a><SpIZ=F7rG1nL4D:"NE/BP8nC^
D[MA^hj^GD=u#n,;SN_f/u+pKGjbY&gc#>dQ=P.(i_u2#oo:n=fg3!+5fqB,)KeqAK/+2ZQG
l%du?^$-iE,E2J*MZ1KDB"1g%iIfh6uf-JNY4oA(sO'?P6as?t=Ol\lQb7lHOWu"78LR6R/f
b!ob)p[1(a#V3P%V%2^eo'$f4^7\FCuVR@rBO=t_bBKXODd(D_XiNW>CPA=b8n6FHmnK=nt5
1E,uXeW:6P_ZTYLBBTd.>?._sB6B.W!(lg?n1=e;gXJ2qC.@r=c`W#J7/-=a4tfF5a[%B5s\
F?/.r*ED"GVfD!j&K&;4YVUW$/=dEe=2%Xj&K_:rg8.(-0[$=\5$t>P7"77OYeb='$UF9W$N
+%!NJSA7MQ(81aN$&NTGJE):>%Ig-U)hFg<oouT.lqiSd3WDh_>3f0r!>oek7)#9gKgr>D8M
0.]Ar0IE:c2<d;+F]A6hML#>Go%(aGes"5CAiV"1(Tqg'_Y/L#W\M$dG4#Z`I"(N2+o@$b&TuJ
K*rn5oS6?YIN:EgasQ8"p!fn@K$hd`cURLh58N6`Mll<2!9b;fPW]AFT*6B';MV3S%o2q@W[d
.S!>+!9%P7:@*?9L:O&5`o:Y^NtWI5&I)1r1b@PAra$A`F%M`LO$fM?`-gn9Ai8oHM@E#u=s
cP#79bSYV(&NQIRn)GS.7:8\c.l_%S/.Vbu-qrItfh3b`KJgC`TVg'YCBO/oB+sL?%bVX@gT
;l>X.]Agb2.R(\D=qkJdqC<Ek-;*Vp3!\*<JukLd$4tF=Zh;dZ]A%;RVEZ-K&=@Lt[1P2)"iW\
25k@4]A2C:X]A-=\l\+T!FFSNG79&;?En6$>"oG?S?GCNVju`q'HuHjf7ERi_p@b+\WU=;8.%d
$"A;[)4S`*>An>Z'S&/[E?:1Y[Fh.U%e"LX04NUcnoupQjf&CbkIkcJCud_G\i>SOPUYp/>'
+T?%Q`&&FJ>nOgop,eDqJIpN#p=RP7$T<&%(-,^pX3"opPneHLtBZoJfp2sqqZgW=OIE'^*e
o3m1e%#/qfn7p/\On-nQf#>-Y[+*667h<n?G)Z\+7aRXkrVdV)M6]A7$>iFsJ.0.Up=0oGb+K
VsU0&J/B&"B5X[MP^l,GVuI&5\Otj_8FJe)LSp0G+Xs-:i>u7ATqU+TbUak,Z=5Ek<`l8#bo
``6iuOj;)ah`UQS,=S4'Q,\*5d!H';LHgb;LmaNZq@S`YNBd#!%b:>Bd3>93pmbtpBCQu>1,
;>S48l)TTmOud^G$2d^bb;1)MT*+12XD]AcH0tM;M5,g4\KOl=YPq"Z9=WYhO%?gPp`"l2@;k
=G,hk3>n+5/Z/B*74,=&cmqle*aCH]A"DSB$-9ba$,4-]ASIR8EdM=dsi$V6g8i1)HP;u,+O;l
2i;t,mg-42iB$lA2c9B2fA%]AW$(OLF"b9*^=8^9copuOY:\-pa<M5+^9#54gZ'p$4H3(,#E$
Gg=K?Zn@R_"UM!>6;DHM=HIZhbi:HYX[1#r<AXLX7DnW4j9UYI;*OBh4K-iiupI:j8R)[[A;
ll_4&Z:jYtEgiFKi+@uibq\Fp-h9nsq'>FbUH6`(ob-,B&NX^Rm6-+5%hT$FED,]ABaE8\!n6
8jsO4<OohkCZt]A"_r7EAQ5N]ARbONS8Z++ih3%!tKe9)W$l6'6Tekk$[K]A-mGb4Q=8HINF6%"
W)0143JKbYdOJalQHRW)_tm'Y3N\((h!Y]A\Cqg"!07kki%mIH4_/CMDj9dUjQS^K_aOQMPGL
*gj']AY"ePFPGVarqbX%__OcrrW=I/m=/WT=k`bVVQ)134&0fg4ODL$kb&VWtj&W$+h0^8I(D
9cK,Q#9@BnIJ+aN/I7ku]A]A?lknMtGlO&o+>"4D[`@laW*[!>U;/2e:$H"XX-OQ-;+O_qio\D
VA8)eLEdoNY9_)j?kebTH<$^1naN^*mC9ASjp_SOJV<T8I+sh$.<9+4@l6Jl6>*s]A]A$@nMGZ
HGdH3S\m@/>9hS1tNbZ$D^_Nh3F]A[ku""kjH+2lm([P!=IQ+9F?b_Q`1C;g=t#N[SSX,V&G+
7PZ1<N0W?B@P+lZq7nuSu4I:R]Af$q?HL*rek'Z6TiNQFes@T&9t;FjmQm;Pn+hN!=ZF>q,L'
Wkh1P3l@%qn1J_"p:h*0Y<)+X`+jmNdOTW%9ai>SF>^f/+'?5lCZU$EjEK1!<r9SgchQfK<C
3`3Un\5e7T/;KKK`2&/(Ha#/Mk%8<9U\UT2)t$:A22K)CYnD[A`/h'$3me7$U+hUV=56T(\g
5IHSF[eMD'rUU[k9-4>s:g)\qg%b.<3)DML@h19@fT:#:ls4i)R,(<#Z?\9F[Aop.kN&iSSh
U>M0P<C"EZ%B3JJlsb?)KZf$L_mcD2=-7XPb0tb0eqCkZSO'POb>?t:0E@9Q^D&UZ$ZSmRoW
5db[nkoW$Qq%:CGp!jaedZ*_K_1+4rHLjc[^N>frR[Pa-3ra,N2Ugbj%?mdo!8$utW=H;&1>
!J><m8']A\9laa#%m75dZmG?n.X6mg='$WL2Km2VrEFOk`T;uuQr1daZWUo)i=d[i)G/[P?VR
YRL=U<D]AUNjo!+KONgDc36d1&A+US?Y]AUl:Z;N/Xe)A<]A;G&]A1>_t:!bDU(tMr^qVt)bReGm
@@l'J)Jja]AW.GE0%pR>ss-Qd.Xe<Ea&I9B_c=`n_5+!8a9HH]A7<Z1`.4'.VN[c3OtTI>Pa_+
t/KN?KX'WF`:0&42(3XLDER<bD!";c,QWm#:/D^#/PLeKrl8>gXP,WLo&/2=lrKZHt:\M`/K
"uLlnT=cB!o)U:5j%lk\r^=O=Y;fsI.\M@']AaH3E+/4m1NaQe#^7#`Nt!YGLM657JmKdW;LT
F*;0)n6E@&bCnSc4XY8nL5@2[/i\cbg`Pb-)1@lBb#'_W[)G'U!_qFKFP!Kh<n+)fo8O(LP6
1L<7dL6$cpTG-<Qs26HLKEQ$\"9j1dDEX;3m^Mcp@jVAKu\D6fnc*@b>",GT9=q?@`5>OR_(
03I_:ogOD<1=O8N'C?^("1;SKS3[OIHpf-L*\,\NR5_5b'4j9mMHo)IpIX#PTP3Yt,s8-:!I
/;^PD,tsXWWIW+KQ9k_e%R/GhLV+9T!:5_o[)5#D,EKfa+/=0-ooL&B=+MDn57Ar\U4\U>(?
^4'a2dtA7^38>.p9@`<DM")D+Pj-Y#^3G>e)=H5qFc-T$XgV78EPOsKNX=hldkpYsOLc$93>
I`8d1JQS?=^i/Y0f=)OKU<_tBF*Rqh5'bGkCutg8e;YIJoR6&`ri@+P(gTe`F>]ASK*tU5t3q
bT*e:sCg;FQf+Cg8.:9@XfUiss$(ME!4G0TAXJo/V/-gBbN]A:GFUSTT'g(:i?]Am8RpYC5R"D
,fA4$M(e,@lEF;uR^%)iA[&64fJk:)g^XV``5S@G6U;r5`IObB\q/m=$._qIX0bAaT700d5Z
K>XWr!N+^^PJtZIY%I)d!q>Br&ts6!A*u4AFG)@aIb6m+W);9e7^C`c03uf^TMi2]AlM6lN!4
k2OR-qrAc8ho+A!)[Tf5@V_0/Wiq>"cBq?*5t!3BSj.pPlc9Uo.CK&oCPfg!#A#:4?&565L^
22PeuF6OJ70'^Kk1FV-m$4kf8&O>]ATX/Vc(gl'XBFYIc!;OP06lfA3c5K5c`/tTl9r1:jH.K
Ap:1<]AG`SpRM#;i1fmfl]A/toIHB^oOBrkm#L/6Pos6KJE"O+moQf:b!2q7fq*0DT9ui7N,_%
#[VT!+Xg.K:^kqD*GpEbbdj$g+^*$T/J6&S:.Qe8BH?`?GkN)HuT*mO]AG)r(&,N);Ip5&Qj1
NK\okMOp$9nW'C6mi$^&71EY7;fN_3tduS?Q+?a8':1U3H$^PrH0e3T]A&Wq(-s_[\UEJ0$g/
RuY_B+\&0T.1a16S-+)IlQ:lg*8BP+uiC'js#>fF($5>'X7S4VU)?)f&tY89Ik<)`YG#3k+Z
Qm.U1n#9`Oep8HG3o]AsD_n[@*8M4nAa26Z[8K]ASj`*B0-R6C0J>EML.9<<i/PkS9576iW$T&
:Raa?KEo:RkNHAT;iAQ&01V"nEH)ku6q2M0/\uU[09?c9.3N#K[L"S[q+j45b!BBc(2<*N%,
<7tB`#R;6;KrtdA(hh>@2Y<`X.YY9Dt:"[jV(CalXk&&\hou[:,2#V*)a@rpLDGj/GPD]ARXQ
N5Cj:`Jh*m@dO?>qm;\:8(5ZGiV(0]A?\DlNdE>J:4+WQ\.'9krRd`A5D;O3O!oKr5H>!hjle
`mP4.%/bh%=\F5"YG#q:Cb?-dY\bs_;:0?$sC]ASMJr2\TZ@@<R$J(.,%8Z(TAj_uSB-mY753
/jqbQTZ_;n!-P:=@-qqKIK3/n%qXX55IF2c\G>$Wl^lc='_=4SipEDH`h6ePd2<Cdkc?\[D[
2?kn?G4ED&\(XV.jNf^YKY*DYRM1>9ufB_MQS8L]Afq-Q(&!_DRBfPl;I0m,/FN2)`pss$jaW
*!u0X!%E,3\EB)$*`A^oR]A+`OX)\t=fT]A'>&rfP/_+Wp/t6f_4)16.&NHNX_2IqEtSnek+;"
k9>&;.R'?+;*m"hQcUrI=O4k)l>tP5er*&QVE+?Vt*4U21:FD:^$mA?%JR\g5Q?]A@!EKCd3k
PF*_:%7JE_mUQ_n<p0NqSnMddX295YZpZ?Faf/&FgqPQp0FKgLa[-GY[<J.DnGD4*gk[_^\4
XFpWI';)!-PhDXPFmn6Rn%i9PdX^rkY1blD]A(EW?*mMM6KE,0oHB[1sZ3U0<QNNn+QUS-Np8
g7qaSpcdq5t*NH[EVbZWS+r8^f6LI+;4'2tm\WD'1&j3s;0_cj,`.lOca4s17<)Z`2j"?2\'
V/;+eFHI`_bKE0SPVXM!2NRE`N=GCOB$7Q.i:j<.-e$,Vo1%h;c<a!:9Z;4]A,%e^mF=\<sbK
@:1e0S&lCS[:':-\e7E3^l_t,V*9%!l[VB+__Rn$uoUC1@^57!16dT%h@#o3m!F8DPYe'o]A0
*$4eO/5]Ak\TO,8>n1O+;u0.ri>89*E!Cd+tI.#Sdl>B9PgEZG7KMQ7m)MY]A^)"o5E`7/V>S,
ngV]A_TK@Y]App-C0>)9O^\-gPAa%/!ZkH?KZ?jg)"TZYs"VO]Ap/ZQ/+E\dMgV(5D7KSXhJ2<C
DOop2_>d/rB`%<Cfnu!$J;Fo#g=o["4es!(c87?/[oRj/KaP`GKRb'_<7-;/`]AJe7eVY78rp
g-Q@lE?FGT$^8bR,Me!"3AYU8gHuF5".b8^UI.[KFRTDKCq^(SiGrZ4K=kH%2LXe98RO#i[o
RCW!-@JG%DOr6(CFd$NdN*j4^OnHukA0Zo'Y4TW+O*ODp`,SKKosq!r/,GHVq;-ETLJC@SlD
]A,02n;H?7^HPR(Js@$c%5k;]Akg4j?+ZQj+.t4P_\!hBRl_L85=LqL9L]A/]A'0m?GgC)6]A.+T)
(=Qmsd*]A&O]Ac?&nc5".U#E5p#DhZ"L@n(Wl3Q_S>k^n,YkVPiIia[u(UX;'R<.%q5^[W(.n*
$JSAKq3:j=/L8+G[WmkZ=OML]AeKdHT&P5]A"FEQf;'ib:o4u>oBrenDtA"G.98RR8KhIbJp\R
2ZR8Z/S5B45Hfm8>dUtD<)\@]AY&O8E5^C/iF_*(Fd_lALmE3-n:M$=MH=>dX7Au0SH:r]A76$
#!I3*$QO+;!5N[#\A0(jdaQG/,XRp4MsfYomZfS!h2V5C<8IQ'dDF24%i@W^7"Ynj)/]A`>A6
VM!q>C]A@Ea+G.j?,<:`h[GW]A+gk\2A)24G*GVa_a0p0uTKW\lm>sYF`SGc6lIjC1SO5(ds95
-W<):DJtbE"46>i3.s&$bYX_664_uSj^(SA@/Z5f&KI[bCR;,[OkgPilTq9c-;Q(Sh[XP]A4n
l@h,i<iG.A0L+TW/u^9;>g<FAN*-mrUlA,QR[,jf6!*B\n8bRuu$8k6O?NZoJg3Kh8V`-:d%
&l";broIE-!p/j4D'ES]A#Q7FBX=d?D>7A-Xi!1!$9KtnX)9P$g!<X"f5d6I.,/T2j[8lq!l%
LXiTjBo"o?e8eZFRiXk$-#J_5X6_>QIL;R_$r(fj7pI(p\mM;QRK.ToI<BG"Wiq`)IO=&X'N
R['4RI$cC>IUY,==JNCV1GF+H0lQbg<q#YdPf3#Z4ON72a%I;6A8?n<Z?[J>0gi42j[K#k-)
hVan/3A;s-G9PFM;GECj(XB(ZpEh-U7-:XL;+-<acl-*!JQT3nW_?1.qq_4`_bi(_;[8B3hu
si:_$!#lp1ab?=g#WQHPn1"4RJXdJt99q1-GpNSCOo0^uUk4eg>=UH:\.c,+AYf0"=e(%2_k
P0^:0>-(QAN'Q\)3fj._,f(3,PXQR9t>#c:F5ZkNAQ;gKO38.U^cS31cdBP9JoU/To\gQ'E)
a*ss?%E5gSt0pfL&!u<.olo]A(PZ8bQ__,7@,sJ.d#=oNl-i`f'gV>amfJrEi#VNQ"CEecTNQ
p'J7V=Ne<'lP*9p\i7mU6hPJuYEU+r4LF-05[BlY40A!dIA[V55<(9VI$d*-MnXfPRE:;X(,
^/="k)RYDCpuU&hZtLeLfj,Te?tj8"lh?HrJV)ODr&buTqfLUp`PG9Cpg-1>[@8^$WW&K&F>
>Q:p-Mob9&OA(aHuMA;%Wd+S4Z"N^e+I>)u`I7X5Or,3B,pAfN_.bN1/h9_5<.G^>eU-p!SM
C)a9b-3U0Whek>I<:(SP.7hS4:_@n,ShFZCXr6&_oWj8Js]A0U!'YC1P-rG*k2"jN*]AJT5T(Z
-cJb$Rm;9mQThrUcH5&a<3lGo6']AI'0FVa<!E/^mZAg"%/E\qoj,E3Eu,TkVi6U*^I^r?^Pf
+dctVh2>kQ]AH2A\F)a8ilU+]AH,.690c5H4Xr3'_qtE)$J-"Yu>^L^56`V=0r/USbZp8B$gQJ
c=7Z>Z(^X$\[UaW):9OjIBG$B5'h;scSE=)"E[tR\3E#nOmXaN,9.Hg-H]A'l:2(LR:DJU3_(
fW,/^q>'.4S.C@MqJ2R%NQ-c(jhRbj:5.Kc:VTKaeO(JP&H@[8Pq'H4KWa<kUY";=)HHY`6J
ZNb5%&HFGg5Hu>cFVpNF+O:mQ@2VNN4dno8FiT_&rFd07"HNup:rg`hXELk:AIL1lj9D(]AF-
lB4DisEH/gd;4*54!H[dX3lLqa_9FCX'I%>Id=,AdK((S;Y]A&;?1^>C#,&VMoS=MF_iCX\Qt
QpMFZe:3C,UWAr05#i,&&\gLS_*!T^A%=(#$-g1ImQKrLCd@0)E2a<LbM)#!JEA&e&4E_,tl
,&UK1JmrTN"NH?TRK+;Y-_Jl11$YGbB[Hat(AFNSD.Mb)A"4g+6OZ$_4tf[6o2T*Ff+XqCVc
<)QbZQ#WT%l'<htsJaM^<e$mQ@n\d%\c%H+Rrh\%Ca2MBOc>^^(ZMRO*RTR)RPAT@U#ZI.Z+
^e52?!]AM4=<T@OoL`Y0"UfUK$.*3j7DjKinHrNL.QoY=bO4LH$BWeNCj=OR.DQ1a2oL(2lT%
\%71^I_(?("q9L85mfPQGoWXc\HFXiZ@i%M!p#-8^qbGadh&:[2DYGq0d\+8[KaS?qkhV=."
<&m'Yr+BN<q.ki\Qo<O31"V8q';W`u(PEl>RF4!_$$cI^pF5?u$cl`DBqf;Gm;aCE!^;<1&l
Jm-/#XB4I6ChMQ<s17CkVbWu25g9PG^R9&Io,=?7W(2N#:%.!\d42]Ac^pp>fL"?Y/*CYbins
'O"p5etZHA>a`&he&JjS\T*[q%ma,(al:P?V\h^!c"*-/>YV@'XL$\GK\K)uEV;i/6o,`c8\
4jkXs@d\;VVc5T.?3eVP+VC\]A=!CoubF5[N&;6Q(V8oIW10eu'R$&H5(oAmk(_=*.bk>,SDb
&m?<oBXJIf#OOPMU"hu!N;8JQ^KeKiep-a/'HXo0\l5E#Ho@eANmp(mOE]A!a#1aB*RHKUOVt
%D6=B+QmJ%Bc.nLVQbsZmg;&G&oPo1$eLf!,1OF5<mTOWF4_A*BLM#!>]Aq"[-UI9g\ZJIt\[
6q<NIB_4I>Fi]A;:Aj(A9DQA#k7e_3[l&#)'[G$T+5$o2:+\RR1ei^FS?+`(AH$.XP<jV=,NW
;q<.5Z5g2?*'`8`50RZrjT%1Ki>!^I\f\NZSiCLd>8FH`di8pFFE!7gCW%oF9\u<di71WMla
KHP8bFhhaknLW>A<r=Q*dVU*QJ1#YS?)q0Sd$tP,B-Ttj9/d`%RUZ,V@p^HDLe<HI<[J=naM
)&0G<ln_O`O?sdP^>J>iZi+h[6%bKlIT(E#m).cgX16MfB`#'REP'.?-WB4%7P/<!`hc`mik
(K+HXW1&2)@`S("Z)crZ*J"AT`3J6uh;e0NpD$&u>,1&l\hD'g=7;4;Wm>37qiH$U2;8=<Od
m$FSKT(GkSGrn1K/dSatg@$9M2uE"U6K9;hV9U5hC&H1a92L-lJS%Zbk7dsrWnTr"Y]A"7rbR
:&(n/RU+ck[IqKdQ"T%*R60@nDN7E4l-K<LCnAI3ml8:o0cJ(dg^HEn%q=$a/0C)^n'$mA4H
]AH0/'PNkPDF@EVgW9BoKXL#Xdep;iN-fp;O7^*<+b-LWfqCYr8<YbP;jLG<K?-,eeD@Y>]A);
WM+IFD,8^!6^h"O7/&goVG[KmGhe)oT8b$Ti]A7nFm@$,&6aq`>V^.LB(BAI`)C[%O[0%_5F$
FC8\"d2N59W$jl>gdrHU2[_s=^M@`O_(1U"L!`Q7[hK?LF@]ASLN&SlfW6m.BE!I6V)Or#V`5
p_BoLlgSQlq:X:8>]A6A2ffqP]A57@m]A6jUG,Y9JF3,-]A9CMo&4E[J%+9$hEo.a\,O03(EV[@J
N\u">K5.UV.kQcp,3I#?C2LY`ll$8[\(ZHC5]AcTE\Ba[D&8O]ApJ-!'cS;+FH;C*A<l+r=:HV
Y6_*)?\k:qpqtX/t^CLCoF+S<[5=T85;&p&Q:u@f66)4;GJ[XYN,-[_kbkj&LcEJo)0Qn*(q
0Fj1InZs@pUbJl9n4?MlGa-!cc`K3JrGp(\K9ok'ORsCJaKWGRqG<,MSWA8YVP!S,,i@4V(n
0>V=/im)X3Ej*nc87m@kGcfaEmac=V(Pn8C"1[p@1VJBa,7cTY5IUHI'(c!WFu*De;dFaUmu
B"qr:4PA"mC$j+4]ABd<4LB'20g=GMJE';.7Jlp]AJaUK;<Qs4[?VBkS<YTUY>e,n0M\%bi;hB
8;Ks4sREb'hP2$mt!Y!fX7">n'd[<UNC@L;."1nM""elINs2r:Ps?d%29N$Egk^/DrndrEqK
7Q3fDqo-q[Vk3E\2Sh/iJ6/a-XVO@JJ$MQN&a(P^>]AWam.;"di:Y`iutH_]A?hcm>MNFtmjr,
14@-:.1bhM5cAOrtY"[r%[0]Ah1u-nVpc/o1*,\ZIKQ=I.H*B7e_tj*)tlbonl/29X"Q,B@N6
dW+p:):(a1,/:Gu:cp'LTrrl5eO:0=@8._hs'(uq4)hOTVhY(=UD\%U%'i-981n\qoRR$XC@
05I?f6tk9-?F"X?_-i,1Y)SQ*(idN_7)75Yc=83u*2C@ms)+&H14BcYg7o3Z`F]A<>0.Ub=W]A
CgglfFRl$"jUt4RkZf:N!]A3jUOD_6ljARo30kl'8O^_fq"KJ_0e.@p.a8I.D;2ilp?8gReZa
)-hj5Rs(lrO[^dHH*1V%ccsRiL7mK+\E]AmuII/MK$NeI\j>gT\4,TrBMSdBlfoBXEn*WKZ8/
aX\P@#95u-Uo0ZaUNK&A)_E\2Wl>h"?Y>_4MlK[lrr^'1]A40dTLT]A)HOU:_ro[ulOI?O!<nc
-pU.0pSG6%a@-)'f:b;l2>nCY%p#,Z[bJd<lAUFRI0(NTrM?6m0j25kMiYu+DNjK!Ab9b(N+
e,Zj3"DqE4K9S"!Df[dNb36Tt,)=1B7fAM)nDLC9s)I[lFJ#Lg'7$Gd;h!Dbgn;c>3uU(]A7H
uTCP:"b:mSlSV+Z;hJln<!h79$CC!)]A7HLi@cZQBDDPR'2LI3/`B9=AVrGX$S:.qDt\Ik&k`
*pf_2uNpZm\^Z)\2:4a#R[.K7b[i<L/(B.=[gu.*cL_4'@'fDM0p?SfK,.KDf+rmfs$N^ZWZ
q7Akj2i3&YF9/J&pA+O+19(Jck._!/PPW!Ro^O!fR/(aR2r_[#%?*:#l+P'Z^Z(FDMC)B&kG
@=TJ>2DcF9a\NTL6rk+bHF6d\eGk.X%5$=APQ+-<<s5(#!HrquCX?g8_lk+JG/]A9.jTDhNN>
:05s3L-f?K8'Rp0+A)Ic8:bhWOH[Z-3=NP1VFKE:OM!a'T.^aFp(F:JRJ7f3q"ht_&lb3:f%
c]A#$%")n-DDaYiKcTRrG*#DMR!L4jDe<NePZ9:ij#JT[FYZSOZ>Ai3RG<`=Y9!e=HT._DMQD
W89f:;$0U:1)nHl:Ff$PT%53$&@BWOML.O4MGUl9?UkO$=X>]A-oYa-NU,FiF_%liI]A.AVBJ4
BIg,h*4sP7Kb@RoPa?FK$X<Uq,(4Zm*I8S3'baW709%N:WqDqf+3l6R'TL6r=Vf=K]As!QXp-
-T_Hq\P-R&l*f">Akl_9BTeW,2R'>\8+DADck")-]ADo2s8b`oc#5Ij#O9A8*!0^=9gpkd%-V
?I9Eog0unZp,(C9r#_WqX'&LO!`"gT2/VSKTP=$4KZ:_`8RGe7E->1V9Ii7RE5Uel--MT&>H
%7O<8[slqD[<Alpf*>!)4p)lJ]Am$hCfp'kEQW%*rbou/th"t^BB/c0s`)7SmS%*!&,kG&uQW
#<cJ&Q_SqXm^oUE/IQt;ZT@lKhC;B<`gr4#W;192JIV:TWcN2C-2(;$WCg0g;c1f^bVZB(LT
$WQ!X8HR(k3Y7s39Zf+7=tbG\9ref8Wh_\eblH&^[7o3kCbX0e1ZJ6Qd\]AL"-`J3'EDNC'$f
un]APZdP$ZVX8GJY="oV(9Q2Cp$eXS0^$FM6ja>F,m0!(&$_8(%*_UPYl_6CdVi/,(4fi5l?A
HDFX/'(PtW:8KOY)ut/-Y(b2T=na,[*3O_'1U2"F0[BrY5j.``f3EBq2PfMPS.o6K!(n)nN6
u/tcdgM9cG/b[%KO9oPnoE6r*H\]Ag$\LTBO[.f9.Zc7J5m\21=kd7SPR?nb@i0d/r\q:k?3_
)*=94Dnf5cUp.Fb7lY=KIWJagR3:KS<p?f.A8,Q*/nU]AF>s2<]AgHg83!*Y8=edaBs(!iu.77
o/p`h6YG-H%dY6TZ)XZ,dI(H48SO-,nOng4ba2`#+\r"hRr$^7s3g*j_bn'&!As(`RCR+g8!
C2Nbc,)KErZA$A</-0Nh2&,VF<4WV_M`iMSRWbI"$SqU96oKB']AF4hf6o6=:3CC@H>fT!c30
q2UC#rP'$n+uO#"WusUqCZ5PbkPr$Ncss#2JV82Z2Z%]A[;[a1qCNV(I4'$G!7CGO,E)3<^k:
fRCbCEcOo,)\@WarmAjX&[mI=$0'6U-"]A3B_$#A&F'`:)5u'YOfJIAY&"rYkOhi?!cW<QoIu
s@Vp-*,5'\8o&u8Ac^sCuIQU[E$86QR;fgE37QcNQ3q7c66\L?9B`<B6Hf*>fkB>+RAP!!$<
.HW*3`pCO4eD)*IchmcFBZdkJG"5,:f,2nDp_#!i]AO\GPFGNBjR9:sC0Ki!n)$auaT\hO9$M
UAe`<1n.nS2QO2$0G%gtbR<]AT<XGG!"CTqpE#SssZeqst55@i?Lg&IPi.P)U-qk'o#l??(D$
puJIdHaAn%OaD2]AF2mVJSu;e@I?'8H)l,5L-6^W?';I\Q<N$uoRPQBBWHF2lVjnHG/ra(1.N
cWCc@1#(B%u6(G1m"T$,J]AI$P8?L&T(T\3ujnY>-]A=CR>lbppV:ab/mDGmb,Zb[E`39W7uX,
ACH-mHGKD'`jS#HcBY,j/,Rol>nFO3Ea51mQNMinu1uM7!U]Aq82;;:XAOLLm/P:%%C/3"^^k
tt@@JLqG!DIhg92<P;^*)>*]A&?b98lo5YrG-"':(G)>jOSa[/cZuO2e-\27DDSpt5';m'Y$8
k$C&GhcC_E+(/*:L@ZhKDAilR%oCCrsu)7sD;_u#>I#['Wceh1-006gAI,V$SM3[U.K&qrmT
Te*4XYFeA?c?#bPi-SF5LcogrrfpE20(2GYO,HBOYf<#)>oUIe_-R>OP*)KP;"H9#)83rbV]A
$6ueBoMsFW#;$.ACUG\akgq7Ttr@59/3qiIUn+8F_duK`"iOaikY$CZBW_`-KG18s]A]AaPPbn
?$1s(@mT`l\c;\;4k!H.co"[N;5C9%=OCLoL<$T(sq<H?$fI9aW([V`+e&0_]A'D$,8I863</
!M@idOR1ApN-h70'gd*q/D4,e%k]A.2&13>DdKB["nc07Z\^;UEbV5dQ+h`m>PDo9eg[fA]A!g
d<WI*6*]A$Z1n29++":<.urK%0lEH'X,5#GII=TU=1pG.`e>7%+)AhS#0;?9:C=g@1$0AUc+?
#:TI5]AQn!ZmDrCBgpVOHm<JM>=ZL)Io"U);l(8k'jl5YP<_/p*a0+JSBqL9T^O,OdjZWW2H#
^UQ_4OBf/NHT8D7K[%Z=iLV]AT'+gR(#)^R'TZ)aEt1n6]A0]AZ>2?4=D&F)R0mE#qqT)URK:P$
j]A0`)&>PHMEO)Ieq91*#4C!fSJ\i*1<O+g^8KIh*;JGK1+q^CY,*r~
]]></IM>
</FineImage>
</O>
<Style index="0"/>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
</com.fr.plugin.widget.picture>
<showType type="4" efficientMode="false"/>
<NameJavaScriptGroup>
<NameJavaScript name="隱藏">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "2" 代表現在顯示個別公司，退回公司列表的顯示
if(TYPE == "2"){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
// TYPE = "1" 代表現在顯示公司列表
else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(false);
	_g().getWidgetByName("BTN_RETURN02").setVisible(false);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(false);
    _g().getWidgetByName("BTN_TYPE").setValue("");
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("P_COUNTRY").setValue("");
	_g().getWidgetByName("P_COUNTRY_").setValue("");
    _g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else{

	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</InnerWidget>
<BoundsAttr x="1348" y="504" width="37" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.PictureWidget">
<WidgetName name="BTN_RETURN01"/>
<WidgetID widgetID="7ef4a073-8e3e-4b29-8476-0724abfefd7c"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="picture0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<com.fr.plugin.widget.picture>
<FloatElementName name="C:\Users\Tim.Chou\Downloads\back.png"/>
<PrivilegeControl/>
<Location leftDistance="0" topDistance="0" width="3810000" height="3810000"/>
<O t="XMLable" class="com.fr.general.ImageWithSuffix">
<FineImage fm="png" imageId="__ImageCache__B8161F937A9A626FD84A979A4517A6A9">
<IM>
<![CDATA[I<p0$P[2rA\S&oQehSs'Zs&WhA1>\mBsWl+A=68>*]Ar&a><SpIZ=F7rG1nL4D:"NE/BP8nC^
D[MA^hj^GD=u#n,;SN_f/u+pKGjbY&gc#>dQ=P.(i_u2#oo:n=fg3!+5fqB,)KeqAK/+2ZQG
l%du?^$-iE,E2J*MZ1KDB"1g%iIfh6uf-JNY4oA(sO'?P6as?t=Ol\lQb7lHOWu"78LR6R/f
b!ob)p[1(a#V3P%V%2^eo'$f4^7\FCuVR@rBO=t_bBKXODd(D_XiNW>CPA=b8n6FHmnK=nt5
1E,uXeW:6P_ZTYLBBTd.>?._sB6B.W!(lg?n1=e;gXJ2qC.@r=c`W#J7/-=a4tfF5a[%B5s\
F?/.r*ED"GVfD!j&K&;4YVUW$/=dEe=2%Xj&K_:rg8.(-0[$=\5$t>P7"77OYeb='$UF9W$N
+%!NJSA7MQ(81aN$&NTGJE):>%Ig-U)hFg<oouT.lqiSd3WDh_>3f0r!>oek7)#9gKgr>D8M
0.]Ar0IE:c2<d;+F]A6hML#>Go%(aGes"5CAiV"1(Tqg'_Y/L#W\M$dG4#Z`I"(N2+o@$b&TuJ
K*rn5oS6?YIN:EgasQ8"p!fn@K$hd`cURLh58N6`Mll<2!9b;fPW]AFT*6B';MV3S%o2q@W[d
.S!>+!9%P7:@*?9L:O&5`o:Y^NtWI5&I)1r1b@PAra$A`F%M`LO$fM?`-gn9Ai8oHM@E#u=s
cP#79bSYV(&NQIRn)GS.7:8\c.l_%S/.Vbu-qrItfh3b`KJgC`TVg'YCBO/oB+sL?%bVX@gT
;l>X.]Agb2.R(\D=qkJdqC<Ek-;*Vp3!\*<JukLd$4tF=Zh;dZ]A%;RVEZ-K&=@Lt[1P2)"iW\
25k@4]A2C:X]A-=\l\+T!FFSNG79&;?En6$>"oG?S?GCNVju`q'HuHjf7ERi_p@b+\WU=;8.%d
$"A;[)4S`*>An>Z'S&/[E?:1Y[Fh.U%e"LX04NUcnoupQjf&CbkIkcJCud_G\i>SOPUYp/>'
+T?%Q`&&FJ>nOgop,eDqJIpN#p=RP7$T<&%(-,^pX3"opPneHLtBZoJfp2sqqZgW=OIE'^*e
o3m1e%#/qfn7p/\On-nQf#>-Y[+*667h<n?G)Z\+7aRXkrVdV)M6]A7$>iFsJ.0.Up=0oGb+K
VsU0&J/B&"B5X[MP^l,GVuI&5\Otj_8FJe)LSp0G+Xs-:i>u7ATqU+TbUak,Z=5Ek<`l8#bo
``6iuOj;)ah`UQS,=S4'Q,\*5d!H';LHgb;LmaNZq@S`YNBd#!%b:>Bd3>93pmbtpBCQu>1,
;>S48l)TTmOud^G$2d^bb;1)MT*+12XD]AcH0tM;M5,g4\KOl=YPq"Z9=WYhO%?gPp`"l2@;k
=G,hk3>n+5/Z/B*74,=&cmqle*aCH]A"DSB$-9ba$,4-]ASIR8EdM=dsi$V6g8i1)HP;u,+O;l
2i;t,mg-42iB$lA2c9B2fA%]AW$(OLF"b9*^=8^9copuOY:\-pa<M5+^9#54gZ'p$4H3(,#E$
Gg=K?Zn@R_"UM!>6;DHM=HIZhbi:HYX[1#r<AXLX7DnW4j9UYI;*OBh4K-iiupI:j8R)[[A;
ll_4&Z:jYtEgiFKi+@uibq\Fp-h9nsq'>FbUH6`(ob-,B&NX^Rm6-+5%hT$FED,]ABaE8\!n6
8jsO4<OohkCZt]A"_r7EAQ5N]ARbONS8Z++ih3%!tKe9)W$l6'6Tekk$[K]A-mGb4Q=8HINF6%"
W)0143JKbYdOJalQHRW)_tm'Y3N\((h!Y]A\Cqg"!07kki%mIH4_/CMDj9dUjQS^K_aOQMPGL
*gj']AY"ePFPGVarqbX%__OcrrW=I/m=/WT=k`bVVQ)134&0fg4ODL$kb&VWtj&W$+h0^8I(D
9cK,Q#9@BnIJ+aN/I7ku]A]A?lknMtGlO&o+>"4D[`@laW*[!>U;/2e:$H"XX-OQ-;+O_qio\D
VA8)eLEdoNY9_)j?kebTH<$^1naN^*mC9ASjp_SOJV<T8I+sh$.<9+4@l6Jl6>*s]A]A$@nMGZ
HGdH3S\m@/>9hS1tNbZ$D^_Nh3F]A[ku""kjH+2lm([P!=IQ+9F?b_Q`1C;g=t#N[SSX,V&G+
7PZ1<N0W?B@P+lZq7nuSu4I:R]Af$q?HL*rek'Z6TiNQFes@T&9t;FjmQm;Pn+hN!=ZF>q,L'
Wkh1P3l@%qn1J_"p:h*0Y<)+X`+jmNdOTW%9ai>SF>^f/+'?5lCZU$EjEK1!<r9SgchQfK<C
3`3Un\5e7T/;KKK`2&/(Ha#/Mk%8<9U\UT2)t$:A22K)CYnD[A`/h'$3me7$U+hUV=56T(\g
5IHSF[eMD'rUU[k9-4>s:g)\qg%b.<3)DML@h19@fT:#:ls4i)R,(<#Z?\9F[Aop.kN&iSSh
U>M0P<C"EZ%B3JJlsb?)KZf$L_mcD2=-7XPb0tb0eqCkZSO'POb>?t:0E@9Q^D&UZ$ZSmRoW
5db[nkoW$Qq%:CGp!jaedZ*_K_1+4rHLjc[^N>frR[Pa-3ra,N2Ugbj%?mdo!8$utW=H;&1>
!J><m8']A\9laa#%m75dZmG?n.X6mg='$WL2Km2VrEFOk`T;uuQr1daZWUo)i=d[i)G/[P?VR
YRL=U<D]AUNjo!+KONgDc36d1&A+US?Y]AUl:Z;N/Xe)A<]A;G&]A1>_t:!bDU(tMr^qVt)bReGm
@@l'J)Jja]AW.GE0%pR>ss-Qd.Xe<Ea&I9B_c=`n_5+!8a9HH]A7<Z1`.4'.VN[c3OtTI>Pa_+
t/KN?KX'WF`:0&42(3XLDER<bD!";c,QWm#:/D^#/PLeKrl8>gXP,WLo&/2=lrKZHt:\M`/K
"uLlnT=cB!o)U:5j%lk\r^=O=Y;fsI.\M@']AaH3E+/4m1NaQe#^7#`Nt!YGLM657JmKdW;LT
F*;0)n6E@&bCnSc4XY8nL5@2[/i\cbg`Pb-)1@lBb#'_W[)G'U!_qFKFP!Kh<n+)fo8O(LP6
1L<7dL6$cpTG-<Qs26HLKEQ$\"9j1dDEX;3m^Mcp@jVAKu\D6fnc*@b>",GT9=q?@`5>OR_(
03I_:ogOD<1=O8N'C?^("1;SKS3[OIHpf-L*\,\NR5_5b'4j9mMHo)IpIX#PTP3Yt,s8-:!I
/;^PD,tsXWWIW+KQ9k_e%R/GhLV+9T!:5_o[)5#D,EKfa+/=0-ooL&B=+MDn57Ar\U4\U>(?
^4'a2dtA7^38>.p9@`<DM")D+Pj-Y#^3G>e)=H5qFc-T$XgV78EPOsKNX=hldkpYsOLc$93>
I`8d1JQS?=^i/Y0f=)OKU<_tBF*Rqh5'bGkCutg8e;YIJoR6&`ri@+P(gTe`F>]ASK*tU5t3q
bT*e:sCg;FQf+Cg8.:9@XfUiss$(ME!4G0TAXJo/V/-gBbN]A:GFUSTT'g(:i?]Am8RpYC5R"D
,fA4$M(e,@lEF;uR^%)iA[&64fJk:)g^XV``5S@G6U;r5`IObB\q/m=$._qIX0bAaT700d5Z
K>XWr!N+^^PJtZIY%I)d!q>Br&ts6!A*u4AFG)@aIb6m+W);9e7^C`c03uf^TMi2]AlM6lN!4
k2OR-qrAc8ho+A!)[Tf5@V_0/Wiq>"cBq?*5t!3BSj.pPlc9Uo.CK&oCPfg!#A#:4?&565L^
22PeuF6OJ70'^Kk1FV-m$4kf8&O>]ATX/Vc(gl'XBFYIc!;OP06lfA3c5K5c`/tTl9r1:jH.K
Ap:1<]AG`SpRM#;i1fmfl]A/toIHB^oOBrkm#L/6Pos6KJE"O+moQf:b!2q7fq*0DT9ui7N,_%
#[VT!+Xg.K:^kqD*GpEbbdj$g+^*$T/J6&S:.Qe8BH?`?GkN)HuT*mO]AG)r(&,N);Ip5&Qj1
NK\okMOp$9nW'C6mi$^&71EY7;fN_3tduS?Q+?a8':1U3H$^PrH0e3T]A&Wq(-s_[\UEJ0$g/
RuY_B+\&0T.1a16S-+)IlQ:lg*8BP+uiC'js#>fF($5>'X7S4VU)?)f&tY89Ik<)`YG#3k+Z
Qm.U1n#9`Oep8HG3o]AsD_n[@*8M4nAa26Z[8K]ASj`*B0-R6C0J>EML.9<<i/PkS9576iW$T&
:Raa?KEo:RkNHAT;iAQ&01V"nEH)ku6q2M0/\uU[09?c9.3N#K[L"S[q+j45b!BBc(2<*N%,
<7tB`#R;6;KrtdA(hh>@2Y<`X.YY9Dt:"[jV(CalXk&&\hou[:,2#V*)a@rpLDGj/GPD]ARXQ
N5Cj:`Jh*m@dO?>qm;\:8(5ZGiV(0]A?\DlNdE>J:4+WQ\.'9krRd`A5D;O3O!oKr5H>!hjle
`mP4.%/bh%=\F5"YG#q:Cb?-dY\bs_;:0?$sC]ASMJr2\TZ@@<R$J(.,%8Z(TAj_uSB-mY753
/jqbQTZ_;n!-P:=@-qqKIK3/n%qXX55IF2c\G>$Wl^lc='_=4SipEDH`h6ePd2<Cdkc?\[D[
2?kn?G4ED&\(XV.jNf^YKY*DYRM1>9ufB_MQS8L]Afq-Q(&!_DRBfPl;I0m,/FN2)`pss$jaW
*!u0X!%E,3\EB)$*`A^oR]A+`OX)\t=fT]A'>&rfP/_+Wp/t6f_4)16.&NHNX_2IqEtSnek+;"
k9>&;.R'?+;*m"hQcUrI=O4k)l>tP5er*&QVE+?Vt*4U21:FD:^$mA?%JR\g5Q?]A@!EKCd3k
PF*_:%7JE_mUQ_n<p0NqSnMddX295YZpZ?Faf/&FgqPQp0FKgLa[-GY[<J.DnGD4*gk[_^\4
XFpWI';)!-PhDXPFmn6Rn%i9PdX^rkY1blD]A(EW?*mMM6KE,0oHB[1sZ3U0<QNNn+QUS-Np8
g7qaSpcdq5t*NH[EVbZWS+r8^f6LI+;4'2tm\WD'1&j3s;0_cj,`.lOca4s17<)Z`2j"?2\'
V/;+eFHI`_bKE0SPVXM!2NRE`N=GCOB$7Q.i:j<.-e$,Vo1%h;c<a!:9Z;4]A,%e^mF=\<sbK
@:1e0S&lCS[:':-\e7E3^l_t,V*9%!l[VB+__Rn$uoUC1@^57!16dT%h@#o3m!F8DPYe'o]A0
*$4eO/5]Ak\TO,8>n1O+;u0.ri>89*E!Cd+tI.#Sdl>B9PgEZG7KMQ7m)MY]A^)"o5E`7/V>S,
ngV]A_TK@Y]App-C0>)9O^\-gPAa%/!ZkH?KZ?jg)"TZYs"VO]Ap/ZQ/+E\dMgV(5D7KSXhJ2<C
DOop2_>d/rB`%<Cfnu!$J;Fo#g=o["4es!(c87?/[oRj/KaP`GKRb'_<7-;/`]AJe7eVY78rp
g-Q@lE?FGT$^8bR,Me!"3AYU8gHuF5".b8^UI.[KFRTDKCq^(SiGrZ4K=kH%2LXe98RO#i[o
RCW!-@JG%DOr6(CFd$NdN*j4^OnHukA0Zo'Y4TW+O*ODp`,SKKosq!r/,GHVq;-ETLJC@SlD
]A,02n;H?7^HPR(Js@$c%5k;]Akg4j?+ZQj+.t4P_\!hBRl_L85=LqL9L]A/]A'0m?GgC)6]A.+T)
(=Qmsd*]A&O]Ac?&nc5".U#E5p#DhZ"L@n(Wl3Q_S>k^n,YkVPiIia[u(UX;'R<.%q5^[W(.n*
$JSAKq3:j=/L8+G[WmkZ=OML]AeKdHT&P5]A"FEQf;'ib:o4u>oBrenDtA"G.98RR8KhIbJp\R
2ZR8Z/S5B45Hfm8>dUtD<)\@]AY&O8E5^C/iF_*(Fd_lALmE3-n:M$=MH=>dX7Au0SH:r]A76$
#!I3*$QO+;!5N[#\A0(jdaQG/,XRp4MsfYomZfS!h2V5C<8IQ'dDF24%i@W^7"Ynj)/]A`>A6
VM!q>C]A@Ea+G.j?,<:`h[GW]A+gk\2A)24G*GVa_a0p0uTKW\lm>sYF`SGc6lIjC1SO5(ds95
-W<):DJtbE"46>i3.s&$bYX_664_uSj^(SA@/Z5f&KI[bCR;,[OkgPilTq9c-;Q(Sh[XP]A4n
l@h,i<iG.A0L+TW/u^9;>g<FAN*-mrUlA,QR[,jf6!*B\n8bRuu$8k6O?NZoJg3Kh8V`-:d%
&l";broIE-!p/j4D'ES]A#Q7FBX=d?D>7A-Xi!1!$9KtnX)9P$g!<X"f5d6I.,/T2j[8lq!l%
LXiTjBo"o?e8eZFRiXk$-#J_5X6_>QIL;R_$r(fj7pI(p\mM;QRK.ToI<BG"Wiq`)IO=&X'N
R['4RI$cC>IUY,==JNCV1GF+H0lQbg<q#YdPf3#Z4ON72a%I;6A8?n<Z?[J>0gi42j[K#k-)
hVan/3A;s-G9PFM;GECj(XB(ZpEh-U7-:XL;+-<acl-*!JQT3nW_?1.qq_4`_bi(_;[8B3hu
si:_$!#lp1ab?=g#WQHPn1"4RJXdJt99q1-GpNSCOo0^uUk4eg>=UH:\.c,+AYf0"=e(%2_k
P0^:0>-(QAN'Q\)3fj._,f(3,PXQR9t>#c:F5ZkNAQ;gKO38.U^cS31cdBP9JoU/To\gQ'E)
a*ss?%E5gSt0pfL&!u<.olo]A(PZ8bQ__,7@,sJ.d#=oNl-i`f'gV>amfJrEi#VNQ"CEecTNQ
p'J7V=Ne<'lP*9p\i7mU6hPJuYEU+r4LF-05[BlY40A!dIA[V55<(9VI$d*-MnXfPRE:;X(,
^/="k)RYDCpuU&hZtLeLfj,Te?tj8"lh?HrJV)ODr&buTqfLUp`PG9Cpg-1>[@8^$WW&K&F>
>Q:p-Mob9&OA(aHuMA;%Wd+S4Z"N^e+I>)u`I7X5Or,3B,pAfN_.bN1/h9_5<.G^>eU-p!SM
C)a9b-3U0Whek>I<:(SP.7hS4:_@n,ShFZCXr6&_oWj8Js]A0U!'YC1P-rG*k2"jN*]AJT5T(Z
-cJb$Rm;9mQThrUcH5&a<3lGo6']AI'0FVa<!E/^mZAg"%/E\qoj,E3Eu,TkVi6U*^I^r?^Pf
+dctVh2>kQ]AH2A\F)a8ilU+]AH,.690c5H4Xr3'_qtE)$J-"Yu>^L^56`V=0r/USbZp8B$gQJ
c=7Z>Z(^X$\[UaW):9OjIBG$B5'h;scSE=)"E[tR\3E#nOmXaN,9.Hg-H]A'l:2(LR:DJU3_(
fW,/^q>'.4S.C@MqJ2R%NQ-c(jhRbj:5.Kc:VTKaeO(JP&H@[8Pq'H4KWa<kUY";=)HHY`6J
ZNb5%&HFGg5Hu>cFVpNF+O:mQ@2VNN4dno8FiT_&rFd07"HNup:rg`hXELk:AIL1lj9D(]AF-
lB4DisEH/gd;4*54!H[dX3lLqa_9FCX'I%>Id=,AdK((S;Y]A&;?1^>C#,&VMoS=MF_iCX\Qt
QpMFZe:3C,UWAr05#i,&&\gLS_*!T^A%=(#$-g1ImQKrLCd@0)E2a<LbM)#!JEA&e&4E_,tl
,&UK1JmrTN"NH?TRK+;Y-_Jl11$YGbB[Hat(AFNSD.Mb)A"4g+6OZ$_4tf[6o2T*Ff+XqCVc
<)QbZQ#WT%l'<htsJaM^<e$mQ@n\d%\c%H+Rrh\%Ca2MBOc>^^(ZMRO*RTR)RPAT@U#ZI.Z+
^e52?!]AM4=<T@OoL`Y0"UfUK$.*3j7DjKinHrNL.QoY=bO4LH$BWeNCj=OR.DQ1a2oL(2lT%
\%71^I_(?("q9L85mfPQGoWXc\HFXiZ@i%M!p#-8^qbGadh&:[2DYGq0d\+8[KaS?qkhV=."
<&m'Yr+BN<q.ki\Qo<O31"V8q';W`u(PEl>RF4!_$$cI^pF5?u$cl`DBqf;Gm;aCE!^;<1&l
Jm-/#XB4I6ChMQ<s17CkVbWu25g9PG^R9&Io,=?7W(2N#:%.!\d42]Ac^pp>fL"?Y/*CYbins
'O"p5etZHA>a`&he&JjS\T*[q%ma,(al:P?V\h^!c"*-/>YV@'XL$\GK\K)uEV;i/6o,`c8\
4jkXs@d\;VVc5T.?3eVP+VC\]A=!CoubF5[N&;6Q(V8oIW10eu'R$&H5(oAmk(_=*.bk>,SDb
&m?<oBXJIf#OOPMU"hu!N;8JQ^KeKiep-a/'HXo0\l5E#Ho@eANmp(mOE]A!a#1aB*RHKUOVt
%D6=B+QmJ%Bc.nLVQbsZmg;&G&oPo1$eLf!,1OF5<mTOWF4_A*BLM#!>]Aq"[-UI9g\ZJIt\[
6q<NIB_4I>Fi]A;:Aj(A9DQA#k7e_3[l&#)'[G$T+5$o2:+\RR1ei^FS?+`(AH$.XP<jV=,NW
;q<.5Z5g2?*'`8`50RZrjT%1Ki>!^I\f\NZSiCLd>8FH`di8pFFE!7gCW%oF9\u<di71WMla
KHP8bFhhaknLW>A<r=Q*dVU*QJ1#YS?)q0Sd$tP,B-Ttj9/d`%RUZ,V@p^HDLe<HI<[J=naM
)&0G<ln_O`O?sdP^>J>iZi+h[6%bKlIT(E#m).cgX16MfB`#'REP'.?-WB4%7P/<!`hc`mik
(K+HXW1&2)@`S("Z)crZ*J"AT`3J6uh;e0NpD$&u>,1&l\hD'g=7;4;Wm>37qiH$U2;8=<Od
m$FSKT(GkSGrn1K/dSatg@$9M2uE"U6K9;hV9U5hC&H1a92L-lJS%Zbk7dsrWnTr"Y]A"7rbR
:&(n/RU+ck[IqKdQ"T%*R60@nDN7E4l-K<LCnAI3ml8:o0cJ(dg^HEn%q=$a/0C)^n'$mA4H
]AH0/'PNkPDF@EVgW9BoKXL#Xdep;iN-fp;O7^*<+b-LWfqCYr8<YbP;jLG<K?-,eeD@Y>]A);
WM+IFD,8^!6^h"O7/&goVG[KmGhe)oT8b$Ti]A7nFm@$,&6aq`>V^.LB(BAI`)C[%O[0%_5F$
FC8\"d2N59W$jl>gdrHU2[_s=^M@`O_(1U"L!`Q7[hK?LF@]ASLN&SlfW6m.BE!I6V)Or#V`5
p_BoLlgSQlq:X:8>]A6A2ffqP]A57@m]A6jUG,Y9JF3,-]A9CMo&4E[J%+9$hEo.a\,O03(EV[@J
N\u">K5.UV.kQcp,3I#?C2LY`ll$8[\(ZHC5]AcTE\Ba[D&8O]ApJ-!'cS;+FH;C*A<l+r=:HV
Y6_*)?\k:qpqtX/t^CLCoF+S<[5=T85;&p&Q:u@f66)4;GJ[XYN,-[_kbkj&LcEJo)0Qn*(q
0Fj1InZs@pUbJl9n4?MlGa-!cc`K3JrGp(\K9ok'ORsCJaKWGRqG<,MSWA8YVP!S,,i@4V(n
0>V=/im)X3Ej*nc87m@kGcfaEmac=V(Pn8C"1[p@1VJBa,7cTY5IUHI'(c!WFu*De;dFaUmu
B"qr:4PA"mC$j+4]ABd<4LB'20g=GMJE';.7Jlp]AJaUK;<Qs4[?VBkS<YTUY>e,n0M\%bi;hB
8;Ks4sREb'hP2$mt!Y!fX7">n'd[<UNC@L;."1nM""elINs2r:Ps?d%29N$Egk^/DrndrEqK
7Q3fDqo-q[Vk3E\2Sh/iJ6/a-XVO@JJ$MQN&a(P^>]AWam.;"di:Y`iutH_]A?hcm>MNFtmjr,
14@-:.1bhM5cAOrtY"[r%[0]Ah1u-nVpc/o1*,\ZIKQ=I.H*B7e_tj*)tlbonl/29X"Q,B@N6
dW+p:):(a1,/:Gu:cp'LTrrl5eO:0=@8._hs'(uq4)hOTVhY(=UD\%U%'i-981n\qoRR$XC@
05I?f6tk9-?F"X?_-i,1Y)SQ*(idN_7)75Yc=83u*2C@ms)+&H14BcYg7o3Z`F]A<>0.Ub=W]A
CgglfFRl$"jUt4RkZf:N!]A3jUOD_6ljARo30kl'8O^_fq"KJ_0e.@p.a8I.D;2ilp?8gReZa
)-hj5Rs(lrO[^dHH*1V%ccsRiL7mK+\E]AmuII/MK$NeI\j>gT\4,TrBMSdBlfoBXEn*WKZ8/
aX\P@#95u-Uo0ZaUNK&A)_E\2Wl>h"?Y>_4MlK[lrr^'1]A40dTLT]A)HOU:_ro[ulOI?O!<nc
-pU.0pSG6%a@-)'f:b;l2>nCY%p#,Z[bJd<lAUFRI0(NTrM?6m0j25kMiYu+DNjK!Ab9b(N+
e,Zj3"DqE4K9S"!Df[dNb36Tt,)=1B7fAM)nDLC9s)I[lFJ#Lg'7$Gd;h!Dbgn;c>3uU(]A7H
uTCP:"b:mSlSV+Z;hJln<!h79$CC!)]A7HLi@cZQBDDPR'2LI3/`B9=AVrGX$S:.qDt\Ik&k`
*pf_2uNpZm\^Z)\2:4a#R[.K7b[i<L/(B.=[gu.*cL_4'@'fDM0p?SfK,.KDf+rmfs$N^ZWZ
q7Akj2i3&YF9/J&pA+O+19(Jck._!/PPW!Ro^O!fR/(aR2r_[#%?*:#l+P'Z^Z(FDMC)B&kG
@=TJ>2DcF9a\NTL6rk+bHF6d\eGk.X%5$=APQ+-<<s5(#!HrquCX?g8_lk+JG/]A9.jTDhNN>
:05s3L-f?K8'Rp0+A)Ic8:bhWOH[Z-3=NP1VFKE:OM!a'T.^aFp(F:JRJ7f3q"ht_&lb3:f%
c]A#$%")n-DDaYiKcTRrG*#DMR!L4jDe<NePZ9:ij#JT[FYZSOZ>Ai3RG<`=Y9!e=HT._DMQD
W89f:;$0U:1)nHl:Ff$PT%53$&@BWOML.O4MGUl9?UkO$=X>]A-oYa-NU,FiF_%liI]A.AVBJ4
BIg,h*4sP7Kb@RoPa?FK$X<Uq,(4Zm*I8S3'baW709%N:WqDqf+3l6R'TL6r=Vf=K]As!QXp-
-T_Hq\P-R&l*f">Akl_9BTeW,2R'>\8+DADck")-]ADo2s8b`oc#5Ij#O9A8*!0^=9gpkd%-V
?I9Eog0unZp,(C9r#_WqX'&LO!`"gT2/VSKTP=$4KZ:_`8RGe7E->1V9Ii7RE5Uel--MT&>H
%7O<8[slqD[<Alpf*>!)4p)lJ]Am$hCfp'kEQW%*rbou/th"t^BB/c0s`)7SmS%*!&,kG&uQW
#<cJ&Q_SqXm^oUE/IQt;ZT@lKhC;B<`gr4#W;192JIV:TWcN2C-2(;$WCg0g;c1f^bVZB(LT
$WQ!X8HR(k3Y7s39Zf+7=tbG\9ref8Wh_\eblH&^[7o3kCbX0e1ZJ6Qd\]AL"-`J3'EDNC'$f
un]APZdP$ZVX8GJY="oV(9Q2Cp$eXS0^$FM6ja>F,m0!(&$_8(%*_UPYl_6CdVi/,(4fi5l?A
HDFX/'(PtW:8KOY)ut/-Y(b2T=na,[*3O_'1U2"F0[BrY5j.``f3EBq2PfMPS.o6K!(n)nN6
u/tcdgM9cG/b[%KO9oPnoE6r*H\]Ag$\LTBO[.f9.Zc7J5m\21=kd7SPR?nb@i0d/r\q:k?3_
)*=94Dnf5cUp.Fb7lY=KIWJagR3:KS<p?f.A8,Q*/nU]AF>s2<]AgHg83!*Y8=edaBs(!iu.77
o/p`h6YG-H%dY6TZ)XZ,dI(H48SO-,nOng4ba2`#+\r"hRr$^7s3g*j_bn'&!As(`RCR+g8!
C2Nbc,)KErZA$A</-0Nh2&,VF<4WV_M`iMSRWbI"$SqU96oKB']AF4hf6o6=:3CC@H>fT!c30
q2UC#rP'$n+uO#"WusUqCZ5PbkPr$Ncss#2JV82Z2Z%]A[;[a1qCNV(I4'$G!7CGO,E)3<^k:
fRCbCEcOo,)\@WarmAjX&[mI=$0'6U-"]A3B_$#A&F'`:)5u'YOfJIAY&"rYkOhi?!cW<QoIu
s@Vp-*,5'\8o&u8Ac^sCuIQU[E$86QR;fgE37QcNQ3q7c66\L?9B`<B6Hf*>fkB>+RAP!!$<
.HW*3`pCO4eD)*IchmcFBZdkJG"5,:f,2nDp_#!i]AO\GPFGNBjR9:sC0Ki!n)$auaT\hO9$M
UAe`<1n.nS2QO2$0G%gtbR<]AT<XGG!"CTqpE#SssZeqst55@i?Lg&IPi.P)U-qk'o#l??(D$
puJIdHaAn%OaD2]AF2mVJSu;e@I?'8H)l,5L-6^W?';I\Q<N$uoRPQBBWHF2lVjnHG/ra(1.N
cWCc@1#(B%u6(G1m"T$,J]AI$P8?L&T(T\3ujnY>-]A=CR>lbppV:ab/mDGmb,Zb[E`39W7uX,
ACH-mHGKD'`jS#HcBY,j/,Rol>nFO3Ea51mQNMinu1uM7!U]Aq82;;:XAOLLm/P:%%C/3"^^k
tt@@JLqG!DIhg92<P;^*)>*]A&?b98lo5YrG-"':(G)>jOSa[/cZuO2e-\27DDSpt5';m'Y$8
k$C&GhcC_E+(/*:L@ZhKDAilR%oCCrsu)7sD;_u#>I#['Wceh1-006gAI,V$SM3[U.K&qrmT
Te*4XYFeA?c?#bPi-SF5LcogrrfpE20(2GYO,HBOYf<#)>oUIe_-R>OP*)KP;"H9#)83rbV]A
$6ueBoMsFW#;$.ACUG\akgq7Ttr@59/3qiIUn+8F_duK`"iOaikY$CZBW_`-KG18s]A]AaPPbn
?$1s(@mT`l\c;\;4k!H.co"[N;5C9%=OCLoL<$T(sq<H?$fI9aW([V`+e&0_]A'D$,8I863</
!M@idOR1ApN-h70'gd*q/D4,e%k]A.2&13>DdKB["nc07Z\^;UEbV5dQ+h`m>PDo9eg[fA]A!g
d<WI*6*]A$Z1n29++":<.urK%0lEH'X,5#GII=TU=1pG.`e>7%+)AhS#0;?9:C=g@1$0AUc+?
#:TI5]AQn!ZmDrCBgpVOHm<JM>=ZL)Io"U);l(8k'jl5YP<_/p*a0+JSBqL9T^O,OdjZWW2H#
^UQ_4OBf/NHT8D7K[%Z=iLV]AT'+gR(#)^R'TZ)aEt1n6]A0]AZ>2?4=D&F)R0mE#qqT)URK:P$
j]A0`)&>PHMEO)Ieq91*#4C!fSJ\i*1<O+g^8KIh*;JGK1+q^CY,*r~
]]></IM>
</FineImage>
</O>
<Style index="0"/>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
</com.fr.plugin.widget.picture>
<showType type="4" efficientMode="false"/>
<NameJavaScriptGroup>
<NameJavaScript name="隱藏">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "2" 代表現在顯示個別公司，退回公司列表的顯示
if(TYPE == "2"){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
// TYPE = "1" 代表現在顯示公司列表
else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(false);
	_g().getWidgetByName("BTN_RETURN02").setVisible(false);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(false);
    _g().getWidgetByName("BTN_TYPE").setValue("");
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("P_COUNTRY").setValue("");
	_g().getWidgetByName("P_COUNTRY_").setValue("");
    _g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else{

	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</InnerWidget>
<BoundsAttr x="878" y="504" width="37" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="BTN_TYPE"/>
<WidgetID widgetID="016e7665-4d5c-47ee-a650-71efe085f48b"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false" index="-1" oldWidgetName="comboBox0"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="435" y="172" width="125" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_CATEGORY3"/>
<WidgetID widgetID="71780c85-6a6b-46ce-88a6-d4ed3bdc8cfb"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false" index="-1" oldWidgetName="P_CATEGORY3"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="TYPE" formula="=I18N($$$)"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_CATEGORY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[col_accu_surplus]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1415" y="200" width="430" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_CATEGORY2"/>
<WidgetID widgetID="71780c85-6a6b-46ce-88a6-d4ed3bdc8cfb"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false" index="-1" oldWidgetName="P_CATEGORY2"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="TYPE" formula="=I18N($$$)"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_CATEGORY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[col_income_non_rel]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="940" y="200" width="430" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_CATEGORY1"/>
<WidgetID widgetID="71780c85-6a6b-46ce-88a6-d4ed3bdc8cfb"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false" index="-1" oldWidgetName="P_CATEGORY1"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="TYPE" formula="=I18N($$$)"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_CATEGORY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[col_pre_tax_income]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="465" y="200" width="430" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="CHT_03"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="chart0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ChartEditor">
<WidgetName name="CHT_03"/>
<WidgetID widgetID="a5104667-1f90-465c-b69b-3b2e57eb5651"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="CHT_03"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="40" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" showArrow="true">
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="PingFangSC-Regular" style="0" size="96">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<buttonColor>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</buttonColor>
<carouselColor>
<FineColor color="-8421505" hor="-1" ver="-1"/>
</carouselColor>
</ChangeAttr>
<Chart name="預設" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="true">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1118482" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-6908266" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新增圖表標題]]></O>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="WenQuanYi Micro Hei" style="1" size="120">
<foreground>
<FineColor color="-13945534" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<SwitchTitle>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[預設]]></O>
</SwitchTitle>
<Plot class="com.fr.plugin.chart.PiePlot4VanChart">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1118482" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="0" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="true" themed="false">
<borderColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="微軟正黑體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="微軟正黑體" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  class=&quot;rich-editor-param&quot; height=&quot;16px&quot; alt=&quot;系列名&quot; data-id=&quot;${SERIES}&quot; name=&quot;系列名&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:40px;height: 16px; max-width:40px;max-height: 16px; min-width:40px;min-height: 16px&quot; /&gt;:&lt;br&gt;&lt;/font&gt;&lt;/p&gt;&lt;p&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  alt=&quot;值&quot; data-id=&quot;${VALUE}&quot; class=&quot;rich-editor-param&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:16px;height: 16px; max-width:16px;max-height: 16px; min-width:16px;min-height: 16px&quot; name=&quot;%E5%80%BC&quot; /&gt;&lt;br&gt;&lt;/font&gt;&lt;/p&gt;&lt;p&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  alt=&quot;PERCENTAGE&quot; data-id=&quot;${PERCENTAGE_-436740454}&quot; class=&quot;rich-editor-param&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:85.791015625px;height: 16px; max-width:85.791015625px;max-height: 16px; min-width:85.791015625px;min-height: 16px&quot; name=&quot;PERCENTAGE&quot; /&gt;&lt;/font&gt;&lt;br&gt;&lt;/p&gt;" isAuto="false" initParamsContent="${SERIES}${VALUE}"/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</richTextCategory>
<richTextSeries class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</richTextSeries>
<richTextChangedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</richTextChangedPercent>
<richTextChangedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</richTextChangedValue>
<TableFieldCollection>
<item key="PERCENTAGE">
<TableFieldDefinition name="PERCENTAGE" function="com.fr.plugin.chart.base.FirstFunction">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
</TableFieldDefinition>
</item>
</TableFieldCollection>
<Attr isCommon="false" isCustom="false" isRichText="true" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</color>
</Background>
<Attr gradientType="normal" shadow="true" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-3355444" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="true" themed="true"/>
<FRFont name="WenQuanYi Micro Hei" style="0" size="88">
<foreground>
<FineColor color="-8747891" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" layout="aligned" customSize="false" maxHeight="30.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="true">
<borderColor>
<FineColor color="-1578256" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false" themed="true"/>
<FRFont name="WenQuanYi Micro Hei" style="0" size="80">
<foreground>
<FineColor color="-8747891" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</DataSheet>
<NameJavaScriptGroup>
<NameJavaScript name="DRILL_DOWN">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SERIES]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "" 為初始化，BTN_TYPE 還沒有賦任何值，此時Series為國家列表，點擊 返回按鈕顯示
if(TYPE == ""){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	}

else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("BTN_TYPE").setValue("2");
	_g().getWidgetByName("P_COMPANY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue(P_COUNTRY);
	}
else if(TYPE == "2"){
	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="cbcr"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<PredefinedStyle themed="false"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-18944" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2084834" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-1340416" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2403478" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-12171706" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-8553091" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</colvalue>
</OColor>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<GradientStyle>
<Attr gradientType="normal">
<startColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</startColor>
<endColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</endColor>
</Attr>
</GradientStyle>
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="55.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ID1" valueName="VALUE" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false">
<SeriesPresent class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ID1" viName="NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[CHT_COUNTRY_REPORT3]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</SeriesPresent>
</Top>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[CHT_COUNTRY_REPORT3]]></Name>
</TableData>
<CategoryName value="無"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="e42112a6-c2c2-4677-a499-8a8cb236202b"/>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="xy" controlType="zoom" categoryNum="8" scaling="0.3"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false"/>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false"/>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="" isAuto="true" initParamsContent=""/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</richTextCategory>
<richTextSeries class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
</AttrTooltipSeriesFormat>
</richTextSeries>
<richTextChangedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</richTextChangedPercent>
<richTextChangedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</richTextChangedValue>
<TableFieldCollection/>
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-15395563" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
<ThemeAttr>
<Attr darkTheme="false"/>
</ThemeAttr>
</Chart>
<ChartMobileAttrProvider zoomOut="0" zoomIn="2" allowFullScreen="true" functionalWhenUnactivated="false"/>
<MobileChartCollapsedStyle class="com.fr.form.ui.mobile.MobileChartCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
</MobileChartCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="460" height="335"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1400" y="185" width="460" height="335"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="CHT_02"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="chart0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ChartEditor">
<WidgetName name="CHT_02"/>
<WidgetID widgetID="a5104667-1f90-465c-b69b-3b2e57eb5651"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="CHT_02"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="40" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" showArrow="true">
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="PingFangSC-Regular" style="0" size="96">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<buttonColor>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</buttonColor>
<carouselColor>
<FineColor color="-8421505" hor="-1" ver="-1"/>
</carouselColor>
</ChangeAttr>
<Chart name="預設" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="true">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1118482" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-6908266" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新增圖表標題]]></O>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="WenQuanYi Micro Hei" style="1" size="120">
<foreground>
<FineColor color="-13945534" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<SwitchTitle>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[預設]]></O>
</SwitchTitle>
<Plot class="com.fr.plugin.chart.PiePlot4VanChart">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1118482" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="0" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="true" themed="false">
<borderColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="微軟正黑體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="微軟正黑體" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  class=&quot;rich-editor-param&quot; height=&quot;16px&quot; alt=&quot;系列名&quot; data-id=&quot;${SERIES}&quot; name=&quot;系列名&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:40px;height: 16px; max-width:40px;max-height: 16px; min-width:40px;min-height: 16px&quot; /&gt;:&lt;br&gt;&lt;/font&gt;&lt;/p&gt;&lt;p&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  alt=&quot;值&quot; data-id=&quot;${VALUE}&quot; class=&quot;rich-editor-param&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:16px;height: 16px; max-width:16px;max-height: 16px; min-width:16px;min-height: 16px&quot; name=&quot;%E5%80%BC&quot; /&gt;&lt;br&gt;&lt;/font&gt;&lt;/p&gt;&lt;p&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  alt=&quot;PERCENTAGE&quot; data-id=&quot;${PERCENTAGE_-436740454}&quot; class=&quot;rich-editor-param&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:85.791015625px;height: 16px; max-width:85.791015625px;max-height: 16px; min-width:85.791015625px;min-height: 16px&quot; name=&quot;PERCENTAGE&quot; /&gt;&lt;/font&gt;&lt;br&gt;&lt;/p&gt;" isAuto="false" initParamsContent="${SERIES}${VALUE}"/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</richTextCategory>
<richTextSeries class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</richTextSeries>
<richTextChangedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</richTextChangedPercent>
<richTextChangedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</richTextChangedValue>
<TableFieldCollection>
<item key="PERCENTAGE">
<TableFieldDefinition name="PERCENTAGE" function="com.fr.plugin.chart.base.FirstFunction">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
</TableFieldDefinition>
</item>
</TableFieldCollection>
<Attr isCommon="false" isCustom="false" isRichText="true" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</color>
</Background>
<Attr gradientType="normal" shadow="true" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-3355444" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="true" themed="true"/>
<FRFont name="WenQuanYi Micro Hei" style="0" size="88">
<foreground>
<FineColor color="-8747891" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" layout="aligned" customSize="false" maxHeight="30.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="true">
<borderColor>
<FineColor color="-1578256" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false" themed="true"/>
<FRFont name="WenQuanYi Micro Hei" style="0" size="80">
<foreground>
<FineColor color="-8747891" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</DataSheet>
<NameJavaScriptGroup>
<NameJavaScript name="DRILL_DOWN">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SERIES]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "" 為初始化，BTN_TYPE 還沒有賦任何值，此時Series為國家列表，點擊 返回按鈕顯示
if(TYPE == ""){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	}

else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("BTN_TYPE").setValue("2");
	_g().getWidgetByName("P_COMPANY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue(P_COUNTRY);
	}
else if(TYPE == "2"){
	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="cbcr"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<PredefinedStyle themed="false"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-18944" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2084834" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-1340416" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2403478" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-12171706" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-8553091" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</colvalue>
</OColor>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<GradientStyle>
<Attr gradientType="normal">
<startColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</startColor>
<endColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</endColor>
</Attr>
</GradientStyle>
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="55.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ID1" valueName="VALUE" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false">
<SeriesPresent class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ID1" viName="NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[CHT_COUNTRY_REPORT2]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</SeriesPresent>
</Top>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[CHT_COUNTRY_REPORT2]]></Name>
</TableData>
<CategoryName value="無"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="6689bc53-ad5c-4dee-bdd8-d818d9bee1c2"/>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="xy" controlType="zoom" categoryNum="8" scaling="0.3"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false"/>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false"/>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="" isAuto="true" initParamsContent=""/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</richTextCategory>
<richTextSeries class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
</AttrTooltipSeriesFormat>
</richTextSeries>
<richTextChangedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</richTextChangedPercent>
<richTextChangedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</richTextChangedValue>
<TableFieldCollection/>
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-15395563" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
<ThemeAttr>
<Attr darkTheme="false"/>
</ThemeAttr>
</Chart>
<ChartMobileAttrProvider zoomOut="0" zoomIn="2" allowFullScreen="true" functionalWhenUnactivated="false"/>
<MobileChartCollapsedStyle class="com.fr.form.ui.mobile.MobileChartCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
</MobileChartCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="460" height="335"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="925" y="185" width="460" height="335"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="CHT_01"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="chart0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ChartEditor">
<WidgetName name="CHT_01"/>
<WidgetID widgetID="a5104667-1f90-465c-b69b-3b2e57eb5651"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="CHT_00"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="40" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" showArrow="true">
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="PingFangSC-Regular" style="0" size="96">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<buttonColor>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</buttonColor>
<carouselColor>
<FineColor color="-8421505" hor="-1" ver="-1"/>
</carouselColor>
</ChangeAttr>
<Chart name="預設" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="true">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1118482" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-6908266" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新增圖表標題]]></O>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="WenQuanYi Micro Hei" style="1" size="120">
<foreground>
<FineColor color="-13945534" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<SwitchTitle>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[預設]]></O>
</SwitchTitle>
<Plot class="com.fr.plugin.chart.PiePlot4VanChart">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1118482" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="0" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="true" themed="false">
<borderColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="微軟正黑體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="微軟正黑體" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align:left;&quot;&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  class=&quot;rich-editor-param&quot; height=&quot;16px&quot; alt=&quot;系列名&quot; data-id=&quot;${SERIES}&quot; name=&quot;系列名&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:40px;height: 16px; max-width:40px;max-height: 16px; min-width:40px;min-height: 16px&quot; /&gt;:&lt;br&gt;&lt;/font&gt;&lt;/p&gt;&lt;p style=&quot;text-align:left;&quot;&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  alt=&quot;值&quot; data-id=&quot;${VALUE}&quot; class=&quot;rich-editor-param&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:16px;height: 16px; max-width:16px;max-height: 16px; min-width:16px;min-height: 16px&quot; name=&quot;%E5%80%BC&quot; /&gt;&lt;/font&gt;&lt;/p&gt;&lt;p style=&quot;text-align:left;&quot;&gt;&lt;font style=&quot;font-size: 16px;&quot;&gt;&lt;img  alt=&quot;PERCENTAGE&quot; data-id=&quot;${PERCENTAGE_-436740454}&quot; class=&quot;rich-editor-param&quot; style=&quot;background-color: rgba(54, 133, 242, 0.1);vertical-align: middle; margin: 0 1px; width:85.791015625px;height: 16px; max-width:85.791015625px;max-height: 16px; min-width:85.791015625px;min-height: 16px&quot; name=&quot;PERCENTAGE&quot; /&gt;&lt;/font&gt;&lt;br&gt;&lt;/p&gt;" isAuto="false" initParamsContent="${SERIES}${VALUE}"/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</richTextCategory>
<richTextSeries class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</richTextSeries>
<richTextChangedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</richTextChangedPercent>
<richTextChangedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</richTextChangedValue>
<TableFieldCollection>
<item key="PERCENTAGE">
<TableFieldDefinition name="PERCENTAGE" function="com.fr.plugin.chart.base.FirstFunction">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
</TableFieldDefinition>
</item>
</TableFieldCollection>
<Attr isCommon="false" isCustom="false" isRichText="true" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</color>
</Background>
<Attr gradientType="normal" shadow="true" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-3355444" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="true" themed="true"/>
<FRFont name="WenQuanYi Micro Hei" style="0" size="88">
<foreground>
<FineColor color="-8747891" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" layout="aligned" customSize="false" maxHeight="30.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="true">
<borderColor>
<FineColor color="-1578256" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false" themed="true"/>
<FRFont name="WenQuanYi Micro Hei" style="0" size="80">
<foreground>
<FineColor color="-8747891" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</DataSheet>
<NameJavaScriptGroup>
<NameJavaScript name="Drill Down">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="BTN_TYPE"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SERIES]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "" 為初始化，BTN_TYPE 還沒有賦任何值，此時Series為國家列表，點擊 返回按鈕顯示
if(TYPE == ""){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	}

else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("BTN_TYPE").setValue("2");
	_g().getWidgetByName("P_COMPANY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue(P_COUNTRY);
	}
else if(TYPE == "2"){
	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="cbcr"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<PredefinedStyle themed="false"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-18944" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2084834" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-1340416" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2403478" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-12171706" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-8553091" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</colvalue>
</OColor>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<GradientStyle>
<Attr gradientType="normal">
<startColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</startColor>
<endColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</endColor>
</Attr>
</GradientStyle>
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="55.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ID1" valueName="VALUE" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false">
<SeriesPresent class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ID1" viName="NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[CHT_COUNTRY_REPORT1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</SeriesPresent>
</Top>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[CHT_COUNTRY_REPORT1]]></Name>
</TableData>
<CategoryName value="無"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="46913a1c-c7a0-4053-9d6a-d31c3093e573"/>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="xy" controlType="zoom" categoryNum="8" scaling="0.3"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false"/>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false"/>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="" isAuto="true" initParamsContent=""/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</richTextCategory>
<richTextSeries class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
</AttrTooltipSeriesFormat>
</richTextSeries>
<richTextChangedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</richTextChangedPercent>
<richTextChangedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</richTextChangedValue>
<TableFieldCollection/>
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Attr gradientType="normal" shadow="false" autoBackground="false" themed="false">
<gradientStartColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</gradientStartColor>
<gradientEndColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</gradientEndColor>
</Attr>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-15395563" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
<ThemeAttr>
<Attr darkTheme="false"/>
</ThemeAttr>
</Chart>
<ChartMobileAttrProvider zoomOut="0" zoomIn="2" allowFullScreen="true" functionalWhenUnactivated="false"/>
<MobileChartCollapsedStyle class="com.fr.form.ui.mobile.MobileChartCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
</MobileChartCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="460" height="335"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="450" y="185" width="460" height="335"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_06"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_06"/>
<WidgetID widgetID="f52a02a5-f8ea-44e5-820d-dd22b9c6cc6f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_07"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR F="0" T="1"/>
<FR/>
<HC F="0" T="2"/>
<FC/>
<UPFCR COLUMN="true" ROW="true"/>
<USE REPEAT="true" PAGE="true" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,1257300,1257300,1257300,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,4381500,7429500,6096000,6096000,6096000,6096000,6096000,6096000,6096000,6096000,3513600,6096000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[width]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="381000"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="571500"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand/>
</C>
<C c="0" r="1" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2476500"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="609600"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("country_id")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("entity_id")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand extendable="3">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C2"/>
</cellSortAttr>
</Expand>
</C>
<C c="3" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_income_non_rel")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_income_rel")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="5" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_income")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="6" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_pre_tax_income")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="7" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_tax_paid")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="8" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_curr_tax_payable")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="9" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_paid_up_capital")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_accu_surplus")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="11" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_num_of_emp")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="12" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("col_tangible_asset")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="1905000"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="609600"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="COUNTRY_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsDefault="true"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="ENTITY_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ENTITY_ID" viName="ENTITY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_COMPANY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_income_non_rel"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_income_rel"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="5" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_income"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="6" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_pre_tax_income"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="7" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_tax_paid"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="8" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_curr_tax_payable"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="9" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_paid_up_capital"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_accu_surplus"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="11" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_num_of_emp"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="12" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT" columnName="col_tangible_asset"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ROW()%2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="3" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="1905000"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="609600"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="3" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("TOTAL")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsDefault="true"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="3" s="6">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_income_non_rel"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_income_rel"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="5" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_income"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="6" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_pre_tax_income"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="7" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_tax_paid"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="8" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_curr_tax_payable"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="9" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_paid_up_capital"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_accu_surplus"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="11" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_num_of_emp"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="12" r="3" s="7">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM_ALL" columnName="col_tangible_asset"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" bottomLine="0" leftLine="0" rightLine="0">
<topColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</topColor>
<bottomColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</bottomColor>
<leftColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</leftColor>
<rightColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</rightColor>
</Border>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1" paddingLeft="0" paddingRight="0">
<FRFont name="Microsoft JhengHei UI" style="0" size="144"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-2500135" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-2500135" hor="-1" ver="-1"/>
</color>
</Bottom>
<Left style="1">
<color>
<FineColor color="-2500135" hor="-1" ver="-1"/>
</color>
</Left>
<Right style="1">
<color>
<FineColor color="-2500135" hor="-1" ver="-1"/>
</color>
</Right>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Bottom>
<Right style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Right>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="1" size="144"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="0" size="112"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="2">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="2">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Bottom>
<Right style="2">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Right>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-986896" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<a+\PLnBhXY'6GOLA<uJmobc#QY0l.BulM7%f>A![.gn.Yc#,-97AQ0o?66VGnEW15QD_&;
ZQ;'SK!Y":-8&"pe-EP!BYCh"O7`4m2\lI\-#bqo?AdTD.l,4T#*E[J+"n\(5KbE:Xn#,ALS
hrHd/&ASP79&"Qh2Ck^uVARB?N8d5"N2k/TdbEa;r<el,b)4!#.s0p$]A]AeN!?>3EIsY%=1bU
>\gnr7+kg?gPB+q;jE9LVJ9Aq:5;m4"=8q+3;]A(rS1<;G[T!T/[8Blrp7uB)e4@u2;!EC1R2
_kTE";J"5fJeB@erZ?e"dZC'<RZ$4KF5i<[3ALCs&40V[L$*$&cA+lQt-c^-6]AgYh,-^r:,&
=.EIS:ufX%<G1d".bm@),p1bjhfN)mXd/HH%djl1^6,Ug,YU<M*P/l'buEM^k3pi<G=1p!-E
5tQ%@?b&q9Qs=/A,gTW/;B]A\,16:KrZ<R)K0"`%DKteq3POY-:on*a;&t'I;Z,0s(rTepcs&
6lK:O,s(0j"gB=^gb?>[CbZF=iiBKl(ieD0jU7ZnYA<$8%in$m8#iE^I=phtBrmNC,%3HDnb
S0b<9-4Cq'D!"ET@&"FCA[QhecKd;11#;G`)QZCl=3J%oN:/N[rqR*5I<Sh+J$;`Z1Zk_^,,
`?*bn1!(N'QUW6$OBcITlTh#UO!daXUb!j?uZ2h=8:6_>i!S>Y6BjWE5t6V*uqcR\ujDhp8k
7CKf'j8l(6ortUf3.i;WG<V&M;6J)us6Q:8X$.YG%8FNO\fro$j=0%D0D9cB3qnamUu(cJ08
DgJ1KS)tKZWdBDj`[kLSZZ48^P;c8)PlKS7M<1qr)eNb+n8e(+G]A'0=#_e2\^d+NH?6;EjPV
_()(I=fUd?LotC\6e$f,ald*1m!jqF^qVa*14]A'61027F9rGZ'*`3+uX'903!l`O;K9;edF<
gN4JDSF"Jb=tsCa8?YV%un$,Ho)IIV_A*;l'J&I.bV5qT*d9(aMtE-()dU9fYQZ8rZh5,%CT
UQatRf("iH.EaWVmDqDg2gF1l]A]ArKitinL6dqmff:[jEQBBA@@F,X-o;gq./,.j?f^a<10Sd
M`,su@[Pk=XkWL-Y$lM'M[Nm+a[,Mt?FucCCoc9%@Ml""@):q.bePiGrTVr`#$a>aF,@dbpd
fXr-Uh^HPa6%mjPlu:`!QcLcD4nW)oHL;.>@T6";Pj-MjS:3.(a7,#1?AEZF\eGJ;MBl+=<3
3%X&VJA!LlFPpq8KeHkFa>CM<-[9bC43]A0-T;[iW%X$i*H:TXukEXQ]A3;nkYC(K<:)8p-[1S
8-Qlj/Bj+@[j@8(7K$oE(,&hC*`3B,flI72&oJ5,muZk5hL)T(.$M1'Yt+3*?=%(WVQkq-&T
2j@s)m]A`bN:mikIUq_t;DM'd#SH/`;8QPS3A@A1'tA_iK`>)bLUX<I#Y&CYF6lY&Cc"-_E7a
op-DtROb5:GP+TERnQcj1p;?k;'XGkRqm[l`9LEr%nBSt3k_V*A*$Bg*^P5SX2"ZDXq7I[ad
9I"f+`u6F?1QWmc&%gq8<#!.8Cda*CX\TiGLfiIk!G')?7A$\9UH]Ab5V)'Tg)m!?<-J$M`n;
%#mZ,UG!e,<\k5?(pJ,gWPK:5;e5F^PjL8m,8K6Jeq%tPli1!5rqLb07ZPCeE`ie8fL^YIid
IFJYiXj!GW`NYhY'6M.:.Nou.J#oGA[l8/h6/khrdU\CC.@$ocS[f7STp97>V`n'ma(@'n$$
m.MJ&]A:0CCj1j7=OalW^kk3>[b:SBm4VU$:R2g_+VdYo[5UVL-s`(>:>D6'6k,I\r^*8;+AI
?<F\E0&bR4h5=hM>/(6tB+GD^5Vafq_WB"\*b#rJ;2[r+1X"r#ecWds!!C]AOE@1O?*7P+:.*
J44+3[(@K)'t3B)U`>G38Lbl6M!EY4B!'ir0L+7TVUHbN"kYCL&I=l:A8n4,5&V\:T3t6?B&
i.ntaR*6'B_D2m!r:o*)@/*Ztr`GAo7gf,KCHuP`^:a_0X<ej[8q\E2-aX3rY7:RE"O?LEpG
,EkFlhH4H._@ihpf!ju8H_!_95]A.k$[&)odt:em'3K2$cLthI34YZQDa_kmmMYE-H`*I\Rs.
d<fliiU2?X<r=G0/g7($rIo8\Da6U16QA+_=\-(%ImX!I0?%Ib1.GFncb#Am<#("=fuM$JFA
R"!O1;\6.ZM@1kuK7r>F_h6sc4+_IYTf=Fod-`^Aj29QiS1q.q^R`Sh7FtQOBn=O`M0JI!0e
_@7S;#3AMk#-B4]AWRb);Qdkg5[&84Prcp'DqNZ%qRY"Nu#&(\=tTWFN;Of2)6b?NZ"S7O"5U
>VMGlZplI1P5+06baK7u:%sa$ur5hpE8Z$QG4QC+m9^OC/#0!lIr-2uD@mSX1_E-@571s*@7
F\=@G5C]Ar;l+5pJ\qt7dHru#`#iYK[I*JIG5Y%FK+EX#4CMHj=+X"ML6tM`&4q69#dE%Y^>\
DD,9@W)rU.J9cb\(BJA\-Y.%QEIGK5)8S(^kGL'[%cV.9p#'RSR-BBo]A:Ur1kJT.@Jb_tSF4
<mV9S]AUu-[;0/61;"C(jn@>/:lj]AY:r^S7#XV[p%Ee+$q`<1O9BaAK]Ah(+]AC>&+*4`8cSP4<
p]A07-S/L=:;>c6kBX'%")IH@AiEJFVPg;hcuA=/eG0(B%i[gbocq3;^L<<?cg:0!b?gSOS:9
f#$SMs`rn$'\q*H)KRD#t(a;6_c)_e.B_Vj!\ELba!@0Uq-okL0+S)]AD*T8&9ZdcFaF*1/2Z
&6e*Z.c"#Y^26A.2\CPC.;nB&OV9BPkd_dE+3l]A8ZfMs=H$Z$5eP2r$(>auIgXd3]AKu0do@C
;r9bRQCk'FV?8Bsn0W\,J9k$j:Bp7+d:+5NP+C1H%?2VE/I,JOguGGC:8Tsc,K0pJfRceW5(
=n&q[e]AEr^Hg?\^jl`N/-jDdpPmo_CVH,Z"I./1QbTGK]A:`g2;V7)ePhI4INX-HZ-)r-[9/M
^e"!4-Ym8.?^WYdW5ah2q.,=nu!FN@*+jdLp_?Y=/20/%fNoF,llb%&A*S0:A0,/]A&clMlk?
\[Wl8[f[2lXB14_hDu_/l<)O?f?.3^+&%/ZrmO_Vgo#;oc!iWsEL1noD(D)o4H9k^UGCpV\2
mao_19lTW3?I$q>W3DdY?NnbpNTN.53(4;1D).]Ak+QlN_KH'>3sQW(kb`GEKLimJbin?6LQ`
Ncf$8*%FDj.93SYaZ6+WJS"b`mZ#>ef"&VDIg2Z8Aum14n[k8JG@=%k#Q!\!u8OKKFq2if`<
-5f>AKg`5-kkH5,mrsg4n*G^5pa&?NH227N]A`j;^jrE,Ye0/"PQ)[TO8hB1b7Gm6d^lrjt#5
X<pB7friG^]A!?l793i9S/ItJ"pY;2]Aa9W]A/A></c)c%goQ>^e"jAF@R1@C?T(XdXh]AmcmY,)
`#UYRar9f>A]AP^Mu/XeB'P<q>tYO9VUGGii>-p\(LUkY/W0d!p+4*P53^\1jIGo;^2\0;W/c
=e'=^b7BW\amAlJd2[J_tNK(,XkfLB3&dC.W:>955f<:*>Tf_'AhHk#12r5PNZ#D%iMU"5RC
i6))=08FD/JbYm\Q6LcA/1V?^OUohjLof/t=oj3=?lX&lTJkZ;WS3RIP@?DTP@)VEo(FMThA
&q+uI/dHUp`n7-tKt5$dTXBooq^j$ZLX,1hCtWeCb!Y1BW@%"u;8CPP616QN\iquLR-Nt'?i
D^j$J'@K7L[Q2cn`gqc7pT1F.ifF\CS5\(W0@>pg/SU(d=<l>MMZ2E:S"lpH_X<&jJn`5p>]A
R=3@u*mnH[$Q/eUeW7NP^gIPApmC*d4f+&LOHS.7U[C"kf9Z!bBEAmp11\u]AaUFY\%rp>Iuj
!.Dq26G.Z]A-&%jIgCD44-pGTN`WNUiDcI&9tsAtao4i#$$CS6A:(;Mo+V_#&M]AFZ3r/El.AT
Vmmq$@5"aq'-Fls5WV)eR\"T+NU1qXC-!V1ne\#ujZ78[_Ah'4=c>l3GH.!@)k9-YQ"<QUSl
k)_Kq.soS3f]Aa\]AKlk[!iJ?CXCNWksANk!-gVY!:)'FDF>'>M^,>,V.;,9s>nGVZI'h/<(Gu
Kr6Gur04YmnV.MOft+h1">+K.V$D:*Eb'+Ug_!#:cm3gCF0r8CMS:1lW36\G$$/V+3R0\OT&
QG*\r0M=bEP/9t8:2Wmr;OH/>R\[pUh'"Pg_BeB?6E`_O-rD%psE.Qs/^&\l-:/(fuDF&:8U
[CCY765._#`\@s9AEu4iGb"1m2>4=iSi0p3`pa?f)\IYn\d`pSB2sMnS%j$RqnYYC(c5`5(6
-U1XI%DVi@QI<@.DQ;%2'%B(0r6J>6&,%I0CUrP;66Z-=D^J1Q*Ga4EH-W^?8a)K05H2ER'U
HStSf[]A<?2lXro#1@QaB;1r<^g8EEI8^DS[leeR@>TUsG9$K#=7<:.!GC-`<1L.Rk*+M5P,K
kY4VF==<R_Qi3Vlbk'Ajnh6rYoaTP)ZuIb_9Nsmi%m)!ng/(hdEBG8MnGWc'8iC+'(<!XpB)
BHbRa&ki+pEA"\=pdC^Dbcg@'ScFB::Quenk6Y6dk0\VIejo-+GXD]Ag0+hn2PU!V,-\(q`n[
:ionr"FEj[oZM`eOjCc$._s.I=O;`<IW+eUgBai3)dK">HWr)A.[S4A70U8@43lM[+5aH&9"
Wn'2WZqS[L&TEo=NqT75?^a,8(>##>sP%GM`oQOgn&p[YB43#Og2IGqECX9hD&gqPQ*7a610
b_j'W`9Ru6`1^`.8oJcs0%5VpI!CqPjO<A;%)/u6K]AMiGW>JXScV%&dDsja8_**p'(jn457i
7r9+DZ,6(Z.lTiR:F.r'@]AjG%SJm<>ZbL<m4q&N0O"@@`D!p3bLZ4YIUd6l:h]A5ViR2^G^`]A
lqT%3f*B3bVR'@jiUlbRkJ/MEmhVr10<X+FWD\IjPf/CROcs+dF/I%b-h]A)jc[lH*krK@[;m
:cpJK1Zq,p#7[R=6cS.pU*j^\rSB$,PML;p;m]AF.4Xn-SM-sJ6?L_<5`MZV2u#_Vaf7S/2@a
uHpO,<W$E`s'<>6oW]A@rJ9@&FB`C4fS[IM9'Z&)G1>qke3hgP$rN;Ia++,>(TUF_$kd?L"mm
XprU=NQ^H/K8&O&nq%!5Hld1@Qikfp>:#TLD=]A0j`mA64QSXZlfVqP,bP'Gt,p_-3noLZI,?
j_1QYL=@:nms$_ZR\HLi#M/SddmR=3Ss5lA#e`&6(5_6t0-\caGE([Ii:+$%32In<Z`d20_=
IZSHN_p\Ia"9tp;6U"4=`N5.=bhGB>?VJ4#>@[>.GM2Z>5l4df'Wm@%CF8lf;\4B0qnq'hph
JqYP>hhqZ48JpP@mP/6YX]A"JK)m5VT^2<3po#9F1u(31P1K0g^Z]A0P)]AW@73a4gp+rr,Z"S8
V2FluS5W;GAcl!+0VHNdck%2F4ZYF^,Lf>j=%/KT*c)]AttQ*hS$7BAdW6rXl%%j%$[7-BRc`
HOmdT&hS_U6;tRLRR;s#P6pW/Ap-cmQDP=?]ARYDl,'Vh]AG!!/2p/+%)kj>FPI5g1$<bI,0)m
aPABuuR2%204S.Q?g^DG=lDIQ`<6bPB$eIj7H\Tc5ANZ`d]AE,5VMF*+=9B?7Rm(-SFQBlMpV
dr+=_Kd([gFn2P^e2A9k6RNR.5OI4e"ITGH6nsD%FA""KX<jSkZ?=[@R`)4-_o?H<jou$[14
_Xa5GlLFO>;!kaKm.U8''r8=^OpoEC1%1hD<(&<?IS^+#&.C<J?a%E8)%hXrPPf=2A@",A:J
gllAFrYO;Ns$5gmUl^UMtp#A0RPc7Wb5pc$<Jq6O#U?AZK5oV7h>LpK[.@sE6/h-Gr[&:Zs]A
XeEnXd?/CoL6P;;PCRLa%5%u*<>k'$m"anBdP!bg.NNlaU&deWkL,4P;%8+D8;o^;5!4T*"#
=eJ5>Ymmd?VGY*n0A,XR5ViqYdC1Q(S*Yk0jEPC<#?M&QuN.8?\nj!0<&>N\=,Be5Qj3A24T
&M\aG\o@^iCPcdrm4t8Rd8#`q*Kmn39f?&qB3pt*.2\_gprjlQHs,[uAq-f-."FI8]A[p@MNX
]ANeF!D5QM2AnI(W#9@[XY#T[ZEpM-`72t_lLACH-qOa+EXf$8<"drY%]AA*9@3U6cFBq7h/#,
Z#To_EQI.-n,;WZo/G&N#I,H`E"Nub%"=<I86*8$DECeuq=WSdhl)Gs&b6o;pM/9]A;E@TYKc
_Io;l=]Ad-Q%1r%*ZW8WfO9cpM0aX0=*HBEJO[T7!,,-^hVB>CrAtmsH<</MKR0Z3S"Z$9m'Y
/@DVTYOIDIVnL*@j0*`6-J@VktL6n0&a=X:l"gS@k6E-T*f<DRXGgR-gB7#,Ui<-A!e`PFVu
[VG+X[<hBr<?KLh_ftqcj/-8fJ\eqP4kLRE`;i,>*=g7!4S0\CMC$bA(gVoRQ#[K5B6q<I.9
`;e"e.\ePo_du"KD)BL07u+,I47]A:49E$0ZVfHIhRlT^l?)XC`^^3O0"^E2hXFj+SRnIXEWD
MY@[=1aJAcTt$-(V&>V.TgrSc,9R*;'UJeT@17_)=F/.#a'DGF!ropuF4\GO*f@&pKL'dtK1
0i\[,a&pg*8$CW$><Da*[[K!O7,mPe!n-4Q;'0qP#;u+:FZA$M/FTP$Eq/O9Xd'bj1/3BS9"
o_r0?m'f@`1DnJ?rZ]A9YX7_ZgmVNBi$!r_"`_#Ie=bnH.`2;P3,W5Ps=P\,(1<]AqV]A9=S=Yj
.W]Ar/OmAa+dOs%dh<?LINF%\BGLhGIF*IJQSLnLT0gN<7Gdk,2#6oT]A(QRFKkP3oVCh!80B>
\V6$9`tAV>jVP?;3W"830=mpD"?i]AIi-3gZEaV3NHtMG1MpagGbQ#5)O[4G_[Q.UjG#lb!sa
3L>lR1o,6YE\WHe'qH52*`feQ=H&L8>$oVfWaIC;&!?NXkK6)M,TNL/%$4=hNcEnZA0"=+@N
$m]AiGchQ0YK/D5:0rEcVXc[)2M)lh<P#g3HK,%[f3_+BlMgioWW&8E:,38Dsbn(6TV]A5<l/K
AH*S5gYR>BFu!F:1[6f&n3hYpj*#'L)(Aqu%!;%VHKFai;J<_"00h:%o%"Tk(<RQHNiK7n]Ad
_1)FoqhG/&Qkr,f<pFCa7A+(2@MbJ#%T0KFpSW..b\I8M8<*=Ft5^^a'DE=2i`je7S5r-r)`
%IR(Ie-Lt^Lc@3O1hq`EB8=C>UeTP)Jg)o+jmJ#Od5D')Q-@0Z*Fu26'nN)0AW2G"c58NUi4
(9\@K*<;I,4XAcZA3\3S<X]A3"_5.Tl,6(M2]Aa?L1lS7:lS*Oj!e3EV`6X['".7[[(g\?Pn%3
l[1apEXn=&P+eEmPU?PM[:?5&U\@IJILQ38q.[ll6-1<aP^t8.l,`_MfQ3C9R&3+d8GhRRdi
?C.RD:UgSUCM[rGOTicI#HIIB_%R*RA1XgC$qL!:kL`JhoS8&7=8Wc(TeL`bFgsfuJ+`$fe'
C79#V`=7X$\*>g<=::[)[qd?hHFDXms(*-b;9K#&0]AVtA:/6:3r2Me)>3K!9hC;M)O<k>)RF
kZiHf7e$&j`2O=%?ML8"+a9=2Ph+n!^Kb:T&C=h^m9,7E\6Pi!.63).,.@MHIA_4'LWE/N";
1b0T>ca#@.q3MopSRZXV)TE-C4D^Fl6FNudT]A2U/`+_??$X4Dk-JnemiglhEd2<;,9Mg%ck4
!+k(T"nKVI8=\'a^t9R#Kk7]AU"Hm`F:X&!YF,@\EJZ[GkF=0J\,7l8R_)uNuG0LkCR'(m;+A
29Y_?VuQS(09<f;A"(Q-E+6,ZY`U)d:?9<V,f#^U)d.?Pd"nXR,E93!2L^Xd2?O^%'tej,4+
Udg`mGa-:kRLW#>^"([?u^qi8:9kh"nHF)=7*"Oj.l284'!L*-Bn8+nMj7b&9FjGP2^Oq<f:
H"kX1VkuT9gN7>GgLH3@YUQ?5d]A'oj!"k.2<<K>8q-Sc__-K>VRPQ^\+4p\iWc_#$OgP4oK5
GNA<:M8/OjE$6I_jUgRQl+JGSc@ek@mJ5im^?pGc>jS9dbn.p=S3iT1ZFO:79JPr2gW+1]Ar$
aLZdEeYNSuYH1jpm#D1Rls?\tKu8tKjs\Z-_o)NW;kLLWklYd*((47W_r&j?_UBb&SH(b<N=
hpS:?L!`C_S<2OBsOQGa0h1[b]ARQYbUIiFr_sqA/"Yf/tfotKm[L6RW76F3Uge#Sjc?NZi=K
#;%2*)#EmY=9*DoN0H=1f/D,a^`493upSXP-0NM_FGEH#`8GU#c$4j5DFF]A5=m8@'-Yh)qm[
^P;#<_NZ#d![X/:5B8?O<3lC'!/%)&P-D,Fm48'Fu%JBF'=O64eh=TEe')aK"eIrBe>B($Br
+sD?Ta`h-;Zn^oKK26A5&.YKJ;5Z&ri?%,fmm_]A#Fo_W[+%#<//XeCXi!\oD=JEhb&E!pI02
GO=RKO2*E3dDiQ&?pd,;D'Sc,S(hX<)ke4Q&`"Ljf2c@WpAhZUp4G64'.Ue^")rt%T3T"?IM
g-aXtMP(b+)<DSS<[nf?;L-a.O]AVf=CKY]A@DA):;s![QjG0l')`T>D;3oar?5uV//0IGBa!u
`1Oprs>A-/:s)?-*^N"R`0D"^?[=*56)W(NPkIR'B?mJVP=Hm)?:^Np'I^Ws8)/n%%&8^^#@
?p"I[*9B)7k31\?/aq&iO:oY>j*4!I2<A"9@!L$=ht8(ZE^724j(%UMf<<Z_L'S]A>"]A3ZCL2
2JKD>VFj/[orP\6)fA&M.aW^&I2=JN'oHZX>!Xn-a*=8St-mqrruB1o]AD,V67!5=PXslFi=0
7&aphM^ZeL`Mcsd0Df]AfJ5lFO@*r+bW5JZ06W&dE?\P<uopBqr=\O)uH(<XqPi:VS_H63@J+
J$Lqen#Bbp9ZS8R"S;'mK*#%:!J+2dG$rN(l,H"GGQi`Is`a'QTgA?Vb3C^A=ZGibPbC3"C>
.<r_[Q^'euS^ncmHnCcWNB_s&*>?UpoTfTB;aUNLAWQNfnRe9DhI$LRnHM$]A9I[ddbAFR3qY
3:%Ye\eX8dJ!Bei#]AG1Z98&`[6pnLTTU"qLhaWXA7iA)nE.&c5e(-ME4DS?@>@;'M/0>3Q0a
L$2#)t\+*6UNk)dfb^`lJq.6=&HhSWnX4\i#m*:f,*GpaW`fUdu=9&A&)0PGs/CAT&ESI]A\&
`UE1,05*t^$_aVg]AY5NA#^3qC&m+6<=c>!=VUg[VAab*G]AE78X[_*?UB"?C!ApM^_^qgiA`I
Kr>PR@4mIUI%BhCn/5Ldb>;jP;["4L\U6Jk.KE*\H3l<@VTli]A6KDdI[/Lr3"2VJ<i+oK5]A?
h^V)ddeO0PnP?Y5*\p%(r+lN#@lV]AZ2Vh1p!aUe9KR&Z6+%OAnO1Y>kq.W'Up)Dl$J&tYB2H
BWMcZ.a4]A.,%X.A2+cXd,jQT^LR>tUJ]A%!X\2cIXeu/eZI.6>]AHcLDF7_!d"k\fW]A%4@^HG%
`IX2E2UPf]AOj#Le'!)gXck9c706G!\Wg:3\lF\C7^jKcsXuii0fQS,=9,h)7K-0`Z?"&16KP
@f]A?&32:7XBe2L`E7W9oMQdM&5p&iNDfi"K:@W.XdqTmtKIc2&_RGjg<npr=aN[!p[jm]AQ?k
',CM(UpYDV[#F0K\6ffc&B>l"?L03)0p5Cbrh%,<Q"4BF5-[XD;\CWu8)\`00ruXM[h,E<B!
gjBq8!$s,Ua.&Quk/V@CRe>1A1SrnUno;FdGQ@R!#Upl?c[6&Fr2bFj_=)>:S%feW=/mt4H;
UpqUj<Z0O:lA0)a?&^P3G8Q(,,a9EgM,<.:E>n8YE!lF/cepRs&A7>j-cbZ?l-4B50#c@SB!
h);DFQ!2M-N,?(*<g-tRVd7,OXr?i%6Q*]AV6#PMZI6/skgL_1gGcifiB%qb($H8Lk_&UgS+Y
8KCj]AP7g*+m%C0,bYi]A'+oRbM>%<)?Jg@>o]AcXJh*d&o7j["8(h9+%qX%lLBmq!dY4DE2]AV4
u/f/K;N4Z+l!e<npnER5!Yng4%$T8NVpNei;FROaNlL_WZmBR/6BL7mJ7K$&[)nMb2EI$5Q2
&it577JPSF;p!2PHcWTp%$q5fVGqo7O"mUlFn(]A\"&ij*\Uo@js^H_(J.(-f=3-No;GBX3U<
!LT0!IG2AZl,Z;KPW3S^hb@r!//5Q8d)kG77AY')HbJZj/jj&1E0(K!n&A@W?dgk&C1cnm]A7
('Pb_,_gb*b5GL&>T.'*d\YdGJIY?'EdrDcsmp<qp&5/#i:f(Zeq`'bFj-Bd1q4pJ\>q(!'2
lmQ;NXrdM.Z/jRM(kXS.5==%nWRRF[)`XpU.'FQ3MN!?FkJJ-!_VCbfX!@NrD?#QT?V?3EEY
CClPVOl>I-t"A`AhY/,5a#'=uYVY#h4iP5]Aqr(AHqaiQb1`W->rYo__b(2lUG7#"[BHV=I.2
)k[,1C%,\g+)5YJ/]A1q0I&6FgNX?SKRad$l&!;4luFD?c7<:G.*%X4W`dC$Q.<All><N\Dj3
4#SB.j7MKIZA.NJ&je_hQ(>e<S^1![J9UQ/6;]A6,Qbq<k-cp>'<pAG7&CeM;-`JWgAgI,b@>
q*_Xg7M=E0Btm-1fsqk.ob*J\C2\Z6h*4']A'D['./!E&:B[I/V2b7mfh0P=Ce.%K$\L]Ai/jp
'PpaePEF3pjt.DYe)QG>$NWG:1H1CD#ke!-a.a[7=$?`IYWMR@kd/;#7gYS$YTHGQ[\@(Kqi
YEK&IcuYAniO6j(X^-i6Ehil5KMs?^F:J=TBh6%Ml4`#Q\^?If.,3:$N=48AAd'ae4H^RAGb
!nt51TUo3EX%mTOd1p*C^&eL>H;)['V8S<V6%Pc8!)gcAE$-W=+!>rA'PqI:g?M;AI&TDjr+
AZ.ZHqMn(`?dVK^tBD*5hK8VEhH/26?KSj1a/t(Os//X<n-6sNWTnj*179BNKt@8C^i=*e0i
N9B,K<fN:UQ$^`oYQV&&(Yliiuf]A(%6@9+osn[F.c]A="/1[mV@G0eV4!ihF]AoB:,81XH\%TO
_BO_HkA?9AT'm2Pjj8L^`IltUKEV\Eo0:@C]A9)ODer7d:#Gs<Ei3`rV_e>\)Le#`C,T![*'3
>X\\-EF5pNDLP8p/#.-FKQ^dLp,6(pMlr&-@)F7[\0N'9%p474-2h%0pnp!Q&QK=03YWqA$g
j15+Ei8o!i*G3(]A!S?AnL^n4f3r(-n3Fr4$q^lF*i!o8!<i<sZ)&fr)IkWUVdTElFdZ!aIQ>
Ri+:))!MCB(+Ll0Ah>J.aUJDkVTeYC3hptlg80]Ac`j@6S=Y+R;#P`V]Ao&$7IS4P-8]Al/HcK4
W\l:Df$oYl+c1pGRsGhWUeDZ?"2N3@4Mhi-M(LTPIqY=\QK`/Qbp!R9AE4PYlMNqol0R.Ao>
QKO$(#U\UgWg6k4X(8!&74#HI$0(]ARiriI9=R9i=3eOnEL+BPqk(P"sGq$"+CTLp"7@QBFiL
hfJLCg>LqQU+SbFnS7Ib?<MffgPIKVf)'N\^t+VSg/q[Uki-`pTQ&ic*l2?!\2gmQht,C!3*
+N3SIW052ITInXp=)a-/Sd:fL_UrH*C$2CFs]Aqa#!C9P3[+C2oP,5'ibE^`!kEnC[6a,0I"<
=_n_X;AM!nM8aZ"<<44CcX$8:.%*fHer"+Oh+clBm[;W3M7`??DQs==A[J0R3AJ9&m42rdVI
O#bH@WOqpg_:qM0ip4N]A7tU+Y'M/U4`Ph%?DNYtdh`78-GO-dU)jrlJ*01i7>K#5;).K6usN
:XttbqNcTsJk.EGr^(q[JZfJ).50l*4$I7B*dAti>lWnI*H]A*@+U1DU?1[JCO'>e-mfcV8*m
"4%:OESbIeV;o]A#X]A!ca)iF^&.&[7C<$j5A>pQaaOaM<jd>Lc1&K//HII)/cdR*/cdR*/cdR
*/cdR*r]A^Oa9XHLs"%Rgh6*7B<=g?f#mN9=k4l9&c^%snWe#\$!M#Vieq;\UWR)d)54lk8?p
Z="m/O:sS/O:sS/O:sS/O:sS/O:sS/O:sS/O:sS/O:sS/O:sS/OB=g5ogg20iS7+ITI5C^YX
J4Z_b?>Jm*b0Jm*b0Jm*b0Jm*b0Jm*b0K)34lC*ccgY@4HVJ.;KiFkHCan]Ar8krXS~
]]></IM>
<ReportFitAttr fitStateInPC="3" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1845" height="527"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="540" width="1845" height="527"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_05"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_05"/>
<WidgetID widgetID="42a1fe2f-fee7-4218-b1fc-29bd8b5ab796"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_05"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1497600,1752600,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[14256000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_CATEGORY3]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=I18N($$$)]]></Content>
</Present>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM3" columnName="VALUE"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<NtVP?7KrXB"V"`O6IX&^t)9U/FDA8J:?B15Z`#=.)HI(h841;QBs)!C7i]A5b^pa&Wh8D,Z
Y6a!f7Nj)3UXX@L+5GJ/C&tKN>kVhRhA;j5/ZXG:g+$ep?6J=o4`fSoaV3T=s,DVqi?%r+kK
1!!'g#;^[Ws!<>"pW;i>FWh+1l9/lnOW;4rJ?d;q1S7QSUn:Ml3k1^!bj6[/Im%8a\IcS-6)
n"7`rpliHO`)1VT*[:O@K1YW*BO?*UV%Vn76,)J7d$.>*UW]A75?6`@oIgV/1ZPeXbT"/lDl+
T+:>9Ko1]A6p@lQOFJoo.2*/.m\CDjsif'H/PsP0lQ$+jhrW(_iFLnm$rlqMPU>+Q\IQ!5N$(
F=/@NG)ge,dSdq-i!OAj=/q%Zd^L/<3\CFO:?6d/!'GLuS=\QQg'dC.FSZ%=3$%1RVRl^,0W
P0!m2aaEG/3<+W+0gDNV/XQdCq>;#6=+-o2*en%\ocs1t2UJ47sP+Z;"7\`LUfFZ5]AYG!;om
!A[$(60&KF37)r;;/FF@0W@h-*EkZp>?HlPWIUBH`o(0\uYP1r'j,X!HX,"+SW'e*NaXF"!B
9i5>i:dGL[),l&9P'4#`<nX"eF6"m9B0)WHZo3KrUis,c7f<sdDXd)KF=!."d\,C6cbN]A@+d
ZrfOm48T#`Vkp2Q$A)Z?S;Q*GIo>8o0ZrR2oRm?)2tT4Z,n68#R!$cLlc\mjqKBqpCeWr:)@
@YtnB]AS4_gVI^OrZI!@i09[1^l0d>pn?1*-T(iCg1":D+CIeu99=_Z%'P']AAo;N+0A^bNJ/2
0Efo&i(R>]At^qaG!?P1ae03EHBXakE2J!Xa(&RGfV71c<*d*c3,WGi^Fi_3*@'onY-aRIN:!
uq<b)fPD;TK=-f'UI9R%0_?T5G%c?^0'KakKOiHpc:53+CPg>B!MXk)=3%>S6CGe"f9JRPhg
#meBJ58YKECYoKM4XOFTT9bB1UeQ%Y>k6FOB"XSe%^=T^;/ka9N-L*H%)[i\Q.?nYp3+sTU#
6tW/J'3=dt:(>gieEaoPcEo:L58.hebDgRk_fI<qkkVk3:ica!BYN&1<CYD)sKm^EH?%6+.G
1!2l"]AfGDd7EsDc%eo4rgd7urBN`YnkJ\h=556Gp1-2q]Ae[DK'JA=hKI1dm$k'EAV_K.#D`P
FEPC.Ymg;>W'BYtN8V*E@'9mt.s!-s7RH)ABfC=<?l*pCM5HJr+P6Y^DVtK7"f1h3rh(Y!^E
"S5kQ?Eo2fgV"gX!dK7Y2jNC+*Da8LC,V_4g0F8@0^R?RD;ahU;Vd(&qS&r9Qh%2,m6]Aior9
ut6is&?i@b,"4di/HM?i40&H!b<j1m+F+GC-n!di]AeI.Od%X87N.Os4hDNul(2NdHjFWcLnc
(HEj6&U3<bYYnr",m.[9aL7H%"AB#[.45_J&jD'1<0Sd=_pk!/]Ao&(c$b^nH&5Y'5%gpR2h-
+-1qRT_A8@i/SV-dh8uD*>?Bq?I[G[3353$9DI^^.PF=uo"WiBp90X`Q+ua#Tl>$M_q"IDjS
3gL@G9'K-Y%hV1bQ7:Y?(s>E=gL]AiM0[<9r@6GP>RTKXiW@i)<+<,;YtT9puVZ[/pHM4&G8a
g+5`4XP(<9ur.F)"\u[4;2[8[tg!#?la>EAOmbI%F[,?_>`n<Ia+2Qtr:"C)fr="gA-_R:+*
6X!U/rW>aKEJC$-ga@^K+!i+9`3R[r=QEa#]AuI\MT$0:rZQe5:l`?UB8oM?d-elCA']Ao$m+=
6MY9!K/CcuMqkl'P=-^T\?:(./#8.qP=nJU=WY?o9E.TY=jP,ZI$G(Q=a[D[e]A6jJnlBP)V(
-kuQ56X>c^!kW.5'gEa9Sg_ZipNnDIHa@nqIWd>'XD$"'H!@/NhpeR6feE3\VT[M"'iZCj@f
CSr@m(B[Ci6<lp%Xe3C8&ZZHuX?]AbXaeb2?g$-Bh2tp2jGS\nLM_<4p*Pj[V$t1C;@*28d1>
u`=80G;JSDLrMp>_$n5-)4FFGA30o`.M9:qqaP96#Om('rDGFrDQlsmt3.SU(^+=)lM/ZfFo
c;(PL<sp\q1<)]AIMmuK`-nAoD<J,E0oPmrLLQ9=1TKb<FNDt[rc2(TiP"CT$#c?FR'=`(aK:
V#?RPfjb[<Rc:-Ve'Cf![4GZ6r[U1sNcB9=tY[uod8'+k?m]A_',o2[I)@K&dYZ$&\5T`D_aj
7cq,[9tLD:UR\i6PP,O5&bXTj\sLDe))6k7E<A_#fh#)qU<&+tOQUL]AT/e%.*5Z[X0?1VZIQ
g@PBtql@#D3nj-<!mra-=6g>@OK2+5_eIK/55n/+X=ARO>T'St7cO@EE)H;0Y-S[hjZ0?Ok9
*['d&4MI62&:AX8odd4oj7&DT#ZQMH';.V1)5+]A3P)T[@#m$YI!N$PE1YrqW.,S^lUiOf\I"
W\_3`OeoM8H3/VO2bLK;ck)$I(3?TL`#N+Rob^S1+NDTr0"KMYN/2+SLrst$KLssH=O9uT"`
TX>S0h1a3Lb=:_kG41LcYP#X^;fDuLK\!057,J<ElLRDQNgk*u,o8<g2n[ri'1]Au!AX2UX*t
[W6llp"5aui%soURKE(W)Jc$@=YUQQ/8kE!9r@1d/&%QG44*]A8Aq1A(`H1o<N>Ygg_d=@UIH
u]AE39OSJM*Du0PlO%iR;Y&DH%>8DfX!Q"^JO*-<QD8<0H7kGh#6=8^7fcDiG#CZPNg5Q/;Rc
X&1h8YkB&P&^X:c-VosNQmpK+K-0a%=kC-_/p>>'/jLoMjddo[^>KD6S06;Gpq&cCSRAj&LA
TsGB6gpiuOeT+K3Qd1ifZgZJ>@V-dFDjnAbb9oI>LDeamNs@@jD@)s&F+O"3pGeZU$0e_/HI
JuD'o7fW`cTn?35JXHlAptI'>c6nbEIgd^[1[UQVoiH,s4sHC!Z"dj^f7,h!j-eu3haHC`Ha
e>nYj%6,7``K"i1JjX2.e<6B$A^cTk`oTI6C"o7hMh<F39R*_2n80:te"g2$fI6e*QYbZFpB
Q@*gL('ZcQaH_MBMo/QS0)8+_+77bn?1L_T>lAA['^LXbeutqs@>//3j(3$aG5=5V@sE0GW%
Y/>0o2I__.T4@7DP&iF>c[.c8\eTV9S9Llh/A#Ne]AMMHhnj_BB!m5NNO@`#[_,&,*7Jk:I`F
;qtu.e4&XLnDs=c61H@DY>b'aTqi78CVol54I.MO7;!YLF"E;qlf3cG5L77+83oe.6s-ADkt
4BXE,o6G59gNothMM!We$NNdhk[IS@aQ%CU"X+_<\c^Him=+h+g'7HQIP#K3p8d3]AS9;5$%X
*M]A7K$+]Aek-StJn7J>IQbWj6&iJO%/HSL3ka!Y"gmV(&>BXmQZRlp?$%e9"E,7U_&WeH`>[U
"B^9*3O'Q#QSAe$ssX]A--LbmAe1%[LtA<_$4CI9eEg[c3j%\O&!3$,Rs"_fr&h!Pk;Z(1CWp
2/b7drmJUJQk#PCDd`c+7WF,@3T&^JBf#JH<7f4*9mBhYH5>?n4\NqV5^Gb`(V+di5lZ2'29
/QUnRi6*J58Ll+=87c548cl:$:):IkZ[eF;i:'<`!WeihGdB^(?r-t)lGEl!*<hQb98HN;&O
!snB3hd9?TKNZ\N_'1t.Lcp`mU:9s@3nMA%)K5?rD_s8)&7Tf0PMZf,;9lJfLO`N5oG^&b2F
8r")JHlfeY@.Qs>/9j>1KfbEA`:@KTIlsIB%tCkCZd,qV9$akO^[;d7h#mMOp\sD2rr5<P$;
Tc3q1-,fK(;pt4imNh&\)2]A%/nqs2VbPYO-10ealXapq1bqZd9ItlKY%i&[E<;qKT"7=f7[3
Z6e?q/qEHn(,U"#dY'=\&!Z;WG,OT<19>tGhGV!-\m7PhnKeH-mJ;\6<hpE>>J0`5n4B0fM'
_6Q?i8BUf)Q`/aO\hln_rbeklE.7s1his!@a>H`P%1;/c,)XSSiLR)2Jlq=P?<V"2VUOB.;a
]Aglt6rHaR\['RuVZiQA9<k-ePF=(rHlTi`in=l?SKpI;T`r9"<3\=JK%#e[tW?/.QFMGIDnN
M`c#/1V2KpUHpi.\$o9#VpY#"^aH8QMpiB$Z\Iumj@\Qkm=@VBHM4"`bK_-*B,:C8^nb%_"2
3(o;]AeX[Ea8.9hNjn>:I&kIT?#bZi>po[MB4nMd:GnGHnLGk$OTtT/aVJ$H@2VsFJH>cQSVE
E%,$q$UIW#U4kU&+T,XQa5.O.AU0f&_1BU]A/LQLqObOD4-F\?V6WVhL<?+LN=I4lPaTS>BgY
[$m/_:1TC4s"NKZ$=J"E]A%--J+[_@X1h^5N^"`;P5Xk@o&Fe_'VO@2;YqAX-%-E4Z0"U=\bh
R"D-I(4;SWOu`GlffK4_'K2oMNCR(g)mTkZe9kaj<IMdqZ*L"V7G_QZUQ9k0'RRF`0GDp*#/
?=6e$Up$5P<;&BoaDj*E>CrtVH)AYD'*qY&87H&=1qC@(AliW^Y;5ihhr0[$=JH5\7WYM'1\
$`$=T$gYH3^YD!-,FWYs/a",B?T?<M!"T&kja!Y=UP(s/_T3cBGd5o=(p=$M0]A>d;]AZ5Ie5)
_nR7HBQ-V?WQX7mY`K!)S0K2>'3tPl#aE0ZX4joFhWfXB_c43/DCPiscnK]AXjQ["nr1"_suM
$=LD=7hDC_T/%D@hUWNSW6g6KIK8*)j>J>(+*M7l%_YcXQXnlA;iHX45M2p<$2F*MLSM/MW`
Jq>GH^3b^G-"2KKJ$V@k[XdTGnGJaO"@Y>K_4d3cpOJ^L^()h["\k=dI+q=)]AVs(oMc(OhD6
gnBL,d^iM,0pa,NV$i4=i"JUP8834VkY3%MW-_)"mqYM453?D,[-Kn=`tc7WJ-`(+DSrijD?
@K*>c%J0Ioid;3qdNjW'C0e/\\OU%L^hC_kEA[)!XS@XF[(Hp3:b1&hkN@Yc<QqhlJ<WkT%<
e8JJA<bu.?%"EhiKcC7!IHMY3m%_=&5^.U<biD%PHBeK_#d_O<:%bAE^"6rr7+pm5`-pt7$@
JP;qmD%]AC;TTVNbS66R0iB/4j]AFOr:qm/i.14?sB+a?jr.5#K,50FEY#`/?2JDDWKlDp1Ml#
*aiKjY8^+l:FI</`,%!R\OjkJc;I;T&J<j/2A=u"Vbap:uT:CC[<F2MB.WsU$jA@l!nheE55
11ibcGOb2E0?b3(AnZr[*jtdc&WCeMSrG;n/f7C8LUQ`qI71nJ[FPjqP#m"\F/[eM9<np>>=
$H.,,!,6%Z-;eS<l/'jKE1_o_S^fQfa^UEtQ\Hc,9sOa[g1uf2tq;[`pejB<9Y]A_j&s`E)9O
M+l.GWUM+93a0mZM9gu<_L6%m';e.c;UFpK4iGMerHSI@i0S+^>Q"T7%#RXfhDIXjG"I6hD]A
tbDtI/-Z5]A>h-k0NqbRqjPrRp'_%1$lahI9=*]A_5"%oZ.'OoP1a1-).a2Oi.C_hlfDT\QCMA
W,0uN&.\8_Tm7&G_m?&-I\+dQ0BfM$"JrjN^<4R-Ib/8&U>Gm:7<&n^[pFf`0gBbi!L`.f'P
W41T@TJ;-(dZEkj7Bj,Q+#eebD)5F25kpFBW#Pjo6!=LoNX_fQ*I0;(,?-1n4;\'"1\9DfGX
h_29n;XM]A0NRmfD9h-Nh#<1'=a0c+=EtS[qPH`F@pC<Uf^rp13P:%S%UnsIW'`onl?E`[#<<
:Ea`%`Gs6.>RaLIqo<GE0hTem:TsR2`$7tuk\UccV.i+,g=G"j9X--]Aj`HD%126@'cgb8;_T
QopjpY9(VX;1:+*X!?tOH25gGKjM(=K-$U=,%raiFi`qr:$UDLoNCW7nel5lup_s)k$)8aEZ
304K).4=C:0_Ub*#A8Z.2NI!6f1XIn:bU!iO,-W>tJj4RBa*Fg-/\L``I5kpA9B?q<ec8T$"
-WXo#h3sfo4Akgr6RbE*`,YHR^Mbbhehd:[9i[1ALuKpJCD9MYh3=Q![4eo/PCW1%=h5!YX/
uTh/Z_#MkN5e@b7d9JXanXk:fb3(?<[^0=ctAnb=e,iFgoE&P%;8:7c^7eT\W^TEM:MQh&-=
$[CjsK&Nj3m=mac0H);#ha895738P>@9ABDnGic:)>@l2rl4>LMrr)@@,!9_Jn=h5rpm,[b5
b+O/2aR/l]Aol!07A<N&C=":1$HANgD2Am2BZo-qaR!GV0"WoHDBGq))`&Nq&Ml1kQgLFMb21
JD5:6<u7*eiD7(+5hL0f]Ah]A[l_ZUa_J/W9>7FJ`"`.8]A3qK9FFqV4.m6;047h%_6>(:K[Y^=
0#1G+Qa&FHkr<i0\<j>f&Sp'JkeE5BRP-2#857/!/C.r<qi_X=qHAVkZM:OJ6(Qd2'3[iQa"
cF4g[X&a,B_K'0N[#W.3j@fD%8[&IBo<q)K'@iF.OD*Q#5GQnrg@SVnh#'lh?d9Ria?1pW@6
!^E31?R:G]AdnsDbc#[',%=A#BnQE&n;S1E7549op<;j?@gpLM,2Ih/bMNc#cAXu*I5:O+t$-
HV(/44?__DJ)ika#Flq/^$P:1A3Q4B&XV#"X+bdki/81X)<Og:(70ejrT-;!P#@$bW;Z]A"7P
bj2[!ohbS^Zm+Zd=\26LOXo>&cr]A^9mqLI9_CrHBu_4dp'?<gg4EIDAE?FABdOeK&U.m=9$\
1&CJO3;0ut-AdSA<4"IZCbWa9(fhK"1<1^%!aC,FqS]AEul/6WP1m?LiChEP"=r;b1^4)Mdh1
G8M-2thY[uFq+$U^kg;CtN,o:_R\hWrbEl(T(:mQ%pPR`KXY\ne_(Jc.k+00KDYObSaj$<>&
WMo_YL?1`8SG,kXumI%67\LnClmJn8G$)"98`t4lQE7=g?m)LVWb3UqTbUrTP_4l-0P_i.1:
<&i8CL@:#mF@1F`@@!R.K;)^(i/RZ)dm22/r'$V+N*Q8eLB0Dpp_tIF#S=@NJM1"X@`<7J7!
upYT^)!7M5d5;:ZVHFk,3Ks"FsY7=&g8s0H[(\<^San!?Qu'gC!jLj]AEWk-_REW[6rtT,`<,
,BOIj1i!%U2!htM(]AVgurO?N?/X!GQf`S396;7G_!<gO$DH2R,\UgO1;(a#ElJdJ=FmsBF#a
ej(&FQdgrA<]AOK"&]Atj-rcs5Hkc%VL%[*$=&Fah:i$38"8@BR%<CO2=\o)$-Gs"Wq2+dVJ!:
s_:e\`"S*u&h]AA-q'P7#`nV=-?"6sJD4UH<Zn?1r.ABNZTkiK?0\0!B(ATeBBSFO/_PuU<7<
k#&tQl,-[(7_+:nZ%dK@GJYtX\=DP_`CnapGMK>d<!W/NJB@&cJsnjm+slVlH5qH+LH7r`Ye
*8^^KADK9c-m#6OEWcY?fYUCX_S\oXYf[SGOr+Xc:BRqX>jS=O@82Gf8a';%,saC\i,Nhmn<
Q&_7iA9>*,Y(i=BXoepo<:lUno^8nE@!=;1V>UKG,XbSK4uHJiUK$n,\M"8=2K2&S1H*X/p9
.Mf7^ik<5bl2K=6K]A4aGZ>rcf-6p5IY2bI>I0g5Q$SDn+W\5+%CT.N1Q]AH<P"*mo1h2ri3)^
N&g'_JHljINWTSGhFg@ubq@nY$/oarG/.9dJ[WCRcpRP50UK;9Mi@8EBH)tYMB5bYC$1,AFD
^In.?*0N7iEbD=BFJ3rXi*%k<Oau[Mr]A)""j7mDCr?YM)8eA6YbJH+P5HU!hp#hlALgAVnEG
=OR&3OFHqU3WhVNX*jJc4/83^:%(FgsnW#pmF'$GjYEC._5m(o6lfps(R/c+RFq<Lglc6PK?
U'KKBDJu0T]AicSnN05c6oeK2*R+0tJY6Z?YWF?`_ei=kbVI(SI3[;6^OuV%rY/kN2l\VaEq5
6NC;Z)`A1L!W[I0VBK/+RSIH!KS:PeNhN&`LS/8;.=f1,n&n^XtI";/Hn/o]A4G>c!A5/;Fh%
/+l6',pA3`e5>(ag&Te4@M^HWE;tAG1,9AIkGL.Z`IcX_``4PSX!bK-$%9NG'YXB20@X^S=N
H#>C._fRc'kC'*GXab(d``]ARND@<aBXZ]A%"`SUf'>dpUi]A@pMa&Rts/<!H/k8bcD3+(g>peK
"pA#tj,0DPMpq9g#ah[e#V"k=d"'WFjnJ:i+%r*:>o$=[YF:o.1s"d:B.RS:2.64/b5-WPQ+
*';:Q/)i8h5W_]A;SI,9jJfK/'[0NV/O8L4'lJIBM+4Y`K!'FL$=F_K6e=W93J6Up1.1#Ftku
Dj-pr5o(q$@$\Z<Bd#%e!Da.0..1K/M[Hj#,jSj#,jSj#,jSj#,jSj#,jSj#,jSj#,lsYDo/
',:T(^:VW-hju.#2cr+-fm9>#0Ui^bKVqJ,'5'-RIYVgA/>Q`Tn2/j"0"4t=GE"-%Sf>'7_%
9s"e^bp'?>Qb"u_(VOWRqf^U_]A\6V;od^S<?M&0p\t6~
]]></IM>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="375" height="85"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="450" width="375" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_04"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_04"/>
<WidgetID widgetID="42a1fe2f-fee7-4218-b1fc-29bd8b5ab796"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_04"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1409700,1790700,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[14256000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_CATEGORY2]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=I18N($$$)]]></Content>
</Present>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM2" columnName="VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand dir="0"/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1" spacingBefore="4">
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<E>EPLnN3H@2bV.]A(\s"d.iMW/-7'@><>6$8T[F#Y:[F7*82Z!<PjC,%[o46V*_t.Zh`9#_
>B?5fTIZ5R8N:+<_."&-rCo]AF!/\oAcqFIHt2-^DGJ\8"OL'Hgg..msX$D]Ai-SqfW/gih[TV
d<#g?Lk7.K>WNH*uC9->#BAkQM!3dMe3;8&<*.!pYUY[)YoO6]A?;o*Au'BSc9%S_$F*-Uaog
6oW3oC=P!r;P$_5mBE/4GsR<*Z>%G.L[DiYOJRF<DZ^;&DjY?^\>qa`sS/qP=BkEPslo<Bm1
OMlqLP?;%KdL>Nh@6e.qX.?k?9\*15_X?`TXRGKORa<lc`Wn@9gl$WkgrD(f;aJd>h^fN@S"
M^;U*p^,K0hhO%sI4m_GTQo+KMo_Gp^AGm"]A%a[o^sBD,#*,F2a+,,*a8ZVLI*[m8.F>2($l
o+s+rh=^3rf@@J,V9($pG&dgA*+_MZS=3Q;3,_kB4oFY:1]AcTe?Crj-FT?5+o&bf`hF=Qp'X
%ZctI/;`T67p(qK^T*Hb#h/=3_*oBQfjtip$dV"8uXQ&dL,gd)Ba0/KB1eG@N&q425jSjkK2
u-6DiYNt_0'&W=F/K]A@ZS-m\JsWsT#lH)A.6!WOOg9pW5*43(eWhkB+;,m2C[[%.iQpQ<Z!Z
<8p5.!&pI!49fD+ToAnrj00;:Y!*d'cPN\?O(DVIW(L,!H19d@[kj)SSK+J?;b-=QindUf;Z
`)PYr!(u0d@4[Z\6)Ub8hZ7!i:OcW*7FMNn4j?$a>6ZGue06-?AOqq<;C&?Q)"2\:eCGkao%
r>XD,n8!YgH*BDi*DjKm$G@f[(:e*+UUu#U0Y\aCd>ZWGOPh1Z.u8o#%B^Q\NdM8jB`']A[o(
:ri(Ymp,_BqXj]A\V$:"EN96,G7&[Fl$>.64eHm1+I"4<6NJ;kp#e+27G.X0F.XUMQX2s7lbG
=:ApX1%smj3`!XqceC.f%4ZT23<$imrB+NpAVFQW>Yfco4*<qigV/,\'(;EY=c!RZj^4e-]A5
TQK.rX06STsm1Wn2r4jL"a;rk5"Sc.LlofOH'<R(+@m9Qp<X&lL?LDBqm)*\4a5]A:Zk:08J"
\SEtE;'KO]AYP4;q'XAla,kNmg<hl/4o_iQ+d(L?4qB3oAdcCh=\"I:j8:R2T'.cG-a55%-7[
4.Im<N'k*7U2@=p>B&.u%4&T.b<[".R2[Y,)`Y%4P/To,h$rg!I8e#flgAq*i7"LK8"m8>W#
8&L;<(rC:ra(?a>.*..\uW9O[q.?7[DZ'!N6,,L?u-*;O<C%W9;2,<)sLWbn#d:5nT)=/F4V
/]A72Dd%'spX?;a@5<\,mF5))@C0D.#SI*)ZX#J7Ifl0F[cXH)OhQl4JNeX-Hj.K5E@^tV-&d
4OeESQp?8_XjZC9!%BM!Dol\lM=E4,)te+5T+D!ucTiE\MV7DmB3&l[DXT:]AC6R4ZE"CS">Q
Qe3Vq8b+EEUt>JJJ+Y3-jp6ZM*TXqT9$Qr^@J\33e&CFO7>@!T%'"2Y7u8l8L+td.,:j)os1
PCeCS?PWcnS&<dh#]AnoRT%-o:l$U]AamB?M;eRd*ki-9j?CuiU=+D/WK?Eta!SLe6#[SJ<@kO
=S2><s3>d!O#(G2:P=$\IW3>ACb[YVJ@"&%s/4OA+iI"5P2(".Q)G'8Y<`Ei$TXeD(_SDQpS
n3bSS5/W@VMi$+Nj2)\,L#h\F6MSH_s]AG^3jc&$Q/>WN:9.gJ#3P9aZq]A3"iIRJ!o.RRL#1#
u6Yc)s;O*@ILX_G$selH-:OpG+9cfkJR(HSrPAU,g!E5>YbEHD<76sOMQF*@63DJ$45(6$VR
a]AVAf+b>CC,#(CjJTD-tXTuG+l9P`1mcg8GVuA_4g@R=JSEs/0rH>DLigdJ@Rc#R90\-N!OX
YsO>U%Dcm(>+'D%el$0El/iNQ!pN,!hPgaZAd9@nPY$i4NK.CsPfmK1f=bGi:s:ZF6/pdHcL
CN'tZBmC>BDPFCZ#]AMC8T\-%rIP@$&h>G;\-2<9:M0P*6U-$.op#^Y)V"BpS6[-U!=dTi?0o
E5#tl?.LoC?1b9>5ai*p.66TM7AMgB$drJWa9`e8Qe[Y*ZWId3JD^Q`GpAW[*B11CqfH5&\_
]Al:L9MSS'9X#pj53F]A-C'6cH*-]A?5!)C(cE"iRH8E7R+#7bG:s(*8Es%*@Se@tH$B<k0eRh8
h(jDD0NnVFB[P4[O2Z1Bj+dKjEu3n.>00mJlgE'V"CH0`/>u"AV/0?[D@6G`n`HT3q79[;H%
7di[I*:4ET!Ks$:V/1:>6LaDLJKr,$^&pXif"$gF]A:nBdPu#dr3?GC\H$R\l:d%Pd/[.G""Y
@Ju-ph3WZR2Sr.=Pgpt<4N@h,?X-oS$H-qhZLG7"+2%&bW7@#M2,Z_MIKV/#(H:^6ADY[#':
4B>NfYd.7WujAJMciE[\uUG"3bt[L'Kq?@M/AE=ekYDKQ:0#D4R(&no*V<XDeGP5a5Y+H\DG
XV>CBb=r-"e\/LI-%`FY"ps'e"f]ArpZpAdKM`MX8t;E3c[?)KbFgjQrIf:er:O6#6B>K+;Ge
[1$!o\1=kkgC$A@]Ad[`LEhi;PUb;BIleclmkkD\c!#VQ*jI/U2BK$8ch_,Lk;%G3;Td<du%V
^tZ8')l&\Z<hV%'sn(hq%$p^nSS0i\f]A\U,hR3-V?d]A!N+OoM85'PIq;+]A@h=$-Bj5XEL7r:
T/LIB*3%K-*"_Y$fC'Q7b^]ATY;/m`f/r@9(k-JqRsX+V`oHBk7[ClHP<'/YhTPkuIrWphX/F
\D#jfXn,*I"]AkM@jF-WG%N6Zgtqd;?a0pI.V%GZ[)G$#-l+'KlYN#h3#84=nY3!?*)io"$gN
rNScX>NUI[@jPJ,CjB3V0I:\\%u33)>2mQ$lqB?BnY*cBT[3`>QCI`PBHZ[!ViH>$o>h+Wlm
9Nq<`hV3O?<DBfDHf;,`J%TA")>''eCtZ,5etK!X;AY',SN2mlNaCaGTW700diEOgEL4D\14
2=8(Eu;5kgr7aG>Pu%+s2Z`#R?WVFUe6#/Vo\;O[O@YH-eA,!d/6ar.E_g^\%9ELUW?3fbit
">Art+E=%R#7Wn7GMu#t>i06m;djYN%L-kqV_/GR-Y)<[HH;7FIMG#\[/Vg#_D94jfDZ2D.0
junIVAa#.1<_"sP9R(*njqYOkOaVW-9h%8'nJk&]AS!'>K^TK5O*<Hl6c[55\[M*"k=RcG+_E
SLocLf<DIZb97K;nH\L?ToYjusGil5:+.1`'FApLZ?C]A$-?L-;?2Lk.5Z9aZB^KK(',CqniV
o\?[qURni"46H[3MO!qL`NAiC:F5\t&P)eTo*_i4p^4tJBt9QPEmt[<IssG,1!/$)iSm;CkV
<RRntjXt/-<-AOeEj]A?B:&[<JbL[VXEqCA!l(_TBB9[hZ@f8s*foT@j^'fKB)odI%eiHP95i
5%:',EDXVVZbO7!?]Acb=ITRA.hQWo4DLWr0M<T?3[G#sWfQl\0:f%Vb/hR_n#M#c;&K45<nd
Lu+5]AQJa&o#S!H'g\LE6iY4RR/1$V)]AQgu,ub4K\;^5gi@[uoL:\1(@@)f=eoX$t(M\5mQg>
Vn/Zn'VZ]AYm>@&56hf[B3/\m=_q[EkfuhW^>?#K'kI=]A54MUQ:GN36kl??N5>Sq',&&ha.63
]A8?@V5%(>i,k(Y/1!%WG[q^gKNlG>N:=oW83r-n*DG9WCm98u,(@Lp"2[-_F55J#W?<8KEmd
$D',db&^l4kgs?N,c@hisb%m%INPZ%-<\/2OhUqZ-E;(g*]Am+7I:PbQr%^jmUkAG-Kms9Gc?
)D<eC]A`(uWVeT&C`nVg,?`A4s]APlKIq*0Z1V"F%'u`.(`\,?r>l2WG7(T*1bhP9mfIEp*,H>
TF>c+UBqmY=@@:@i#jtFmKW]A7@Pk?HLrX!rIU4sMq"8,Xu=GDKX$tR=NV&4,RP1L7u@Z>@h*
7@gG#jsI[\3L!7l6dj9J85#tcP$jRcCSdH\3$d;Jj2"`(]Ap4B^7F_C\q8dI';-Yb\WYB[tJ%
4bBS9/U`IGEt.I:Zh\3]A^Z>32dEqm!N5\DIAlUl/1"UrM^R:d)XOg%JN^Ao7N'A1<V!lo,#k
#O7V@5d<c%%O*mSVg%e;0bpQ`Z="<(a,]A!8ECFhRLiYfj;<B4%cbgRAV`A[\[#q$-o0W[A0U
BcCU6-YZ!L=kaQZgAS!:5XCV;EG/='!_Z;9k.V3DBQXKmWO%)HJr.j0G/<l7[rZLk).QWYh(
u9@%aR(K\W=Bm3FW7*9gq%V9q]As6e=lO))>tB2RoP5WWAJ(QB>l6#]AQE;.k]AbdCd0M[(u/sP
/'i?9PlWZtjKdf#D5#6#)+iL(4S:GYaRR2/V*ft\sAa=@f?\2`=qpo!&'i-<PCZKMYldH3db
:E=%n/@t:9LdH8c0"J49P7f3*Q\l.fbp^-Hnu-X"dc89cj;i!Va(lHZN.QRp,PU=&[Rc6j?+
_*'-pinaH7K\g'H<!:(,QT>(lM2E@dmeV#H)XqV)\+JdS\cI&au$8I`fa)o_[hM6I21&*3X9
]A8Q"#)\rrW8:,N(*.i_,aj*0n:_FE7fdPXe@&jO%A[5&Wh7/'YdaA?K.m-^3%p)WK=@PgE^S
X'`]A)O^>BWqJl-j2^AL%=Q+6ThO$1Z0=+hV_:Ie%Zq"FJhp/GlkLIWoKqLRgE[r!<XjJ>ZX2
Uqrlk8cV!3#[M'+l;\Ne8r*b!h]A=q%\M7s*JP]AFsrn)-)dST^6436M*%uNa"S.H-VT)Zn@!X
\;O*<Sp4&3MV[U+DiY]A?%hf8A/U`7G*2s8.N!L40a+fd7XQ1L"U]A-ZXNp@"5b2i`cdfU]A/"d
9"SU&L**I&tLr-"rXR;?oaIp0Ed%SuO<#Mt_`B+V9Y(M4Q(*kT'r7Tbc_VU[qkCnk`FFg:nO
?:CQI2Eh/RXA=]Aq]A=#sTJC"Ll^Yr4?3^%D-tL:N*d$#-)#6Z*+j/C@_a^6;>u99>'<d^Qa>:
bOC,5BcH;ImV/%:S-G?8PsTIF0/oL"q\YENL$P)Mq/CIm-cUsWO^l'gTZD@`K2C>eQG_;ZRO
(959r'u7da%6DfeXm6pWoi@]AjWn1NAn=i:cK-bmg/(oUn>[@q$hI[QXtZ6nG,JPtu_(&e]AL^
%<F+:/0;iZoO@mm?IGM7-dhK3*&ffVKGE[b/ek4akp&ui&?]A&&gX.?u<]AgsM;BA9peV&u9XB
1V=b;2L6gq59t*/6AG=p_T[N*DFUQ;^+=+ggp_%+oYTp_%\>hg^hdp56t<0.rW'&d;pe[2Xk
'"?>)G9e4WGVYXUfVWg'97\]AQA?dLh?V>h/<Y$6i>&$]AKN!csAj2[cSX/&^@80"=MX:0O]Ac@
DUBq8LfU'`!\RsQ1M_4^7(.^W-LdOFLc+\/0g97rT_$V6VBkKo-frG(^irN>-7HAQEfQr\<9
Hkhq^KS;TpqUbW;CA6NFCAs(OJ'%V6iM2n#udP;)g9D</:Y-MRmHng]Aap@+r,q\lVDGi^=TF
+@OXYNpS'UnNA?o%RT#");Pc72sK\Q,hVs^B0#]Aritt&cdRuLp8YuNRb]AfJq),oMr`5Ffcj:
O(nUcu_?l?tds03g1ZE&"2<N&\oNU=Oj<InDnK]A<98I!gL,8s)r>dD[H3p?qS[[aGR>eKt2s
=I:5?hZ=h7H307.8J'>DtQ*t^b&=(n/CM]AJYo#_:sI2)ID$Z8B`N[']AtB"*02cA60DDu)!@A
HBBb"96'gP*MeD7@Be8:`,ZQbn2TXKq)=Q*?KjY-QFap0QAG"QMXfs+#I?cLGeKONMD`*7bV
)bmLRn.00K&?0U[J\Yp\,l]AgL*2NAm!@SnQcX\OqTjTtW+S+"aFP9154V.9B_l5A!`/LM!=!
9cXO:g#2?G,JM5&D93\.JY`3GiB]AZ@B!:d5*sfKneV<5E8Gjgh5&RdVJ`O@1eBN;Gk)%ZQPh
f+IKjO1P@cJ%Un+bTqgKHFM\JU<)FuatN,ip3)1FD%@Lj=dKP/V/_V`AOL@ZsW7@SM34eSgg
FB`4Gg=mos<GSbG=G`k[OZJ\RbQ<=6CYG`IB.3r$JH"FL`RVU5n"ZeKrf>5U:DGc[DV2s6[W
K`:/Mhai_mEtm_#Il!_LCf=DHIX'.hnSts,UcC[R(;e+G,bq*CBB<^*f@1$+;':QNn:,4?PQ
0PA$95;E6LB1^2ka'`N3P9"2#hB)b%uN<n7XDWHZDQU?5C3F=+IWlR>VVm!E<cn4i8-D80=V
;p"(d6]AEPnm@qEY]Acfjn5uruHrTr4DSVo0cH(D/8hM8is2B3EIObhgSXH'QWq$j*ZN88'Z[Q
uN(-uWn`Q1]AY%eT&UAGUOU/9M86hikC.C%]A:c#a$>#Kk5?9-f^SfrfW`dC067AQg[3X<B>TY
<\CI2ETk^'sEL!9[U5-FcH`mXk3$Tpf\J00@'A+An6Brk^BcZ`Q(1k=Oa)PO'5t1<4>t&3D[
iW*Lm+!.K/['%QN'2LcL6Lmio7WqhAfZru[??dDdjh-6F>"\[JX?S6Q.Is,@q.@R7\/WWghI
o<nS2<)X?mh<%e@738e#q1*4:1uQ>uL<jrS.RjmOEXUg`Ot-G/Z')12f=n_2$lAG2#@N'6?G
/$<r30Sp6-"s,/(l&8J7FMIJoOFP?clY\ojK_@r7Ga(>S$]ARn7V,-ls?Pf/X:l^1;bk*8@`g
U-6c6Y,f`##'3$N+0dNIT\eC:V37Fnd)Ub<oGl!]A0aG2s7.8[OnV&,QiO5F*_9k5/"?,_JHe
p1j[3e6*a-PIouo#,L3XbMK*Nul!JG%5$hckUm*9Im3&ab<?hWPiKi6!!^Z+B08f`!Eg&<=O
4UA>(aDR9]A\caB3MNHldN=&2[I.It$5eb,)L2oX%b\'191cng[b%GCP?/t>--j!:K7m?M)aU
[>=kd-/4>X1YM-3)oEr/M;W14Wr;9PM*F47)(9A\*AT19Q]A\R>C8V`%EgDqKFo1ViH;26Au`
_hS$".S9^,s5AuR)4L3Ln-/,Unsq><reE8To'ttjN"X]A!mHpoSf&eDs*^s4ss.cXMs+S9pr8
N(nF8:-22@[fe&D(B$T"X^g5ShZt?2:.0=K*:*m'qr\P<GUWo34JF#9%tM_KiUuo$K)$<k,Y
W6h/T#2,-M+qMJ^<$F)g]AP*/.'A;1bof78ur;ac5h]Afgs:/r%VI`^K4DQ.=+.h8a&Gb34Qii
M:==VJM*+XdF\uYJ+#sjfH,H9E6RO3$PLe=3&l`IRmc#_TP!@05P;gBqCi-.d"=(T[V`)<39
pM$o9bKX9VpcM*4G6ne&;`$0irrUgTkcqcf]AMHkrKOl]A"OGXT(KIDj.qRdlullB]A`A.U07#G
a)3VPR2#(b]ANS&A+I(TtLljphPHLfd7:_^`n$CUOF\f%D@FVV#</jG+<2?NP`m$P:S=:3O0o
;%`M&SU*AYj9PXq.%&Pm/>RMV"b,]A0-Mnjka;\n!"baS!DS*ShBDoDqKJKmcVBI`\SHS&/6k
l8)a>,hsSU\j2(<+Xdrj@pV=!u^M*q^'7QZ?p5.p<^IhA"<"saJIu-kk-]AbRkD!A(dqAkJ;3
lk]A5<TBrM`=X$ia0EGF6&^R<pQIQ72EDj?O<EVWFsgK+7uCXsTe9LCZeJhQ5IL>rS*_]AB`1&
^;De3Wn@T;QDN>MTAT!"opn0$<?@%X`gik]Ag1i!tId+p9JJ6s;1GRp%JWbfn-+ioI3_/4W/7
+#gK[MA2a(b@g8oSK2P]ANq`(3>IJt9N*c`'k_!Gl@;D7eVI"B5PA)pnh\:sHlrH4nGN2@W+[
Re]A*iuL`mO&Xu/]ARBWOP:=<5'NB+qQ+]Agh18\qbso&CJ[*lVnRR25W+iD[5(PK)2orEN(*>6
11Ln*sNb\,c-adHmMZ7`&3hudQr`Rcg1ld+TO"3@<!:Z8^ZCh:"%lYI9i#fKKM?EY8>GZKEI
_N=#m/Z$'.Kp=_30UpFhB[$&2p%QM:%BWVPIsKD,]AAi)ad_?cng=24,Zt>[]A_UU-/5u+9E8a
l3J=$/Q\B>@$pf6]AWPNI:^C_PS,2o/4-'AN^L_+ek^g]ATRP9lLd$"?4.kE"h"02o5M"?92/9
j6p]A$O@8okiOm>ogmP4Pru1~
]]></IM>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="375" height="85"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="350" width="375" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_03"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_03"/>
<WidgetID widgetID="42a1fe2f-fee7-4218-b1fc-29bd8b5ab796"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_03"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1409700,1790700,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[14287500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_CATEGORY1]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=I18N($$$)]]></Content>
</Present>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="REP_COUNTRY_REPORT_SUM1" columnName="VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m9"X9P3Lh8:1ric>0_=qZs9&6[EREH=)=bQ1mP.>F/?l>;)1L[!G:VtNolL/L8^=U;_I-gWP
G<nUo9NRL5;'@KIEdLL^8CdN-!:TY4"F'pW*"UIsBrDhXCEUch%(CqtHnYpN#)qH1tnN!3jH
0m&:?m^m>;UIt-4OHGX!e?ipDSV/E3Fqr)///9Aur6Q#a=6745N:iANOfue-GhDa\+D;<]Ajm
e3WT?$kJrFgj;SGW_)e.0!g+,dY4ur&!7hG+[/B:Ysa)E:1cA)90rU>/W[AF%Kl#^<*W)_7g
Anr)^ijhA)5J.GAe8)M&7Yo)r9U5_Dr:9I.A[3EV/rF@r>%Qc<ML,-2)9]A53dU;me=>MKl9s
&D;i"X'qE43g"a2:%b_$o$3UTfWjBi]AR7J/)")2*^6De)pmc'r'``1S-3(\e<jMOZ2tl*X#6
94Y9FXf-qZ(OCIt)b.#LtL1nAb:uU!4^cm4[0_S4*%_*X.&D4#&^mqR6H9r0@(R-&aKV9<e!
dqdk:@IKKRh5,*H)YCPqYRfIuZrMOrde)R?Pkg]AF'PN,lt+&:.o*BUP9jL!jd)l]A$LT97a]Ah
+`pq>j+arjJ$:G[-:=;eK1[T5B;OZPS\rI5/ESi\ctngkN2QKENA+Gp'J\8*g`j".tt>]APqV
NrD(3\TBN"<.6D.97S2I!B?c)7SB,c"bo?JA?G21Kn7>).N]A",=Z@\TS\G>O1@O>g.reN&(-
d@EGeQoNi4)p;q:J,T6:PV+q45u&6T_q<YE&-ArOr(:%>ZjRZ#b>&Oif_A-276)^bnMI0-eQ
E3f,1FqUY37jG0q:Q]AQ32Vm/G%q+5Ns"l5E+p[[ZhsN;WW21+A]AAhgc_%Mh1K"n'80=$?i++
r!Pt./S$j4dcS$qF+`56U>=B%).\\?D./sqXD@=IAG&V&"IZB!X@bLHn);<%a9h6t63QV%9@
O75lSg'c:f9BP$>EjO'$G:L`?^U.o,\;-ZM>)m2\MUDYEVfKPQuu&LqPdacPV$==R_pQbWF7
&Gi0L\`b>DNkMa`M<9jhg6/$$_sKfjFC<OQcNCNOU9K/D=RiDX\?r<QpB>?[E_[npYA<*#7=
STj"^Oaaf^QZP4;$n8#$>ut.&eDc=6RI.FAA,h'aClN!W4`0VZV)MiL;FI,t)l*(#%cNFo]AM
8$1q\e5fn1tH-@#n$7W43t2-VJBLSA^31Hm>]A0]A`pOb?VQAX55"%_9B=$kFBI3B33-Y)(b=_
$ZI4CC+7L?G>V"-\cfOm9`'FXWIYi#XNhJ":[hMhs#IL<A!#*qsm>JirJ?=#W$TO.sgb5CM$
/n$so>D)i622"=j"WYPOb'L%*cr*<,#u8H\t.&T*[qE44N,mk:P,#hAnJFjnN\JMX?6nG*<?
PLeI,C0>E_<ho3GPBaH+WfR"B%*2(%lo`X_Le'((GVog4!SmkA3`2<i6SENT,&9(V%W:oT*"
PqK#'+o&H,43Q\d]Ac1&QoSO=2q"MMKr3k9pH_=Qp4t3[eWGp,oF5;>:)8:5Gn.Pc*F?"J$,]A
sS:5m"_H;9_7t&Q5B&]Ajbl7ISBo$=WbQ+=HsEaW6A^,$)nQC(2mo!k=DnF,,K^a_-C<NI4%`
'#UP9m>-oKTTZMfj.^<2k*EsAsJX,Dr5:-7^(`/Y;G11d0g-6YL8KWs*e[Vj?QFccj=gJat^
IoG7.cj4mJBq;PG23b.GSVYZc[V2GW%NMqO`NCV/4cH7!MuDNkL-Bl1't8W:5q'4O2Gdj)*J
[QM%_E$_;\cEK"jIG]AMSM;4:iXmg@s1^(2[T]Agh$Eu)Lj84Ic,D(]AU:J"]A^H+&et##*B&TF7
=0u5%;j&i%47c!mN4r00=nG0[2,,SpV[KkHB_YB9]AF_o,K!dDu(pbs,<$G>E^cH'QmHH_WX3
@`JUmN&+hjmjM/,R.HfgMjTBG+(("HW=VGMQ]AKBTh+]AAM1BGA.i.P<4b7d\fMr%kqKdQA=(j
BDSZqCS:aKj*\i4%2e>2=!8\lUSelPZ_g'.@D/"4@Oc$N9Bt`f,!R76^d8CW_kMim"/-##/X
D661e7hQgTeX7<`p3rV@BL`)I!F!fAu&J3UDaiq*.m0B4,3tgOK537"DMGE7OMGC$LDQ7Xd0
FuA[@j/D,]A+,\/\`46<6uW$7'W6%Vts>^Wam).nVV.=5.V2dNOc+*3,=.?Iml_n$CujrP2s?
;hT'b2H8I7r\Z.m..JJ-oj`p;n_I<%\##8fb.X$:''N,5JC!F6/dD@[Dr/,u63hRD,cA<ua8
(YBPW]A,BS:6\;#orokdH,K=@_t>cp@\a*og.#?&IE:f]A7P`q>pCV-%%5PR97iT"91,u&(/V0
]A77:/>P+^L;M"'r;^;>^`@jZi?%IhU<7]Acl27j8-'3Q@UTN.+='_cWCMEL;[/[chF!S!]A<tB
A4\LIXorpi@NrNBt[>@[<W99d(/LBn+D05_WoF7R/.V8g^l?""dd_qg"aNEG()MkX"QKXo02
9'VfsqS0j;K#[@ctT0XLA\0.hpBPE%RVA&uk1$(O@d1n7uf-FS@N>`d*k@F5"D%M_'<1QKi[
o)6PP6I.X]Ac+b?n%(n8nQbRABcIJZ')278pl,Om.#Kbg:9ZgbkKN6pc<mK_1ABAJk."i?s'c
bH6B=A_Pkp)emN;DRdZ'H6TV-R#;_\JTFRC!ZJl5nPbTQ>L9Gu(,H^$qS,?u+I^6L0]A912pY
I.W:-\(H6`FqerW]Amje.$_PmZ8%t%^.=+@M$O4=sRJ)FZ'&)3*ZdPg!o!:e_mcB1,Qb(PCR-
-N[Ui*mMOd3qMSVE4@LLR##FaD+@LjDO;7CeK6KWpe)(%)^V&;(-QRgHlX:.^nADng+d)gTd
*b99o#.Q\p;b\==T,YLiN^l%dMJ]AB0sH?'g5d.0&7uNcQRG"nE<WdRB%]A&e2:u9@5=Tk,q'q
$cTnNr0<9t3@jHiT,5l.dCCt(,.h#a@4N=^kCg&U;Dq]A]Aqt@_7W$^%!(8cP/+MUZt1@:Lech
uL[ZlrO@rB@A!(b$7OlX%#>3'*UJ%!Da+-oKF"2LPAMD5`dG@We(^*2V':9jhNk-[p+Z&^@<
Ja5HlW4XN,9'-,P#jIlD$?a_n"`Vn5G]AB%qKlT=-K\qBp64"1nbOA0Y;@&1.ZBKN]AW;2_p9B
[K1,K!@3+K9l>!LY_^*,hfN'/)55)pTZg>$7'TZbmded6%2$d#RQOsW7D=o-M>QpXrZ.c=:F
>@hDFCk]Ab86-h<-iHFJ\je(&L_!CS`HS2EcdNiiJKPVg-:)RKO`+nUioNfluK%#BfQ`h[\[`
394([1N7'0X8aa1cA,V2C1[;9+97W-Vo7lb,DU4S+OUDF2>$0Be7eNP^K$+RrBOS0FS=2a)c
g**1JZDiK/Uj@N-kHqmE<=@?i7lQ.\$^F4l41(oZG/5.'#lAl!!%>J)"kW^D*#'s74tVcG73
(2S\n17pS<`o<WorYNDk>N7+=!s(Clap<shMf"$;?J,"sR\_sZXk=%/fA^r>uO&)n71\p]A2r
-r0l47L5/#OCOLMtT+08OkZN:\UjlUX'?@XhPK.KCYkf]A"oR^%WLMcnho14V)3WJ3ftIXX-R
+f2hlt:K"Xa5Yd,J.A,I`[':)'pKToJ`WF=5.L'9#5^3b/<=YPDk/^5G[#t.:aUeH[Y6Pm]A+
>Z"$!QZXjh>m+J4S2Y@=^V@BL+,D0]A-5jH++Z0eJLB\?P#\BC/*g/AJ]A*.G]A&_!YN9<1r6#t
;h;4__mY*a00*1ARo"K;P_GQIKYIBtZfVBcJJF-rdA'X85)^mcUuGoKS4W67^g(aO(6-hZ]A)
Qnrr^rRZ>ZF2B`A/f#Zg!)&6`%ENI6gJ1;<)4`1_f[2'QHrG7fIqB'LOr(u=.TaeFb[Ef[.+
Zj.Z&<og)N_7Hq?G</\Qd:N@HMe_f)aZ]AZmI,qh"CC#+iVDepp39cRK7Dm&?QlrY`\gk+Q6F
lYq:=<]AkV`0Q'&&DT'a2sgF0(irA+Z8l5%a]ATZ!DVHb?qiYTJO2(9,=I(T%X]A"BbAq>:;#JJ
OJ(5eL0,Q'^1)@RZTicp6+/c_#aLh.#/"oT[s7P^\:=L9_p#h-C(lh#b\=KVlJS'p\\=HPeZ
CT@]A?3lDciqSW-Qd?3eti]AZOpuM1;0Z5-l6.Y/5?HRUJ<JtROTWR36Eu62)nol2RGJKI-5>V
&c^<7LA;9G<eZDi*r'MSq4HS*97uQF;a4*I)%1f)r6@3bH.%=gQZlF8Jn*udO$V?olH;M:8_
O<[U9#Jo0oQEGAQ'N;01WP'j0jjb5h[L<lR<P)3oDPYKWFj"J*N/^?"WUsITU[s5!$/j<3d7
:+YM']A]Aj,8t^Jk\9qBh70Mp.7o!ig_%n)Y![qbI;16Ak*K>1Q^!T2b%pq>t>[U`"H_n:;E+F
#u:Za[amG#apCMZ(m3[6K(ZJk`Gd0mRh86J;j!C]AM((.GU]AfA1QpC3?hts`HBD4\!a3DpNB'
setGO6jkFBah4l1n&P1AMu"_\/RjCH,Xe'u.*??Ma@-)9_0]Appm(=):>CN_@0a@K./i3mr2&
*$0S.kd#0b\j^e'cM'mGAUN]A?"b'L(oSh9AY<V(o9BTV3@:;2+@_51@p&'WGd@Y`5-kSKSEV
'The4uL("6SIh!CV/K#Q#2$6YhWU(R9C7iFMZ)Olm=:47$'Ae-;I@3=1IB(/+hBHpV.">HYU
mn5:VC!d*@NY[Z>W<W#Yi_RgYu]A5fb\-7Jr*]AHR$gK_`XOA'\\:R?iq:m^q[@\[I:aEk<F+t
.%D+=c3<[8gAV2$.h&>Djs;7s+XW)OAu)?KppHE-o+V<G0*P:4#jS:@f@()[kO.I2mB_H5nu
`uJiW$t<0L2ANY7A,>.?sW[S:6ET&fi!C.#dGQFo(VTE2:nnU[I%HHnbM+]Ag-6K\26iS85cO
f>96DEWEr9?R=LrWf^\8A;uF"A4G?jl*92+-D=LPpbl[EM,2$9TU+&B08iWqiX*qsl@uEuW0
U-be3&j4DkBi1f;0^<YKd$W2CEL-aSa%j"38-k"EmpVe,[_W"Rt[J&.I]A/dBH'=iRNG_VqVs
!4HT1)ES21QE608$CP(nah*[&5..]Aag>YA@\T.7CnX_c(\#\[f7]A/V/$L1]AHgu]A>QtJa><Q>
eGc1'?r/.am]A?`q=V-X7BJgo<n-$N)7f,TQ!RcaDFY=8/NI?Q#6k5MRjg1-!F*p8EI4@hMMT
OS8bH+`hVAT8e/)%N16?r^nU.Fc6-FkCr]AC1oL\ukH'6<=l9FgYkb]A]A8E*8%6I_4=W-SGFbq
)HTS2*W*<-Goj63+Y"B6+8IA5gY6-7U\=V`fpfbJ1G[Z-n9h^>PPS\`C$A1EW0n(4ii*2.*s
)>\,itlL:8Qa.!ZX\aFX'@B/#VSV?Lp!G`;X.n/Fqe@Ec*TJF6M[VkdOcYR`6Mhn@d;3">>+
'fpPnFD$\%50':m7H,MCrCa)>b,E_8^aeoqqLb/dM0j\:!M5OsQ(\KfT><G0&b#)'%Y%LStj
[+KX-nfF==(KUj]AdHX>0ZON'`2QUTSEb?LY%fZ6K=WMI/lL:hmXX9jLrREa7cj\a!0ZTBGP(
su92AQthJ]AdL!#p^j%+e;gPJ#Tj)?iZn%ns..$]Ac6R@E'7dOnO\R9n%$@'&fq`k7)"C[W`'u
sJE^!LN'aGe[>ZTP'k?N4"HL3N%``e(j'2`C3\IK+X+XLZI1bS4n$dKdA[[.PJ]A^QO0(^rW$
`=5R,f7afP9hHl18CNN2s%(FHc@.)8ZL]A*COM=fW#BHQ8n[lJRbOP'gCGtX'N[H_FsUEQbH?
_-@<n:&HjlDN<*'PpHVLBHV13K5=<Ep+<61;b#?:BV?<lc>"#<3n5lBQH?(Bo,7B+]A%H)@GT
i?qspN?r6$*3r@ESsT-:(;=\m[H.Zc]AO8R5R3?+`.YH:M8D\?-o!`_-\VgV&mP9i>@1>I_3]A
l1mD1S9Zqt]AFO`\Y<#>,8f>J]A[Zu>Eru!qTUbaJr3VB&&1f1if<$.O9LK@h*i=>Z]ABCFe2*A
m7ff)@3Md`"Zdff[K<^MW%"hi:s$Rd?gb7gd1:rie;YB(W(s>]A$+bUPLpI20Mgj;gc(l\rIa
aX*B15#JO@QY`MU(6u48VQm+?5(T21m_obXa_#]AS16hFB$tuGDD93@:&GPUQANNR@%G([$`a
n>_61N+hB:e'3b]A[@Hn%8=94$";\EVA_)Y/Q'0PM`_PI03s&!_pe+@$WHS:ejT1Ggen5`GEc
cJj;"Hqe>0aD5El6(fe^<l1HMi<X>%!&F7c.t3$b2\d.S&fJ=9^fJEQO46$:`3A!aNaI^$)h
+`CYj5BMM'qb/AIb]AF61^#:bb`Umr7mX%dtg9X4;P;ojkFkM]AB8FFM)GC1\[kJaO5@#;,?lH
#r+LJj`.!-sa(s4dn:#dtHGufD,a++Ck6S,'Si0((B%m_tm<:eIh;X3s[Y.Ct6F/3J1O/R5r
6&-7.Z)@-6PQ^dlWIH%7sZ,#JsrIkN]A&29LU,u,c`p.4G1]A[^jI2Vm,9;DBm\VnDgNglJ[t!
tjP:$F?cki,RXI?Ag4uPk6U670A=E6>b^O]A^kFN[0V-Lo-MR"RbPf-LGjR6)q]A*=6<1Uj^iY
'I.-!?jq8H8p5gT$#BRagb#X<b?u@KnqW7&;=OISG140#CM-$3XMQ"h?I;;qK[8F@%8$5O32
7uqLn!2Y(UPk7St6a5Lm6XoD\PLB1$!+^9<hh5mP+T,]A+@sM9d0OLeI%/7BUKB+UK.^Cn&l3
#1,"S53NT]A3Nr!mr55lOIOSn83&K1`Es!<R&?(Zn1oV[#@CA-+J5'ONJAa4'Nq'S5mcRoe^R
'E"$gFRVcko%J[JU]A26*]AUCZs2J]A"9"/*Dp[bb2`0HaS;N^gan/HIYn84)9&U1@U"!qWhZap
=(W/@38I3gANlWq+N#f6;nU2C:/>2M`agF,;\K11lY:2/0!c"#nUd*?Yp,G*YSJQcm^oj4C$
W7o):l]AeKN)GWh%/>EqjWYQ+[jgLhrI6]AF4,@,29Ie+hhER]A2cq9,?)@8XI>-n<3j</,>)6b
SL.SOWLsER>GoC?=(VLO6bPQsQ7gj+g"Sm>2fuNck_,bDOPCa6J<1Xc,5BI`(pH_,<c>q]A8m
gR71f8_Jt,VOW'KF^h.VAW9VRg,B_oqqs]Ar]A^3$2'jra5#EEeU^g*e41+&k5Ok`\Bj=bar=M
Pic>*JnjK1hq+^G0]A:U";km_I\lnoVCnNQ-MP`LrEo9+lWYHPT6N<,XQhEK;>7a?$i27KRj-
e#;X-\k\Sq;_RRSR*<`g+T1&/+$PKZb^Z_Bk]Am9^qpKGATT#X'8tJ*`_k%,b..,5.%-I!F(/
ee/Skq<&3VJ3b4KCKFoJWV8N8`Pc=52LJ?W[SV_^JZTK_a-*NECGtkK5E-j>F\pV/61`^2AO
Q"A[g%/aoNapN/_=7[+(OP1r1FDRPmV[#fuT?(mrFBcCRuIARfTMmjcI/[M)K^FCV9jem"Mh
B7Q>WRbTQU/H<T5KbQ:/V"kQe\#KC3l+nS6oN=\DS?u3#K@R-2W?-Q&1"3cKa,DLCXPVdX5<
SY_nM05,ZSZ,TirDBjs/Yd&A]AMnJG.auK$7)V1/URB\+cB<2+^$(:ldua[L6??"r+*!F-FP+
:7>TXL$Z0%Nu:0]A5e$<O<$=WYH&^t'hJ-D0q7IaY#j5X>X7k)*PR7&/s?OY5M<X)\o767.PD
c7)uj$C['P+`;pMM[,\EcT?NZ]A&YE=16?3j#WJAeGNKn<IrAgu#c_&.!;tQX-GTY4s8KVk,l
iBT^Qp)F?b7-P<W2fC\lq,p:)L1b9#0<o\?F;OX=6'C2[(,*L9)P6a;V@=X<DB#)R>+!+`#.
;ZA,G(CWPi&H0&/GagF.C;hARdV`q'9I%Ih@hQQ@^:Mt2tD:7.\[E17u#1S/A:]AkGt%B':bT
E`nr)GgNN5RjXm24t0'J=GGg<@1D00SHGrDPt0CeUN)Ef)G^~
]]></IM>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="375" height="85"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="250" width="375" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_02"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_02"/>
<WidgetID widgetID="9ffc182a-e45d-4224-9cae-88c46e4b2884"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_02"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="1" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1238250,1238250,1238250,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[6172200,6858000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_PRE_TAX_PROFIT" columnName="col_pre_tax_incomee"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="0" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("PRE_TAX_PROFIT_MARGIN")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="REP_PRE_TAX_PROFIT" columnName="col_income"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A1">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="A3"/>
</cellSortAttr>
</Expand>
</C>
<C c="1" r="1" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=A1 / A2]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsDefault="true"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" textStyle="1" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="Microsoft YaHei UI" style="1" size="96">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingAfter="4">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<FRFont name="Microsoft YaHei UI" style="1" size="160">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?qZfdTbK+m@;<G[<&E#9s%o?AkI\bc6r!mcK:Xo<6gAaVDo\rk>[bDQ=Ge>k*.ma9K6Ek7a
<=*#ZM9^#ikt2LcfAF\^15eGi&AM\mPBeie>Q%TD`8,Hgb`WfD#16J\A1r`%K_K@U`dZ()JV
`Ll#tIhY>d/?22P.@aV9ER'E$tL%A'e\I6@3hrL@"<51SSfk^.Zs4HSF2/53rIfI+I]A%WYB-
[+o+IZ-A:\Hag;n8WW<[86bgm&*EmpZjo4+,\fOUgL<lG\\J<bjWoQ[_:.,gV2"YQfCQ<Q9U
jZ1RKd7,H(sR`HVe06H0<kmAgr6Erd!f<F>sm:'.!H%#Ou>=m]Au\HZ"8rc>"$4Fc0N4(8OdV
<#]Aq.P40>Ko'Y5"7>%5O`-uXj0:^mmQ#)hl2kfQnnfHadejMj)d`59_J7GR$f*%_5rXXSJ<-
EZO":Q?N<:/;4<N^klb`*2E-.Z*K;ts60(jj?OY"b04kVeWtL,2S!N)!/^;t<64p8UU'eGCN
`1bDFmeTQp@*VN<=TPlCK<6b@GJ2,e<Np86^d7;:JE&:6oOnN?lT4C]AMlBiPlOWHJ4S9Kd^S
)-5HcQ^25m99hE',*RY2Gc*'I,j>IJp\DQBr7g,du3ghrUOP_D?+Rb\s`DXON+#SP$KDnUP<
,:K/=oYi8enX!e*]A\h!#i/2VGG!lC4#Lefi6s`c60p5`cc%Y>]Au_1>L5L2VN8o;9?0MPXE<E
WUq4R*r6Q0(A7\*\Z7l^^?h2t7MTq/7jsNhE-RSp39Tt\;JS#>peP,4%tA)TLQm$^VFf'Kn?
/W"!_F`EI2%@mX"LZE:>K"2M34S&3fAS)=\JHY:t!XnVq)%S_E$s+Q7V'D_B#\`iU*:.CG[D
'</r$3YH?fW`E:mPX"s.kX`CNG[&j`<VJ5]Ad36*&C,&&8?]A4EhN/n#2hWUV_DY;Kc/4J66Um
;mPK??(OE*J$--7J='WN=k=7Xk436Xu`]AB+S:N1W+hbIc)HqY9Kh^n)r2Jsr-dr#o4j@/L*L
g`lV:P8:N63\6njLZ[*86`a.sPlk?tQ^rb!3]AJ'TPB7-)-Pnr!Z!4#DoAdSHEjjmB^-pRJW`
^;"VQ03iW>QL84"AnlRpY@<K+9XECiP,B:7':O3?TE=sg>o7nhfCO`]AX*[d]AMW`q[Ge?\W+>
+Z6r/ZX'O'+LRFXWgc<Y87DcM5g*V:+AbrtGXq&30]A#6gt_T4[U0fidnG]A^f]AQ8O)H@m_AX#
$WNFAB]A^%:_$mcu2"U&;9-Z$ohXYo!]AP?Y8+j3.AIM2$<RGk*Mu)U+E3W4)[M9$2h!:WtBUb
*IN^"dQr=01l7Sh0>B3QI['R;&&^?pI37RRtXY($[q[O[EO64G3:$GP'#9GZ2(U_gLMWeP*5
_iitkbcFoqCMh?!^QKJ7"!3D+GsoIPE/;JStK1sK#.@uDi/8TT:hG>'m<rfL@;]A9I4t9\*jh
K(sM@nM\5aU]A09@2Lks^'^8D/IC`=E52L"ekrjIGBt[U+XC:`0U)ao]A^_5M;e[Ti$VJ>brc:
%1g*EB`n3SkHGdumP)H$rRmg&FdVHHckIChUZCHC;?+O.['j>Y58l4RmB7AF!X1DT6^jPaok
ObsMX.Atg`g,aO+^4D\7@^;_4qe]A@7"a`,Z`oss"[;r"C@qi_=FkEiXe9Io`IF'u^&9b!Leh
sL#6c+sQNKtXB1BH]ALp:?=':@a@T6Ku[5cP<Ye@j8SgY"+:o]ARXr@Sg>I:UeZK55b&i(Xn,V
)eCFPVkBn_9F1cl09U1_3Tmp=d-mWS)6k.VSEbPYIC,!Ue@AT.mq-:#-T-b\W@2TDGQl!_NH
lJ<cT/#-"83I=!ZN`a/Er4;("NO8[_kYlZh;+L7Plop[(-Vd<-oNYhA":JkB9X*T'=9Yo'aM
,dd4"5uT+#A*)Nis<Fl(a^d"QYC_*kB#Y0rgCEkgY71ClXeI2pALhrfpi9>_&1Yij0Z`3\ig
%FZSupm<#miGbf*d6M=<9-R/q-h"BO"YG(aancrRDWfN-K7TMY?Q(r?((osa%N!aNo7:JOZk
aL_P:JB=2XW'Qp=e>F(]A9Im;$"9#`iLiG(E(mT*I/NmZ5i(&Em0"=>-r:8E&e49EJi"["8^?
Q9kGQJ(-r-Eg[O=d:q)NU%Gep/.I'O'^c?+_jnMNG?@0p;GHjFUNn$^AB*a+YgQp=.+Op3&P
(OubYQd2,GR'M%Z([0&ac&C!7aWl`JeNX?rgp$:8;B_&ue*,</GdkWG\0=)sDK)6^3PgSC-B
s\]AgRk`B>\SP&*QqW71oNM&qC54?]A1+l<M7oKnG#X$/Nk@l8#d-k.=#t<M/TD+`priuTPT@f
Y2h,DASAuFKi<7,0K)QbJd(doI`5:m.X[8X^M,e,G^(nr7?-U9.OOf!la%m+hG]AGNMTbM=b\
TL(QHu+,*Ed^/^qP@arkZkeq#6V)CM;qQ?WAeKs.L1\2U)VVPG)A>]A+muh=3%LM.ms?]Ad5XO
Kbm=.iB;BSX=jZ]AI7X2qk%f.d,_%Pk_Z'[J0T?p#K*#oXbM"'-+KiPrS_SF-dL[_C++k]AfG/
/0#(h+-W!5$s$RO_^DA0R,Wpd"A7f?!XBWW8nV&Cc5VI32;RHJT"UGdcVAAa%(o)!buB1;Dc
YDeN\kP0#L9f=%M'.thPiquJ>9oHJF)\C6jNMCQ8L;,X]A$leeq7LnFQXKB`q)O?(Y$uT?7pQ
jWsN%,D$8]Af;267QkGPN3\lq<Yge"@H9mgJkQC0*YWh$LNH+*0<L2"$I1!D_Q>a<XK7^S7Z+
r"*AcjUJW&Q=m![aS$XO'a\TH_0"hM$@^)g4RD7j*C@[i0`i@`<Mt2Gd1X,oGJT[#pBNKOD]A
N2ZO\3Ma8nd"q.hQ$6AD=\06O&GV`kCb]A_1ORT0gPp[ba[E;D*ODl)3"<@Srmc(J`X4'T;qp
M?4rm7tf=a1XK9@cVK"#B>^Tec^*tiBJ$d`Nh,K>J"CBoN!fk30Ng%L'0HCNa<e5OP^$`*EX
(d11;<SeFo8$TTGElD-ZucmQ.adV^YmQ1@;0$<g5H7D1Rg2)6G3?A0&r1Uig=7fT(:9j*Ro(
)!^01<Md)Kq;s9F?]A3::%=0iCf3DnVF&o3ichsqrmm#7I/A1!XkL7ALS'-l><H1^=GfH>q,!
"Y-VQ"&;HmX9[d6&h"dT`![@-J`!]A_('4_/23TiC;iP?#FZEjm>gYje3D(>?l@-"nA(=OLqm
:s#<'J&0ItaOnp,9pGBhfTBj&-gFT5cB'pLabE!9B'>VZY]A7ZdD9lhdW/5rT8L]ASJT2<8-3G
@HH#u:\YEiPimUH?KljW+'Dd9/.370OIs*c&n>s:A&AX?k$:UBgU)'jc6[k=i/*M9*,3TUX4
il@Utha;>K`Se/5k8D+6)jE&bZ$#MI<kH5p6Ip^s3p)s/Z"Hf>N6Sm'Dp[F]A@Z>UgCca%4M&
$_f,sX?*N2Reeg71>$hZ2AYaQ'kDZjp$MTK\"_qC_Ee4pn,7F@@H2Cs&n2$Xu6b.,+Wd;Fof
]Auo$hOTG@[NjHJkdW8i$Uo52f.D8JTFq;;Zp>MCG*;HI+murbh*l[9o_+'HrHUO'0`gajA64
%`#SfeO9#`0?^CMs:mR;mB7ck3:,2Td.Fedba#b/Zbh1.@h*<5sCFB;sXD0E/>PrbP?.!H_2
fXJ8s]AP#Ob;+<m+O]Adrhomo@.g:&G.n3kWX?q;0?CK$$jb.VZ/^aL$%UM<`63!]A^YO9n7A`Q
"4(#4Oc[]AAYB/E6<ZXc:Z[7GWV"HMB/j%f9PB]AH;2B<a\bCp-,.mSl-$]AO2;r0`W&Du_?%!I
gP`L6CY!(Y$aH,BmQ4/j!(-?*K\s;8'C:8VUP[rRIk[CG<s2reAq`82N'$[6<q??GZ.f+(eO
</6\T9q.1o"hgrlsGpqCYocsLWQs3hD<:3iS(>Nr`!u62DbmSs7H4"it'LC9*=Q,bCqUToOJ
nkU/g1(^p6(G$AXQO+D?b1+HIT!p:5>_3'NK(f>K@V']A@)=Gl/;YO<qVsTa\(E-\.A9riO_K
\)N%A,7)X!2Z5K4aH,a5Dq['8Sr(Bfe!Sb]AOd60Y`f\aoOKWl^NJ32*6YH?+nrdh;T/;gERP
S(O/c/n>:MlSpAc+YGO"W</GA+T%eA,oN8R;VN(I_G-?)U[RquVa5_P2kV3Ie'57Tibp7S#3
!C^j\3W%IP`V\"IX"<+bt&\>=mRU4khT0]A@"6q/A(kc;mk1(0)p`[4;"P&o#><d3?Xd/q`0X
EZ%8ZtVZ`8R<ECj,ElSr9tm[O*Y]A;VIT+_*$.+.Qm^Q*o2ec&hPg#LW?)Q?C>$_i-o)bs'&4
8Ef6t#46)^YlBu5G"n("bJ%.=-?"Qdq*T2^B^`1(:0a8mZ0:k4,*VDXie*heshN`GLgn:H*u
0Vj!.1aVEu]A=7NTGUIf%*\At2A$dqp[>sfk,*\0c=$(khdpHZ:4edWb4"Yd]Ap)upPY%n_AOh
=4SSb2QG[nt=R@6$b.g2n&Q)qlhSP!oFe'9-4*<KPhnf9\;/iSN!`rl7dIQR4U51KqMtW=+B
N9FY+K_6,305f(hT<tm+(Y>/$8>.5?pdK;fd-PcOM%=*kk_4r8aQ@j#7`CnL@K7>nUJ=i.`&
E,uG]AS0ph>5h&.G,9kRprf49O3ncW=T3+>8:j+,73mg:4?!>0Wr8rM%5:V'Hf9F/cds7R5KT
]Aoe*fP*c,k[F/V_tRB]As.4J>PqCp1^_X]AjFQH8*=e_2R\%D]Apqi2D^GHpFMj2Xk0qhASANZ3
X!1i\nb%I5*tfERo*tPbiU^:c-8,5M9>F;U_:`)u$%FK(NJ89%RJec`@s>TOijZg<rq5[Sp8
Na!OIiR9#EJf<:&ShkU)KE$*BYP5T,6a4+sNcJN!;Gu%LJql45(RXo&Bl<EnW0m0HC1e[,B>
:=F;^8B`snNVaF'Ffi8Q&mL<7-6BYZ;hfc!]AhK[ehd)I6^<OpY/]AcG.'&K+SgPmKQbZsk;3\
DuK7$5IUZZ<G2%%OpEq;MMb5ahr,9?^4M[[;i6?&?R)PXA/FCZ.N5'1lcAo5*puK?k7L"'[M
R$:i[7sg`N3o;VWAFNq&Dql1SsD%W3$hAY]A^??#U5%?>39`TKc<hk@hd)ph0VD9Y,W(^"I$1
j!E9Jo(CfQWD.m(YFc/g1ALRSJ3oH^^[ZW.+Fh6s%r0;Wlm-4p#u,O:,n>m[)FaQ.'%iNBcA
['=&QOrD(..U8`?0R*Nt9RIPPSX+Mipl[^6VY4`UEMf4gV\@@!^Xk;=oY'A6t0;LG9Yn9f2]A
dmq>sqY5bMgj?29lq-M0M8l_NqB+plRRN2U$_h'kj)72u+g\`!SN3a?te;L'@i\TST*"`dB$
(GT+&`*@1(!rFO%j%nf?Y8,[mqtBZgj5,s3(/_bEP]A0AnTo[p01kkRDt^IUnA*ll5an*pdHY
flnplIA\lfd6m/Q01@2JAc5H3_!LNG(/5"-uCQ6f[p>`Z(o\g.([?H9fqm(gt([/uo+/#@"\
%RgO)!F^]A<C]ALJ9mg?jelUDnje*?$FqXp8YJ4r_0Y`6n?Hod`f?a8kLrNL]A8r\H=[ON]A8`5o
Sk4&&&oglG&>rV<p;';!3*XYh6u`XZ5/[\31>pAsK6clf%MC.6T;(7Wpsi$nqS]AnhL,g6>HC
QpKdu,V1eR4_LALMdpun1k%X33rcCHh^[,^QA^h1pCWn`cW&,KO&\^F:*hC^#TJ,_0(AQ4s+
q3>t+.I@<./eQj$$/?3hAdf1?o/rN[94o\*jP5_HUUV_iSa"dI`Tk^RkCet&Er_qj2TiD8'4
l#EN4%MT@,6`IQ9Tue-Zmj6br$2n4%t^Jq]Ar;5Y&9M=*HBDN7H/o=_5e<Ga/FR^W]A8[5==79
DE2ID\pnUOp^uMh%oAc(O4R*5]A>jUQ*rU2m6W+ddD)%,I7Hb=-9hOR-0+)[%.s%RIY#O8S/F
NC1Kl<IZm<@bhj['ja4fi_YRVnth_@g@a^m/3Br6r*SHqGHTF[E"p4)#K@Vk;i"lla*35>uC
<ZoO5+9GqPV.]A]A&jp#k./b5+]A]A&&20f/W/[T^ljPFa/$RY9",ecK7u/0*99HmIF7deeIJaA>
4PMqC\ejH$$?el.eimJ??**dqIU_N*sl`MUXqHFR"JBal8q_>I6>kdfIM_S>V(,&pb\d]ALu5
^r-FBcR0fPS8K)oo6YK>VWXLi()p8Lh_rA8Jqh$P1glIq6GOG=ukgi@4?rM2ao#4.ZnQ:-3O
2f^b01u,3ip7ZuTYa6nf]AjS["1P$T]A$!lT!Xna!sgn?4GdQ>^)R02]AqcL&#81[ANQQD<oGig
cr*f>pJ'0o)1eDE5@SUgCI1"(EGL59<TX8f4_)<s*jc?D_3N'=^$poLXgYNcE2Nj4l3^RX9-
17TU(s*G6#2Zf#^Rpu;kG6T`at2YK6q%!dS1SK;hR%I2m2PgZ\UnSsgh'YmH5UoVMd"40/h^
.*HN8@Qa@a4;a3RsT%Q,ht$<\!.fE=t;ka>m]A"pKu.PPouMBMXh8F%5i>%9o9r\oFYEL^k4#
?Bn)M!nh<?;nkI0"<+2#:rN*P?J++E,cH[-WY*gS.sjEB_WA`]AOSF;Ejh.NMq%3!'P=h`[)s
FtD;0KEhVPn"s,+WKT3_j@&B3-cbppO2dG?c*[0]ARi<Cnem(#m8s6KVM93\3478X!CZ\K>Ys
\uG9FsXU5"P5^/"Do(B>MJlF5Ic_C-imtP@eleGFE>@J"3,miCPNTUaq4lD3^s>LB:g)0=`>
S#HR[ue2u>M)VTQ5G12&$fo^K6Aet_p^U3[.a_gTa@E9`ApuC_KKN,</eO03`]ARu?NdU$@bN
l)*Dn)VOdkUZVQn;FYp%WqujeQEoRRIATJY@X!GMis(O^I&]AEk6f`JU9+J#k?Y9EF]A(-_k#d
A=f.)*3I9W:8RiHLbHt>3"PQ@jA)?TI)I8GX70o2?3Nd_\[/o?Sn2I$u9jjc<]A&1SR'd8oM$
Xoob;oWPH0cA!1JXE9b!o/de_.[TTck)IXT4M/ch`>_n>hLteqgN,:/i1ulJp6[p"$hi[GX5
hQO[FHm@12*\5$aUD+[]AnFu$g"+@VshcQ4Z0dPe(!IBQBcPn8QGA&h6_VG5Dg.B&[m8jD(D'
([3S2$H7F@TOE@5pIQ8r>FRQg?[R^;s&9^cc2:hX;[#E2H;"E_6=B>+&:HTa=(5$6kO2H1aJ
Dqsn">qc%Mg\qOOCL(oM1/br'.s,Kf$/Ps/?rarUPd/pNPXPBQ%UI;(1n.$D/M/LYZe*fj,B
9OObGusAJ[Rl5YlU]A#\BEk/&Y,&lK+;,V=`?QFXT#8&@hInM,I9(]A\G<".W4L"Jp:c/ieMf8
lNdr_Xh*<CJ+Sd'lgH8SqUl[Fg9s-5oHJa%9dA_>5g?iP/+(6BP=d.+%SpF<G-F%`J[f;$'8
qk*4TD#`@I'9A1i)D>4dPDKC_4d#UM]A</(A6gEQ9KD,1$NGiD%Gj_SMO51<D,U;bNoe::=*+
%=3eg=Ok6oRrVE`Q:Y0_i+;m*Q(W-&b9Y,D>@"IM,o+r8N;SI!uJ'HUYk?->>c%)Gr&aO39e
$PJlHHbqraY0gVXoP@iQF[$_JrkVNP!p"GKEQS!gFft`VuTHUML>/NokRDc-Fl2_5u$4:2N5
1R!q;n35IAa[8S(016="r!AQfmpXQI\s*'Au'35a5lL%f7/p5dAkHBW8QJ`1Hfi2r#eGr`a@
oYY9]Ae0[]Ao]Ah.NND.\/H(ffNuIH>MKUT"Hk'TJ$#NYiufmIbtpjSsdJ3-=fIs!?ap7fP($oe
udOP5*t8jEsAMhb3HTP&bJldcKfn#NF?mdqgU5jU-5q@?1AmRH&M:8^D^Dp\1VS^5P[PrD/\
2rS_;T*:hIB*s2D=OR]A=k@4E)'n(p$a-dN'Gqlm_k1-ahXg+[s@eQ45*`Mebjp2s>K(A:P_%
F4u`o>QF9SR4<^*JfOeDH^)GhiAQpg\AJ6;M7J@KLK!r79G43=G0+FKLK!r79G43q#>^=9gG
X7h&LTE!91]A*n9M'::$Um9f9SWB='+,r?<Or:Zj;P^#`>8\MP(64TEpFJ#`>8\MP(64TEpFJ
#l_TV?$"chB/QSo.,4O?iXacOeL"Atr#Y~
]]></IM>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="182" height="65"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="238" y="170" width="182" height="65"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_01"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_01"/>
<WidgetID widgetID="9ffc182a-e45d-4224-9cae-88c46e4b2884"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_01"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="2" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="1" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1238250,1238250,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[10477500,6819900,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_EFFECTIVE_TAX" columnName="col_curr_tax_payable"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="0" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("EFFECTIVE_TAX_RATE")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="REP_EFFECTIVE_TAX" columnName="col_pre_tax_income"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A1">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="A2"/>
</cellSortAttr>
</Expand>
</C>
<C c="1" r="1" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=A1 / A2]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsDefault="true"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand>
<cellSortAttr/>
</Expand>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="Microsoft JhengHei UI" style="1" size="96">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingAfter="4">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="160">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?i/uP'Pg&D5O0Z>@s<r)cJ8bZHUBH>g\j/;\Ml(1UkNN>``306,f]AiB/2@=;NT,Lbg9UX&:
qu/8JuLk7ARqW7$.V'f]A33_k'<Qi]A]AZqW]A]AZrj]ARS!_*"IAaqrYVqhfW;Xp\Xj*%IC<JmE]AQ
*1c3cFT)-uC6Y"Yap&"XT<52,OQVV=/fM+F+HL,GLEgE]A8T^/!I\G")-e>479^Se@!e@l[TS
36L-+gH+3Z#A7GJ$WTs`f6PW^]A1I-JKO8q*^+J_rVRqCr`.F.R.CRN?oMs-gi7(EGQ7/6*p-
`#'@26t'?M/4F0fnlj.<r#'=Q>L/QT/)9Z'e`O:OSc+[!r\]AE5%q?%`2R9rZOe!:I%DXO,>@
7RDioj5D:8.-)>R+5S+=5$E;K9sBAlp"/1!:>kI*.ss8qgX,fZ`B"Hf6ODBY?#0F%eBS+N,!
6d?UL=;pV!fC*5<W79mW>Z*q).2N2)NmD>q*C%E$=S^8PhJKCs?g%!&Q1LB*T>\@LPEubnKm
dQ*+0:O-@//J==<0H5sV;T8XfGcPYgh"?]AsK0&a!#hag=]AZt'nM"<GQlCPkSkW4X=*UPgf=a
!8\;Pt6>,#2L(pkC/T#JFA[.oCe)W_bS?;?%ffZY?,Ft#-dQ;$Q1URp+.mpcDT;tE&?TmUnQ
8H7sEBC#j[->N+6WcdW_Kor-2PU.,$7*-b:?&CXc2iZ>KA2[l(Q);6=7+j**!Jq_4Jl[aIsW
n0:_Jbqf#[h+$';60VckpL7Qq-K"2qR,!>te9Z?E1&l"3YRBgJ!Z$mtH9%QC.k9[r$SB]A>#T
HI`UDtQ'2K_[k>qIGq#m0X<K`<#t5%QUh)(7U<l/-gFgh1F[.>]AU^*SV5sOS0j?Idts^+4ee
`o`;@9[uSl3eN]AF%\s/"!#8n,4Z=J<L;GW8E[k56(gf&SG2)%AcBJ3LD<MHPpq\R%7-C]AS^r
\6Q+GQ9XUdhoHPr<[DeCD!?X$:&SUTp=iaR"0V9`.^OgUa9:WrlMQ8l6!X_A>CPf17V[7&hf
L8`P'#'L]ASlZasYkc:S+7gI4)F#%V2.UIebM3mefABT/^Q9.j!;tSrArq39Wqo<_lo(GL]Amc
]A)<p3Isr(RPBuX>3c>:p\gTi`Z9-\Mn@Op"JM+6G4NlHeY]AXurJ7$r;q;oLgrV^Q#=`:?Qi0
QCLfF_"<o#(aZ_On67UcCQ+F0-6aFIY9dl3ndfk]A]AhfrZ$;qHeRlVD&O</4u\0JG'IZt\JJe
pbI)&e@0.<d:CK"\P+=P%D)T.d4Pn&9@rNG8PAu"FFnLleJ0_;e<1V.HE7@u_U7EI>IqC,]A$
gksOPTkYKZ=T]A@0j2Yu<mHO=:pOs7)=)i'*$`$q2Xu0,9BN%p,6<dIB(bk5Y?E`9nY8r%JV=
0s_CL=H'le>L*b!FQ+Q"i-eDNcHOn4`q`1`PpN$+,eUSB4%='9u;`kD>u_<.7jVAI1?-_pts
a%"P%RBc]ACi<3H[a)l`m'q3q!eDZOTMfq3d%4@$fVZ4S"#ujK(O$k4qeVl^#HY(uXn_D;SeV
!^(D6T^0J\=L3+.fZ3W<Y.#rQ2cM(iu@m,8CA^fKSi:$%G9L#hC;%R=f&C8CnbL4*W++9d":
e\\r<=nX_J@qXg$.7^_f^QK0':^k>!LD^MTkk?'.c5sJqsPr$>e?$SFWE9%22)<kOF9<LXRW
:M[1l(PC,DDa@@G;>V3fZ%ZX]AqHa')-tF+"CfZsYu1%LD3%G(OKS,0@T%J4>RWo1aFF4AZGV
idN9QUhVdhVIalX&_a<gA(rW5qZ-;23JS#EbNGuEH\[Hk(a`8E@*&-&]ANT^84c.q>EUr%&UG
MDbh+#@`[7>Hbc0s*<K(#Lg5t7Ke;9bR/Lrb7K.@cW7VMOm(Wr<+aokrcXV@bF#9A_0^s);S
ThfYP=8dI[5co4C#-sAaYeQ>]A*Sl9b6qW"^Df[o@Z0hp,M,.:Z0qraP-KLS/Hj^CUZtS]A/ZN
keBo1HoL>/,g&QY=q%5M"Xb=7g$O$A^ci>;a6+i!OW&:S3mmNYA,n`(eop<UU_\7As"f/6n8
o\IR#d$]A/#BrQ8]Akf^(,_]A2]Aq\#uVN1D9X7(R"?+%/F+Z>7A(VaeJV"&R7]AFB"-235/59(/g
S\'dA?#=q*k[$)2_t`pXPO-.RT\Gf9el,1qW"h)?;kH^SiOet\GcJqW9Zqp1OrL@f(jFE_o)
fc6$d&qE6+eQ*%@200LipaYUtL*GKm7%W^RAMiE-oNU%,*eW8iM6M\i9K4!DHP3bBW,fO>WS
f4<@WgbDMu<?1<X^l$5bXRV?QFS&Q#QO[!QA]A4J<,86_E=;cVLR%]AVA`m-2@3.q12(iI(cNt
C_Q+[#Gd.qSbT,[p*kO6`^HS45c.Ys0jPpK?MCTnhNT&5fL)IA^#04AiW'ClDH*46D'nm/-5
37MObVroFf^K*A741eRoeGD]AhsH2S$gt4O]Ai=Z46Tg]AiEOPK-eVYHJnC;r\@g4Qt4T/o5q!=
b]AX1t"VhFZZ7$smE*-560bHAk%=A[?%q>hOcU=+h2?FT6StcX\eZq`UUc*q2m(+d=i#MtC0b
!0Bog&L.pchf/k$mEXQ/SQ`,X`99RF_P-`+!I_!Le_Dg_FhN&n-!d'4)qlHb<B^o+YB;p#-e
MaH!W9BeSR)lj7(rS9T]A*feTIbIB&rK0I_l)MPr?TLnP0hi!I27e0:I!9E[=,5S4sTbFMVHJ
V$#HkfQ0Z/,[ZdmrlcU6[fH6S"Ob>b@q2+e`q8(AC/*?tbYE*n4$Z$'kP$J-RFdF`<MHu.e=
YWnblo<Nk4MnVKOe3N>rXEBCNP@/q]Apg%1;Us)S(*U1Ro6.Pu<h(nt[&;p?@??e2FCr>?Qsc
"j>LV&cRSSL[f(Gj*b[7?@H0<@'LSEn@GIM-MX?]ArdccRT;cHLPC<K0FpXR"5seP9<a-U*!_
_pPN$C[P(Z#K=gaR/Pu<jYN2u&%M=t0a9,;'c=B2.)\GX!6L)6*lA]A\BBSF?_u,S:c5PN-r=
_[c6;Fcil0ZR+AQ)Zk-sE://eiaAVA*K'?Re+skKDri+Q#$!/,5R=/P[$(E%p!H;:UgL[^K'
&j@qoe]AQfC2k\e`A,:o5m"ln8%&;"c$q\\4"3%Ik3$J%U6#Nh'V&An^EDU^0*Q'ZGd"X?#PH
/B+60,n')G.5L>V"DiIi+*X(+N5/4"T7DBo@j_A'o;Y(QH(?d"X[_JFQ;(f,q(f5i,6`kl?U
#I#UZtY*TI([^)f).AssH``\qD7d#52S-l(]AH!qFX'#%CVa7+Hfl\LJnL'B`l8L3O(.qX/&^
h`5.<oUP1M=gp`.7cM:r#XKI_]A.BdbO4=i]A6+ZZ4;aQ*!&@[l6nr#cgh0b8s7d^5Ij*4H+gj
XEkcE]A^V?umiM1T;e%HR8LMql*gb6uW_X?A1IJBKoAQbNLm-/I=NRQTR0mF_2fPRA?DX:&@/
@>peXf:qX^n3o^R/-2iEo/]AJdFopc.37i.n5\C0D**OiK<'@cc.ig[c8W,a\.D"[m+WZW;qA
3CJ=Z^?\B&!HNf7[%u/S<Ig,pLqN:18OBfVs6399R7e3M#1?e*t>'!>/qZ6C=(IYe#*UY7:C
#S#_[mXGm0C[V-^tad*5\DSH,b-m3:/a#.Sd,n2$oe-kmuY2+9_KU.;&!,Q%.[,`r>6/HO`)
e+ZCYX?tY9nKsfjj?5>B^H]A=+\DoqAe+9)7LE]Ao\Wlk#>hSW0fII]AF.X2aI0jFtB@]A6BL8bm
LWF"ONFYT*cI[_JJQFSi3/JD<+NQ3q,CJbf*8pl?63_H=?O0YEWAAeD/<DbZ*WrlK>1id&.b
R[1L`r0\Wr1$2=BC\ToA?rEI&=OOZ-9'@gs<G"999TfqXDLrPf&2au-'Q-Xa]AIS'B5h6q7`*
Y"(<=>j%"QZ=ja<3TflB4j9*"jPSAEZ"T:8\8;$N-)G*'/DD`G?1Qc/%B'j2@Z(-G+r-JBaE
[7ZBi(U\JhVRB\P!th8PipP.c;-gA</N@T]AqII:a:>l]A`Iu4PWYO]A`m).5[btYHG1@*q]AuLQ
pFX1bm1JLWHU/O$#IG81L%&CI'NKso4-i4_fnVdgX#t7)km#bGft,`QG=>U):<jAP]AY(a#3>
!jt7-o3Geqs@D3acluf)'?#!QjI6S5DNs\r2"nBu0u5`:)7*p1sBX%OVJL4!G+OB(MJo3!g`
GHkqt[\.=sQ1DWDo/EVb-FGQ3bOl_d\;O[AU:(cg^]Au-d`V>6Z)S<<J;G7i*.1!uEa[5(Bmj
]A6`[0"P0ig5KTldq!M%l&tsHqn_:"D]A3Q[iP-k1`5`O4X7[)X1j_R8?T,E3N8>0;PAIRV_:h
ktKuGu3m16p+9ctT*M*(9[GE>P`+C':oGk,1YKCV)a\E)-hmDK3K!\WOtX;G82rJ*B^h3TOn
&#RQbo?p\7DZ)NGEkKTq$FNk'.D^Dfqtbdu3*Vog%r;mSrSu*h(FZop-+#cD/OSYinTN[eqh
7c`Gs2&qjZbCD(3/SAnZCE&1]AHJdVVIod&2LDU)f5sudJ5E3B;O]ANc*,P:]A5b;TQ5/T)-'a9
N$.F=qS-(kT9iW[]A:d\l;F`9Gn-%9/XYd^W3;FFe9Zam<X=XFsDaMt%_J,LO$LdsucNDP`[T
C9jO-BIIX`7"hU!AZ!t6tK2f$FW"%X\nr:T3hs@cAL)7isOW/O!E@fnj?E!Bu@a*q,Ie]A=e#
EA-L)fT@f1H>l=.I*IfnH<7)&TS97lE_j\J2EVG@n.IFgEb%>17:l3"P.i05te63q1GZo,]Af
)EF@?BjEkE4u;!-PiAX4lCp5#)<7dS-VO@07&c<t1g6IYCu$>;Q5:p6@3Ll2d@e4[XS\j6`/
@,#]AOA!'[2lr]A=nW4+da/(Y=\Zjnc()1i>62GJ4K\#*#OUfq"E#f2AH>&]A'GB=Ho,R[*gYtq
c<(6nfF9W.&"`6dJCN9_4WDr<;28((&B*7kVd`S#Fgs40W??NOOmP_?S\$;Q;0>fLo/G#LbP
c0LS0.N7lC?r6B-^[+i=3[;0?)OcfVeI"?fYqsgd[-/O^5Gec&BA_s*S?&+#"UjkW\?t`pE2
6$"<NDr;AFfr%U9%:O[j1Yp'P8H;>Jscb>_8uPRd_/Y?0]AHQ<+?UEKJm<S-OQqkASS-hEW+[
aPN?!SM*)`@%ANjhlTd5rS7+*&j#[GZ/1Y&b^QZ&QZ(X!$*t&0Pbq8>$fZZ=9%G!$M93.i53
<)7BsQtA(gt)ap@46]A0K%PL5&=S^0PXWA>It9^XZj,I?S?CC#A<DtnoKP'dr<bB>n8;7]Ap+4
70g3_i$56nZ=C2e!j-A<FLbP%VnB(^uNUO#T1!'+GY&[?2pBKGo>DHrHXRo]AgE,ZE<bD/3dY
7_]An^Sj(j92QD0r'L<Y,IHCIOW1>X8Y3Wc]AQdIIl`XaBc^>_h5/2\Mn/@`-7Ve`4SZN"Rp'(
#XS/k]AF,*&sr3F,-*\W_(]AD6So:,oY-AZ(Y,sN;VH?_6qeq_RpW)S#)5&9+Tt(Va!3/q:euk
4q7@dX`fX%hq2Zq!s%b(4t6R#]AU1g)@O(+'N9)p!jD^pZV+,r?$GFGd2TLr1AtQPqXHGuX%M
WZXRucCLUPsiRF$J9mkM*@A)n!0NGg7R'N6L,.N?=^pgYUa*\Xt#51rrGK;4A9(2S-Z&-icG
JQVUKS;t@ZCTO"V:TpPf.E!*FqYr31qM@un%ml;?q_#fs9A[j]A:Ar5Te30b%U34^=GY\DF`*
b,[:.=a(#fnD&qrmGL`p>,kga@r^p4Wj#$\"C1B5uu\56J3JMD(Yi>,%b_O[[U]AJ4)Epr4>8
XXZK)Jg_+%(W]A\O7_Fr4chT2%N9IrODPn%Uo'qag2CQOOVej+Xh'PbQZR,bV.k0L[sg)DC.1
!n#m`'UJRGQL@@RZ:AE'MR+YWZ72cqNggYoa.Iak_;`AQG,b/ibAdMNU>p(TCudmL6"CLHCW
ME3EJ5MHhX=q!Ci$,og4GAnr,&?+%eFtlqJJ/^]A]AT'cFkMt^!!UB5+5)VX=VcM#IM@)Y9VpO
tl@fDsag#p.Lq.+p+Xei*5P"`=ljKUp:kGIZ^R$]AO.5WB9O3FTOk4gYT8=CMpKJ5q[mmD!ZY
c@E$A&*_39SjQ8Amef;m&0U[3/PV73OI\QCMA=K1u!<rcFi:pO.N`5>2ZGtAe+Y5S&72fJS\
]Aa`i&+hYW7h?CB19qik(%ZaDBnQFRrZc`FoPC/+.9:C3/QR>PR"no*(S1rbZS'fV#JW@sbp<
Bq`j=q)FOoZ9J[1A,I3?.>bgF"?I7?Q]A)aU0tFs;re\$[H4*,!<i.MPE]AS2=hA"mRjCef[AW
b&H\iQ*pEfbi)HTVboGLitfC7j(Ib,334S;5,Z<X/k4Uh36nYU=k'*+!_P>Si<h2@b2M,G`_
^dYb`WJ8-0GR^,/FmQ$LM]AahpP<qaR,cdjpDE"B?oEaf6F3e;N3j-JCPegtt(FVq@!mf%rIY
at]A5/(m&e?N'E.]AkJJI:Q*HpGNISt=3mX70u.P.^WVQA[.n4&S8ZR\EL[ETl'C'`oO$iO8hM
4]AjYUjmCI-#cVD$(,,TJ5hD?_>;n8MnX,]A_*(\@&qADR(8Rp4,7L(>U'!4RW#8,a\*DF$:3/
:39M#Eo,E`><)C(Ir7I]AHMh$Hd`,.BEf"i#/C4mB@tkXo]Akm(B<ZFdRDT19HQTaO"R>t6lTY
gFZ0X#5flq_I%opbt"r#*M%KN2uU_0Aj/6)`Jq7XZ[*]AslY0l#Hj!8jV47gfRHi-`VL'N*7\
gDl0e;M3snUbW9o/G?QhGC#ZS`TWgcori%HQg;@.Agn5SZ^!WW/mnB_Oe)Xi%F=V=/D==nEA
<aP0^ZAH?;Pe7T(R+5:)0q1bX9bp.@C.SGF:nTa9'euMg)\seYZHV;8U?IHOX-)_HNV;4,Km
EZ[Tg83:?ZE!Hf\@7MR?t=:KaNR?SDB@2Se&Q-JTM.73K]A[MQ4CQEl75/B@:TW*A>8id%Fuu
)fVQR\$sF1*ldaDeaF-f;UVEoKU0N`ZsGNlg/aU;/krJiMt_]A,,C[4uSoY/2"(#]AN]A@Fr.-+
1^a1#^;;=uY/aq2g'G"mR,el^\&tk&[fQn-B7KqpS)\Xb%.u=BrZo%#AQ5pAOjeaQgg63AHp
?fLZ:m>.;rOg^qG*JcY'<FOn?`S;g_]AE-Uq0l05[k.]A_u%.=]Aar)7/"Clrr_$hR$+>iURqro
QSm=O_/>62<!C4&0/$\PULuK'4E_i6Ap-(A8h1jYHK@#SM+Z!ZGs,^]As?phgcJmTp!p_$Uua
'W;Gi,NAC6Rk97X9jDN&ag*f(0e]A2V[)^m??1+]Ao&oYp!EnlUs0)&onT$CKPtjc#>E$K%o1n
i/gj"d.1Jqs+A.ZhDuQ,=V&^D^VlY(Dp%;o^Zn(F3U9UIr,#H!$cBrOWf]AF(b:3umj*+SS(R
]Ac*!TU?2IHY,7'<D2F>f9o=\8IMRHeU.FV`?-P8tH>;BB,kC,M`d&-$-"!rJ.ak"72Qlj"Vh
AHGThbcsq795<X1\i02;n#FQ0&A-JAi57T.S"=2:r9g2+!:n8Eq!e$L,SMu\\XZD_0<L`hm6
kb*t2%e\$<r7FrC#9I1?UMM2=*dOgEP[=t7FNGEDG,Q/m(rFG7h=,)>upU1Z/[8!4CSb2<)9
k1VVa#4fhe"`_3gRjr-1Qr>Q7Nh\^4;,oWG92&n23:ZUujGJE`;i!_@f1nQ''929#L\d]AC1U
URkDJc9B-Q8&BS!VU`9:o0]AN*3AOD1Xgek)8sO4.W'!t9^2U1JC8D`jT,s7LnpkA,<qkE>NE
?W5;KpIke=^H>X;!AHZLh*M@H#_L^)$+LDc[S$'.b^o7jV)05A0*OJU<'2*P?3=C!qO:+Q!Y
I40boYn]A4`!"R+tq!Q/T6B=R+fGGJltqk[>bYElZ`VP.:Y[eAt>n2\=4[k4e\/d:sTZ`h[?5
^8\YlGqm?.>pl'"+I\q6tGl^?@]AU/r,ftRjeI#LN#_rL@AhS07bP8^D6o-M@)F7jbU-;&CsY
.PW:n&]APXU/Pn14-;`l8[2Fltl(W-2oiT5fpg[/0mf^+V.N8^-453+aC0!VaRU.je!)jfA:2
!%jqg\:V51I-DtBI_Yb=P4fhq/uRbBFZPDV\R1))Tem45RW2-`_GW\4e?P:FK"R;ore+6WCV
nO"==jEs/8de+$/B":n!Ytd]A3nr.#"AdKRM&fSk<f+8Md<!Od_dSGUGHLl/B.4W:A7\i.Pa`
hmd[9X9:)+]A^1e!6r-)M0)ccWO+V:DU<8i./Zu4Dq,IBp_J"M-"+,i<i?_K;Z0lkpjO7Kc<I
fjh@l%>sWZ3,%VXV`ek#Jo*UYLERObTe@_X2b@'1H![c$T#EE4'NUAa-UrY26OQjG:bX.G3$
8P;La/1HPnKsA\<tgnM4FjbBOmXj(5l^Qglh;`ln/W4he(0Aa+[B=fNIhg@NQq%?5Fh9?1Dl
rUof7YD7J80-.J0Qf0]A)L<FNR0#M81%%#p.>_^F@)(rg<\."__1Aj@gX)da.4%?=Pq<DmY-c
*RK*5?IQ^An~
]]></IM>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="182" height="65"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="170" width="182" height="65"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_10"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_10"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_09_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="375" height="85"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="250" width="375" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_09"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_09"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_08_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="375" height="85"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="350" width="375" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_08"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_08"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_07_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="375" height="85"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="450" width="375" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_07"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_07"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_06_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="182" height="65"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="238" y="170" width="182" height="65"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_06"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_06"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_05_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="182" height="65"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="170" width="182" height="65"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_05"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_05"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_04_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="460" height="335"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1400" y="185" width="460" height="335"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_04"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_04"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_03_c"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="460" height="335"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="925" y="185" width="460" height="335"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_03"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_03"/>
<WidgetID widgetID="8df43348-ad2c-4108-bb4b-80c843eac899"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="report0"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="微軟正黑體" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="460" height="335"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="450" y="185" width="460" height="335"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_02"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_02"/>
<WidgetID widgetID="9a1ede5c-2778-41e3-9eac-0bde14a219c6"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_02"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1440" height="365"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="435" y="170" width="1440" height="365"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_01"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report5" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_01"/>
<WidgetID widgetID="100bd49d-ebd1-4069-9bf9-95a23c90e9ae"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG01"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="11" bottom="11" right="11"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1860" height="110"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="30" width="1860" height="110"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG_00"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Microsoft JhengHei" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_00"/>
<WidgetID widgetID="9a1ede5c-2778-41e3-9eac-0bde14a219c6"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_0"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="11" bottom="11" right="11"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="Arial" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList/>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
<FollowingTheme background="true"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
<MobileFormCollapsedStyle class="com.fr.form.ui.mobile.MobileFormCollapsedStyle">
<collapseButton showButton="true" foldedHint="" unfoldedHint="" defaultState="0">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
</collapseButton>
<collapsedWork value="false"/>
<lineAttr number="1"/>
</MobileFormCollapsedStyle>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1860" height="912"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="155" width="1860" height="912"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="REP_BG_01"/>
<Widget widgetName="REP_01"/>
<Widget widgetName="P_CATEGORY2"/>
<Widget widgetName="P_CATEGORY1"/>
<Widget widgetName="P_CATEGORY3"/>
<Widget widgetName="BTN_TYPE"/>
<Widget widgetName="BTN_RETURN02"/>
<Widget widgetName="BTN_RETURN03"/>
<Widget widgetName="BTN_RETURN01"/>
<Widget widgetName="P_COUNTRY_"/>
<Widget widgetName="P_COUNTRY"/>
<Widget widgetName="P_COMPANY"/>
<Widget widgetName="LABEL_Country"/>
<Widget widgetName="LABEL_ENTITY_NAME"/>
<Widget widgetName="BTN_SUBMIT"/>
<Widget widgetName="REP_04"/>
<Widget widgetName="P_PERIOD__"/>
<Widget widgetName="P_COMPANY_"/>
<Widget widgetName="LABEL_TITLE"/>
<Widget widgetName="REP_BG_02"/>
<Widget widgetName="LABEL_PERIOD"/>
<Widget widgetName="REP_BG_00"/>
<Widget widgetName="CHT_03"/>
<Widget widgetName="CHT_01"/>
<Widget widgetName="LABEL_TITLE1"/>
<Widget widgetName="REP_02"/>
<Widget widgetName="CHT_02"/>
<Widget widgetName="REP_03"/>
<Widget widgetName="REP_05"/>
<Widget widgetName="REP_06"/>
<Widget widgetName="P_PERIOD_"/>
<Widget widgetName="P_PERIOD"/>
<Widget widgetName="REP_BG_03"/>
<Widget widgetName="REP_BG_04"/>
<Widget widgetName="REP_BG_05"/>
<Widget widgetName="REP_BG_06"/>
<Widget widgetName="REP_BG_07"/>
<Widget widgetName="REP_BG_08"/>
<Widget widgetName="REP_BG_10"/>
<Widget widgetName="REP_BG_09"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetScalingAttr compState="0"/>
<AppRelayout appRelayout="true"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1920" height="1080"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="false"/>
<MobileWidgetList/>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetZoomAttr compState="0" scaleAttr="2"/>
<AppRelayout appRelayout="true"/>
<Size width="1920" height="1080"/>
<BodyLayoutType type="1"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="LAA"/>
<PreviewType PreviewType="5"/>
<I18NMap class="com.fr.plugin.i18n.bundle.configurator.data.I18NAttrMark" pluginID="com.fr.plugin.i18n.bundle.v11" plugin-version="2.1.6">
<Attributes languageType="0" default="" backup="en_US"/>
<I18N key="REC_DATE" description="">
<zh_TW>
<![CDATA[認列投收年度(起訖)]]></zh_TW>
<en_US>
<![CDATA[Recognition year of investment income (start and end)]]></en_US>
</I18N>
<I18N key="EXP_YEAR" description="">
<zh_TW>
<![CDATA[可抵繳稅額期限]]></zh_TW>
<en_US>
<![CDATA[Deductible tax expired year]]></en_US>
</I18N>
<I18N key="CN_PAID_TAX" description="">
<zh_TW>
<![CDATA[於大陸地區已繳納所得稅]]></zh_TW>
<en_US>
<![CDATA[Income tax paid in China]]></en_US>
</I18N>
<I18N key="CFC_COMPANY" description="">
<zh_TW>
<![CDATA[CFC公司]]></zh_TW>
<en_US>
<![CDATA[CFC company name]]></en_US>
</I18N>
<I18N key="REC_YEAR" description="">
<zh_TW>
<![CDATA[認列投資收益年度]]></zh_TW>
<en_US>
<![CDATA[Recognition year of investment income]]></en_US>
</I18N>
<I18N key="NY_CN_PAID_TAX" description="">
<zh_TW>
<![CDATA[年內過期之大陸地區已繳納所得稅]]></zh_TW>
<en_US>
<![CDATA[Income tax paid in China expired within 2 years]]></en_US>
</I18N>
<I18N key="COMPANY" description="">
<zh_TW>
<![CDATA[申報公司]]></zh_TW>
<en_US>
<![CDATA[Entity name]]></en_US>
</I18N>
<I18N key="BALANCE" description="">
<zh_TW>
<![CDATA[尚未獲配(或處分)餘額]]></zh_TW>
<en_US>
<![CDATA[Balance not yet distributed (or disposed)]]></en_US>
</I18N>
<I18N key="CN_TAX_NOT_OFFSET" description="">
<zh_TW>
<![CDATA[尚未抵繳]]></zh_TW>
<en_US>
<![CDATA[Tax not yet deducted ]]></en_US>
</I18N>
<I18N key="CN_TAX_PAID" description="">
<zh_TW>
<![CDATA[已繳納之所得稅]]></zh_TW>
<en_US>
<![CDATA[Income tax paid]]></en_US>
</I18N>
<I18N key="ACT_REA_DIV" description="">
<zh_TW>
<![CDATA[已認列投收]]></zh_TW>
<en_US>
<![CDATA[Recognized before]]></en_US>
</I18N>
<I18N key="ACT_TAX_DIV" description="">
<zh_TW>
<![CDATA[應計入課稅]]></zh_TW>
<en_US>
<![CDATA[Taxable]]></en_US>
</I18N>
<I18N key="REC_CFC_TOTAL_INV" description="">
<zh_TW>
<![CDATA[認列CFC投收總額]]></zh_TW>
<en_US>
<![CDATA[Total CFC investment income]]></en_US>
</I18N>
<I18N key="TITLE" description="">
<zh_TW>
<![CDATA[投資收益及可扣抵稅額總覽]]></zh_TW>
<en_US>
<![CDATA[Recognition of CFC Income and Tax Credits Overview]]></en_US>
</I18N>
<I18N key="SCENARIO" description="">
<zh_TW>
<![CDATA[版本]]></zh_TW>
<en_US>
<![CDATA[Scenario]]></en_US>
</I18N>
<I18N key="REC_INV" description="">
<zh_TW>
<![CDATA[依規定認列之投資收益]]></zh_TW>
<en_US>
<![CDATA[CFC investment income]]></en_US>
</I18N>
<I18N key="DUEDATE" description="">
<zh_TW>
<![CDATA[到期年門檻]]></zh_TW>
<en_US>
<![CDATA[Expiration year threshold]]></en_US>
</I18N>
<I18N key="REST_TOTAL" description="">
<zh_TW>
<![CDATA[尚未獲配(或處分)餘額]]></zh_TW>
<en_US>
<![CDATA[Balance not yet distributed (or disposed)]]></en_US>
</I18N>
<I18N key="AMOUNT_ALLOCATED_PRE" description="">
<zh_TW>
<![CDATA[截至上年度累積已獲配(或已處分)]]></zh_TW>
<en_US>
<![CDATA[Accumulated distributed (or disposed) as of the previous year]]></en_US>
</I18N>
<I18N key="CN_TAX_OFFSET" description="">
<zh_TW>
<![CDATA[已抵繳]]></zh_TW>
<en_US>
<![CDATA[Tax deducted ]]></en_US>
</I18N>
<I18N key="AMOUNT_DIS" description="">
<zh_TW>
<![CDATA[於申報年度實際處分]]></zh_TW>
<en_US>
<![CDATA[Disposal amount in filing year]]></en_US>
</I18N>
<I18N key="FISCAL_YEAR_ACTUAL_DIVIDEND" description="">
<zh_TW>
<![CDATA[於申報年度實際獲配]]></zh_TW>
<en_US>
<![CDATA[Distribute amount in filing year]]></en_US>
</I18N>
<I18N key="CN_PAID" description="">
<zh_TW>
<![CDATA[於大陸地區已納所得稅抵繳情形 ]]></zh_TW>
<en_US>
<![CDATA[The status of Income tax paid in China]]></en_US>
</I18N>
<I18N key="SUBMIT" description="">
<zh_TW>
<![CDATA[查詢]]></zh_TW>
<en_US>
<![CDATA[Search]]></en_US>
</I18N>
<I18N key="TOTAL" description="">
<zh_TW>
<![CDATA[總計]]></zh_TW>
<en_US>
<![CDATA[Total]]></en_US>
</I18N>
<I18N key="TITLE_COUNTRY_REPORT" description="">
<zh_TW>
<![CDATA[國別報告當期總覽]]></zh_TW>
<en_US>
<![CDATA[Country Report Overview]]></en_US>
</I18N>
<I18N key="UNIT" description="">
<zh_TW>
<![CDATA[單位]]></zh_TW>
<en_US>
<![CDATA[UNIT]]></en_US>
</I18N>
<I18N key="PERIOD1" description="">
<zh_TW>
<![CDATA[期間]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N key="col_income_non_rel" description="">
<zh_TW>
<![CDATA[收入_非關係人]]></zh_TW>
<en_US>
<![CDATA[Revenues-Unrelated Party]]></en_US>
</I18N>
<I18N key="col_income_rel" description="">
<zh_TW>
<![CDATA[收入_關係人]]></zh_TW>
<en_US>
<![CDATA[Revenues-Related Party]]></en_US>
</I18N>
<I18N key="col_income" description="">
<zh_TW>
<![CDATA[收入]]></zh_TW>
<en_US>
<![CDATA[Revenues]]></en_US>
</I18N>
<I18N key="col_pre_tax_income" description="">
<zh_TW>
<![CDATA[所得稅前損益]]></zh_TW>
<en_US>
<![CDATA[Profit (Loss) before Income Tax]]></en_US>
</I18N>
<I18N key="col_tax_paid" description="">
<zh_TW>
<![CDATA[已納所得稅(現金收付制)]]></zh_TW>
<en_US>
<![CDATA[Income Tax Paid (on Cash Basis)]]></en_US>
</I18N>
<I18N key="col_curr_tax_payable" description="">
<zh_TW>
<![CDATA[當期應付所得稅]]></zh_TW>
<en_US>
<![CDATA[Income Tax Accrued-Current Year]]></en_US>
</I18N>
<I18N key="col_paid_up_capital" description="">
<zh_TW>
<![CDATA[實收資本額]]></zh_TW>
<en_US>
<![CDATA[Stated Capital]]></en_US>
</I18N>
<I18N key="col_accu_surplus" description="">
<zh_TW>
<![CDATA[累積盈餘]]></zh_TW>
<en_US>
<![CDATA[Accumulated Earnings]]></en_US>
</I18N>
<I18N key="col_num_of_emp" description="">
<zh_TW>
<![CDATA[員工人數]]></zh_TW>
<en_US>
<![CDATA[Number of Employees]]></en_US>
</I18N>
<I18N key="col_tangible_asset" description="">
<zh_TW>
<![CDATA[有形資產(現金及約當現金除外) ]]></zh_TW>
<en_US>
<![CDATA[Tangible Assets other than Cash and Cash Equivalents]]></en_US>
</I18N>
<I18N key="EFFECTIVE_TAX_RATE" description="">
<zh_TW>
<![CDATA[有效稅率]]></zh_TW>
<en_US>
<![CDATA[Effective Tax Rate]]></en_US>
</I18N>
<I18N key="PRE_TAX_PROFIT_MARGIN" description="">
<zh_TW>
<![CDATA[稅前淨利率]]></zh_TW>
<en_US>
<![CDATA[Pre-Tax Profit Margin]]></en_US>
</I18N>
<I18N key="report2" description="">
<zh_TW>
<![CDATA[國別報告表二]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report Table 2]]></en_US>
</I18N>
<I18N key="report3" description="">
<zh_TW>
<![CDATA[國別報告表三]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report Table 3]]></en_US>
</I18N>
<I18N key="country_id" description="國家地區">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country]]></en_US>
</I18N>
<I18N key="col_hold_share_or_other_eqty" description="國別報告表二">
<zh_TW>
<![CDATA[持有股份或其他權益工具]]></zh_TW>
<en_US>
<![CDATA[Holding Shares or Other Equity Instruments]]></en_US>
</I18N>
<I18N key="report1" description="">
<zh_TW>
<![CDATA[國別報告表一]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report Table 1]]></en_US>
</I18N>
<I18N key="col_int_grp_fin" description="國別報告表二">
<zh_TW>
<![CDATA[集團內部融資]]></zh_TW>
<en_US>
<![CDATA[Internal Group Finance]]></en_US>
</I18N>
<I18N key="entity_id" description="">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity]]></en_US>
</I18N>
<I18N key="col_purchase" description="國別報告表二">
<zh_TW>
<![CDATA[採購]]></zh_TW>
<en_US>
<![CDATA[Purchasing or Procurement]]></en_US>
</I18N>
<I18N key="upload_record" description="上傳資料">
<zh_CN>
<![CDATA[新增数据]]></zh_CN>
<zh_TW>
<![CDATA[新增]]></zh_TW>
<en_US>
<![CDATA[Add]]></en_US>
</I18N>
<I18N key="col_out_of_business" description="國別報告表二">
<zh_TW>
<![CDATA[停業]]></zh_TW>
<en_US>
<![CDATA[Dormant]]></en_US>
</I18N>
<I18N key="language" description="語言">
<zh_CN>
<![CDATA[语言]]></zh_CN>
<zh_TW>
<![CDATA[語言]]></zh_TW>
<en_US>
<![CDATA[Language]]></en_US>
</I18N>
<I18N key="title" description="">
<zh_TW>
<![CDATA[國別報告表]]></zh_TW>
<en_US>
<![CDATA[Cbcr data import]]></en_US>
</I18N>
<I18N key="submit_enter" description="提交">
<zh_CN>
<![CDATA[提交]]></zh_CN>
<zh_TW>
<![CDATA[提交]]></zh_TW>
<en_US>
<![CDATA[Submit]]></en_US>
</I18N>
<I18N key="search_enter" description="搜尋">
<zh_CN>
<![CDATA[搜寻]]></zh_CN>
<zh_TW>
<![CDATA[搜尋]]></zh_TW>
<en_US>
<![CDATA[Search]]></en_US>
</I18N>
<I18N key="col_insurance" description="國別報告表二">
<zh_TW>
<![CDATA[保險]]></zh_TW>
<en_US>
<![CDATA[Insurance]]></en_US>
</I18N>
<I18N key="col_admin_mgnt_sup" description="國別報告表二">
<zh_TW>
<![CDATA[行政、管理或支援服務]]></zh_TW>
<en_US>
<![CDATA[Administrative, Management or Support Services]]></en_US>
</I18N>
<I18N key="edit_record" description="編輯">
<zh_CN>
<![CDATA[编辑]]></zh_CN>
<zh_TW>
<![CDATA[編輯]]></zh_TW>
<en_US>
<![CDATA[Edit]]></en_US>
</I18N>
<I18N key="col_provide_serv_to_nrp" description="國別報告表二">
<zh_TW>
<![CDATA[對非關係人提供服務]]></zh_TW>
<en_US>
<![CDATA[Provision of Services to Unrelated Parties]]></en_US>
</I18N>
<I18N key="col_hold_int_property" description="國別報告表二">
<zh_TW>
<![CDATA[持有或管理智慧財產權 ]]></zh_TW>
<en_US>
<![CDATA[Holding or Managing Intellectual Property]]></en_US>
</I18N>
<I18N key="period" description="">
<zh_TW>
<![CDATA[期間]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N key="col_main_ope_ther_ifmn" description="國別報告表二">
<zh_TW>
<![CDATA[主要營運活動_其他資訊]]></zh_TW>
<en_US>
<![CDATA[Additional Information]]></en_US>
</I18N>
<I18N key="entity_name_en" description="">
<zh_TW>
<![CDATA[報告成員英文名稱]]></zh_TW>
</I18N>
<I18N key="col_manufacture" description="國別報告表二">
<zh_TW>
<![CDATA[製造或生產]]></zh_TW>
<en_US>
<![CDATA[Manufacturing or Production]]></en_US>
</I18N>
<I18N key="col_regu_fin_serv" description="國別報告表二">
<zh_TW>
<![CDATA[受規範金融服務 ]]></zh_TW>
<en_US>
<![CDATA[Regulated Financial Services]]></en_US>
</I18N>
<I18N key="delete_record" description="刪除">
<zh_CN>
<![CDATA[删除]]></zh_CN>
<zh_TW>
<![CDATA[刪除]]></zh_TW>
<en_US>
<![CDATA[Delete]]></en_US>
</I18N>
<I18N key="entity_name_zh" description="">
<zh_TW>
<![CDATA[報告成員中文名稱]]></zh_TW>
</I18N>
<I18N key="col_sales_mkt_distrbn" description="國別報告表二">
<zh_TW>
<![CDATA[銷售、行銷或配銷 ]]></zh_TW>
<en_US>
<![CDATA[Sales, Marketing or Distribution]]></en_US>
</I18N>
<I18N key="PLACE_HOLDER" description="">
<zh_TW>
<![CDATA[請提供任何必要或有助於了解國別報告應揭露資訊之簡要說明]]></zh_TW>
</I18N>
<I18N key="col_res_and_dev" description="國別報告表二">
<zh_TW>
<![CDATA[研究與發展]]></zh_TW>
<en_US>
<![CDATA[Research and Development]]></en_US>
</I18N>
<I18N key="report_name" description="">
<zh_TW>
<![CDATA[國別報告表]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report]]></en_US>
</I18N>
<I18N key="col_others" description="國別報告表二">
<zh_TW>
<![CDATA[其他]]></zh_TW>
<en_US>
<![CDATA[Main business activity(ies)-Other]]></en_US>
</I18N>
<I18N key="cbcr_overview" description="">
<zh_TW>
<![CDATA[國別報告當期總覽]]></zh_TW>
<en_US>
<![CDATA[CbCR Overview]]></en_US>
</I18N>
</I18NMap>
<TemplateThemeAttrMark class="com.fr.base.iofile.attr.TemplateThemeAttrMark">
<TemplateThemeAttrMark name="經典穩重" dark="false"/>
</TemplateThemeAttrMark>
<WatermarkAttr class="com.fr.base.iofile.attr.WatermarkAttr">
<WatermarkAttr fontSize="20" horizontalGap="200" verticalGap="100" valid="false">
<color>
<FineColor color="-6710887" hor="-1" ver="-1"/>
</color>
<Text>
<![CDATA[]]></Text>
</WatermarkAttr>
</WatermarkAttr>
<TemplateLayoutIdAttrMark class="com.fr.base.iofile.attr.TemplateLayoutIdAttrMark">
<TemplateLayoutIdAttrMark LayoutId="9ebf6aff-ad53-45a9-a175-9633f4162a3a"/>
</TemplateLayoutIdAttrMark>
<StrategyConfigsAttr class="com.fr.esd.core.strategy.persistence.StrategyConfigsAttr">
<StrategyConfigs>
<StrategyConfig dsName="DIC_COMPANY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_COUNTRY_REPORT_SUM2" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_COUNTRY_REPORT_SUM1" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_DATE" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_EFFECTIVE_TAX" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_COUNTRY_REPORT_SUM_ALL" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_COUNTRY_REPORT_SUM3" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_DATE_MAX" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_CATEGORY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="CHT_COUNTRY_REPORT2" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="CHT_COUNTRY_REPORT1" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="CHT_COUNTRY_REPORT3" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_COUNTRY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_COUNTRY_REPORT" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_PRE_TAX_PROFIT" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
</StrategyConfigs>
</StrategyConfigsAttr>
<NewFormMarkAttr class="com.fr.form.fit.NewFormMarkAttr">
<NewFormMarkAttr type="0" tabPreload="true" fontScaleFrontAdjust="true" supportColRowAutoAdjust="true" supportExportTransparency="false" supportFrontEndDataCache="false"/>
</NewFormMarkAttr>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.27.0.20240627">
<TemplateCloudInfoAttrMark createTime="1711940947019"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="fc8c24af-21c7-4877-a78d-4650ba7f6d5e"/>
</TemplateIdAttMark>
</Form>
