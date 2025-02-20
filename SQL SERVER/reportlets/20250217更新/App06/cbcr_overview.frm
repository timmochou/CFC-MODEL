<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20211223" releaseVersion="11.0.0">
<TableDataMap>
<TableData name="DIC_COMPANY" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
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
AND T3.FR_LOCALE='en_US'
LEFT JOIN 
V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID
AND T4.FR_LOCALE='en_US'
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
AND T3.FR_LOCALE='en_US'
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
    AND T3.FR_LOCALE='en_US'
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
ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='en_US'
LEFT JOIN 
    V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID AND T4.FR_LOCALE='en_US'
WHERE
1=1
AND
T1.REPORT_NAME = 'report1'
AND T3.FR_LOCALE='en_US'
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
AND T3.FR_LOCALE='en_US'
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
ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='en_US'
LEFT JOIN 
    V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID AND T4.FR_LOCALE='en_US'
WHERE
1=1
AND
T1.REPORT_NAME = 'report1'
AND T3.FR_LOCALE='en_US'
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
AND T3.FR_LOCALE='en_US'
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
ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='en_US'
LEFT JOIN 
    V_TRS_DIM_COUNTRY T4
ON T3.COUNTRY_ID = T4.COUNTRY_ID AND T4.FR_LOCALE='en_US'
WHERE
1=1
AND
T1.REPORT_NAME = 'report1'
AND T3.FR_LOCALE='en_US'
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
AND T3.FR_LOCALE='en_US'
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
<![CDATA[SELECT '1' AS ID, 'col_pre_tax_income' AS TYPE
UNION ALL
SELECT '2' AS ID, 'col_tax_paid' AS TYPE
UNION ALL
SELECT '3' AS ID, 'col_accu_surplus' AS TYPE
UNION ALL
SELECT '4' AS ID, 'col_tangible_asset' AS TYPE
UNION ALL
SELECT '5' AS ID, 'col_income' AS TYPE
UNION ALL
SELECT '6' AS ID, 'col_num_of_emp' AS TYPE
UNION ALL
SELECT '7' AS ID, 'col_paid_up_capital' AS TYPE
UNION ALL
SELECT '8' AS ID, 'col_income_rel' AS TYPE
UNION ALL
SELECT '9' AS ID, 'col_curr_tax_payable' AS TYPE
UNION ALL
SELECT '10' AS ID, 'col_income_non_rel' AS TYPE]]></Query>
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
    AND T3.FR_LOCALE='en_US'
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
    AND T3.FR_LOCALE='en_US'
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
    AND T3.FR_LOCALE='en_US'
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
    AND T3.FR_LOCALE='en_US'
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
<ReportFitAttr fitStateInPC="1" fitFont="false" minFontSize="0"/>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<DateAttr format="yyyy-MM"/>
<widgetValue>
<databinding>
<![CDATA[{Name:DIC_DATE_MAX,Key:PERIOD}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="390" y="85" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_PERIOD"/>
<WidgetID widgetID="8984286b-2315-40ef-bea1-895aa4755d9f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName="LABEL_PERIOD"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.LabelTheme">
<FollowingTheme styleSetting="true"/>
<FRFont name="SimSun" style="0" size="96">
<foreground>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</WidgetTheme>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("period")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微軟正黑體" style="0" size="84"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="390" y="45" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_ENTITY_NAME"/>
<WidgetID widgetID="60c85dce-6bdf-4cd4-bfb3-16c895813fad"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName="LABEL_DATE"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.LabelTheme">
<FollowingTheme styleSetting="true"/>
<FRFont name="SimSun" style="0" size="96">
<foreground>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</WidgetTheme>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("entity_id")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微軟正黑體" style="0" size="84"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="810" y="45" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_Country"/>
<WidgetID widgetID="d506761c-b875-4982-a6b0-53670ce8d233"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label3" frozen="false" index="-1" oldWidgetName="LABEL_CFC"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.LabelTheme">
<FollowingTheme styleSetting="true"/>
<FRFont name="SimSun" style="0" size="96">
<foreground>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</WidgetTheme>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("country_id")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微軟正黑體" style="0" size="84"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="600" y="45" width="180" height="35"/>
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
<![CDATA[=I18N("search_enter")]]></Text>
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
<FRFont name="微軟正黑體" style="0" size="80">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="1735" y="65" width="120" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_TITLE"/>
<WidgetID widgetID="db840ab4-6734-4b0b-964e-0982f426ae64"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABEL_TITLE"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.LabelTheme">
<FollowingTheme styleSetting="true"/>
<FRFont name="SimSun" style="0" size="96">
<foreground>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</WidgetTheme>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("cbcr_overview")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="1" size="96">
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
<BoundsAttr x="65" y="27" width="415" height="80"/>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
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
<BoundsAttr x="600" y="85" width="180" height="40"/>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
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
<BoundsAttr x="810" y="85" width="360" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COMPANY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COMPANY__"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.LabelTheme">
<FollowingTheme styleSetting="true"/>
<FRFont name="SimSun" style="0" size="96">
<foreground>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</WidgetTheme>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("unit_twd")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微軟正黑體" style="0" size="84"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="65" y="90" width="300" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COUNTRY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COUNTRY__"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
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
<FRFont name="simhei" style="0" size="72"/>
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
<FRFont name="simhei" style="0" size="72"/>
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
<FRFont name="simhei" style="0" size="72"/>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
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
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</ThemeColor>
<selectBackgroundColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</selectBackgroundColor>
<BorderStyle radius="2.0" lineType="1">
<borderColor>
<FineColor color="-2433305" hor="-1" ver="-1"/>
</borderColor>
</BorderStyle>
<Background name="ColorBackground">
<color>
<FineColor color="16777215" hor="-1" ver="-1"/>
</color>
</Background>
<IconColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</IconColor>
<FontStyle fontSize="12" fontName="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
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
<Attr position="4" visible="true" themed="false"/>
<FRFont name="微軟正黑體" style="0" size="80">
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
<UUID uuid="dcf28137-d9af-4cd9-a784-984a2ecb0c4f"/>
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
<Attr position="4" visible="true" themed="false"/>
<FRFont name="微軟正黑體" style="0" size="80">
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
<UUID uuid="9eed2cde-c599-4457-9a2c-12d9c940bac5"/>
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
<Attr position="4" visible="true" themed="false"/>
<FRFont name="微軟正黑體" style="0" size="80">
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
<UUID uuid="b56d16b9-12eb-4ae0-a76b-1f733cf1fb59"/>
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
<![CDATA[723900,647700,1257300,1257300,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,4381500,6286500,5600700,5334000,5448300,5676900,7810500,6096000,5715000,4914900,3200400,8953500,2743200]]></ColumnWidth>
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
<RowHeight i="1524000"/>
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
<![CDATA[=I18N("COUNTRY_LOCATION")]]></Attributes>
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
<![CDATA[=I18N("ENTITY_NAME")]]></Attributes>
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
<RowHeight i="1524000"/>
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
<RowHeight i="1524000"/>
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
<C c="1" r="3" s="2">
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
<C c="2" r="3" s="5">
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
<C c="3" r="3" s="4">
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
<C c="4" r="3" s="4">
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
<C c="5" r="3" s="4">
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
<C c="6" r="3" s="4">
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
<C c="7" r="3" s="4">
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
<C c="8" r="3" s="4">
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
<C c="9" r="3" s="4">
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
<C c="10" r="3" s="4">
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
<C c="11" r="3" s="4">
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
<C c="12" r="3" s="4">
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
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[`-ci4PP;M'>BY/XX[jrl,#_\[#Ng:Yg+(/T&.t",R3Ju"3?^tr<CE^YbS[Q,KGg2q&7Wg.;c
")4&0RDI&OJ_g,X=n@^CT(IcJA5b^$kd[hEF`-qUd(NQh=Qu^$iSiod/j[]Ap7[9:]A10tcT[Q
"^3oJ9B:nSCrp2FtGCSERr(T<OWqpA#7I42b]APoIjl142uRe3?GPgJT'^7#D5]A)=n1P)#4B]A
P5%IhToiK3$Du`05pjM%i"gi3q@_)_b^:0itqI>^A-[qjbN$nII?=]A0B76:o1R[F55X['73X
J3H`&]AP^9U_k2*O\"icE@I-(VBi<E3%QQ*i-Pln:f.@Nk8[TC)UKNQcqpnaeD<3#\W#<h8Pt
nr$]A_E-j.6Ds]AqQ**k2'Y;GBBIf<-!C>G+%4+>4!7tY1:rnLQ2R:Q6d<M/csX]AhhjF33&-d'
4h?(DW8(?`6fB0.VCHa?I[m/ip^"qYgdQaA%YjfcKtDr_2qpHEP;VL&5cH<.Z1%(E_B/r>F]A
.eB-rIHLq=7<Qr:+mGCS!(2:lY8,/6br857/$G?:dnEJ:R?N[D73:YaNeJ,NG7$H(5]Ah@XNM
27X&JeQ<WcBe3oF;n4F*aJ42Fl0DjDR+JBYCYQebA[C7Y[!K[*dX@KlsF*aaOf$<kA/43W1t
s+=7>1;e%Z(js*^l<Uh.<*Ie/G4q<)#IL$t[XC:5TVjZbsKS7FrHE:9g+*Y`q:HpY9f>,Zjg
l0nI-d(aok:J(s2\9R+BhnG\*]Ais9"K--GFT3Ah#H-h<;>#51Ac0MUoV`4L\b#KlTDZ;:D6U
`<uPk9ZZI>25p4UqDJQ!<DfB:&W`coTYR".=1_ieP5CPbQ\+XS.Oi_Wg#Pq75+`mJc\V-qM=
C"h@MH>;qe72g<egn!*b9:[DqBf@)AI8m1.Pg?2MT_gF=JKZ35G(9`Q8bVua$2Rm>5\,=iD3
#CP#kdES@-mn)1g-Fr<4s!<dP4@;hTUN"&HND^Vs5pA`5_io`DDWse`SCF_=>"MIeSm-"c$1
D@Bb%t6,$04f<4#4r6H?XWcY&A_L=DgaBG&02W`L`Nen;&0Yfh$kR:O1;DPDG%9A-]An[;ho]A
G$WKVSa$)_[ouBC?Hn,5I#Y=j9Z9H_T'M-tIdCA\M*OS>1Xf%@#Ref>Arg4[_O>o5ZUX^:gk
tq#+\g3J,&]ALFBAWL]AqZE[%b'7Zp=Jk`0D17L(+p]ApHp;X)IY!;029:lY>Ceb,\_HOiDk8*F
6-!R\XjYi%1.;@65p[bRLWB9]Acm]A-KE/n(`bC@$LVG]A#M1qKcVuc$GNo?dTI,ZXqp)2D"&'`
E<m\\o5:YF)L&2N>%VdFcL;3\(.KK;ts>u+j'M66t@Wd(l4%]AC<<GgBkQT"rUR_IE=;TgOXk
:Y\4EHuQi"foVQ4=gm7YLT:51Wd(^+u#>1`n##E*GKG9j)SbjXO)U0-(#A#'"^<\Y[Lo2b1-
T8(>s>-?#DDX'@uLQ-:DYW_1sS2G#-UMgn,he/`G6r'KOZcPT\>qed.ITd<:@#Y^*k]AH6mh\
8A`=m,WL[sHtEB7IDl4WtGQf1``V5%:a<M,:A%9O=W+K[er<CaoU\"*a_Y#O3r#j6m5oLJ4&
BG^Nf)M7eO&^Y1d+Y]A1c4VJE8'^-m&Y`iJ+%=ieeBVaph'#fG.s:MA-h,Fjc#QB'`J3UCFP4
]ALWr==d1tV7MT68n>9aK.G5V,3Q:;O23SJ6FMrP!dtDVK]APr)V)*oE?=VC1s7-P90MOQ%:-1
XK2J,A$B;S&/'=9Y$T:PJtB.a]A4-*Pe]AU)<WlW;s52]A",ZTp2MQo>>ooA]AliI4DcDrlGgt8"
_h(s^%Xjt9gG]A%;MpCrGc)*Tm3,/Y%EU4N:'c$0o>N)$pZK=0&WSQ7S`fWd6NW%ush)DQ(,4
bsQ<ff,7&XKo!#@.[Cch[7P.s>\Z[rImUo]A0Un:lD#*%>Q]A@&J-=9T&,^Ybu"dpW\Din4_B&
^7tYo<]Aiu'&`PqNTo`d)RZ/QLEWE;P)$RTH)n:(\Xi&U"?-27WQB;;!PUW8qIl'Pa'KC6(hO
<OY4?cdBDHou<J+*E/5.]A'Oo?JR%P=$oBi]At8cq3*@K`*[9AF_C4NEirpqREjJuFj7rr!>`<
?\nb@<4[JGeC36Vm#m&1JK:bkjY54X!D4%iS`-h\l%lUWln%?XJsMLf^Pr4-,Hq<t?6="#m1
o_K4o*61Q+mk\!F&>"Bq,IG10+e0tA7ErfXNoj#!K_P:.G2Gm5Gq9('D)LY,b%3JhA(I]Aca#
2;PjoTS9`YcgdhO`q"4>Y6J\3$mN434O\5ZJ\mdm#Z+CbDH?BGa`U`SAK=L<j?9Cp2^kmA`q
MNX7'!.GRh5.*(r)5gt+ha0D.)_'=*6ULoX@7eRVPn"X3;Roj!Z&e]AS&#]AIW&-A:"@UI`D+k
G\[7jcbdJgIo3q/m3Qjf9dgp;*f>ikB5DZZ0WGl\imHS`_Rn77FcBelF+r=3"7ri5/R+2opV
r:V/tYi-!+A\=imtS^(qMuS#7L8PleGJSUtoNX1j*T5>qaVnPs/-D($_g>bJk]AP)Dk=b)mhk
-A70F\X*l>bZA?G6K)Lbbbu9h8Fs@t'>t/,>U>i!RF'Qgle5Jk^'tZ,3oD^O<A=hEI9Y%>7'
&`G:B&@+]AZWa@7GO(`a;sFWQ<fPA_VJJ6HsP`%b*8]AdG$ZO[P&t$Um7/eRj9>GCQaiUEGOF%
=2i5SnUA(Q/`q)7g3#EO0B,mc5DnD`ELgj64!\SuUk6ZN(i9]AHHb3R?gWS[S.Su7F71VGP-S
d@XTc@<jt<aG62T5Y<$Wg)`fdS@Kh[^u-)W[8^7E>#48a"]AC>rhp@B-5r8)_1025HuT?8(,"
$Z$SY>%H6mOLAq_D7R$Tq.?Mh%_geXUCkT3j4OOF_RBE<ksFP\MsWbDDHrXM?G0@&)cVTnX7
(m,23Je_;)AH$S@K793:foDZkMr=UoqRE"I6"F(GCJ2O&$FZs5qO*\LZSAg@&Sd,iR'`-omV
KY15DUhrCegt(KMSj_$:pB?1o66SJhX]A`etc=%qHR=\6GBY5C7p"EIWQ^(D)]AGJ(?QPL?IE9
M&f[H`Vk[GFkDEs]AZXmF-N\mCi'D'NcUc#A)kIZP'dIHTd[O=1I$OrVJhTo:B>J4UR3'pem+
\^4H)=:Lu`"d<N`!N3W]ARe`7#6&U6L/Ea-WSMst7JDgrGCW8]A`Y7Z@^/Bc/A#&EbNJD._YII
XImASV-_'TaF6AJEI;E45<>hrR:]Ap47!#[(8EW9,St&-Bu<M,m6I-DN405*VjYFNldl)+9f/
k<F_LrA5)tbl!QD.p2Fe59uR3]A6</cBX?$P_9/j\dSI`jjSWbZ-QO`)m*%pPRO2<8kspcufC
*;q8"fo,3g]AE@o?^2-gAMi)qQ9%<fV^2Yob]AibnMY,:lgaObJ_uP90u5O>H1h=^gW!3srLG"
#?K;tG'e$nf63LJ-V`I\c7bpI@1<S(j2cY@%HoF8tZsW)S:(Fj`H_Gu&+0tPY6d/6D#eDe_#
OD@K)'Y@;P[r(3dD[;q.\%3:9n7jFEMRDm\S+t.E^f-@d:LLJA_=OU@i:3+VX(0)d?Cqf9uF
-)TeI#OdY2Z@:rhl'#P[NQQdpoBaCt34-cTqns6:S`*BmFppfsC&=[MnK\o"CX]AlK[AaBYT[
&I=M?Hpm.*e28nE-gdrG2Q8'X'_Csa]AE3FX4*Bb7dpDc+@VE]A)qH[8_kdiG-D.LB3,OOZ8R<
]A8f)M4E=dGBk),IYSHiLH6+2nQLg+smXuKk9!jZuFP!BDL4>U:AS%OI\>p0a]AW1H"fGs7@]A)
@&rlboS`fgf.K\m^)qCBm#tE<5%>uWu=F4D5?@1G[JCg</66sj`X;-Fj.B='G1Cc03rJ\&V:
s?A3D0J_=PU3#.VYLOWdrQH9)t!IG)]Aj,lTS:W&,Rm>cLd#(s<1LjhNtlrU#DDg]AR?SX*S=[
&rBrsssQQOj#(%7.eTB#(+(tYb#g*-*+NBG%e]AKp;&E#1JAb>.XiI,4GM>h`SHlnGgL@,rj2
U>!N#ML`[D+T>4MO^Yth<J[>XT92gGePp)K2g"m9CM@uP?JI`SRK5W7M-M@F:<*\5[6%4DR0
k`2+(G,pX)!gQ7.DoDSrk6:j)sSL62K_nNdlNGRk3R]AKEk.dg.pU7GJ[']A@(:q.nn-XE(QJf
oc/5PO(c$XPU[+d$T&)9MXu`BU9!<_N_Skr+H<![t4$;d8Mr#CIVJh\:*gQVQ?\Wi`DZ$ebm
E'0_@ZWj\Ml,>jXM`R^U`?i&Wr^l0S9(B(MN@1koUE9oRs4W<5%e6T/DV=0a'Yk6=?5"+3]Af
2e7DPPW'egOiphUJP4t=+0XQcJ+m0O?R?BjVpS^+RIp$)lSFlp5Hg1muDmb7och2gTjlarLS
jpD"Nf/O>2&XA3c`DQRl;C96:F6`B@b>=l]A>,uBY<O*h6`jZF073l^3crulS7]ANJ3fp2S3<+
"@`/iWj%#(VkM,34i4OYb>+*hYEM<ZZ_DQe5YVB/La';]Au]A0Y2!`qeKesA*`X#!#TnGa'rfh
M8RkEegKOuOnAn1r`mC+U6([hYAT@ia<<B'bG]AG?_IP.=1]A+DMnQ;ea%Iu`)1r5$>chTKS^L
Lm>R2/I\gLihhm[q[h<%CBQPd(V>P6,8WIFN[0pLfd(s\%)uKZXKQg9TR9KOmd(STBs+#g[0
1JanPg+<VeU&[`n(T?T6+#5ZXnb#4[Lbo5XfC5-lBC!s0Td50Nhm7At)q6bE,UXfM#?[j7g=
(jCXK&c,WBd*uH+f8<^Q*GrEM;0`ob"!X@8fu`,LIp4;WWInJ,BPS_2N5_AW@Z@rlK_q\:pF
g-t]A>]AYGcMV$-MFm8;F@l8eN-D@Y"rQ-dfm5\71eIAPQD2,gZe*Kbh\[.Qo-c#l>HCHTN8E^
OHVtdUB=l)+6*`HZ95Yk!.84'/QgmXL4.C+Vm1`S[[/&=*"SA5kR'4n0Ff'>g5p?R(,,FjfK
1-_0c9en(/i3-iB#O$\-`a^]A2gPGH&,Q_$or#GbRH@eaqGY"n&hep('5LsTC>@_!XMYU.^,V
UZiXNdpQd&WtO`Fd:D]A5MVKeW?62XAVukD)ot&WWaY'D;ZBHsZ._S#>t;dG#t/MV7VDjeJ$(
4Z(nX'Jn;nXBg^WU\H\cq:Zgu;V$N]AM_tkJ2fJ?0IUm@:@nrqVR\KFC$\5).5.+)3]A<s<P<?
SaNQ5bs(=oS_m+ru'>I[>=jlehs9k"B%Z658Hscad'I6Pi+<*]A,5BJYnu3L"4BDj_pcpf9j6
-U`RIHNE*9HNr8WadZ3iQ=Q/od[sBomjbsjrf8#MLd<7>K=t$p=ac.r]A5,0V6#lT:BCWKLZ1
R@Ik+b<)q7:LOph!)G&g]A/k2Sj>fo6Z:Q(aEOISQX?9-\bDfn]A-`N#.FD[?Njm,X?sD]ABVcU
;\Xh97T0,+RRKas;udcM8Qs,n^SZYlnC1HcJPQ:$8um6>N49FU_.<B2`\!m,G#"r;[9Kp>j'
?p(('\C6_Eeo2K:)8e,oHo#m)(R50+Z7lB/D-$.U-90,9<U?/TDsc8\N-ap0GMZ",!(b1(<H
[.)Ms2O-bf=nPhR[!-rQ%M,A)]A?"_gV1V]A:SNBr2j)04ro`67ri2c_udU.CHM1SX%qJm`Dg3
K*ZCss?6NhF\p,`2HsQ-]AES(\*<']A=M/-Q17*7EAa^Ii6_i"k(MNk509*IUWmcEK$1;tf!0m
Q*#*S/!Bf,BCfg>>(Ee@6n&lY--M%`E>#s#T*_e)$X5#`7=5kZ5_`,(5f#(4hHd+!:Fm+=8!
l;%7]A50l#6QadeFP=!@.WY_iMl'?DJ+@VA_lA'XIOS=c4AnNY:]AE\hH810Kf.BC,mF@C!u0h
4StAJj+!#-@/'o_&l7`4+li)-.J1Z-N9ZSTKlOiMA=\@"'*_$0HeOkI<H)uObM"k_JP-ID0`
>m729>Z)ZR8fX+hg&uGJm<IJ_Qhj#uhtWdh$(o$u=fu`'c=e9R1LgoJ;7\4AtHn<HBSh\D4r
/0^Q<`?DY9N7Poh)I(dic9[(#Z9N$<KP@b=9V[@Oj&u/s>/4JKP!p"'*n2dNV?6a1Ujnnm:,
SjdIIEhIoJ<K.36C<gLi"HMq'?r6">iWgGDE[ZgEtq#8ReliGcDRqjB>]As/?#?"OQAuV4?P9
/f.i*=/CAV'NhS3JMdS8bgE/oqXoqYRM##rT/EV=I#9(Ke3c,rj5BG)UOg9OLto5s`Ep;?a1
6\c[;rcWQe-#dC.+PT.Ci%R1>/bm=n\^PZHOU@rIPL7A+riaK[JkUc5SpOQ)lB'.3ZBg`Vo"
0I%kXTgZgC:Rbj%foWi0o.>fZ*!cb#Gj8[$-J%:'qV]A#JHpNN@gKZeI/h.:Wkt-+i@&Hd9Ud
;n9+B&i+H!!7Gg8M=G.06INl7Q@lJd`aog%6M^I]AH$K)!,oZQGB?E8?\&9W?oqZH,O'5fKT@
oKbXK".PCYTd&jZu<62W9+F7]AOGNKHB5Yk`JY]Ai4&.-Wn"1lKF__!%-jZK&QhqM,4a4K&6s=
"G6ZXs4`n]As!afG_IlZ5E$4q`cjC,e@noqAO+a`b'9j@U@N-Rp\\n$:$kXDM"#6V)&u+CZK)
2@(P,=gRLMcd?bQqb:C,n->q:lc1(l(*QHcMi,biN)?pFAoOUAFsNc?E`r=CcWRfsh&q"e@V
Xq,Sdu&kF4[Z>*&\aL16##s+5<)=;nYo1Z#fG1&)*<gL;j4Q6B+qijB&g68,K$H+Z#_^5cMZ
Kiu%]AY[qkIhna/f_50H(aV&J)P'1c[%l&"<[aC^J7F:[kE<D0AEc3]A2m.LSI5%dT[PDTqBI_
O)e-H1gRaZ[7HW2uDB#qgTfqCHKPa9NQ9%c.72W,'LD^kmkM25hd*u$HA=K>Q%E.+WlI@'\&
f,I`8f9diije7r[J-R-c)jo[V).e'3/NNnqf\%)mm4>WR&:%%cJoF&nuXKh29^8F*65;9th`
41)`F*H_>bs(W3E0Z13;YlOPJn*/V,p.Rbic1V#bJI9Eu;0!@Y6;&+T)iDH.,AUa"Q_9i+*u
g]A#fWDklZC$PB9aRCPW.P\T+>rHtIJ*Pr"c&&nrlEaa:0?hA&o_#caDV7``Se<(MYHrPWD,D
9$/.J)H4/Tda$^`2?`#f8+(S4\?+LOijiUr:Y.<j833tW=lkeX8ii=aQU<l=#MT9gDbn'=j4
hI384tGIAG>Z"\8@4D5l]Aqo*e<="8"TFp0+4%AVo?I7+1aLNDB(MR;pLVJm%;0";H-4m4f>L
bnh>[]AnAr?":-k+*.Ap]A28+4.g\B]Ai*Ff[=VLq`@9'qga!/nbIX.6!i'&P3O74p^7#,j`&W.
NKGd(NmiQFonVnjRqT4rFck;6^ak;*RD1#Bs#;2[`HQ(L?^1L<#Rs->"bl02`O"gRRK?;;9h
U2/5Mh@8gK1:kf;>/YkRpaug94*OhoM%9&[M>8\R^oZ<KgXSNce2mW?->'!n7Y.C[MEmiT\n
"03+<]ADoc'Ep$J.=:#89XmR^R>NM,ZR&JtP.Cs724E+=F]A71EjV&af/c<<lg>;Z'UlUu<id/
9'\CC.LEuH-X'UPh@]AB5,c_Cgr#lM$+Im7h,:;n23$>FJm?tm'<M]A:bK4.-6@$k1Or0'>g!M
7YdYDkR94%qFh'^qu4CQ^3eF=^T<_r)g`;E!a[*,s'1kNI8I!Dh)L1=(qf"=^^/LB`$'oA)^
,Bh='5A\`cD[Fo$^ch6mM7hu^UT(<hh;t00NRG/.?FPF]A15M?5W1f@'1#X0OWgWAE5VoQ0bq
I;mdad",H8]Afn*9Yet'_q@?rK+g1`/AObJ9FfD?/7>LZ^>0t\@=<soFQ&JP?39+8'NgpZaG_
Z_%ieVj/tSPZ1:4MblWi7:W'J]A.e@tpP$kSF$lisWih6QT-YHrR.!&Y#6/^`"gkiZ/E;u4k.
>4K(n%o!1^!!K:jk-l%1<MI`Gt(,Vs,j"j?a`,["[Q9`=r+a=Uh"KSfJ-8MQ\TSUpFc4=#n"
)gCqhU2T63LA,eC@Ko&GSe!I\htVZq[cWh?5R.-.J37eE2)\H:2?9"7HX+d/+b.?<1-:k(\r
m-n28?;II%Z`E:jr;I4nAA#(!j:CO_W!%:&U3V`s`5RCm)GL0C^0b5\di1r#\AbiO!R8pEnE
J]AGS%bH"LXZ.2=RmF(=l@r7:Lc1H[arD[KC#E&L4#1*O;#"6]ABZ=Y6l1dV]AoE?V2=#MU9i'L
YW#bbH:Q5JglUmR>S]Ad8)Bb3.pS&m#^=tM>l6^L@99"Mo:p*E]AurL%#]AES8o;2E6I2[1Fm%Z
C%iH-JiR3r^B.,!uJIEaF5Js<![/Vi\5g?9U4)^#]Aq#@T^.oOSa1o&66;,T?e1=EBf?HrC[C
%2j`ESpckdMV-=O#8#Q)5!k'lXJ-IE;B#NS2:TIhc=gJ,YW2sFDth6Zo51NOm*8RlO4[E^>=
A3-Gng*WiODgFH!jO>EVp,DYJVF;X<`;ZIDjS+4?%';b&eN!FK4X>B]Aq>FPo$IIU\'oi[mEW
KW=8Y(#]A"i.R@!pur!4n7f22KX,3(4iEkG=AZV$!*MYBL/Ws`-#WF+h:508l:PcSA,RW9Kc0
IoI!K4+8bqCQ>F2`51eC)9PL$'dG_&-p6aphJSIY,M0O(5XZhKYe(FrF,?9*>QQPg,KkF3ZH
I'm92+:W7lSq6>C\?EG3Gn:51)J1dItF:p#NonM_gpm>k!$G-Ade&:=0;Kces'ZPhk0W(A-g
'@7*B[k<UK#4:-j+c59J,?"FXeQTtK*?:\(W+q-$fl82l,,/aK@G<,2G_T'\5fA2X4MI&$L2
VZk>`bIcYjZ)oe1radS&efS(/4u>teCaThqTY[l?OgT#:V63+5'dnjPmX"ioI9EK^Z4DcY9F
NMS[ifL0nkdDok*m&4nj5W1Tf7:ErbQmr;*,Bjkctd#>,U7c*P_-#+@O+?`a"&'[/)u*-5H/
Tb&i:\R+H":dkk"Dhr%;@7/(^1`$ZT1C^8j;cd'kmmPWD?P\rMBs/%0?>\<T-IP;1,lB.*%g
u:)B<U-f*)VD9a@%rMQ3bNt2">hnqcDT0'5n.K"B&W[qW;\/*oL%-(9t9p<:F4c9-t,PEI,5
Eb4UV9/e<afi8I/=3"6f6lBW\#mf-28)aLQHJ4*!`]A/"T0K:Yg?\K30[IlAH[,G!.n99[_*F
Q)kVn*b^>>A*/X^Im7qPSnr=kPR9u4^it?kbbITd+9?T<]Aif`:@6t[0&i&dH=M3l[$2!6oER
j1OMn2mf,B7A/Y09DGjP!hci$7*PP0[-.?hIsiJS6U!4+7B3m2Gus!0R7^6TX$('hN[7eIl,
XS*]Ab)]AcnpoMC`s<P8.^iGreJ@37s^@D7)JNI\?Z^#Mr-cpT5O[:l([ip-NVV0A`&c^?bh37
[X6&"ZccuR)tLJPB/,a[n%/_EddMX[^hHe44bQ-ZQ6\JL-06OosHV$gAl6rTCB(&#R3'OhDi
2:aEb[[kV'VD"\s.!T$m&5/Z]A6QceD`kmo9>bXZ?N%H39fY\:TMh@j*i&C'QfW\^=s[5ZuMn
`Q=fQTB[:CWk`?')$Ve<oC7)L1\donEE@p+NV6TLO([I>WD3te^>)mba-bBW+4dIr&>X9/G<
\`]A-#7ZAKdFO&A*PY0hZ<cRp5WAYL`1%2]A:+7S7AaA'5]AQZ>Bg-/<-;`R2#"m4Gk/:Q*c3<o
e(T?/eNqlQQJjKfa1`a+4,okAU2\1Apr8%UQK?gP(/:X*/c2?nM7/Aq6:7^$cpI2t8,?^lR[
IM6D#LZf'M`"[^$S@ka]AAp9&a(`,jB-of"KVdhiEM+E)"k69I3OOHHB.O-eo@m_;&_etu6%i
di;1>,b:_gKC\h<4eMH`>qHHaVuK7V$OEsAk,mAAPdATem?C^3pu%CH;P/,A(E6"g2Jf*d,m
=>e>$B7Z^XJL?mN*Ze8e,\l8@4UNnB4AV4MdkK9`%I,A,8W\hb4D^?Vc'Ct3.JE9GHXV3=HM
L_B1!KlWGf>>s^G-G;L[Vi_*B7r24'^XR4rGbk/D@Y=m0Z*pbp%YnB.;#`6r`'5f>\4[_(cr
bqsmc,)j8LDp,$<7lJrZ?l=?3QWfZ*8m[b`f1;G$Hg[rHs^b(6B>/dlc-2$?/:B"T7-_2RY]A
%Iq5l,e<Lo'b)R6^=s:7fd8#/kS3r8998sii&htMiss8TRZ7,k(KfeN)FaoH-(e]A^/5hi8`c
H>gbI@G;L`DZ?'%pfp!Q:GX(RHi@fT$29XkT(J*Mj;8L[_`PSiZ>4d,R"/RP!Yle.>mHJ54a
rdWe3EgX$6IjQq,YW6,"&T<`ibkYYS!(ESsc5kI^S;t/Wjam`MpF,jh7)aP\J4A_DQ[,jG#L
o6G\APPu@t-T=oG:>?3QUn1M)K<MlN=&)RoCJcqEN0'.j50$e5idc2)Jc5J'+Nr`(dl06T>'
abW&=-qaHShA_tr#=De*n0.RM*TVC]A:<]Ab5(JPO0Z@0HScK3E.+Bu<@??,i`\klQHUWiH\]AE
n*V:h6mJq/T1!###:9]A4b=uJY'-E(enZ4-C@-&P4OO)^Rkb,:73aNVNObRm<j&Jt;jOgmGnD
G19N6hY%(nWarf0;.O3In+[/'.1DJ(K@=EL/9JeV'kWd@0:;)1sH@R=jpom\Xi,$:`f?f"9C
.A26DP1<d^TXgZ!ZdIj/Y+FA=gEo9IfCn`m:;g[LeXOUC`9d=UDI^e]AJa]AjTjmflBV<tp#<Y
5O!%<+S&\Ys?ZV1I>K;,T'9D#&)ROBT.9%N1m<LjFKc4RoMC<PnF>BW>,F&4*qWKlN'qRto3
O^'%LINfO*+E-[4hK$.V8aj+=B0mGlNQZU7,.h)J*M\hEofVkmO[/nWkG5!>>JIIB\i"R^78
=quO,u$N0=J+/I1gIS5bjB[\&J00@q8Ha]A>$a(@3?3@g[m`fIq?41"'lLea]AU)=m\do&oRUm
dJAZ]Aie.iX59389c\SL87IPD-EA=CIDj'F/M_`<@1*h!Y0mhE#[,YTW:p`'luVjr@7>M80/Y
Y\*-PeQbm`Y5t;]A?\V"cp4`CP'W2*M3_hZ[Ei+;M[08CZ^+oB\Q3%^*LZT5aX<?:&Zcc;l$i
0E=d'l*kIBXm2KIiR;JX59)8pgAkh&iJHd+c'iI\;VDMSojGl94MD$uU-fRX<o4YMK.L/q5F
/F8\4@HR*&oDXQP;Z(!hSbW4aa\p$X[5\FHbk1*fE+8$5Jk7m539%KAkSYFlR!tCGa61I$p3
1qUI5G1"f?JX(.M$%*jm/SPk?"L$M+`T^#A*g)q)S*6U1t[o1.Em.H@/'_D$D\g`!5WRA@HG
ZVJfuoS672TeL$\Gi/mGUeh(j%a.*/f?0r&&^>IijTmZ:WJ4'=pfjeZ14"8-@XD#gV_U2(]AC
f.Mg$\qVM()bcGIU]AMJJVL`u*@:[lgOu2GYlBgpTGNNq]A8Rbu;%jY@jiBO\NbWiHNUg>3RrJ
d'T[&UPtGYq,dpGIu($%Njo/-Jq'3B!%2lm4P4on5TEIm1A^%9r]A:3QE_1!Z2VI@HAR4ls4#
eh>H&ElXkBW+bnl?pI]A\rRTE^jW"^PBK*?Ql8%-p;#$%.f.q(!1?k]A'V:HG?^2('s/qW+j+H
n"+OMnrX<PB$@s856G6cL3Mo=-35>-eX!*>jR]A9C%b_82Z05,'qMj;'*/99LjMCQo,,b^Z\"
<A^q88G(9YeF55&sh]A-e%Nl()a$&.![#.[DI@3+=hj]A8V8Ge#1`.JS7cF=-'So<H#SUGKp<?
5[Bo57#e<<S,]A-Y(MN=@mm<^qE:e<D?9;SUC^;9pUB+XBp1VNb(;[.nHB;D).UfA^WE)NsDn
;hq<H4=I]A8jI9O@JMR%jN:9a<>+4.V0rZX@A,Q%:87ZTWD(C;.ENi_2Q\KFk]A!WWLf?,bh+i
`q&^(SW)o,R[S=Y]AZh;L\5oVcqXoSZ;mjbqEoY;FJ2dVpeoc&9_]A<MP-*jFC+McP+u-0=_ol
qN)/[BQqU8D"W^P=mZ*f"K"<j+Y%ooa@EnXkTGp7'mkSpf5'4YF^m1F6GQJJl&"gI@F"[?0R
rm:pj_Qr_+P#%FGLs6:mKjP-Te>HdY^3?S#iB4hUN)PNXdW;UhQ&qMk5F*-_f/$a*:;+R^bq
^@!IG3S*6gh&^9c,HAAKf]A>U;+O"q6m22"@JOBn=EaX!i=EM!t7d,o@TmP"[>lI]Ao6bMuQ[!
_BPd*Z+!A)Z!_\"3n,@Yl-^]A$0/ENCnUIl>a1W"eZ*=;+SlQ$:AfF6UhT"^oPQW(ceFkU45k
aI"o&Gp6WMa[:i0:8/HHf6.WUp=4-r+NOr'phk8gV.ogEHS*L(1IBh-R4JuI_5`4rD`/iTJ5
UOJOfhI8YX4:tGcQQko:F,1Rf.r+h1EPEcHC*uhphZAd$*-!s&!]AOV(WFtY(_6b/2J3SO<t]A
pTlpZ&eo2gRud6>Ll3YQN>p>[WR/7&S+:Vu!%C)="MBoJLbb+C2KqunM(nb8Tl/ZZp_d<p6>
m3p`?53NYhZ:i07dTfs6D1.LPjqApdIT!QM4RNkc]Au`7d9cC\QFR#.tC#,$_fb%-;m$:i'BL
uLH]AW/M%:k`dJ2!5[4@tnk$jNdh]APsQqMkpTr]AhS<9L6AP:lp=Es9Z^aVIlGo]A>%LaPKlKXC
-rV:KN\&hND;@TLA%@6;&GfRKJoU0*g`H@;$U:S4tHtT[</LrrAi[8'VID,BtmRWOao"+0;]A
3(E]ATjQ!V5a07eV'CKCN-Ld=#s`B@@?8O$@I=%=VM/tRrmk-o%]Al5)q2Pu@17A^9k_5Y7:nu
!Y<-Iqp&"#fo3$D+r,(D7M5j&3%79:&KYG4(WPP1#F28\[AEeX5j$aeKrSWO>C+pW_`/ZkH1
7WN>1VNdnrboa.1cGro2?drR"XAW75o36AN0jBJR9I2EBlSj6TDu'59iC#0,Nb46h#[/qdTQ
blD]Ab`u>nC5V_/]A02]A:>]Aik8;.98T:C87eJWH[1A&V>1Hj?kimAFEAP&DkcN)%+Js,7sO)%8
4kWdSQ>Z**C%`6^&M$7*i9u52T,[ndIX0M:T)QOCYKTl?2f/?d,GJe,^]AJB+NMf]A&I!k/_.V
XR/&rc)%+l_,9,kk5sgTc@X)*!`,BB]ASZ6r7m?X;+t$>S:B%ZP+donp;n>sq<!<\h3?=Uh]AG
\0(0,:!i,!8e/GjsQ]AN53NBrLi]AQ/lof#Lm32EL2GffO$/'<QYAbU@YP,O4Nsi8+0d[b1%O6
6_c>N-skoI]AW'LG.Dlggca,Z5]A1b5eFEDGO"QNfY(28u#)NiseG%!^cmC2W\?i"k7c(#F)a8
PTAs$`9NDKeJ0^H)RUBpKs`%i"%'Eg)c;Xq!J85">lP#FfEh/<a+,]A#e4VH0_rAf0;g*P8[?
M@Lbss3r9Jn]AglA3Ti9?T95p<YJWW$F45>/;8oT.%cWVGkG"Qp+0=U$P=/Q\)M8WErnAL0#m
GIXfK`iA#pG!O4e7sP+pkQ_6.gP)*_W]A_,DLm'PPCDb!LR_h_6)I/$O?B't:UfgmKaK]Am93'
\m7*S4O3`b@]AZggJJP:fR-dQ'Mua6V+K@@b:5gf]AR-_*e$+P9f_Z5hT[==G6APPgILDS5bM)
TA;`fZY]A-V3AFO^pM#7&aW[@&@Va"h.4>'0j@$QSRuJ]AeO4:hZau['YjVSXKF=T*EVkqYM;`
B<m5b2^YWN=7f(f(R7Wi"mJOB,DDl^Ts(D.@:CCgJUG)J3nMT=MWa^ZYu4gb[G.H*(Bp3RaS
aVHUb3a2l,tU%Zuc@KbpLg&B`.Ia:cm-<bcQgN9mmB[0"b>S5,f`G3W0A4@g?OBbNc%;5`OL
0\SoN;ffd)U_@"3Z:24#P;lfHH:hri=7$$V:T4cA9L3Ar@1?0"8tqR1!7\N0?+%V?>miG;f"
>hgRf8EF*n>6X'<>>e'd\pK0CF0;c]A)3daiWBQ23c,g+:GW^;E>2586*N76D'YBM9g<43\Z/
KF^cJ)J^C1G2+9j_QW,Q?'/9G'T&;+;NI,ejZg-I>ig16T$^95&g6+Y(cagVf$/93T$DF1.u
E$b6@QKl8N)G(fDb^b=TN-=FTed"4qLKOOE;68P`I=Gi\*]A/(Fs[_1Q2eK!R0Ne7.9ED!&(s
c&3KJ12F5qUiRR\]A.f,,Qg3EPA=4F71ql!t<eW\]Aq`:r-s9)&5NDs+jI$W*;7%<#g7PAKTnI
uZ1\cnkP:KdYjLcPk`T!VMC>los5i0r$_"N)mL!><^^D;1LfH9%QJS]A1!8h+5*5eLmbp/9,*
U#[_Gt)2PiL[8E74'YOSaHJc&OiH6="f)7q\J]AHHra+NbB@b!!%*;NT^q]A9n&Rgug/<(DZ)C
DNGR:iIjbf(@TWP-O96T]ANp'GF/9<%p/TagchpALVc[GPFlO]AP098O(-!uR:'[Kj[bbNV%E%
&6KG1jnoUKp-*?IGFD_7'Uk9d'>f3B7f4MX^p8$,'N7<?th(3Ka<Xg&,B/!msbD$'akISb^/
3$r$S/$2`T.Ua`+;Na'3NWIcILlbQXuf[QZihu,*#H$h1MO`@'?k4rK^faL83l'5,&aT&cFC
[o.:eEsS'T.eL`aD]AjJ3,u1m'VKWAN2`%I(.Q]ARO"Mp]A9+<sP82>XGoF9@ic3ADE_Ee"H^<7
\$W'PFo`l!:K6.ro]A*r0Gmo+:cP0GCrtpdkT/`BPi=#m/h&jJ[bTe7>PkA.0G[c+N+I<tetg
jV*aF%QK[C%JLjG(cOGMSW`Jp<A,."C=GpsG\ULbY6S7p@'TZZDod8s`_3M4^@0"s[O28eG\
'\^,/!^]A1Y)!IBJ\JNrLI9,g82U*[Er?oZ*)ea4QFg5d/:+&glH,l%%I6o)L`C_ac[n[h#VU
)DJprQ[D`CQ/dV]Apb"Pi9kWO-q,L=4@f1Ksq)N:X%'q,)?igW3mN^AWs2Nrl<7l*Z-Y./0t^
k^4"Gje2^]A\BPJ)bTfD8ojnDjD"UV;D\Q0LQB2!c\>o<4UfQ*(T<r8KO\Td-CRBZ;h<Hjp*I
dRBUu1&CX=#b.'Yk@3H7[%W5s4.5MKs28?oX4i21`\bLP>c>f<3DD&aF?Co`['@PG;;$^H^B
8dIU<`rbAI$:$?S]A<19=U[+"JoUp7mPW]A\B;Niq[^3ufG\6VA,`]A_"F6Y4MZf#F"J-+oLFXM
>RBqtiFIr,2\XABoc<?[\:=*1R"L)MU(F5&?koBt,i0'bP*&79duBY(PD2:SrBUYbjlRmd8i
'3Wed*M'>[2``9sthtE8K9pC,9DHI_4W9db8F`P>C<9JuK/N/(Fl9:GJR8`t):8]AEfcZ,CGS
[@Tp8%lX@IoF'4<.=5dA$i&tXl*jHe7!OPqJfpq;_#+NAE[J`B%IP5L6=+kbIR_bQ*b1h8lq
`k8u!,&%E'NJGdhCp940F:(e(Pp/s[mlDiHAiT%"]AmH[H`Jg[EgMe6ndsjkAQ5F$a[Wp=r4f
'f_D>Dn)oK:c=m>j%SUHa&*-]A&WNY6[=@t1^r[_hmHG+sOsrH9g/c0Un]AUXsB$Ycu@k>F;ki
_j)YB9=8jcU"S0)Od4VUS%0Fb(_@,N`M"O]Arp+i&Y"^=i>Cf.:UVp1b$M2/6s/(T&6WeT\dI
/:6C8o&W<Kqh%B>2RB'2Ai';C#bmV3JcZOXDYea]A,/4;lLZ-&)T?cG1Z!)W+&hpAkn`8+@^(
Ysi^;fkUm)fsKVQ]AB@sC#L)tlGVNOhL2WC#"?'c)F!DMT:8n#M%Yh:TUh\Rc.g$o#bODc&pc
2N&KWiqL]A?]Ah&#BtXI1.SO)3ccl[$"U]A<^9G7iF/dMj:NoMhVBHVO.SAF`G8!\Ii?]A;j+&JL
5CSaSfG1NtkPW`E5VFD5^Qip1"P^VJmJbH2JF)uIe(f>kgdnE+'p.He?nU4W4"5p6h5_MNaB
f!PE7=9*=1(CVA:Pn4e.0#;r.Eh0XFZZN;S)BW8sle.[2!guMhMbJ(b*-D@Q^SuO'J.-8i'p
=Mur)?BUh/o@=SF_0od7\5)rL8r"U>3hljE6_L"!;3_VND%.5?iBK2/f]AjRe@CWG/^q,!5\k
3VB`*0lFo4ri:["pf"/NrWG:deMTPgP#:E`)J2G*,Vc?4gk>8AbPZ,4)/i,jeMFM\rjAoi5o
Y/bqJ`uF@n:i>`7P(.Hm+ajZbR>Ce_7;%h7%)F?gkd(Fq;--h8nbGn%`=WW'7&#upah7fp)n
X\%;.F(a\b\&*8ZNHVA2&"0^V%*!6X"h32oSJXmtIP,0s2lT:nJ$T-%&>(?d"p#b'>i8Tt]Ar
1KlNdG^K3"Y8rdfC2/p$%hm3QN_L1i#cFh/$o6%2=bfW#\P+mi4LL2=EBLCWX7XE/i&Dbs2,
4hPAYt4B11`.Y70EdQ'a1S+YROf![*bL.@6ra[OGCS!aoD"/h(,'Ztq7=WppZKa!Hg`n>]A'-
,F`B.['4>:km!,6e2e5n5ROAB9a)AH&Bim1&5PZ=.PuaVKu@0>W9/O9Ll9E%n;OcNaWG_X08
)_W6I@PfPtq;ZB6]AQlPTD=e)`="_eW`ER4lKj1I;j`da-AG:D<^M8?HsHf.Q^qr>#+8[r[AX
8X2QQ3(%M+V@Wo@jSu*arQ=DfrLL&2.WLIf@;iIH]ASY*(Ma;%s`mEb6'BiGda"^CgjWIM!RG
4"N8+Ics#\pOd(R9@rWK>):4j^<4HDDd1$tPjZe*lN5\_a^e8X0E$bFila9oc']AeUE+RF"Vn
qZl9Of1+Q@RR2?^(eLqa_^08L3"\mpL4*;i4Uh*NkTD_[dYG3lu'N0@W-s358>_moInB6<R%
Xp^Xm]A5ZFWs`F3aI,M8Y$]Ao9r'>9[$hrkcA?oE+R0:_*9&X7]A4CX7T7moRG/E#VK0%pba\-U
Ace,p:=R8Jqg"pLAX?P`U7,ESfMMhA$Pb9gM-Ej+Zk@OL[=n@F$s;,fgYbmuRRVFJrcG-4[E
[)VKe!Z^u#7M`/[=,$C$A"_/=#[^4i[aRm#*7>.?n_:e7dP'<#SIEr\OqWA`@k;Ys/^)m*r6
ap[q@AcO6@Oo[=EIt6/BVhg]AlROs<Tii[B0i$#`Y3_li$2K)//u)-"!_p<nGao(,n_4-:A'3
7G!lSL^.qu.U=t.[Rqd'050>8-D.&OV"#Q1l\WL2A$P6/Uq"O+g+k7G\D61U\bc6\"AdT8+%
X>`I"-"lW)i@^*:=>9Lj"@cin@\Q9b^+2$jBA_qY,5dAOrXj1$1o2@?J<]A-mGOBQrm'Ucrm7
3U\8[`dSD?@).nGYtRU63sOsI]A'3L']A8VnNKoi>nGndhZ^jL#C)W[O:pbT;`4N0IHB,@q>&f
.6W_kCF:>=6S5,;;&KhuWl\G>$r6rCo@'kd+8Z/gN`OmJDpI]Ah!u<'4f02?$SK;'XEf+&MIa
p=N4GZ#JXcGcB5LIk=dF$Mo:)H*O)tm.N\<+r9QR"I)%#Ji1U:Q^!X(T;Y-RfuZPsYXZU<P`
S;)@Y00#f@GYs"_S.4gjGV43*fdX0--f!ng_:hI:j03P#$)V==QHcoVE2lpL/kdIq7rTV,.<
&Vf+g8AOYA8-49r;KEiGbVUh3?FmZmgD,g^^IZ@T:5jH9oW"]ARIC]A_H[=F[PN%h.>OV1*`V%
?%7P_L(3ZFjJ2jK0u4@VNXaacWi.1O(S3G[U/]A"tma'nGp_,a@Ik3gt)IA+GiTo4@Re)p:n6
#O9e;F<mER,8&HLgrIW^QiGcJm$mE7\\>ZC[T>2b;dmmPrpa+@HYTqJ<h>"-E6^(f+<p:-qn
N9Ro5_f4\qh-0oe$g]A\u:NdU*t>I%[WhH&<e%*985KS%bo^Vmt)4W0m1G`pQEktdiij.!;jP
<<f%C7ea?0)#B8TIUE4(m+k#;$="E#eVi)2UXGQ"mHdHC0Q\S?$CF`W2_g=/(r>me:^K-3o+
"2bsnL&+!Gc0o-F9$Vi;F%L;95[7aY(Lq]Abdf$Lj=pV$G<hJcUQC'IBLH-.&.u9iSRig2r5h
)NjZ,u7nChkd,_a`NNa4%c>IXeV;-UWnIAaZp;6@WegIaempH2Gd:NsOns3XoY3]AV!qa^H<&
Is+m\D<6V7V:@N!86s%[E;k=R4%iSq:RL&]A;Uf`8J(Zt6M`;=CSd'$B?[s&7!4ocb:_/9)_l
Ep/9iPZZo'?F&krJWCYNTuhjH)$!l'Y8qiC=C[=HRC_km/<Y=%t9%HU%LD`!3oc,Qe4`=La_
Dj-*;(L+a$6^rRBWk@DOH_$pI$mlf%Nlb#8Ecs`\?'90C;'?5)s9U0QSYi4>YcM'+*irN92C
sf>N\.'!tHW^?$4qoA[fQ`)#?ZH[ZmsS.J)"XBdgaH>a:Jc#u;he9QBU#F)WFI!nC+dO2(70
:okFXG4qU#/s`Tg5$[kc(XI%m&*R.a%-&[L0H?%_#m&!)@m`@Jh'nKhm)_U+fSPh7/9"ZOLU
.I3QrdoN\N6>^7:\GQ:=+9:WsM`<R+7YOO\X"MJ)g3]AFJfjWJ]AnblBc)hZrNrD0b!b3]A$nl2
T<L%(+l4=ASPn^s8,\_j(78T4$DcHBr&j*q^NOOUIWaVc.El.CQ;=f_':ONhb(9UXOI-g7W?
/6@*_r50pZ?mkTTG_pNTjmf:]Al#BaU0De*TM=M5!l_DXR$*E:iX]A:;*u7t1t8m=7"cW$hTIb
HrSTlKP-<J5jhpqU`]A_?5$m^b0H3?(VPu,gbN!I^&#o@BdZ;e6Y:"OdTO\@*qXqiYYKB?lh+
0?YFp&s7u+6*,cR$majU[u#Bm2@5iplS^&g7O$6&0EGJ3rnO6P3fr7hBh0@!Mn0cME27n3UI
kf"8EJ4f@'"uH^u>7+j5YorY@YHl0to*Ubu:a^IRs*bD8lM&&aILZ]AXVnP#.7!KK:YW`UDgn
aB*2RrX\lArdY'll\a'-WV<6>uEsLtm(qJDR3.1"/ES!7onVhT4QK]A^[PS@DGP:[fWM1]AsU9
]AaV9"kM'f)4<h`I$$=1Q[357?FfGV3LU)kVpf(U0(V':]AKk@IKNSi=#:[[drY#s;i'k5tMZR
J@,:\)eeEbI[M'Jd?^B/&`NBmUU9.(Uu;^+UCC5B`sKhLi=OWrb^q4U&t,"nOtJtDKQX;:7.
mH$Z%"]Ao%`P=G]A1Ln&XW.27`>l;PCbHReE[\4='("2/iSgEK=+rKlg^SVg.KujnU='IR4CSu
F3Q<iFf,Fk`JBqpQ_Ta&GsA'+,h0G%:I=q0X\`Hd4UHXP9P,$Z0p9h>Kq&F-.DYu#ZfZ_a4!
k1S:k8[o0I^fT<2YLF5!1@^c:h5ul!jXZ$jp8kn0Y%<`ZJP[O9&5GCaL40eL]AO[Pjfm"`get
j13oQofA%6FV;&20$oN>-UVnB,)JG(?:+P/Tc7*P2):AjaB(1Z1`Ds0V'mW=YqAc+ATB:Gm/
"n:+"$U:1KDUoJH.5F4BENdV$)""pj*K0;TpMDe(%?[Cr#B"*;9@CuX2*8ZUZQsM[7e.3j9m
?L"CucQSD:4c4.lY^oT#Hso59h"m$)D5Knp/EQn!Ze/VFG=95laGeI^*Cl&d9L8:Q-QYR?/n
`NE'5V7p4#=7SpZV#M7bqEhVHb_5(MklFQPWeonT^L5hHa1i[*^1-gP(0YJIHWMJnlXOU]ADp
'QP7'PpQYO*"tmQRC_9?\'IKso6=P>/PJPf\]Ah#-sQC]A'BOl>nt4<abV_[ATX[^!e64RdB[E
G:4CZ1mtDIXk7E\V;0rpcY_s5C?<B/UTk^k8`-f:Jo%Q3r/fopjq0-em1$JU6QX!kUGOQj;5
^=nU>=nS2gtO=2,9L9k`ag9e5>5obk2*MEU=f%[F$t-c1$r#3C[$BCW)H8'7Ln7C48Q:eE:K
o,`WVq1C-K\YJn+I/n%$+WF?NoIG"dQ!hDKP+?!>jH7PgZE(Ws<^lP;!o^fi.8es:@WoX:pD
?6VdAQfrpa3j^p+;0V>"1Cg6@m-iMa'=Mb[HA&bmk!i1\O^Y$Rp;M5V>I:"r(:)nMha@<@!t
Oq-0L/Q):06hZWS.p,K&=$,:'uX:d0F"?EImI=h&Yit!D(V2EG&?q0NO,efjscAa^#<ga#gM
s7bUdtW?nOmkrMg*H^P.C[>;;9pEM5:@/W,@T/"UfdR%?#_c!.0$uqr0d^Mg&<]A':n#b3`M=
(+2fL<gYr09qD>,MTj9]Aq%,%(jf#T("?Bh./sELXX%uV(B\bLbo0Z%"3fl$#p@N5Aj"EEhQ#
2UE9!:"U4NRoANXm<R#Y[R-4_ua1f(V7*q7kZrB+5[]A/aCCkQr0'_f!:*V2n72<WQO@9o^;T
Q")2rT**lt7Mh[n\'"-\=H>_P4iiCqeM:Cb!jX^6*)Mo)NfE0(moCoY#9^<iSeIR/ar7k=m$
^t%g"O.GM,XTE0Ve\XkXoD:ap(L#RI`,kO4j3!:o\=HNCm6r[6K.^_J&9&]Ak#lKli<<E8olO
bFaYR%fQ$4ihML`/qM1A/C`=^XMQf2%PS*[TI,+Lb5CHe`B.r6NU-05#GqcuH9KNT+QX82=4
A>(@O-P#ge<i+Nmco)A<.c\sCBAu=JUGQ,6WO<hGYWbBSu!B%A$;TJDo+&1BBtFq<>MAa>MY
8&)4cN@m8X#\-Y3IlCY^lTh^ejRV&(H4/kM(bYNa0u>Iut.PAmQ]AnTsNh"qIB![U/X+e#[us
Q-pN]A&OOq3W+c:(hSnWMEQI]A"/g5*(b5@4ml&d-,oeP`"gV^6cI#D&kqRZh7I#1*#8i/V`,m
<6>P\\NZ'btY5FDQQE4ZW#p*pE&$VYm&?)FA1b:dtD'Hj)*&$IP)D<c,lL]A5K(PX`UU0]AXMU
F3!jI@,Bj]A^Efd?8)'?7Tf3tq+'VDXBoEBQ+^pbZuAlg'_qIREJ;g)S\Cs@;'J\Si`oo+Q=P
AV91V<`/0rgAH/f#<jRV30B=r;0+`(tCj:Vt8br"a=+<gd4HR(6UT1:]A:?aAq-:[qC1)?BdZ
5^lPosceFEg(SA/:8D<poCer4._=+;i>f3MDIHJC%)`'5$Q6>Hb#RWg'9e7k:h^]AAl69`1@o
qR/p&rno+2%71&s2+a,6.O>YW)'0.T(%8*tCtjm]AP;Z4Gpskl0@4X7JKGj"\cc6/,aRo=kZp
qeS'Q5JdI>/IIoac*t.EJu:Yn%o?/aKjL@Hk=?o)q)o"0Y6cG=MtHP'YPNein#!@jqX?[L%8
(?Y3mHSqEHj-oJ2i7'4SOYP)Z(b<%9tll2@#hCDmcC.ICZ+]AB*_nAOpuJsD@PH=b.LSO99t0
,TbbXb$50DPrl!AQP:o,g+\H=boM&`TEOaJ)"AC<e4NXW*URKbYfACBKM![^N(PmW<AtL[Te
;H!=2oHoBB-#(:cu3-RLVChr?/2IJ48-f>/j#VB=V>m6nmlQ*<t3nOKRtIY\9D-?2I^VM\'\
Fee&?[YOd:f4MB=NZ0/(7?E("24^r.d]APpq:Cnh-nOZ#')C?U?7F88N6L?ZY0aWi9MRGPT!5
iD9\o(D/de2BA[#8UF.tj]A3b\bf534>X&iSo/+f)sH,CXP(*!;@HEl5Hm'XDl!or0^*22c4"
[KBTPj0Gr4EEgW.V@S#rud<kGQ3$WMieHAW'<<EDm*SUdj_4LH"+G\]A?h(u"FDX(UWXW)Lf@
-RHZd$X<F:?U8!?7oLOZM`C14l9:Y&bKqT:FP\Xd)%88_InSZOI_uHK2q4un'll<6b(%+NKq
U_:NG0$FuQ*-3/0U/Vp[\kq%K93k/24eiX[DPo9@<;YrcXga$OJ*7QNO#[@=cnRPg%@=Z2K0
]AI?3JZ<MKqbp>)q-9o%g,#"N$dJ8;;m%HJ!OPRnRYl!1lT!96]AjhVd#_Yi8C]AA;]A0$<,I@K@
F`aLnYOA_lpakg"LMCRuG9uf*fDhhg+LB>t6Li_,+o3g`HLEV+"U(VgU%c=*_>!au=j9@gqu
t;CY"Mi::R-[0UAElXSimL=@./&:g@Y8Z_-S?6[oojuekV0E-?HgCq,-mTg/B<0`R4(jO]AM0
6/['9t\p=&8Ht7BYi"iJngP*8#o:O$59m%J+F;F'*Qc1%LQ\LK`7-V$PUB$1ub$[gh`[.\nb
X+Vq!)1kjY!+*gn#;+g2Kn1X0h8l+lCr]Ag:YPXe+!t6U1^s*mUH1FeTOKiH;opF3a57LVc-*
B5u75>,Hp@6pI_agAFsjqB5j+Ru$$p8.kVQ4DWjFdpbD(_0+d!Etj?NM_X9`e-(`o;kF[A$b
BmlS&O7@,:P-7'epDLBh,)ZV/cMnN.jrcU\siPFt%uS`(9fgVrZ+d:W-mPC[F\PXVkkh3@l;
Q<knF$ZcG$1ogFQ8oks`CG5oT;o.Kk2a'5\"42(Y8<ILCHn)q#UlRu<<57KXn-2=&&<TmcVk
E,rjSc+!RR+=iA]AU9"bKeTRnY:&kQSN#S/iOA-g(.4Y-cW@Gu<SF,>_Y;#4eW6R[4h"!4V9U
qi.dHW^lSbe-<UBbY@Zo%2p$NJVJ+T85]AYDq=p/khlh!`GCgfaYX`dd:2fB;jOrdE;h>:hhu
l0j6hT?iS5EZ!GF]ADim6+oZE1n#sTpO7Z!2I+Tcom@Ue^cIui]A:K!Ll]A^tO3ee=+8fDdugGN
QMtj1VM;Ds(r^FFSb@]AjBj$OSN-X4#VQ"nQbgt8,dTHDAQLU@t)t/Q'_Na>I4-q<hJ3;Dn?G
TIPCEmQ9"ekqg4lqRJW;rX'0).[./<IAYK)YM^n[J5O[^c/ACd4>lW@'X(PIT8cfs:l,t1Ms
&$<gF\:7t:[m'tp\=<njNG:"^;-nkEF@2D?i5*DgoUI(K)TlIq"a\iBR"?,ec-;PN\!><la]A
*cC##IVJ[O6>U&+WKF3FM3Fl$C?SpkS-Y?c5,CVK,I>cF$/kOf1$\R]AaJ8.VYCTfi'lWFm03
Zf:c)=C=!a$#IK7F,S>I]Ap-?[Uq5=U4`kb]Aq<:qXZR5U_lLj<2&]AC1k["V>Vp(UakBml7k*L
:QOmF';TgM8lhk5X?33WDt(R6h/!]A3hT8f,fe(rAM@R>8:Z^0eb@fKf=':cHCi8hJRMn&sci
KV?Z!>"Ig5`JlrOu16S"IJrpk1YWu<[(3MsiRnI`9(5B%gFK%P`:D!3lJY#?/4_k8O^p$Z<7
h$FqE7D[#"%Ne?U^$gtIreO#A7EH.s6KD+.VrLMQjAs<cil3`9Ef1J"soZ(U+hMVGX0MIE.t
hm>6o!:W)9<ZN>aZhe>Q6>7ZA<DC=K1ZUIL4]A2/:X>;56U?)Du9ZW)9<ZN>aZh'LbJsR3sKf
U,d]A$^Eq.EUcfV[UIL4]A2/:X>;04L,.`:[BdI&ZJZ_rAaT!!Mpl^STV!!~
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
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?_N`;s1d.e(T;^/qpa4L_`nRJr5A?M@`*h;%Z2E;F%ZY9/.VWA4]Ali'%F@G;Q'aj'hB#hW'
J3DM(D4t/<Mg/!!*.XL`qLh5W5qJ@r8,fk2&mXm``?dplI:qkPWWLHd;5qcguJk^(0l:BZ9f
_!!(rPJ0P;[!s$O4^A\#NLR-#(VZV\TJ1VcB#7l3G<?[o<fas)>8iZjWk#0Qgh4$#VF`3.`r
hK@7b6'AE\bkurVk5"-EVTh9bMBe*c<`N]A/Eo5;Z/U4_e"LQu`a)Z[C&F\qG*s(n0_FiUl_;
fh>C3ecBaN%$nr5%\NiEBR5b$'fgf''kJHk1gJc#`rPqocZA_(K"cSIBm^0kY9;*V;qE9FB!
^)E*BjjscSp5OLc+,XB0>';[%C,Oqn0;QsaNp?\R)[#!@gEKgF=*3B6?)`>1YcZU]ArZ&/]A^[
uriYm&S,@l>FkFkbaVHs+nVE*%,^0ILgcqoFa7]ANsCP\*_as4U#'i[Eb<e[LeddkC"!C57;=
"*e0Oo06.<=)rdq!2\25B%V<7K.l2J(DV)?m5"_B37rU5Aq9YNem$\L@F@H%Vep*K>ePkWV_
su8T/hU9bd0beC@#a_r:*qG?"mtf+H&SsEJoru;M<<CJ5P*!c/%Bp?D[NsdOlG)C@K$%*9#B
g`lg$$EZs)Hi&#JNJMh)H+D`=Z)\<"d;A(5c'@RnY[RuE,E,?U3E4+(en8krZV_LFNi+Mg8l
Aa8Lj\<sGg3#mEj(1c#-USMIO@p]AAqpt:jt21<33CNa.+qfN#PB/Z3B%I15h/l$8?_LY>!M.
7+dEsuQPa$gZ2/\')^NMA_n9hpoFHh%VSQ";dLFZEmB`i*F'i8@SJR,XY3(u/O7GUA#Z'?LW
?3mjD6/95,,[8#HMbK$47dkQq<6;g-hK(7PaJ*]Ah!Qu$Z2>q"K2gtK+[I;s-3QuXG#kXqCJ-
unI>^Fpkl9_<VmKBcX,UHJr%-"VT"f\c!1o]A",Np.gA1UjbO+1!^#O^lKI)qrfCbG?);R59q
b4W"\HSp)^+@nTuXEX1p6\X_DaG&8nLG_M7*E,?#;Y.pc/*1MI_j3^XOL9\7P+CIK$ZMmYZj
0M%(W((NFj#KsEB`Mn!CL7N,9:,KVJ^Q;Z"YN6r/[fR%WZY`;JoK_]ABc*q1oX"tc.>^uEs&+
DIDr,t)+DcJ<^+6Yc3FN?;O6#tsA$GjTJaOkd)Ge%rI1g]A6sMkp_;n]A%`]AQ]AEd28_*_^J_C<
_QF=#^=a_mk9&te$Z=70HFN\Jk(XK-7e*L]AL<Z]A*C+mGO^I`,dsk>`XOqegYGVoIX_)Xd,r>
#oR0.q;\A'sHB]Ag>eM/4i6\ld1`(rPCL=<,7$5JXPg>H<r@BjHEoM)J+NE8G%P8KEsJrhh!V
,.;A7G]A!FCe3H,5B`fKhr`8,.5W^b[^q#/c(:=dqDNJ]AP38%XW4bj1CaU]ABBq;:d.Gp[EdFL
Ep7e-^9bM)T?!/=4V?>r\m@^1`9%ITcTCZ4QG>5!mYMo/-k.sY8h0e63Q'J&-u=UN1)mX([k
7j$VSk7gnp:g,F]A!.C0b]ANoJrnFN(>K4'(n-pf2.f]A)+mRI"RrAkMRdUjLqY)VDIhmppIEOb
6NA*oW<QUi`Bs=XR?#u/Tod,O=BUNkHEjioC#0(X3aXi0<-dG,_LJ^u-3>K,;6B+H!QIBUGm
3Bd<hlj,tnYUtT+f<4mS!<GuU<Ke1JNpZJ2Q@P^W(6NDD/j"#^F4lS684N_nDg4Wg.9)=g%0
'A9GNEDNna,.?hZcqcs@g]AlOoZqDKuXC\Ymf#>.dX#.W1!I#k@G@8gIEXP4<5QL5iMR]A>]AaZ
GVBCc;jb"Zc[hge1&<p`<.++qGj<E&Ir.o`-[GOY!CRo5LBu8tqC(%*fnPSd0Ho<+nJ?+[QK
3qKUWgX1+>Mr=?g!I`6`@jVp^U(JC+OqpNHu=njPn\ZG&\CP/*!2*2W@'Z#=8:8Bm8hR3Z=&
_mtZ+b'Z%,p^h("SmU/ePEQDS##GROMLQMBf\rdh_Z!a0hr5mc,P]AU0,eYST>?MeVh]AQ9<g1
W+R99M>+?ILIBj=6.Oc'Ec.h9$`*kPu(V#D@0!6.1^ID=7A]ADbiW/[d?@4(`-XS&0u_jX!rY
E)2AiB[ap4A[.HmNL<u>r:?:A2[TiOOQ#:nD5BDgop=&I+(G2ZedHC?8Fd6`^p.dj&q%?7O;
]At3K`NUbFi-"G2Y$qn]A/,5\ptW/d+a2TSq!Ao[1!MYD_)s!cn]Aph>=b-l&D9oL=k-\e!++ak
X1Bo5$"H(Y9DT'oO</nZ%jKW0rfSASY8CQrcR<20LUFHgPgSrR6H3&5"]A=fI.sK#W=",SanB
+[iXRJ8A,%RCoSrofW["_J$I&njSS+"Q6GkA?,4H4PQTjfVkGVaIJ^c#b4Z*gDk3rMg^4%_3
dVME"WY8QDB5cR55VBkhE,!;IiWk*Ao$MBjRLVf$,'n>_;H>`@/Z%RPS-rrk151s9jM)B$AE
r=U[rer?X`k^*JK_LhtFE9Q?kkFW[2/ZBNgE'BUNmq,C:"-o_[$DQ?ka3*9[2]Am?3NBVcXGc
i0e&A4PTS&o@LCGW90N-#GPS6c&Jpl^nQ=1s/[.,/F6fV[CrQFRpcoR\i-A:FK<YCGRDGrn-
SUtPi<bN,k@iPGF#k]AG<mYUge_\O%kI$@dQ\,*`'@SYaP4=)hu%I5=BfX/)+EiK`GG9joLaI
IV3Xj@Q$F9Q5>B&EO'Qsd1aO?PKCK8Ga`![B"-G!7606%+-^#g;.4L9fmF.><*HS^r2U5UV<
jCXrLLnd8qu0RmU.jq%ldh8<"#N_4p+"gS56[=IA/![t_b0VK+-R)C,E6h/&ut=>(*%HoC_u
Y_(&a6Q[NOsLgn1?@L6g?,SoaD#:n1AdnPi$N.37@+jQ=qi3a>#1gW&6().>EO5kPO?U/b#Z
PftuuF%fc2]AR0mnrrWa_3PW_+KQ<h:?f:-G$5_IUK1\ZH>g*NF@o2["C#*<mAJ^l1$@le]AA,
]AZ`BP"R-qqg(I9Yfp]AnoHc0l`,Wa2TXXk,iJ%,^/cCCc_)P)e[[LCY6Y$b,P_c`0PQ&$>m/#
.]AF![FZqad=8QbnP`V@n$aQRGRB1Hq(_8P>&(ig820cCtKC"prb==Sg8[d\P+=uf^]AODV"0m
5E+aCM.'UHEcY:MX^!"I&FpRdOfBH<f\#ho;c::eM&M*^$JX*F/Rcc*="_qqWr@*[Cc6]A<?u
Y65A$db`*r=@C*VrLOg'a_J2s,Ts6=f5gbCo(%:#_K+!HQ<2+4Ok/=NWLEccXTC,Ba37u6Ch
q;`_eXNKg5pRP0\D+0sDGYN@l2CA!KR-';M;9'eHqofk!XXR+a)'[^/1fZa0!jos!XH\f)Q@
Loch.rND`Nok4:dPm!*d>MWW\UAIn4H\'0gRb?]A]AbVEA&'dcFM4arf5OY8DX"d;bR3*J',u\
h671Ebl(bI4\O@mid/6GKd/06IFp+,hLH-M[]AM6fVF5G^GYC;r$dB2Dc>-7O\:e/]APA@L(=3
"c)1*&UHU5/F*hlDZn:mBEnCG8g+O465.cDikQ-(F?-N:ZI#Y`@6(\[3p_3YD[0tgG"8.2An
2f,"CB-mu!uID1X!R6NhmqMeW$5jJG0Y@ZGaC/dJ+)eU+VS9sGo:nE.NTa8u.eNuP;O8Nk5t
'j]A))'Xn#f,)tTc`S*'#4'@L%#h43$NYM>sADsIB9'+^h@$JXnC#_1Wq1W-6^AdXXRp92tMK
kqg@JR:Bej.EFPP>7ro&nL<Qbh^tY"=b-C9+u-QOgf><s23b&=@bXdG_m2Fp9<egj-n6jPFI
c94rg6O]Aq.JWbH%6712X+3W@YfkH/#5*'j+:Mgf2p$H-*FWg#@Z_7l^C+\8j"gDobHif<q_J
]ADkF#I+'a(5/OGQ@qrhH'h:nQWfo,IV"8cT(Ca*rc6Y(8_f<lm^Lnmas%`:A^"j:SgteX;N(
!;.jRh&e6(dN3:'?dO>`kj_6nsh3g(9Fa*#WQ@BWl$;+Bljf_hH[4`tqPgj*cJE;==l%bLAG
;d0K\48V$As05,H9S9UHVCl>R[P&5L3DH#>fh&QMYD2StUNR5k8l:3f1V0H2?a?i?l'tVoql
$fYSO;FCS]AJ?DMc9l0<Yr)I1f;:Q'HZk/NUJ&\2:XW;4rHiu*^SmeS:YpaOZ_UKJcror'7P&
]AX+,GXDW)<DLbh0@iOKb,B0fXA.!E`JI_L8CErY`UNcTKqAC:pXa47!Z$2Q_pg,EF.:f\&`n
)fJ6IC6R4Af[+ir%jmFMhcUehVjdueaY:(`#hri9OnMpk,*S%Ed".W]A7ZhuliN$_G!ja,^%>
+,PBqI@22%LQp(,c3DsBMe;WS8/Lc>9sj#6ca(o"8,:'4fn5g-ZHVAZ#!4e%X#hHFjS2+R5i
_BFZ]A+409F(n3;_UHge3@j+rlc;A4%ms'>MAZ_<V0,^h29q8cb/t]A4l#8>qRh]A>>&!BQ5fhn
X!^)g$spG-l$@=sIfTCR66)7uTBuH]AgD@\=u!LVF>Z8[#6l"LLIUT1dZ,P!^pK3OD;n`P!&S
_%Pt6'?N`-Db^%KXT9?#Z11Z$H;9_OsJ\t+&HVA1>W^5PG,D3F';,O5INT$I1UE+@5?@A5ei
4JR@G4LA?em&W$7N"^f.LGXqITZdPooLp+TSK[65JVe59?m5ulquYW&cJ'"4T\!Gce[1a>c!
EG%/ma\k8ls8UTMf6F5RC:]AV+)7)/Mk.[oX<_cr5"ZR'6!&)-I\Deaes5U.c='b^:Q(*6JLh
)a:Tc_V)pt_JXEi^Jod\dOQE7X,J.8@RmaMTI1`P6_-`FeZ@ubcJCGOnC]AcL%X<`eN^ogiSK
Z^)ArJ;>1aYl/gj`laq2bF'Fr<:E-q>i?SMM&kB#?,s]A85E^%HlGIRjheP>l^#p.U[:ll"^J
NEOV>iI]Ae\gkL6>Q,5q1$B1$et"T/Q#Uq&2/4,H=^,Ed$MDU,+rVp7L]A)>+PY;d\Jbk.6h;@
r>:ND@3MlW^d^^U55*[i"!BDPbsJ<h\Hb*5)MOFgbGhO?=)Fj:Z6G,RkoO/mXMAiJ((9!6//
l-bWeN-2olAKMX,l__\=`:4dn-`j*K&p7m6&H1_O!@L"Q3:rf5Zm3/b,M,/J1P/j07q+aXD-
NGt)fX6@p57=!gO&\]At]ALPsir2'7@<nK;Sgdo9<UKLUR;5I9I(8"/q8Z!P`t4ZfLl'TWg;V%
bCjruMiN)?[,+[NlK2/!l:o<R^cg+0R9!FFM'?F_cE]A4Ulgp,HR?_*OI-ihTUDa#G-O?%a._
cF<'n"7SQIA@H_<=1\#q0hVB[+3CcTH-M(nJ4/q5OlJ0WS`^$L%]Ac=pkHf[h"=T\rY!i3Fad
o)V>ABor"<=cA1fd,=ROPGTZ':1r@?0&]A9Y/SrO)@)N17O/QLl8"Drn?cZJ/c^0XW2%A\mV0
""b>,PVqPXW+$@<&U0[PK7fqkZGUQb?c45MfRPbbaH`k$0Dm#\36bB*Eo,H@a`KLfY75q\96
:edlKooAO+/hHYNPcGZ1>nIe;FXOR^CCNA@*o;S\]AW+nL?mSp<D$.af)H(d&f(cm>^F#,IZZ
..:!RgG2+jTFr,J8SFOs%j(>@G?)]AWtJ#)YF".6c]A-QKK-URE+cKh@L't9E9sM4!!((j_/K8
g!:]AgCde<cmO#I9W#68#;a?0Ilm.,/>p"P,R/6DSGeJ<12kR%=JbJGQQ$"(Q9n0NGg?c&0!-
%$#+_O'a<HjO/sQgc;K$"(RL>MKY:0H^(?,=ssJrr<(TJe+$Y3dL8Q~
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
<BoundsAttr x="0" y="0" width="355" height="100"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="65" y="450" width="355" height="100"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?hZgP%hPKEI;D@R`[@_ZqQnQ/Z6fT:jGTC.]Ap0/ZaYR!$$7pP%u`Q,U-POq9[d]A*bTe,co0
A$s.YlI#),F@hW!I&>W/-8""9^V>2>^ZpYJ!0e[GOd7&$XX&\pi7P?dF/VfDkl4[;YNZ"nS&
)!rr</G5WY!56,(O@fBJZAblS^:a6)CIb;+[B^<L!iX*n^V^9Kf,2'.g6^/OVIpMZmmD><Jh
g:Zj>Z#J"HdAbMh[XqAd35pWO14]AkX=Xcca$97_frp]AJY%jAs]Ab6QNp&:s0GN.0M#J\Hr>t_
e2F5P%+&Zo+#f`"6Fc2.Oh$KLR$cu(a!h_:J>d!NhA7)^@"[BEHgRr:_oqhfd_Jark3*PfLN
$$NQRo_?VMN=eT1D.GUS^^%(j1t*)A0q;[3+1kq>Z"`<?^tjab*A`%Yk+/]A[1Y's>Zn7K83"
NOZCqC8*'+%ku!X`lHP^T?07r8?T/M2]A'/"/$iL!ca:#YPE3>d4T=h/'>@L[PKC0er"Wo="S
[Ap!/*A$:8p9N]A$:Q%S7L+')'a9hCTl!<mj.m*h7'3%nMnZDVQJ]AinBejR,dc`2?<f?m@\E/
[CT@_IflXf"4"?2Z^&s3`W77I\g%;LDo5aH["]A?V3%FrqHZZpA=an]A#Q>q0/06@3jifqeer^
gFb@o3bQgj8b9!pEC2)-3q36)IuXp77@,GfZ@REW?$<EOd2TBNJ,^na@q>O,(/("1LI(Ta,W
KnOSooEQ%HTZ3M^)QcnRU_K+9R?S30coUCq8>AMNf;XbaP->KjN6<*SkOf?F+t2slF$GVaE/
SJLPB<Q#=IMQr4"[&`;UX'YYj+"AZI9cpA\(#I+-J`O#Ud79XKS9fbDP;d%<3ED'`Rc%Q5Ch
tJCDYD>#\&sE-f7WV-d6afG.KPj7S)HeCTVrB926hY1N^`'oQ7Q>dN#sjZ3W[+0_DP')+cS2
O(tT&QQ&MBC9RCRhC^RBnU_f=)KF'WqdTV4T`/cs'n<^#`gh[fPsWKX9(c2h5/:tVHr#K$&U
2c8KQq5lua=]A`u]A.Yo3SlaK'ktBNjPBIpC6VNHt4U@-u.\0f%*k([4nbPZ(IP%V>FG$]AH\):
BW8X`6_7Lu'3.(DB,FiP&pGKM<H+E>hOB'KQ'[^O-a\Lt%+c("KM@SSjf4+V$+o_!U/NH#;h
#KD9+q!`%rK`>P`e"%Fqj[RE:spXpo]Ad<<cc&b+_htCjXl\Bq(@=)@3M]AV!CMi0U;,)Ns"*]A
[dGuph5WYRu`nUtQ)ajHK4jH%u4#:27^sk%Nj*^KV?J*mNAG8uHYq3ZDSJn5Pd:*3L4bNL13
_VskH!LdAhn"P,p#Ocse<^ud1ksBoUOK]A7d7fH"44J6diMB3)CD[do">n'Z[Z20-=0dc4aAM
'B7TsgS;-]A0Qb\L]A#+rdD1NW*mFJX4r;-gqkh:kq+q?(,1833unY^a@%co]ANT9^m!(l9@G4d
.2I$;NTWNsM8mD6?ZseL:F^.e\#9+caYaT`C3Z5I-Tc9bmNbbO79oU&[!3q->J!2WZe\)8]AZ
[->!Ap&SS9?Z'H3&d(n!?^mi@[t^ALAF3&=3Zsr3iIf\<8!A^eB2Zi4+%j6Ece;MP)HBFVEI
$JnCgW;^#H9=4-):Vji;4;*8_=ir/YNT[rXR"RFcN=(l._I,X$UC/R8KRnVXkD9I'BV\ldMA
<J0r&?ehZSb<dS1GGWtaDJ9W@TEq+a+@^Y"EpL<Z6!FUOmt.^r_)?bi7\[n&7>-%n3oIcYEs
.;n]AIc(\P#tQ8'YaXOVpTF`qE&r.b.C)7<p?I.;M11]Aa8utd`RFg$GaQ)1c0iL$X6;i1+#"U
A:o:6/&IBlMiiWcl`Tom%ni,99:%e11^/u<E(AqF"dndPn@4-B/&7P^[X5p$e""ctFjj$'q$
%[Q(@NUZ&SSu[`4r9#qo2DK9&ZSbC2t#DoC7neh1""sM.rnjdJ;LiVpVRahRSd`VS!kOn%WB
DSOoljUKaFm,!@92FT/#KKJhs\A5C1MPN[?=D=edsKU'pEY9>%0LD_#UTou.%^O@3GKV*F-`
p^uj+!SQ>n.*iOEV9j=7Jb18Q<&PJ0]AqE^;;_MlfU;.Zdb-0OC@B\%NO!Po5pato,m#C)(GY
4T!.s#eF)Ur@d]A,8f+\/;'qKmZ@)DAk1dog_m$?'X!K1Rjq^j6]A<@>So8]AT['<#Pn#C<\IuO
Fl;nK:=k$md@L'=ooNJDbA<kV1p?:TZ]Aj,5%t$P_7euQ.D@Ee39RN/ADnV/Y!2X_1C\tm]A1S
`Ld_c!7Q67#L/ca.#e@<iTo[3OZ_\>*6Vg#>?h#gS8FW)WX^Pe@5rlo<dU,JPBqCi3OJ>NFQ
<Baol:/?HHQrgNSZ<Xfd3cEtXl\N($\:4*sCQ8oGI*Ze]AhlR2>Dec/pB\BEUk=C%g+)[QM'`
^+ae.OX,,LUWfT!/.uOB77AfZRH=jeElb?.<44&M,e.n'3BfUP#=X8N,>ul8G]A9Gk3TNgD%q
LoGMM^c$N5t&Y<7jC)qOt[@EULYG]A*^A]A")cYZpA79UQhcFq@f0]A`".Y/@h"H;4BdFLPNNul
ZM2:X*HH0k_p5]A72`-kT'H%rMd[U"e=o4$1e4l#'Mo:nM-cdS[r+\U:WB5^T""IrSe4F0h8&
4V#PL,m!/9HO-=f4d_CkR;]A"<k!l*KY/:%kM2Vm3;[AkdaC4e;MrB#5d&PDg/bUG:)Qd!u^d
Z0ej?SVCnHC+8ZmsXO.#p4@sMa&8!S;nl'p\Ei@DO1N5>91JjJHj4&5n;KL<_jfIaBl>WUG3
1pe8BjD(<NS4NoG[fV6,W@k8ogt`1[2OgkaoK`XQjW<a=_$&Z%ksm$G,ItMPY(#QOG_FE^jq
(K^ZVR@b'8Bqce3fIXAECBTX5/&'@1'>3*9_0r`!3[2b/uYku]A!o5#_I0GHl-_2?b6r*s,G"
#Wq468%ud"_8_Ej?SW7aq93fFId"H$F$RW?n`mf5l#K8!B&HH&h)&#:nD5;X.m;b/*.*n\eO
mqgPW4oHJ4)d`gs%kVQ66LBLFBSb9RasDMSm`^g47Q('<e0(j9UXE[CgP(C7R3#TFjc[&e_f
u'I:n!!o9H,>nIHL4']A[snZNbXqad7oVft<KRNsO&?WG*D*+j3"81ASG`p;_'Wd.C:"eCC24
dkR9>/s--/FADi.E^&,g?[DRU1dbERV6P`nT:?KDJ<CZc)hig`N4JOk]AOo]ATmPR-RI87MgPS
2\FA!*`GC#30I#ko"l(]Al&`_:gU#ur3!PojR:"S=<6`Kh+@Tam$Zr:.?$5s+d[=Yrb>4C:%'
@jtC$b&ARN5P>EE?j![9?tsg83F"R8C(J(=me>fQ^*U%0r@4j<L`^MBS$deO=W[?7#l'sgnY
0*#[B`&_>J#4ClpF<BZ9Ct[$D^mKr*>o9'G(KnF/B_;j"X`hO#9=:06,IH[PCO*!,4R.M8M[
pr/9>pf>jgbnbG#tV!c6s6;)@I,'didp3'n,qmm0E&Nr6s"c0/TRaAH>N?H8&SVo&P)k_Qp0
%OsbP)QCGBuCiPXZHm;+Mcqdb,!3UUq?Wu4+=2:YN?^,R#7(FUp5uUp)N?_".42CjYAg,AEH
U`\i?ZB_OWg1NSdgZ-k7iSU++se`]Ad3+Yck?a;?SqD>J=2apZl/V\S(YL1'kij+2*;O7Wc2_
%<TV3NeH=I.W)m,5^qOi<ZDk*p$U?FSSP<Dj,6!b^:V1QYQ^?)+!jY>/&rE<oQe0>/_(G4di
Ij=h/J+.@39WJ'[+MC$Ya]A]AESm`-]AND)\OX9&dY/&kg.ZJ&BrkbFj!g1`6$6!tc#!k!GeG`]A
Em;WOY>*-\qO#PXrTXpT+/7>[-XB&$Q0g2AP>,$\Lf[jMQMLpPVYk*\SD1<D(o!fKe+6,A!*
`)qnH\55MJd^RgFaHMG$CO9>Gr>Qb<W'F`P)..b?Go;pd=:Ap)hh4dV!gpP,VFk6M/<R3</i
"B)qX,Jm/kiVYMBnFmO@,4*H8ZdCiE1UEFD6-c.o;lAp[XkX@Wi7Ft:28g*%=S!+e6o5/fm3
?o9YCej</9]AjPD,K[H3KIeGU<IYj(kbX'U*jgIA5C@(#N&_u'1b[7gE)P'a#pOMQAQ$<O>lS
CK?,7mbQQ]A@@;;sH=W<>FpT]A`2BYLH-bWB&lD)As\dI+fOOgagrJ)Ir)JI2q/pQ\c#iFebJ7
dV+m)q`LWBV>7<gQW,+q-+3cPd[J@0eY4ndum3,+Hp,A%aea1!b6M1mJ2K1m@rd:h^.oarFC
qiWopn+7+S4l"?_NZ=3b6N$[2b9Iarg%BZ1>^c=pj.U(;sQ5o+5mp2):e?teI_LB+>Dl"K8+
9EqnV1G`D_2k:0Wl14dagmX$*9mF=U)rfk>a/f&q+ggD9'VC&*i'94E17\ta.(Fb6X6%5]A4?
qC`P3Q%g7,"[[-AraVoW=fAL@^Cbg4WVMY_Iiq^,g^4XVK0@!VcXNI=dNQ<VIb1^l;mCM!5;
kj]A7T?k#BR+0W*'r2WN/'_2:*-c88g'c=Eh1'%NVLq(-i,k<:U1#XbT!MJ<$F=o/7TD=T94a
HTOGkkb+0oC0/nX5hT!P,(eRur<[D2If]AC.lrQBRt+6cg*NtXVD-I!@]A.@8K.2;UKQdBOdD_
m%3h`35s^B34s[XY;8*YUp8J3pgk9rac0]AQ^l1i`fVihW7P6#kS9;H4jbC+TqmmZG6E1umNs
HfK9`6>,=pAm5Xqf7?_Za>VL:r\]Ar%6t?_>^+fRCFYoXPa66ZjM]AOdJ'"Db-lF@O)c<a?`D/
A:bb*g([qB4'e%aZXAmOX&7bkBb7XeDPfJ20DuQ#HDU!kS`nbNoA@j1>aDu_N-qBY^J[f[*R
ena8pV<LoC.YGTk$)Y(`'"Dm+'\1%=Yg1MFo>N0VX0$.mLDM3k`"ZVk5de#XQa[O:&Cdinmf
*2FMhqI6%g+j0X*]Ac.f)-5@VR/YV,>.I$Xa"Q1Xgu+aWF0?sM0=M?TkOe4O/6'UcWj>4H4&p
,^$o*2RT=+.$\R['e@3BIlVKjb?-cR"RMh6E`0Aa"oF6c-S]Ab\sc$Og6H-S@o>m=.lDa3!>h
[RRsLpVZK_Bk/a&s25%^rUqfB/Oc*#G7&WO9e3YY:iHT1Llkm?RU2;2iZB'6ZFZ'B+Yr3tW=
ZuY`KUGmo3/PFuhLd!Zk)UaBL5mN=TY#!&opslieEE?X)TY`HYZD'gD\>/D\M?^ckZu,9,a1
ip21cVrjRYDLNLm(!7k^@POFXOd3dBHVPCD[LAR`QI</f]AK&f@I;L0H+oK:)K&A=ej+te.:p
7j'Zij;,e$(nKC_Q-J6q4L?_@@_?nigrR501X6-T21*6Tmrou?17c)J/Y2tf2iFk2cq15I<d
]AodG[dSBEr:>&AC2EI[9DF1EY+Z=UHqPXm*"5O%8`q>o[tqp5pH\1ms&R>;IiDuT[MB?j+?e
'm!,*qSm^3/t!9Y<0RJ\Sna/dclVMf@e:)Et5@</mY^pY@-ds%\2&d&-bB"JHGG,<:k"25;7
"6P+o?k/P+k(#I"%[[@\J2q!IQilK$3FE>a"6P.6LOdAm@BHafs/1%l83e8(l1)aEk4gJ`q]A
a+OkL`CJ:6-@Vn2pY(UO2uX::"Pp3MkP:pg!Uo*<*DfmqnRW;I7'o>l]A$OmgZ;MG3n4<!!~
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
<BoundsAttr x="0" y="0" width="355" height="100"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="65" y="351" width="355" height="100"/>
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
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?`)t;qJb(j/$m3.hlh.b)ct<Zpd6R'L>'cU9PG$74*RRD'L5kA.3"EMW+p<Qim^mnUXAjW!
i\n'\(Vd7#_a#O>%LQ,U>^26fo>hpV-CJrSt#&hcas#`uerd[J/@H]Ah\,;^>F!Os$#*#:Y(!
s!eFDPZH)tf#\5j%Gcb4g=t-7E-:+<nU42XiIOMm/1:$afFQs@Pgbln4_1piK%7[Psl'DkB4
RZn\rqPX]A?gegok0S7"pK*jU",lOR.jPGeSBc:"^NT69U%pJLO)Y,$DF8c$jfXCA;,QYr%f?
n/7HFR*Itfqh%^dR08M8b3Y_Yo5MWLTgDf=D?Fa&S)-K8N^BbnVj5LFFj%"<LUU',QG?VSa!
"5ShohIeD>.;moYd\C2%g[+04$bB?>ft@q^[0?drFY!W[<5iCQ'u)BU%!hk$kL-tOp]AaP`:m
N!_7h3iG<tVl''7G>k$IFV:01XLXUJ,dTqcSRQ[e^d=at*hJo1d92_g`/`K3eaAf\S[`5?c3
[FdI?m*NS*N9>=_MB6jUYXdguF8R2o_,ipbm0cR;!*GIthIA%Bg1^lR,@1Y9EPt&9]Alj/bmc
"<W:3HgA$dpjEJKRs#1kSi;9mA?b$S`PuEOmWBSL)b/f^aF5M/HBWMp?WFP*]AJgHM+1;gnT_
4Kgj-ktILFPrUQR;e<Q(,UG@N`3g,A6nj+OK8,!g_a+:!6)#Gf;2_;%"DD<L5>33M5=-_u4D
Yb)utL#VEAQk?Dp=T>f=oWuTWdhNKA(BFu#,q7r>CFD%q3l!]ARQpHCJpQ*^37D0s9GTbLoQ-
@V"GG1dq?>O.?l#GI?#DCnkW4'6/N!m(8[?p=_.$,8+V]AO6P;$GQ/QFWcrRa.33_P?o^en^S
U-ou4l/_(S!qY1RTY8&X!^Yp2nfKXV,lK)l%RqAOP8C:u7,BKWSh3-ZT4on;pTTt(7,DnTSs
278_";lmS2)WAE<8p(FVg$05X+.kYgUnZH_ipGnI55W8l]A!e,ba&h-I0Usi\U=]AE>Em]Ak)#.
r%H*Y%aNp]AQnMpKG&n$rs0Q?"Uj,9H3t5iugr6L3>nP)!j@?14lLE<JQZA09ghc/<WR;sENV
6u&psQshTp6f*Nr/aN2rSa5aB9_n:^AT*#<S?<0uSn:fTdP&p3-=%h`+*f(*%*RNTCQiC4:\
,+hO#?J@['+3m/MeS*fr]A[2*)W5dD)OU`oS;5$^emb5DRA#qB!p)820F/CEN1,iY#]A(RUX6+
2/),eAAQM"SqK6jT,:ff+`mM+.I_H!UUE_Gkb/)Njk#gk%NMu7<?k70;QA+<]A5^&jFZ2?IiY
k=BHI1M3e#6I=V6!B<s=*KOZXB[tj:>+t#Hj!6rEa9:E3]ACm0EIG*H_t!h$#fD#FkUD$'&/`
ZV8Wc^RqPtDQaihJ%Rrl#aUT'RM<`W7=E=H!/3E)BeX]ATfK?Z.G/Btft((&mS;,khk]A\s"iI
kH<\'Y/"O'$_/r6Ba4WR;5?;GG(4WBSEDVjV@#!!d+`U[U=d:l@^XQZ7Q#lNNm+k?,`K)qmm
4e./sdp@_Ca\V"VGakr^2)/QDlAB0,Nkkp1EB>_;'S)D6.97a@8bY8^,C9TjN%f4>!+J;r30
?(l%(LoJ@Cb.;n.;Kid8#[<I\o\ocVRBm_fQ;A6'kc"4Ht'sD$'JOcsb<)?3ZG'YO"2/i0@&
E'6@E.":UJMN:i)/F<kF_-.\H*+0t99icOC%8;'U[EtD."TGf<sn!A-5GJJJp7Dh<CmDVDk:
:=\RU2S84Qk&`9S='TeTg.SPJ:4"s]A6+^+b4(B7i*ZTUe1m=B>"Z6eoh-qqC!B7Itq(-eIPt
Ke]AFe-;.%6p:CtY-q`eKqi5&Oe5m?\p:8RJ3BkBn=KEiUF=icTlM/k'f6=KiMW*k+JkFGg%!
I`7*\s#)qKS_Tq)C"cHe@X<`ShPt]An`\7VS;guQ3X]A$NgUBXSh;EVDYsctQM5VAT>&is/p(^
4VTik=e@$h$/J!4afee=NbQo!rhmX09jK`%SC$f`#EK@%Mepfu[U!9h+6#B5W:cU\`9`r/)0
H>(%K0D3s8ri+:mo6$fM_`Kfo%VjkRW\b6F4]A"$UE:s2j]A#Munr*P#8;th8:$"hHDuH(-:Fk
%.1E#XB4r&_n82u5sNG+loF1JAiEq\?:"G<A6E<1u>ab-B2Fa&n(h8_+,ROM7-'$0,Xl9hPe
lJFXrZ\K4VS>g?s0m&#qVb!\\:bhA3[@Z%)Y3MhUqK]ASqlV*5g./M0`c$q%BaDM+DG/QTap(
a(%hf'[@hu*#"G_96b'X[\Z*WN"5$82Y=9NCVinM(;kqU*&JC&U&WR(+^@U3sXd'f[.Tm91t
4D@,?`^n&t!,=A[bE@%$GObLm$6RT(ggLJWoJ[r9dX^$!)k?$CLRTenc`<LI9=UZaes0>nJ2
@`_eQ>'a[(1=mE4cur4AS2r(@du<DfC_\gJOV]ATJ7Us[C.#'RThO),gM7EWD0DQ2l1-_c8"!
bsfRma;Iq50*:IIP@jd3+)#k<5#P(=H)/2YQ0kp3,HH<:^_,st-@>Y@4hH3MG1`nM?j.=Rc_
g_KrPpMd:g$?KL_k=C(29r$knUo@\Wh?cmu8``:Oa5r+F?j'1t<6k+J&*hneZ/+Nsg'B^F:N
;_qhSs;e[so[(^^)[rgb_`)VA7TS6VCO9dTEAYnQuX*]AC7G.=!QS72>u@0Kgke,QcX.YS,Q%
o`W&7<I>Y&IO3@<?BJ:-FH6"iPT.4%2#g$jjj7-'81qlP5gPfRjM>'aERXU/o#M7+1DC2_a4
(3P;Ijn]A33i\pBLo%?EM>LnW=Wqn#OU3if;p;(SW\"\JO-K\pSXaOb"[SAknG5I]ALK45`;3M
L*B?M.^]ALE%3Jo$Jh_:CB6Dj*(T0GK9i9kp@(o9rKDasLr3&E;m]A%*p`13!l^nNSqC*0P*WR
0\[j,30)'Wc"#q-AcVc;-aHL9aKJ9Z^ccR$@/<4,oX[C>;8BVhVCCaK:I\r9q:L^-::e/TaR
]Ari\);qI8n4.TphXm7Umkm<K0:&=ejllsJb:tlC1.]A23"WUrTF>l(BVbAWb_tq750nB5.`B<
B>]Af^7KShp&ap?98"'2o+S)`&j6=N>jQq@ak<mk8adreE]APh/B=I:.]A_\I%b3j#?F>a8Ct/j
_^`"GV6Uc(^`p4MKEd-T^$Vpr>r*oRFRZ9;1IpM,/@6mPIlUJ1#KC#BE_0RUP<ff?kI@)<K;
+I\((pjO,<UV$hK:^2gIs,$TEds+%;`uX%_3FhV"5>]A7j5/nc2FW,#UL=I+;Fb33g*E'HfD]A
mg8TJr[j>l#3-4Kq4'"6TTOE8P8.J1o.!nhNrY%UD\l&b+f16,UqY6r?CA3%nCsF-9pA53W-
7hZq-JdAk"/efNLJV=5b%m.c+bBR0iPPm2&0GO]A]AB('879D?)"HjX=X>M6B^]A-:(tU]A&NhSY
gSI]A$n$U3la$!0b^fY5J56`TANT+=3oc=0^Eh^cJ&l#l]A7i:-8fjFEpnA65J?<]A.6=!4qton
Y0#n=&3W0!3-ECIl8U-Ht"VsICB]A.ZVfC:G0='K-f+!Df->frBXE$5'gL-@o_LHNB1RM)\G<
g;n-@9pKh8CdXM\ndbnZ'b'e9XY@9;),?Tb%$'#*g5..Qh\+-%;"`ntB(TSnn#$>`Kk:C&('
DeHs!GicAPEt$=;5Ib\!C^qa9jph,I[6iV*MfP*m%VSf4nU?Pr2'j"O3klc/eGGY[q4eL6LG
n\9iO[=OFe=/\XJ53qcIMad8K(:1W,5]AGF8b0t;oQB<;T'`X%%^\C)iUJa(lHpl)=A.+jZVN
kj/!'eisfSDBNGVqAr_A;PmA>sYHeTg"&.F+$e*"r-QQkiQMViH5T4gr9<TJG)nF"65-YN]Af
qT7hekCFe6DVLMYJMaE&LtL@Q;\s"'Y0=YcuO#/)W*Da<=8XB$;^P_06r\R9Fg0[P1Xi6Ar,
X[+XVbUh6ape;n;4'TIDYlL<<A.XkR'`8Qk5AIh^>6X<MZs<&7NlO`)cTX/dW=!:Gg9$'fg$
\u.D;TBg72oLXJq0(`P/28bB[^?Q9h:d\A@As6<^;]A'X8im=+8S'0j2/*0q`_]A8$uKm9!r*<
/Eb^)Kk:q0o-tiCr`^Z1F_E.&sWj)k$<*!1lFcmRL&eY1?8+\mRblEDcMLVPJTE#*nFgeB*]A
M`PP%O4Um6)lf!h9*SPTShSt=6EoX<<IPf:3j0MqPT4ejkOu$DgY15P;mkMQeJi+[LKMS<O>
=@G,[CIWlM=7KI8aW3C*cr!o8u4nRihPil&*>Yn,A.Ahku]Ae@XO]A#BA=<S\2GJPU!'V[9)$r
3]AWKg%.]A=(BBDWeQklcQT5C@)P/GWd<-#Q%5]AjDIdj]A+ZP4AaEV;;ju?DdbCqkO#4k%dZO@J
RklWbb`P^?NU>TV'h3<XVdK*r`ekdR<tS<bjCjU5O&bejF%u;n>c;'s:X@_?AVEkNXD=ot/-
&\_9>.m-[a+nd$"&ZL\-T"0/hQDc%%D;<?g["t[V4'!^(AOm,oUC$?R,NkXE,-Da<W_Se5qK
@lW";<7,b[iFr;PRKS+<IPi]A8X/XJ/kUbsg1*qKTJR)mEogKrigeZC$L_9(_>lje0IZ/%R3+
%**'@-R"\9m;Pgquh(MZ7snM2YEt2qLXAa74Fb<AL^DKR?bo1i/2]A./gH*i/.1i;LP[mi#S9
/^R%%lM([h$K`dK$sV5m>BQO?JEr^PlP!K4_`c7>eNeUC3$il\mJ]A\g[pbmpO)lrR)j?HFME
s&SKg"Eqli$tK6paJ6p!>g;37FGk/+UlE9H?,F(PMZlM$!FQb$Tq'f,rTIYegXK;KFrA]A(n[
:tu?n1.Us5nGh[[$##Q2.J#.JQ-]ASeVqfJb/*2)+YjB\dl&JkJ"D8SJG&XbBm^$\6T2!$;KH
9(Ylr5>m5?J61./")llZ7:'<H&o75BDX4s,Z=@p3-G\ZOjkk%<AZ3?09cd5')=ri-+Pg;4Sj
U%IThVq1S)*oNJ+$&Q"GOr`<`X5%c;a^.0ONXD=YpG\/?j,Im:&@59:+^+3mb?$:e^-H##1!
kSC(Bbg`UaZ/$7EOg5FtBEG.SGTg_GEBa=fPP(=&K3Hfa&O5s=W60aK,$)0]A_XXWsK^%l#D+
M8(/mq*ekmgN>#$^3Tt'8@Tlc58B,E2&0^kB%I?,l,/?,a4rbpd!]AhghqUa=GJkqgD4*Y8Db
tu_7^.bgNgXIL,?\/?maF(61JDrS/^uF)dpaN6f+VKJ(Q]A.-l<C"OLu%A4lLVagd+Ean*Go_
ZBeIMm?oJL3j'flZm4)k%fEp.IJ.d?/lRY<jonhAJ4oTK9i5W+d_6MWHXOf!@c"T#%%IEh)K
hea<:ZRk'Jk=G6)kVNQb0'YI_cP]AP'-$o]A/ob\Yc%";f.u6\\TWLSh`UIF]A&1G6Vo.e_]AF,(
7SltcVP1D&d5$S,;/5ae6KR[Y@7E3M3Z48cRV`iKQG:#ejh-"%$]A!g\?_?jTp:Q@L8h$!77p
J0eS0=9=e=-"%&SrsBS\HCo+@Mn9_D#.K,DG!G\-UlIDcT!8%eib:@F/8bmkAeFl_c/Jb>="
PJ:EUht`m7Z46p%H-XHr]A=T<;XC5bckGtmIR7B3-+0M~
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
<BoundsAttr x="0" y="0" width="355" height="100"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="65" y="257" width="355" height="100"/>
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
<C c="0" r="1" s="2">
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
<C c="1" r="1" s="3">
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
<Style imageLayout="1">
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" textStyle="1" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="微軟正黑體" style="0" size="80">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingAfter="4">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<FRFont name="微軟正黑體" style="0" size="80">
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
<![CDATA[m9"(-P%hP+Cn3>ZBc>`jWD;2PWMSaC1/1L*PW;LL,%tJ$M.fGiYrH=\PWDP,HeF(/JuOP6Mi
B%EL5cP_,,kkt+=R@!!XJ&(oq(8h^79-)k6LeO4TG;hYPYo7jo<)5s)cuNoSZFN!!!!tNt]AQ
_"oq>;k'nnI)4smA%&*b&qt>:T4*!6Q5UnJTL7lhK&`(qi^E)%ujnEu6c!S'9jr[rHVL81fc
u8I&J@@b5^U33rl'9!o2;RR$SF61:lWc_umCkR&=W""+cT`B%B7h[)G@8Wc0_l85'(nS4<A7
`;_\Nrs-;QJ2'oD,s`nSFb$$#BL#I_fU>_JV<loIAi+<I(M5;:!@/cM'/*rl@/\5N"kjUZHL
je:eM^Q6&_EDkTCD$8qpl:d:T.^nuV/<:OJe(Ok>.[-0V[eLpm$<6P))!)`_l-tuMg#r4^J5
ZU&`APu&i)A2d^I+Iq@h>uSe'_O<^%S%*dc;m!X1?>?EM<5^DJn"p^^"(8Se]A,um?[4OHh3!
iaMkeQ36suQiWN,O?aZbKNgJU"o,JtXNMp<q2ntg>/u]A%!$m)Qm_rp*G8H&fR6a#6QGPJ>og
Q#R>#XCqRbVI4oA`GcCg)Yti\RE)&:%e5*NTWel1I$sI*)a$"aZ\Mh04F/l%aU:JO,<F;oX\
BTlq4Uo_i3Qh<a!b>W1ePYNdnG]A)cMGPHnLd9jR+2d<b_\Y1K3)D\IHQ>:3.[SEE]Ab_;X3C3
]A!C@J6+>`gMu/DKrHaU=f7rHGSTa\PP?IcpotOj5!H%HT>o_F"nnht;-.h$PbWp7<)'iTEUA
s"C/>3-hX?R"9_/RMe?%jmt.VV]AhM&.T3Pp:sZ`skCA0(QPFn%)Tn=.EGoRrU_8OJ=m8k.Z0
a;&=mJ7MOQjc#T2ta;fR$R2_sih`3dO0isVVRVK*4$(1nG%Vd?jkaL;s/l(,]AOH9,J(kH;M4
?pCQq)Y^imr\qL3L:'Japj?%4'-Tq_`rAE+mWT^nhS!j+',`?Cg%$jO?*bHeq\!&D;T3qG]AC
dZ:utZTaS;Y@a-/-.ijCNKUD1c;?QGZ\["t?4j4N<H33K:\:kh\GCq']A$/fA;.LFAf]A`%e5Y
nMrUe0<oO0]A6M!9Ib0;LAU^u"P3k89,Y4)1%%mG7GF6OYUI@/?Cqg_=JKCD,>h2)0j)e5Y]At
1.nC3bQ$f99(#SIX)oW9dr/b`b0R$ILRgV-u%n`IXl'M="Lc$f:<N^)r==^<H85Z2i.WRmt.
6fPFeUe[;eT$L4)%V&jr?>=W41cORt>!`<k*"(Bm8P":-gIW[QmL(oJS6nRGPV!2i_(nof_O
1:_\#PB&@?$<Mr\iR'>T>e/.gk#8/\,S0n,5K3(5:Qb*^!LWJ,!%FNKr9nM_27tT=g+B08hS
(k_Dmn\pdg]Ad$jl,6PW5+Gk#Y]A3fB[>'S#`UF!`P<-#At'la:^S"=m!D5T$T0dD4/6r?nnT3
[ahb&qfE:iFD"CiLQoBZ\>E$NHcA\peAo$gA\`,*5p*`X7TCl.6X7AL6(1a[+3?:)_Og^Q*;
UV=CiI!n(:=4`^Z,=W:)@=dEP2"Y_W1^VlR;UM`K!isLu.8GQT%K3H.=>C-#;,?*k9iB0B&A
->9K)C^1i(.8V0^'OiB9bo`O$D:k?R^1rRP@kgGO#'>KAN1EtA+\klNkg#,Z'T<(HdN/I5KZ
-SUHM^N)T8*$Ud0C`UFSsYKum&*'/1dW6LGGq^/%0854nJY]A!lPLO8C6=XVJ6&=`*F+n)+A/
fnUbX9MmK8aVrR7Z4ekEKP5,K/_X-5R78fT90HJg@K+gAFmj!k/]AFc\mChCVfVAO-7_Qf2+k
6iGd?No@AeU-7\HF@O@Am9NWs-X\$N@TM>B5daJY,93_ipe5f$1]Atb/OAQu6<&'t7n%`;jan
l:Q&NEf[VYhBL$#9`RRKRigTm]AbOhQ`/2Wc[>Ql0/=V(`@bH/9(*@S@msO_-b%Qk^3neUAMK
aNu<GR<X<:[7\\V;c/oQmL2(5f`7m;g!K(\PY@RAB8Cpq'prK:'#\`*3F&6B*D!o!DjM'(F(
haCOej:"n#hZ$$qRI"@QkA+ALHu:_M4WeAgX\d#mZ4WsT$F%up=:R+3_58AR>n+$F=f's9El
i!'%h!q'66UEO/u*Prp%agM6=^W`">%C5M:uo`"!gCi@D8QNZ3%q/q=2bLee*.^!e>eq:uUR
eL%JXigo+pn9YJf8,oem\5hd^P5U?u]AYc(??)+DGp1u!XJR2IpqtqY*3MWTsn>kod?oE1Y\/
X<4FZr%J_g,T&R;TSZ33=81Dk96gULb(*9^]AY[IPng%BfA)tNjVdpKkifV*%'%Do.mtU6[P.
M50gXc[AMOADeBN7lfq<GkbD\1$"Z7QY5cjB#[+6>[i!<CY>;TU1r:Lnk)#*tXrPkc&]A]A,Z=
_Cu8:/dc=lQ9Sd@l64=27[17B8ZT?r)hGRbaI*i@Y(^PD`Qg?gmTXe4V%05'4HY6)sR$q9[R
\.=PG"D-(2P=^AU"_#gEfN:4&n_MbhhU5<?ld10tne<D,>VM1(%7+f[.mBd/>@3f?&J2K)V'
@B2dIoJ%-;Q)@%%Lq5'ba_4?n.(BSe)Cn>"cCluPg/3HO)``p9IXkPi4Z^MF@6dj5>9;@WL,
_Oi=.p%%3ci;.(f0-VIC2f)LZ.pXhGWp_0)3*i]AKMdJ/;Zq3l)4S5=5NS3D]A\h&F=0VhfnNJ
?Bo^IQAB?I4CGObqW]A++Xa,Jb.]A^+_?8NYbs3`u6Nmq_2aMj>@`\%r/4.%3>b*'_-QD_\O:i
e-YE#\RU0hc9MD<qNjAJ:]A,J6%MZ,lj:u!R*%\lX/n+k_R#hU.UitOZrFG+93$,!UYs&%gW/
KPB#"`0E(:+S?t;(4l<N<9%l\X/HmJQfNrA61mX:ALZ#W%_[e1s'09/aINH`*&+EFcss6'Ld
]AsaQCe+YKOf)dgBm99m<EQ@>a'lN*R_ES64>S&=q:X0T9aoh0u3\M?T.18=F77@Jj%ID1[2q
!0QGk=Hn^kZlK_<^SSOrJ:n`lLJR!A)Qd,--=qoWSN%5>CG=UDQr*_%hA.2Y\/Ah)DF7.K%N
VUcj'VZ&&""c:b2GG%rDQ-@O;UWF_2'1agZp`2PjRN&5:<b:/hf1X)BVCWq:;RfnZe<-+]A7&
R5eb7uiMpF8dcZ4NBJRNDun#H)1ur]A'_YQ;M>@7T'_AW&/p!EVer]AG)6VPdDN4_;H%EG)c,h
C!h!b`^9A?/rL>9laI9`Eg5Z-%&>,M<c$sU<l8=&79Fl7qV*WM"@U^u)IU:#U-I_Vtp/q&=)
dPT;\#TKWmRAfiXPRLG]Ar<6tP4AqXl#L:<`8BSdf:.ffnJs::a*L-a8C.OIFBhu9-5uUrQ9p
(O'qV#q[m45Qo<o%H"+o,"?bbKS;00)kk]AX/G[pg]A,Jo8\LEEq8L3dbTYT8AQ&rdmnHVa*=4
'+MtFe!]ARD`&GKXD-PAY7@l.P^)9MF7?d2djVK(hMQUaAEJZ@=#An*5,B>l<0)CQ+8qk).(e
^dK*O7)<Q\]AP`2&^p8&^QBFLXcP3ZmsDT&?udTYK&j?'0pC93!o*>se7O!^ehb?5('Am*j_H
rh[V$XeXPdjT$j4QGL6n[:[`8j5lg:8mk@hoa`7`"\OjrHlq*r]AFguCCup@f,!`(:F@pH[`p
4h-?t)EHM8#E`LVN":st5dV:K@Tc[*,jaX[[G\Wp4i2FRp=c.u\Yc`OqPBJsVEgJl,q3q.P&
d)2DD@@t:)9K^\oVE(:-7thGshj/5)3.nhGlCRrVA#8XO?PEh3[RCi;?.F:P\Okk]A8A@(K>U
hMEhuHVCacKW?_MsAJdK&S\BWdX*huSlQK-[#%pSBQbUa!k!Iqcg("1hE?+;^bU-nNpE\*Ol
\LdFai,tW6haHa9G^cY<1e5EPTnAhAO>NeT^N&2`QMt1I8XFIBM9u,YUP2kqfL00H6"^0mCh
.H_7/mOp<%bfi[6F;ZM"Z\_#c,D_D[rp2sK(#fR$?hLH5>3p!LG+Ffi2/Zauj"5V(-7//Ztg
EndGN4OQ^",71P18kHXC-nk$uI(l:BG49lCD)r1s9\`>`5q2euWcM!>.>qu3r`6_W-9800H\
al&"=DH_'-Q^p/0J-m1gQB=/BicoEp37(:&,?JZ'@$BI<RbJ7DKe8.81S54Q7(=fQo5#(#8+
C>V\Dl/iJ78-?"7Uh*d'E1h,E7Ga4;i!;E\*QJ3@=nA8KQEiGW6b;1_VJ!(G5A`6g8(UNEOQ
f6lJjEalHXtF"VIkX(^6@Qu1g+)kFrH*;$&[=:jJ-g8ef>PRlaMbrne-iH%!`P`J<F&cWk-]A
KL=EiJ=.&O8WY^87S@03bTcIs,S^o&7O\0\YoTu6:3-01)&lKD\PLs`(h7fPN:j@m<Gcb2fs
IWN8??03ufVQUn@gF5_Z@`[<h*eOVb9E`g24c3/tMK2&<+C!)hBh+[^aCe/j1T\KrnTdQ20F
tdkk,r-I$.@]AKl&+q1SVgkrBh>:>ruGEIh67)PP2?&2'^S>YUS8D9D`]AW5O_X2(W#g,u<WEf
i>R>i\,S:,=(=@4a>s$,fd:<.?MMM`!4:Qne`.6]AO1#r#H=IQeF]AE+A*Zgl`>-TqEB[Vad8]A
[Fu0999SbT"9S?=]AI")JpHjmZ_X>8/O1Qe8strjZ`tCRgjWMNNTKZrXZYj<BDs&X"Q(Eglt;
NZ4E8OuAg1?@HlMna'6j:'/t/bYO65%=g`*]A>O>T&Q[JNPema+"bbdPqoLcY-]A4pKfc?PE0:
pLIOQhf(P0,E.]A4b2eTORn\Df2hECb`.oQ]AOQU,8k`(]A!He<kei9`q>:mTGJ*M#-C5*EsRlp
HQrg5#J^_X/en"OIhXW-QQ>*_;L-^AAYird,qDs+k?tc/5UpeiqT"r#E,V(*an?Kq`Ks0E]Aq
,(dgHdX`VP$=GIMNj/j:9*OZ(gO2B<j24o./AJePPYh?*U*4aVHN-k@tEb%)#5@"FTq!mS>I
8kOa5NLA;;qmTEG/Sm43r0q\WER\(Z+2fGoV-eHpeL]A@eqA[Rg+W?/RigI)MQ5l,5JlZODQi
u:]AJ@@J&nL;ih\3LN33Q)#75J(3S>DeF-!BDkC#K4Qd=Oh@i2,R)+@iQ@`ph%^2d)th4%8%,
$e<n[Rk.c./*gd*S7Cu)RWkS_r2Ofib[m\e$q<1B6PqeR`[eIjqkMMcJ&Y+SLkgToUQCst.F
HeJOkKEid"ES:4=,0\iM9JkgD&bj9'rjCI6)lufuFtCAok91?#[BeU7jF/5'5k?-`Ggi6M[E
.;npJ#nb8'-=d\9:Ft"WR:LZo6'_f/XZek8lZ^X4MO]A&*`*2QXeF<>[;.0!)<k%$0_`Ee0PK
18-uCmr^mC*rg#4o@t4_K\4j2t&lDGtTPH[H#`8Nj%eo5q[ng]Ai=-L)\skBlW&q='uK_22gs
>UaqC:OkCoe4\1f'C"T@)3^-jY^/0VAGV4V9H9KTC-8f58_>R!kDc\k9C=<=<OqR7tMdL:X'
bCc?-KjKpV\C8cHM$d+-halIg6Y?_L`nVInf-7f]AFlo=&L,-kd*FD8JlI.SG:g8n(,+_$@KC
flU$s!%WVX+5%Cc>\OIM)Zp*nQ6<1d%oQ@W'OP#Z?kn5lP\'j<h53CnJjZ'XkD/M!(hPZW8(
GSSTs)qp(kN!A]AIm\Qo7^>(Dpj]Arq,IceW@un/Nr[h/j1k%*3HC,&bi:nCcOY#=P_Yo<(6EA
HgHe\kX*sf0F_Q6?]AX$Fh=pT@^LFS0`"qu\0]A4OC0j_16_f=Y4N%P1"$&O;omd:$B(e,^S'!
ldVPlEl#.SUo8OUQL/ZG.a492t?:ETE]Aa9:NU4,OI"gpu[En""o(h:N7@UEX(!C"$p=46Kmh
9nF3#bmr=:(U>0'"(B!N5R7"SQI/DIKKPrNr\OGA:km>a8;>T(aid3rbDp-<krP(FUAElF]A8
aBVP8nB7r[E,mG`)Rj*kr$3PdOd*3fl,.Ir'j_9Jh>0EV\eSNNZIMrIQBhR`U=TH<02b?gb=
K7V+n'*pf#G-FoE=-0Tlm@(i"ioQ#7[1YfF*KW1$>#fHSW?YUYSrcR:,e'$4h3#E#mUej_D:
<5p!q@VnNlXo:lZYZC(dUMet@5dCk%Yot'a>QH:_jbF7UH#NC+jd7f,Y+RYqd1nJh3$ijnT%
VRI?9t*DrS*TK^1_gE1Y>c:&Lu11+pbREjPE/C!%ZLLmSX3fcM1f<D>k`&(Y(R6*"=*iRT95
+fsXIc)bJHp>*^iD\H[U`@>*D:A47X?.7N4K#^/2/VU:I+1agIPOAl=DrS?irNUAE6l<bDDr
7Tc_L&``(Y,nl-bWdf9TrLuKg&4Q,ai!^#'VP1O+DG8G4K!%^<OBSV3XW3mQBg#Do.ECIiL;
M9PT6a?Tc)*M+#S=k]A"N@^jHLuE)JT7]AGRG5RuAld[2QahK[*cp:Ye-\Bh]A:*+RDJGgMS;'W
YVA'(XkZ\Q/7Lr;fEJ?%V5=MG"E9!K(%@;$f((;bW0*+'JglkF.l9SX,ge.p*A,P<!:es?nI
%3k5(AC?mStCgEcEI.j+Ok7ZZsb@2l_6j(I;F[CmitT$/?+83klBJ"1tlMM_MdcoT'C5>2_,
hfjC$X(PR[P8@$ol;V>k8Gi>[J#^pdMN?"eVZ#QH+RGR;*PE/,9n!E?!_s?+Rb!UmhqIA48P
s,OUM";\=;udfj0sGOq;[<)CA^ELCk0P)mBK<>da^htBBG-]A3Ss8Y<K*=Qp7W/G7=Ap+IHhR
+id5NHY9_84C7tZ?dB]AeqNdJ%`FhFg*P)sMTmp&jf]AP/_%Aa&mZ%R:_3d5nJKPH3hYSHuOp?
Af&$BRKbb?VF0sEcRnUTTA#t9P2S<%5ae).5riBhGG]Ame#B-r!-D&^IU\uZ,X%@fl(FS'.mu
RM&1(U<M<D>6TT1i&PAN<JLiugq0QWfQ[cXB<^u.I!23aM`eohrL9AEEBM]A$3rUf+pso77HF
\lWPA;pXbdb2RFa`P-!EOMTa.na2!Ad`G""@[%E__4MI=.5>?+S017EPi5kejQDPnhCM)1Ng
;LlV0uqNg+k]A`?hk2c4imgF?:8hb[YusndF(p`8/NGG%`4PZV<1!`Xqam82F7XWH5O8'p?15
O)kfKm4cJ,CIMna7T`M0c4TD%!T8NN1r/pa4K">YB+6JPB9Th!86uhP;lGYX?qMc4A4i_W-F
1ic8=U3NlF1:A<)DA<ISc$]ADM9ht7.?;]A!s4SKl;eckPk_'I&2<V=SFnY7(Z4F@QgQ<aV7fM
fG9?9m%\aK1sQs18m)ME=>1+7[o/,1d3GI/MN9f.GOS>.2!@!n?=A9/I70[jiI2YWt!!S,d=
*im)V"mS.=6Jb\TI9H=u(<]AB;1N-0#ScF]AI>Y=8mo.i^sU\[Nll3p[!pAZ)pE_cBWk@,K8DD
=j!m<!GOJYBqSMZYm',W=g!B'3;5q=<1qnfec0TXa!Y=*-L)mR:KBmO#C?ZQJTe7c)kHfno?
4WUb+)M?`kE,:9npBB-c+PR^:>C_j_.P9of:!Q&&[271=&!2.5GnN$[.f+h@f!W_+`CL.&BI
/CTS\H0G"C9n0G\7H@8!5L=a&d/3C/_Ok9?b6;FJ1n\Si!]A#Xp]A>gD^&VMj0>JC^$h+>p!dk
$_!+19V5D-^0n46(4LLku\L1'X\-UO-c>;H6LqY^2i0B^r7F4H(^rdOiFr[[,tYBjg9+_9p:
=9"?>7H(`6M)hJ-_=IkUr,DKLnb\EKrsf~
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
<BoundsAttr x="0" y="0" width="169" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="244" y="171" width="169" height="80"/>
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
<![CDATA[1524000,1371600,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[6324600,6819900,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_EFFECTIVE_TAX" columnName="col_curr_tax_payable"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Result>
<![CDATA[=$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
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
<C c="0" r="1" s="2">
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
<CellGUIAttr adjustmode="1"/>
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
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand leftParentDefault="false" left="A1">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="A2"/>
</cellSortAttr>
</Expand>
</C>
<C c="1" r="1" s="3">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="simhei" style="0" size="80"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="4">
<FRFont name="微軟正黑體" style="0" size="80">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0">
<FRFont name="微軟正黑體" style="0" size="80"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="0" paddingRight="0" spacingAfter="4">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<FRFont name="微軟正黑體" style="0" size="80">
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
<![CDATA[m<SM7P53_Ddk]AIObaE1fe<8s(g#?%IOb,PkR@+FC<p#;$QK(:aW$ofQPr#77Rc9Kn=Yf)*k*
d\t:)\^Fas`,k)$26:"t6cAB_+pD+7T6rgCIPmqfQ4(2s9Zok?QV!p[;`WS9=jAp`CLs*F5"
1-[sXo=^AQ8=oYn\o'EK.]A8k11.$kT3SP?g__pWDTM+Dt0)u/7DNC]A8TF1L0jG?K!^nC4>C/
f48O?f'd"l/_^%HS_R(;5^Z`&)D>Jo7<H]A*:$Ua\T`sS.@,Ej/+uNMegT9d?f1-sXJ^3:`lI
9"S.8p:N+a2p/DWF7n([?P@C[Bg3!C-85$)82*nEDrQ&i5Uino<]AhJZPtUO^MS^=N\fB#etA
8)Fi>9L6\LOFshp]Ab`<<^=N,6,qWg#<VN1&e@tG;B3)'U1*/"dDB0Ypf+>fJ=e5EgLWo55H/
UncF6C1<&Er*uKK6YcZXrYKatqS*L'W+Y==Z_2TJuXVT5Ws$4lJ\Wi$GS-#UF[!da(%K2'FD
;8U'?EDJ&O+Jtta0Q")raLU`2m2did/N5]AEN-Hr^7!6["F'nl-3_dAoPd8J/9_9_9]AWHsr3n
_a#L=^)\0Fb9&*lms\>COpDJF,sb<+iWb4?p"Tm\]A5:J[:iSf<bsW7Ys*o_ngo/-5#as%EO\
`brD2ooo#lc=K-BJ"S>"X:7<h4@BTI<4V89(m0TRS.gcM6H7sW<L6G%2s-qn8tAfE`?=@Z;e
#HK]A-P:a!(3@\Y+27muc!/bnjRm*M"^heb*o5YYqnfZ>R0(""p*p6hIAM6_?MQF?J_jW*c28
#HMTGV>IYW5?t287\&O"$b7XCF;/D)Ht(DIteYq9Q]A9m'u^#9?^"ZD>.l<"0etWh'RSi'ci(
j'p[.LGfbuKqq-N4$_:BKo)Cj%aq*p#b.mt(H*>:9>TJdbgD9N4AR\BnpO[j?r-qe)+6@dhX
)(WL9-S,nLFj#$JQ*8n#-?!]A#4qH2]APEf3L;r6[V'kS/EBce>9,unpZ>dH^&cIIVQ!N4CEQn
Ys7-RQ\B]AApLG/6,c%!8rH2USA?;KD<;FLaig=DSfO/<2nCmjp`pl)k.I.8<)ZWU2`H><[*2
'8Sdcqu0Bu7u)rmZWUluEL.#[[PY\T8RI1X<V?Y-76D4DC<CG[>H(C;>$:s.X8nVYjLAI%:r
<QF'F!bj59G[9ZT17/rT`",#/#Q5]A9e([WM0;42%VlN[Nfee@NV]AT-kst?i0R"c,J8nL]A.W-
P`3+q=GiSpS4RqWQD*55&UK[`j`aZTcp`AI8WdXRe71K.I`K#tp=>"6bii/S$gIOqUb'[?oc
5%+QA28b*r.]A+H.^*O%1_q+bMaZaFs,sT5.k%q31+l=<A1i*Ki[9$oa*c+%Iq'XNWc#&r)s:
EJ,m*f`EQWCNS+eSW83Ccn!A^M0r>@(mDAV320)Wco>iOs']A)<s?Y8fb["/+I@Oa4;CgFEel
mFs<e?=U!VnC5Ri2)aZp[[+?NCB*8,#]A&5OjeN2MMG(GRFn52T$.7>b,90?D;ST,8Rr',W;%
+afM'8<e==!iOH@a!>*.[1t-Js\)RWQ$J@3FlM8n6ePRj'l<cPfas\EV"gg275N<W1jiZbZ1
gZr2!6=YdP]AZ-m6>P8I9dLL2a,D4"JNQ'88X\(5hapGi^hJIKOFD-I!(P>`gWF;]A<-3FF!>H
tSCLXhGj>=smm:`TCnt_d,#a(Jb19dWPat7Z^fZ^jp-T!G1m78Gc$-pQgE`k@RW`E4:U;r1q
X+4@[uUHt-SqGHt`5./6sZqk8fNWIa/8fBj\&FL6^Z`9cmtT`/AmCoW%%3.;jO-4D!42EThZ
QY/QTndVZZVr0_[FWJUi(g,ZMY</Jr=^p*<<*s5K.1Jm4,FhtNEu&#,c@2)B[BnOik111n,,
oXu(>'%W=_!YjP_YShlkA80R$(%Z'.)hPkhU/74meTM(O3No"E>2*HQa8G(#Q^>dG@/n^aZu
2O:ARY=P:t$fl(+k$C**n#1L#?_pk!6=4c$?TH/R;j"UfoEr$)+`h`c=KiD^.lpkpk#NG`C>
Ike4bII<@c:4&gc;ug1ZbS]A<DKbsV8WutY1U9OFc!M%loNuiFBQj:#ACa>6"jSf=DI8U"TOg
VnG]AT1CT-^'Qc]AZ)-]A]A,Ti<-@=ZpZOB;fpfajjihba;Q>&h6#C181Pp$%pBqZ$O\9jE/JKVg
Cr`k5;nCBO)*XBoRP^$@0,3h+97@DhG<,@E+:ej_/Em5Vk!;blI]A>-_$'reLZ/1$R!i&[P;^
-!aR)4H1;cm<#K\'dd7qPIF_0sC5r]A$&E'u\k9P7[_T@VOM5[`_OVWb%m__ZXJtl_&K8')T<
NfkPHW6ArFl7qaBL3@bL?oE+<aL17F"!AOf,;=9UH^a9lfeeofXr-OX3?@U^L7Re'TJDs6BX
IhH'kIFImL?hNMqe[hu1R??[$O1*g8Hq"f0$^<Xqr@IPAS8s#k?QLs$kCaGMZ52hk]AsTS&ZL
YlYDF]A\l5t3[F`(ddG&dPT3\P)S')=k4<ErhX%)Ng)\,(=Z")dCO%hjFBSN%&SV-^,;/-B.E
ZWM$.Ij@\9V*4Mc6-n4eP'rH[r2W8Rdq)k,q]A2BhR1,p61*aAnqf4$gCES]ANh*;d%NaOT.Ll
Fl+W+116;H<=CKWe!Qrf)rO[hg(XR_ckp9-7t?!!a8_h)i2*_98r2l)FdD^kW.!OeXd^d(;F
p:G7KlUTe,DCGUOYW.gJl+0po%l;uM"DQb(oN)s<M=6J)Xc5DY]A5\<*g7WXcUSmpM,;*Sp=B
J.+;B8U:sF&9^7(^:h5T'`,q^0q=*2D50ob&\o#:Y$CBb%ESS3]A[U$p0,q,[.H46lY+4!T/U
D!\b$H,5ZA/2K:L\\7[T]Aa6(J`TIto_HD:m5dCRlg/.L/Zb(U_r=<&_cl8s2a&%V4Eg,?mAN
PtU2_<*6T-\<p&Ah_+rjSoQ2bApUWZ!*uCn]Ac*;;*--M7''XlV::[6M;`L7q'5qjto(/`LNA
P9SHGqT%r:H(#V]A\=7q71SYge::2@%Ln/%eeP*9Ljt;(#)qeD9uR9k"Y+_IWP,/e67K+Ea.(
m0&QtikI_V:'F%0g;f:Du`H4IS4=%c,YWVjGpf]A:rpY`YMalBQoXMh2U@bkgNb]ASNhl.3H\e
iGID=65Q\IoLA9g1#@+=%-6\$!*\nQPZ\A[*iO!RljK3>PFSn8S?Lr=']A4[@Fh&1B%d,Of?X
D0+)p`!YuUI&69h^HQ<A'F:]AhFhCfHmT9RF4Y%cid5bF4+)b.(P;U#frD2Y8dAs0aufkQ/HK
'r)b<5-PlM]AA2[25^$<L)q8*STE&e7Zp.t5*Q00MacbS!DZ>RuK8"5XM*Ht^[8o/0P=55>PO
/Hd3snu)0a`rYiA@iJW('WmX1VV-Q'C2+jE@]Ak]A0ZW)ORf(bk0fB_5@kMW13&L`A/d8]A<TQq
O;^KPA:aSn@brf^:8#`#TeM0S@#-*+TotuDMFm2`9;UnBp3i`$G*Te7kQmWZ@n8W,!h@s.jC
_+NF*'qWF"?5iO88^W,[3NDtMdXg?VamfZOJ>[jcR'taMYj8Md)>T/UcUNIYS_3DKt@"fpHW
Xi3;;[J.Ut8J;N8Q>NVKd-W7`0r;1TQ<Zq=HRj^gnWY>d!%9EJt$n.0dcVN>(UM\<K>k/IoX
,c:sA/.#GWL+C1XF=>gK&8Tf`aKT@sFX>saf7jkfmWFcgmiV.T@bR[=WFuZF/!$40*S.9eDQ
3*-Y#@D$Wqdg97<4*DN/f/-'*f`2\uWcu+c4,i<g3Eta6n=28*irudk,%JA\/n>Ip2a;XnA[
VfgN2H:G&lELUuX'R\KG6+W(5O7sr<4*L.;2JU)Gl-PCs"]AK9<PAn_G#*eb.t#3<6VS:fDsG
NFe?/f,^Ti7]AOC\r9S*6ec$CC;b27]Aqi!9,9(^WVrsenD0ig*.=@jeD\]ArsAhCK#i^tZ&c!4
:6q$]A#pR7:>9D0=!ips(Dm[RWhU#=dVK_Yh8<hF8R;18'o"4EkQ$Dl;@EdMcU(&GA9JT7VB]A
UlJ:g0?9Xq87kA]AaWQ,i=CWVo9%q^G/\m&6iZ'gp,>4a%:&)'0j!5'R5rUk=KC\MK9E+/"Ch
N3V/O7#%IZ(4"?5.CYj9nD(8Hf;BpN'tKk]A(f)`fpVh$6-9C8gZFUg\.j'VPWXtd2+O4cia%
ao?8f9O%<Bq3C":E'XEniJ#oY_m4U,@*BhsdX76AZn&iiT33$DrMG4)r`lL`2CPPr%`H(!//
LrsQ1>mI^a0]Aj7W2TqjPc8YhrS8Pf/P(6:,73J?]AP3Fi9&`3odI^6\^!a#R"I7ZZo4Z4#esI
G/);=U($FOu(_\Nl3:;nIT+E0j.s(5/091,Ib;RjY)9q+n6dE*]AEb5#X@DJD+74Om_HfNT*N
^DEqXMTO[j]A2I')&c*^n*CKa$D?RC`PG9Gd\pG,f,PmB]As",fhbj/+;'?)bgkXn(rTrNq)5a
H!%&-8Z%LsG]A=-lZc>Jp@3]AYnuC"#><@Hki8@&P?Y*i?s@c^&MX12<([2%cO'[>rJEV5ZLi(
'O*hW@"7qlN#*%<rbQ"Xr]AL7T2QCV4Gb%j1Fa[c@[99D*\0]AFI.0XCkM(4'(j%Hj]A8CM5Ap6
XLm&PjJ5,0M49_a<ir5"P*1%>P!hpmP0)[&%CGBaZ)r'CJM[m(dU983Y:,T1J)kTANcS\N(3
du]AG;-h\b;)Nk'Y-AdRBbTpnN]AEPUod.#ds%HiRRlWbQtl(acQ.2C=.q+8,Bn8NLYL+Y1_Aj
0[]A2T%_Ohm-tu\Y,$CUS^Sk[7^GG]AmX(e@YH8KbPIZI11gRIM_2PXT7?Q9C(\BnkQ*(N'A36
Ek/0!&.@T`B$&00*be8-(_i+Mj:P:LUc+$$o=KYij1Cj5dE.mOlT/M8&RmN[D9k,3UGBP@\7
:Io2b3o?iSZK.:#@,o;\@5@#u6'4(mTF1eNtE^&7Ll3jDTVoL"lSaUB]A:ZaslgVBp_!Jiuni
XW^'U[^r(4%+pF4[MH8TN6'Oo0mL@?$&-541;1EMi\\s;m`8#U.Am8cPN6&W\U*R5S5h"c8&
6:lnlll^%ei?J9Lo+8B7[.AnQGcG'dT.AntD<P6.'WU/d2]AG_d8rfYW]A)=*OR@Y'INK0)pBJ
0*![.<2"iu6KW]A`6Z21AHd5[=BK6FH%Jkd$6me=^jpGZ":Iq.gebOC!$*BG9%To4`7.F#@ot
4NIU3D5#')+cF"um<PDJo,P_t.ClFTQ($hZ(;KrM'ig4>$C]AN5JaY1[Z]A*U&ZFMSNhp'rPdV
\D3[3dr7!\N1_@L.7j:?FNF=^M5>__2.-IE8)j!%bGUK++KCjI.:OkW*B:?-o>+4DR;^QDGo
,O)8qQ"%XDR'u0hU\)Db$dc+TN#tNMjl`=NIAaIVur0D[4,NdA><V6!CAF1+'^c$fP4rb+la
'8g=#g;#(]AQ>3l_3UUa#Ucs(]AoiL"_4AME<V4ah?^-Il?]AiB4O\A[H1I)5=gD]Aep7"b>tA<L
meBT\A"D<-+ORr_-@\%>OWSu4o*.OT2/E_Np90$6]A'<4?6)K)e;BN(+.'W31ZTQ#UB1rn]AAH
J0c:d[kSpmqJOr,nO"gBjEc4f6CYYcC>d(0,ZH*>\K1Cb\APAKibN%Ds$!DrQ?A@shI_>ZBn
!E]AG\0*dHmj>K!b@bq+B]A;jZWm%WbhakJu`X3Cq1_,?c"3g7Sqm2DHJmG3RTH';5G?eH.a2f
Ig2$p5!cP4BsGlB:DB>`<38DWoT,eq=dAJ[TGa[o"PSt!]AoPSGAcT[NT9<CB$F-_OH"kd86Q
lkXp$(R%pTPWV?p1Te#gZ:GQpYhLoSEka8&b*qjcMnd)sm\pYN\s-B>IQ9t(\s=p;UJD9p,d
*0F-"&t,C5&/#\@db$K_]Atn@2a+$K22ln"6#_!%!oC::M_=clq1"gAGIFQ>ZX4#Wq"3eHmG4
Qo)-*qi'=gIU.Qc@jCoDfKun$"D7%r*S.J^\epUraq"KYm8Y`qo2]Aq_CiqpP5+$G`N":JgSD
i#B&I%:-n]A!f(djPon5+Qp_#Ve,IU%OA1SQk/J`nh41!l?M2+m>nEE2DIY4,e5K$3lO:508C
I/J%%q?%'&,UGX<D`62#k0DdWCrjb)Pn!V_hR&.r'$XJH"U\db&$DO)$p5JoA.TpjmbJX3Mn
!Id,CXh7I\/f!PcVU91PeKX@nIc>o<,G;TO7^"`5n*q/@Ri,J,I`J86a4,?)/p-K>0,kjRKb
UHO$nEW6<XiidVD.0CuBf!6DJR$P*[puHWZRp*Lmb]APeG-8j2QNG/"Wej\=Wd:F.>o!k?c5A
Y.s<[=n)X#Mge\-;5*:.]ATcWM(CBa?d#4&bNVi$H`hG_?7c;r:Y?d2B'%W1*_KbR`\+bIZ?+
_J8=KX+jKY2KZ]A!X7a+%9W;^gcmiWQbmN^`FJnnMfcTAVWTVh$f+Oc,SLm2M+EU9=T6EprE5
X<3T`KfF2rU:O.9n4+-^`2QrfCG5(?59nV&df@bn1t=!KDu4U<^g1,*KD,fp>o:UNZhV>p/p
sPTXsmX;,(mfM>l/SdV$b*[E1PQMq"4Mg(Z-ocX^t/I&maI53EScg)/M.Za1Mk/"Td[gToEu
aa_C44S<tE,?Z*XntB7CF/JGqMR4h\?LucM&?!Ks(/D/6N1-tjTS)I18Mc]Am6]A!59gFVho-e
F&</=HZm]AV3grOaBAQ4Tp193lcg[&21QHG:]AdmHhBu%2k#HE7KJg4TI'-^06'%Z!E7kj7LOh
Oa,te.rhfg0dah,Te_^JaM`H/,7f(gKYgtPq3Yc0M]A=hF4%62.6^Id;Ta[c3d6;Z)Mb'Us@:
Znu*aN$NSOGE">l6q.NMOtSSa!>,.`6imMYoS9cSe\'"Y#a34;)Xk'+bRrc7B#3*:Lf_JD1/
YWhK0_C77Lm(`jp(+$S::8$(o]ASrY\Zkjdoe_XOI/nEP"]A$l_+#Mo]A*_rV$eUIFufE:jjjER
>=Vo&\J6qYp/$?G<^YOj%l2l7rQ<PdU88G81#pKQM5jpi.3;d0ec+[\,.E(=EEmrOiJc+Y9`
[0C!NHl;.4q7PA&`(la,`VE-09tT0%l_-U+4JS0<l.7:HOn+4BHZsCZ8Y"'MYu!3kEe<Gi;q
_?Aq[$$k&^9-($(Qhp;lb9Ien-k*67r,JQ-j2^\qbkSJ:6[mX_TPFi`=6_/^,#$SccG&EZH?
ii(]AJ6hgAe11-+pDb)X*X)=HIglcU2Gtb1i3O]A2>rcN*YE:gXB$\79.3#B,dLH_E7^?JA8ek
mhgdJEU2c"J'MoL%E2l_UUc$CPLW9]AVU`I+W_>RQ=Oc797b&Pi-1cG>WX)4uDV&@F4UND<#6
+h'SL*Oo6FVjTH3!s*1?_^RJYXjI4am=G8&OZ;FMZEMXg#Hfaa\BDWOKNPkTV?]A6\6=A8>)%
$q/chKmS3EJ/\hX[!sE\rinb`NEkh(_3mR96n[Hsd4?CaK$InH?/,9-'DlNTJF=d\uku.u5r
]A6)q8iZT+]A8dOGu\-m=Y5dI*\%WBY2_*Rk5'"tZXDm(2j)bAo8e3D8'eK$iUjF$XSqLijAt5
"Gm55jS(G9`a705.b)%;Ce?T<M=Ff#taM%Opdu,4mdHWAO6e7`gJV?@"5F:B(Rc"694gkX7A
K>&<CUY3SEb'To)WNC5d,uTR3/C_n:J"\80=&c\"h7pj(TC@(E@*ji+a9J>fW0m`uR5Ob&R_
?W.Z_/7CmG'UlPO>c=9q$##D``Vm.feUN)EaD/YN=Bq*;Q>u"_K"/1Db=QfW+]A-h=,E%]A#.K
4n"^/s?'lTXjHG'FK?KAYeW^UYif(nd=$Gj4fUraE15d?cqD-1I+R#/+HFrf$Qq\iUMX@oZ#
9OtNN3WaJ`V&,Dih<F;>9k++[P6o^3"*aprrC9!'dfTF&S`?*,c!Q`%W\;[D)1P51L+mBfMA
]A<hNY<-]AbE0P^q$N^\&^5"mH-9p/a<)`MM:kJF[DNh1ILT9=nnU1m6GE/XInWN=J>#_\3[;Y
)I>m.jh@7<+UG1$7<ED;eVh!44;D^PaV&QgV5RE3N1:"%@"Y.U@alt7&XSL[;p(T:KKE?!%d
7=noFq&m,inTHuaJ7rO@Nl$i&!s[G_`(kr(Yk@Qb)kp2e*V58moU'4d.pH[a.[3W8-,bid6/
&HBh<5jWAoi>.."J*6F,3^XK_+X>IGKA`U>*KN$1?BN,fQ9_0M^:+9:iYES@G,JPl3=!a!.f
*B5SaH6lUiD*RKeLhhUhV^OV-hW2/o$&$$*hX5HB-Fa&6U6ie<q^E.E9F'Sc#;&,E6g6e)8X
QCU!N(rSPs!884]A/6AQJ*#5N2eU,]A@*:AY;T.2qQ&83.'$.b.=>@QFHF-8t[b+,IFo4-J)\0
lpf5L]A8]AV_(DHs^!qSJeTj/F",o!W2b=i+EuSf=,uU]AiL315JICHYN&(09,I7GQ:0O\-DL<3
mGHgM!<)nB.$Z(*`o2/:"usCI0OGlZ/Eg*`UUC/*Ud5VFGE47gm"u=*N\L[VN02F*CYgWRUT
WRPLnS"/,,1Vt<2N*;b/YoUHdPl\;gYnSQ5.1SPLWmM]A]Amd[VVdlOT@Nh*Oe/m\f4PgpC,gR
r$KkEtpFd?`&)j,&Zl\GYVH[<"H&"qH1g_ZZ5rmhrM-`RBD+ISV-LiT_ZL8$QVOGP(":jirP
NXTPNV&+*n2tU*YX`"YGICZ)q6*n&9FWIZ.*c8(ce?&sD]ADRg.$hU8Ni6c$_jfn.3R#1kbXC
</Q>]Au@/,//e@s14=&j"g%N%8[j&1Vl=0p).4,3,cCF5,,+8*`\*>,1R^;uA+60\V'O3B>q8
dX^1/]A51I,WBsT0(rF#)bB:3\52/R]A0ILcQahtfm0*[C\q5*/f9hr@V3'/?/NH8%:m)[@mTl
dJ/cfWTG_F'j@2h*u9@O($.]AZP*i9AFj3e`MHJ7$1kSP#LfM65TF]AW8^03Y6F)k;g8L*Ja#J
aAJ"&$r_Knj:B]AdP[8e6rRfp)0:<J4"9,hE4f(&ZEPlddH"A]A^+Q-``Eqe@d?9a^RhTF-bAD
9iRJAfrJ!J7ZjkIn,h<9P@"[mMN!3jrq,qGDi]Ag+R1>t)ZI6_Bs<595hM<Qj<F6f3N_Zc-6g
Gps1*cE3Be%>mti+`^R=d$:0q#ZhlV_!cF=^D9UUGcY+A=<#dJ#CqPt!N?'l`rlm^]A2^n@p=
5`@2B>l?\]A7X*pf1esW3^0^W7CMAQ]A(/\GZNtk*2EVbE2/&VW=XNmlAVGmI+T4K\-"DR4W2&
5G!Nh4p?2f,@dU[rMNf>4Y4FOpK]A"i&t3r.8;F$\#oFp]A\Fj(]A8kln-a]A]A0DG_N^IFW'QLTV
$;WlX:)M5lGh$7"q05gu-n_#j=>4]A1<)g$1.*a?AU_Ko._@H4CG3]A]APk'P]A;Gf518'oDd:/s
%<>(2":Ah_-2bWMj)2<g1*G#rW`~
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
<BoundsAttr x="0" y="0" width="169" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="55" y="171" width="169" height="80"/>
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
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNSm#f7Qt5`obBf0*VO&7=YciYYQJkO%qp]AS@I0=<&^?#G'le@'
#GsF%b_Sk?%PeqgM\<s*SkQpM-@m"5EVu<h?]A$Z>p'i1B.R,)dHVBh_5.D`!#Hcn,iig?%*c
d[t:Np%qBe_p&HlJZorjC;K?0[!77VP!eR3.-ojn[P,%(d3D,<pUZ<g`8rf(0j=!#\Nfp0u-
ojn[P,%(d3@N!A7c&WEj^t#_M?EDd4C.njei>$5!<<~
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
<BoundsAttr x="0" y="0" width="360" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="55" y="264" width="360" height="80"/>
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
<BoundsAttr x="0" y="0" width="360" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="55" y="358" width="360" height="80"/>
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
<BoundsAttr x="0" y="0" width="360" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="55" y="457" width="360" height="80"/>
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
<BoundsAttr x="0" y="0" width="175" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="240" y="170" width="175" height="80"/>
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
<BoundsAttr x="0" y="0" width="172" height="80"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="55" y="170" width="172" height="80"/>
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
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNSm#f7Qt5`obBf0*VO&7=YciYYQJkO%qp]AS@I0=<&^?#G'le@'
#GsF%b_Sk?%PeqgM\<s*SkQpM-@m"5EVu<h?]A$Z>p'i1B.R,)dHVBh_5.D`!#Hcn,iig?%*c
d[t:Np%qBe_p&HlJZorjC;K?0[!77VP!eR3.-ojn[P,%(d3D,<pUZ<g`8rf(0j=!#\Nfp0u-
ojn[P,%(d3@N!A7c&WEj^t#_M?EDd4C.njei>$5!<<~
]]></IM>
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
<FileAttrErrorMarker-I18NMap class="com.fr.base.io.FileAttrErrorMarker" plugin-version="2.0.8.4" oriClass="com.fr.plugin.i18n.bundle.configurator.data.I18NAttrMark" pluginID="com.fr.plugin.i18n.bundle.v11">
<Attributes default="" backup="en_US" languageType="0"/>
<I18N description="" key="REC_DATE">
<zh_TW>
<![CDATA[認列投收年度(起訖)]]></zh_TW>
<en_US>
<![CDATA[Recognition year of investment income (start and end)]]></en_US>
</I18N>
<I18N description="" key="EXP_YEAR">
<zh_TW>
<![CDATA[可抵繳稅額期限]]></zh_TW>
<en_US>
<![CDATA[Deductible tax expired year]]></en_US>
</I18N>
<I18N description="" key="CN_PAID_TAX">
<zh_TW>
<![CDATA[於大陸地區已繳納所得稅]]></zh_TW>
<en_US>
<![CDATA[Income tax paid in China]]></en_US>
</I18N>
<I18N description="" key="CFC_COMPANY">
<zh_TW>
<![CDATA[CFC公司]]></zh_TW>
<en_US>
<![CDATA[CFC company name]]></en_US>
</I18N>
<I18N description="" key="REC_YEAR">
<zh_TW>
<![CDATA[認列投資收益年度]]></zh_TW>
<en_US>
<![CDATA[Recognition year of investment income]]></en_US>
</I18N>
<I18N description="" key="NY_CN_PAID_TAX">
<zh_TW>
<![CDATA[年內過期之大陸地區已繳納所得稅]]></zh_TW>
<en_US>
<![CDATA[Income tax paid in China expired within 2 years]]></en_US>
</I18N>
<I18N description="" key="COMPANY">
<zh_TW>
<![CDATA[申報公司]]></zh_TW>
<en_US>
<![CDATA[Entity name]]></en_US>
</I18N>
<I18N description="" key="BALANCE">
<zh_TW>
<![CDATA[尚未獲配(或處分)餘額]]></zh_TW>
<en_US>
<![CDATA[Balance not yet distributed (or disposed)]]></en_US>
</I18N>
<I18N description="" key="CN_TAX_NOT_OFFSET">
<zh_TW>
<![CDATA[尚未抵繳]]></zh_TW>
<en_US>
<![CDATA[Tax not yet deducted ]]></en_US>
</I18N>
<I18N description="" key="CN_TAX_PAID">
<zh_TW>
<![CDATA[已繳納之所得稅]]></zh_TW>
<en_US>
<![CDATA[Income tax paid]]></en_US>
</I18N>
<I18N description="" key="ACT_REA_DIV">
<zh_TW>
<![CDATA[已認列投收]]></zh_TW>
<en_US>
<![CDATA[Recognized before]]></en_US>
</I18N>
<I18N description="" key="ACT_TAX_DIV">
<zh_TW>
<![CDATA[應計入課稅]]></zh_TW>
<en_US>
<![CDATA[Taxable]]></en_US>
</I18N>
<I18N description="" key="REC_CFC_TOTAL_INV">
<zh_TW>
<![CDATA[認列CFC投收總額]]></zh_TW>
<en_US>
<![CDATA[Total CFC investment income]]></en_US>
</I18N>
<I18N description="" key="TITLE">
<zh_TW>
<![CDATA[投資收益及可扣抵稅額總覽]]></zh_TW>
<en_US>
<![CDATA[Recognition of CFC Income and Tax Credits Overview]]></en_US>
</I18N>
<I18N description="" key="SCENARIO">
<zh_TW>
<![CDATA[版本]]></zh_TW>
<en_US>
<![CDATA[Scenario]]></en_US>
</I18N>
<I18N description="" key="REC_INV">
<zh_TW>
<![CDATA[依規定認列之投資收益]]></zh_TW>
<en_US>
<![CDATA[CFC investment income]]></en_US>
</I18N>
<I18N description="" key="DUEDATE">
<zh_TW>
<![CDATA[到期年門檻]]></zh_TW>
<en_US>
<![CDATA[Expiration year threshold]]></en_US>
</I18N>
<I18N description="" key="REST_TOTAL">
<zh_TW>
<![CDATA[尚未獲配(或處分)餘額]]></zh_TW>
<en_US>
<![CDATA[Balance not yet distributed (or disposed)]]></en_US>
</I18N>
<I18N description="" key="AMOUNT_ALLOCATED_PRE">
<zh_TW>
<![CDATA[截至上年度累積已獲配(或已處分)]]></zh_TW>
<en_US>
<![CDATA[Accumulated distributed (or disposed) as of the previous year]]></en_US>
</I18N>
<I18N description="" key="CN_TAX_OFFSET">
<zh_TW>
<![CDATA[已抵繳]]></zh_TW>
<en_US>
<![CDATA[Tax deducted ]]></en_US>
</I18N>
<I18N description="" key="AMOUNT_DIS">
<zh_TW>
<![CDATA[於申報年度實際處分]]></zh_TW>
<en_US>
<![CDATA[Disposal amount in filing year]]></en_US>
</I18N>
<I18N description="" key="FISCAL_YEAR_ACTUAL_DIVIDEND">
<zh_TW>
<![CDATA[於申報年度實際獲配]]></zh_TW>
<en_US>
<![CDATA[Distribute amount in filing year]]></en_US>
</I18N>
<I18N description="" key="CN_PAID">
<zh_TW>
<![CDATA[於大陸地區已納所得稅抵繳情形 ]]></zh_TW>
<en_US>
<![CDATA[The status of Income tax paid in China]]></en_US>
</I18N>
<I18N description="" key="SUBMIT">
<zh_TW>
<![CDATA[查詢]]></zh_TW>
<en_US>
<![CDATA[Search]]></en_US>
</I18N>
<I18N description="" key="TOTAL">
<zh_TW>
<![CDATA[總計]]></zh_TW>
<en_US>
<![CDATA[Total]]></en_US>
</I18N>
<I18N description="" key="TITLE_COUNTRY_REPORT">
<zh_TW>
<![CDATA[國別報告當期總覽]]></zh_TW>
<en_US>
<![CDATA[Country Report Overview]]></en_US>
</I18N>
<I18N description="" key="UNIT">
<zh_TW>
<![CDATA[單位]]></zh_TW>
<en_US>
<![CDATA[UNIT]]></en_US>
</I18N>
<I18N description="" key="PERIOD1">
<zh_TW>
<![CDATA[期間]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N description="" key="COUNTRY_LOCATION">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country Location]]></en_US>
</I18N>
<I18N description="" key="ENTITY_NAME">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Report Members]]></en_US>
</I18N>
<I18N description="" key="col_income_non_rel">
<zh_TW>
<![CDATA[收入_非關係人]]></zh_TW>
<en_US>
<![CDATA[Revenues-Unrelated Party]]></en_US>
</I18N>
<I18N description="" key="col_income_rel">
<zh_TW>
<![CDATA[收入_關係人]]></zh_TW>
<en_US>
<![CDATA[Revenues-Related Party]]></en_US>
</I18N>
<I18N description="" key="col_income">
<zh_TW>
<![CDATA[收入]]></zh_TW>
<en_US>
<![CDATA[Revenues]]></en_US>
</I18N>
<I18N description="" key="col_pre_tax_income">
<zh_TW>
<![CDATA[所得稅前損益]]></zh_TW>
<en_US>
<![CDATA[Profit (Loss) before Income Tax]]></en_US>
</I18N>
<I18N description="" key="col_tax_paid">
<zh_TW>
<![CDATA[已納所得稅(現金收付制)]]></zh_TW>
<en_US>
<![CDATA[Income Tax Paid (on Cash Basis)]]></en_US>
</I18N>
<I18N description="" key="col_curr_tax_payable">
<zh_TW>
<![CDATA[當期應付所得稅]]></zh_TW>
<en_US>
<![CDATA[Income Tax Accrued-Current Year]]></en_US>
</I18N>
<I18N description="" key="col_paid_up_capital">
<zh_TW>
<![CDATA[實收資本額]]></zh_TW>
<en_US>
<![CDATA[Stated Capital]]></en_US>
</I18N>
<I18N description="" key="col_accu_surplus">
<zh_TW>
<![CDATA[累積盈餘]]></zh_TW>
<en_US>
<![CDATA[Accumulated Earnings]]></en_US>
</I18N>
<I18N description="" key="col_num_of_emp">
<zh_TW>
<![CDATA[員工人數]]></zh_TW>
<en_US>
<![CDATA[Number of Employees]]></en_US>
</I18N>
<I18N description="" key="col_tangible_asset">
<zh_TW>
<![CDATA[有形資產(現金及約當現金除外) ]]></zh_TW>
<en_US>
<![CDATA[Tangible Assets other than Cash and Cash Equivalents]]></en_US>
</I18N>
<I18N description="" key="EFFECTIVE_TAX_RATE">
<zh_TW>
<![CDATA[有效稅率]]></zh_TW>
<en_US>
<![CDATA[Effective Tax Rate]]></en_US>
</I18N>
<I18N description="" key="PRE_TAX_PROFIT_MARGIN">
<zh_TW>
<![CDATA[稅前淨利率]]></zh_TW>
<en_US>
<![CDATA[Pre-Tax Profit Margin]]></en_US>
</I18N>
<I18N description="" key="report2">
<zh_TW>
<![CDATA[國別報告表二]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report Table 2]]></en_US>
</I18N>
<I18N description="" key="report3">
<zh_TW>
<![CDATA[國別報告表三]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report Table 3]]></en_US>
</I18N>
<I18N description="國家地區" key="country_id">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_hold_share_or_other_eqty">
<zh_TW>
<![CDATA[持有股份或其他權益工具]]></zh_TW>
<en_US>
<![CDATA[Holding Shares or Other Equity Instruments]]></en_US>
</I18N>
<I18N description="" key="report1">
<zh_TW>
<![CDATA[國別報告表一]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report Table 1]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_int_grp_fin">
<zh_TW>
<![CDATA[集團內部融資]]></zh_TW>
<en_US>
<![CDATA[Internal Group Finance]]></en_US>
</I18N>
<I18N description="" key="entity_id">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_purchase">
<zh_TW>
<![CDATA[採購]]></zh_TW>
<en_US>
<![CDATA[Purchasing or Procurement]]></en_US>
</I18N>
<I18N description="上傳資料" key="upload_record">
<zh_CN>
<![CDATA[新增数据]]></zh_CN>
<zh_TW>
<![CDATA[新增]]></zh_TW>
<en_US>
<![CDATA[Add]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_out_of_business">
<zh_TW>
<![CDATA[停業]]></zh_TW>
<en_US>
<![CDATA[Dormant]]></en_US>
</I18N>
<I18N description="語言" key="language">
<zh_CN>
<![CDATA[语言]]></zh_CN>
<zh_TW>
<![CDATA[語言]]></zh_TW>
<en_US>
<![CDATA[Language]]></en_US>
</I18N>
<I18N description="" key="title">
<zh_TW>
<![CDATA[國別報告表]]></zh_TW>
<en_US>
<![CDATA[Cbcr data import]]></en_US>
</I18N>
<I18N description="提交" key="submit_enter">
<zh_CN>
<![CDATA[提交]]></zh_CN>
<zh_TW>
<![CDATA[提交]]></zh_TW>
<en_US>
<![CDATA[Submit]]></en_US>
</I18N>
<I18N description="搜尋" key="search_enter">
<zh_CN>
<![CDATA[搜寻]]></zh_CN>
<zh_TW>
<![CDATA[搜尋]]></zh_TW>
<en_US>
<![CDATA[Search]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_insurance">
<zh_TW>
<![CDATA[保險]]></zh_TW>
<en_US>
<![CDATA[Insurance]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_admin_mgnt_sup">
<zh_TW>
<![CDATA[行政、管理或支援服務]]></zh_TW>
<en_US>
<![CDATA[Administrative, Management or Support Services]]></en_US>
</I18N>
<I18N description="編輯" key="edit_record">
<zh_CN>
<![CDATA[编辑]]></zh_CN>
<zh_TW>
<![CDATA[編輯]]></zh_TW>
<en_US>
<![CDATA[Edit]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_provide_serv_to_nrp">
<zh_TW>
<![CDATA[對非關係人提供服務]]></zh_TW>
<en_US>
<![CDATA[Provision of Services to Unrelated Parties]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_hold_int_property">
<zh_TW>
<![CDATA[持有或管理智慧財產權 ]]></zh_TW>
<en_US>
<![CDATA[Holding or Managing Intellectual Property]]></en_US>
</I18N>
<I18N description="" key="period">
<zh_TW>
<![CDATA[期間]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_main_ope_ther_ifmn">
<zh_TW>
<![CDATA[主要營運活動_其他資訊]]></zh_TW>
<en_US>
<![CDATA[Additional Information]]></en_US>
</I18N>
<I18N description="" key="entity_name_en">
<zh_TW>
<![CDATA[報告成員英文名稱]]></zh_TW>
</I18N>
<I18N description="國別報告表二" key="col_manufacture">
<zh_TW>
<![CDATA[製造或生產]]></zh_TW>
<en_US>
<![CDATA[Manufacturing or Production]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_regu_fin_serv">
<zh_TW>
<![CDATA[受規範金融服務 ]]></zh_TW>
<en_US>
<![CDATA[Regulated Financial Services]]></en_US>
</I18N>
<I18N description="刪除" key="delete_record">
<zh_CN>
<![CDATA[删除]]></zh_CN>
<zh_TW>
<![CDATA[刪除]]></zh_TW>
<en_US>
<![CDATA[Delete]]></en_US>
</I18N>
<I18N description="" key="entity_name_zh">
<zh_TW>
<![CDATA[報告成員中文名稱]]></zh_TW>
</I18N>
<I18N description="國別報告表二" key="col_sales_mkt_distrbn">
<zh_TW>
<![CDATA[銷售、行銷或配銷 ]]></zh_TW>
<en_US>
<![CDATA[Sales, Marketing or Distribution]]></en_US>
</I18N>
<I18N description="" key="PLACE_HOLDER">
<zh_TW>
<![CDATA[請提供任何必要或有助於了解國別報告應揭露資訊之簡要說明]]></zh_TW>
</I18N>
<I18N description="國別報告表二" key="col_res_and_dev">
<zh_TW>
<![CDATA[研究與發展]]></zh_TW>
<en_US>
<![CDATA[Research and Development]]></en_US>
</I18N>
<I18N description="" key="report_name">
<zh_TW>
<![CDATA[國別報告表]]></zh_TW>
<en_US>
<![CDATA[Cbcr Report]]></en_US>
</I18N>
<I18N description="國別報告表二" key="col_others">
<zh_TW>
<![CDATA[其他]]></zh_TW>
<en_US>
<![CDATA[Main business activity(ies)-Other]]></en_US>
</I18N>
<I18N description="" key="cbcr_overview">
<zh_TW>
<![CDATA[國別報告當期總覽]]></zh_TW>
<en_US>
<![CDATA[CbCR Overview]]></en_US>
</I18N>
</FileAttrErrorMarker-I18NMap>
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
<ForkIdAttrMark class="com.fr.base.iofile.attr.ForkIdAttrMark">
<ForkIdAttrMark forkId="67239230-bd06-4f31-b687-3ee1c3a2f206"/>
</ForkIdAttrMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.32.0.20241202">
<TemplateCloudInfoAttrMark createTime="1711940947019"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="67239230-bd06-4f31-b687-3ee1c3a2f206"/>
</TemplateIdAttMark>
</Form>
