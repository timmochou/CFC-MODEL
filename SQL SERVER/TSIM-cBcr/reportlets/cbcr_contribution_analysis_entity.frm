<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20211223" releaseVersion="11.0.0">
<TableDataMap>
<TableData name="Dic_Period" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT DISTINCT PERIOD FROM TRS_FACT_COUNTRY_REPORT
ORDER BY PERIOD DESC  
]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Country" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
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
<![CDATA[SELECT DISTINCT
T3.COUNTRY_CODE,
T3.COUNTRY_NAME
FROM TRS_FACT_COUNTRY_REPORT T1
LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.CURRENT_CODE
LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_CODE
JOIN V_TRS_DATA_AUTHORIZATION T4 ON T2.ENTITY_ID = T4.ent_id
WHERE T3.FR_LOCALE = '${fr_locale}']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Table1" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH COLUMNS AS (  
    SELECT   
	    '1' AS SORT,
        'col_ros' AS COLUMN_NAME  
    UNION ALL  
    SELECT   
	    '2' AS SORT,
        'col_roa' AS COLUMN_NAME  
    UNION ALL 
    SELECT   
	    '3' AS SORT,
        'col_roe' AS COLUMN_NAME  
    UNION ALL  
    SELECT   
	    '4' AS SORT,
        'col_etr' AS COLUMN_NAME  
    UNION ALL  
    SELECT   
	    '5' AS SORT,
        'col_emp1' AS COLUMN_NAME  
    UNION ALL  
    SELECT 
        '6' AS SORT,	
        'col_emp2' AS COLUMN_NAME
)  
SELECT  
    SORT,
    COLUMN_NAME  
FROM COLUMNS  
ORDER BY SORT ASC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_表格圖" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2025-09]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_TABLE"/>
<O>
<![CDATA[col_ros]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[TW]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--加入排序且將指標行轉直(成功)
WITH auth AS (
SELECT DISTINCT
T1.USERNAME,
T1.REALNAME,
T1.COMPANY_DISPLAY,
T1.COMP_ID,
T1.ENTITY_DISPLAY,
T1.ENT_ID,
T1.MODULE
FROM V_TRS_DATA_AUTHORIZATION T1
),
REPORT1 AS (
SELECT
T1.PERIOD,
T3.COUNTRY_CODE,
T3.COUNTRY_NAME,
T1.ENTITY_ID,
T2.ENTITY_NAME,
T1.DATA_NAME,
TRY_CAST(t1.value AS FLOAT) AS value
FROM TRS_FACT_COUNTRY_REPORT T1
LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID
LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID
JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID
WHERE REPORT_NAME = 'REPORT1'
AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')
AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'
)
,TABLE1 AS (
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
COALESCE([col_income]A, 0) AS col_income,
COALESCE([col_pre_tax_income]A, 0) AS col_pre_tax_income,
COALESCE([col_curr_tax_payable]A, 0) AS col_curr_tax_payable,
COALESCE([col_paid_up_capital]A, 0) AS col_paid_up_capital,
COALESCE([col_accu_surplus]A, 0) AS col_accu_surplus,
COALESCE([col_num_of_emp]A, 0) AS col_num_of_emp,
COALESCE([col_tangible_asset]A, 0) AS col_tangible_asset,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_income]A, 0), 0) AS col_ros,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_tangible_asset]A, 0), 0) AS col_roa,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_paid_up_capital]A, 0) + COALESCE([col_accu_surplus]A, 0), 0) AS col_roe,
COALESCE([col_curr_tax_payable]A, 0) / NULLIF(COALESCE([col_pre_tax_income]A, 0), 0) AS col_etr,
COALESCE([col_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp1,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp2
FROM REPORT1
PIVOT (
MAX(VALUE)
FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,[col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,[col_tangible_asset]A)) AS pvt
)
--select * from TABLE1 
--where period = '2024-09'
,TABLE2 AS(
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME, 'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,
col_pre_tax_income as numerator,
col_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,
col_pre_tax_income as numerator,
col_tangible_asset as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,
col_pre_tax_income as numerator,
col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,
col_curr_tax_payable as numerator,
col_pre_tax_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,
col_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,
col_pre_tax_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
)
--SELECT * FROM TABLE2
,PERIOD_LST1 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)
--select * from PERIOD_LST1
,PERIOD_LST2 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)  

,PERIOD_CURRENT AS (
SELECT
T1.PERIOD AS PERIOD_1,
T1.PERIOD AS PERIOD_2,
T1.*
FROM TABLE2 T1
WHERE T1.period = '${P_PERIOD}'
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST1 T1
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST2 T1
)
--SELECT * FROM PERIOD_CURRENT
,PERIOD_FINAL AS(
SELECT
PERIOD_1 AS PERIOD,
PERIOD AS classification,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
DATA_NAME,
ROUND(VALUE, 4) AS VALUE,
numerator,
denominator
FROM PERIOD_CURRENT 
WHERE denominator != 0
)
--select * from PERIOD_FINAL
, RANKED_DATA AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    numerator,  
    denominator,  
    RANK() OVER (PARTITION BY classification, COUNTRY_CODE, COUNTRY_NAME, DATA_NAME ORDER BY VALUE DESC) AS RANK  
FROM PERIOD_FINAL  
)  
,TABLE3 AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    CASE  
        WHEN RANK <= 5 THEN CAST(RANK AS NVARCHAR)  
        ELSE '-'  
    END AS TOP5,  
    numerator,  
    denominator  
FROM  
    RANKED_DATA  
),
ENTITY_SORT_DATA AS (  
    SELECT DISTINCT
        ENTITY_ID,
        ENTITY_NAME,  
        DENSE_RANK() OVER (ORDER BY ENTITY_NAME ASC) AS ENTITY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.ENTITY_SORT
FROM TABLE3 t1
LEFT JOIN ENTITY_SORT_DATA t2 on t1.ENTITY_ID = t2.ENTITY_ID
WHERE 1=1
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
${if(LEN(P_COUNTRY)=0,"","AND COUNTRY_CODE IN ('"+P_COUNTRY+"')")}
ORDER BY 
        classification ASC,
        VALUE DESC,
        ENTITY_SORT ASC;]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_條形圖(當年度)" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_TABLE"/>
<O>
<![CDATA[col_emp2]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2023-12]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[TW]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--加入排序且將指標行轉直(成功)
WITH auth AS (
SELECT DISTINCT
T1.USERNAME,
T1.REALNAME,
T1.COMPANY_DISPLAY,
T1.COMP_ID,
T1.ENTITY_DISPLAY,
T1.ENT_ID,
T1.MODULE
FROM V_TRS_DATA_AUTHORIZATION T1
),
REPORT1 AS (
SELECT
T1.PERIOD,
T3.COUNTRY_CODE,
T3.COUNTRY_NAME,
T1.ENTITY_ID,
T2.ENTITY_NAME,
T1.DATA_NAME,
TRY_CAST(t1.value AS FLOAT) AS value
FROM TRS_FACT_COUNTRY_REPORT T1
LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID
LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID
JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID
WHERE REPORT_NAME = 'REPORT1'
AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')
AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'
)
,TABLE1 AS (
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
COALESCE([col_income]A, 0) AS col_income,
COALESCE([col_pre_tax_income]A, 0) AS col_pre_tax_income,
COALESCE([col_curr_tax_payable]A, 0) AS col_curr_tax_payable,
COALESCE([col_paid_up_capital]A, 0) AS col_paid_up_capital,
COALESCE([col_accu_surplus]A, 0) AS col_accu_surplus,
COALESCE([col_num_of_emp]A, 0) AS col_num_of_emp,
COALESCE([col_tangible_asset]A, 0) AS col_tangible_asset,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_income]A, 0), 0) AS col_ros,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_tangible_asset]A, 0), 0) AS col_roa,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_paid_up_capital]A, 0) + COALESCE([col_accu_surplus]A, 0), 0) AS col_roe,
COALESCE([col_curr_tax_payable]A, 0) / NULLIF(COALESCE([col_pre_tax_income]A, 0), 0) AS col_etr,
COALESCE([col_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp1,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp2
FROM REPORT1
PIVOT (
MAX(VALUE)
FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,[col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,[col_tangible_asset]A)) AS pvt
)
--select * from TABLE1 
--where period = '2024-09'
,TABLE2 AS(
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME, 'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,
col_pre_tax_income as numerator,
col_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,
col_pre_tax_income as numerator,
col_tangible_asset as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,
col_pre_tax_income as numerator,
col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,
col_curr_tax_payable as numerator,
col_pre_tax_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,
col_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,
col_pre_tax_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
)
--SELECT * FROM TABLE2
,PERIOD_LST1 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)
--select * from PERIOD_LST1
,PERIOD_LST2 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)  

,PERIOD_CURRENT AS (
SELECT
T1.PERIOD AS PERIOD_1,
T1.PERIOD AS PERIOD_2,
T1.*
FROM TABLE2 T1
WHERE T1.period = '${P_PERIOD}'
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST1 T1
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST2 T1
)
--SELECT * FROM PERIOD_CURRENT
,PERIOD_FINAL AS(
SELECT
PERIOD_1 AS PERIOD,
PERIOD AS classification,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
DATA_NAME,
ROUND(VALUE, 4) AS VALUE,
numerator,
denominator
FROM PERIOD_CURRENT 
WHERE denominator != 0
)
--select * from PERIOD_FINAL
, RANKED_DATA AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    numerator,  
    denominator,  
    RANK() OVER (PARTITION BY classification, COUNTRY_CODE, COUNTRY_NAME, DATA_NAME ORDER BY VALUE DESC) AS RANK  
FROM PERIOD_FINAL  
)  
,TABLE3 AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    CASE  
        WHEN RANK <= 5 THEN CAST(RANK AS NVARCHAR)  
        ELSE '-'  
    END AS TOP5,  
    numerator,  
    denominator  
FROM  
    RANKED_DATA  
),
ENTITY_SORT_DATA AS (  
    SELECT DISTINCT
        ENTITY_ID,
        ENTITY_NAME,  
        DENSE_RANK() OVER (ORDER BY ENTITY_NAME ASC) AS ENTITY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.ENTITY_SORT
FROM TABLE3 t1
LEFT JOIN ENTITY_SORT_DATA t2 on t1.ENTITY_ID = t2.ENTITY_ID
WHERE classification = '${P_PERIOD}'--視年度更改語法
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
${if(LEN(P_COUNTRY)=0,"","AND COUNTRY_CODE IN ('"+P_COUNTRY+"')")}
ORDER BY 
        classification ASC,
        VALUE DESC,
        ENTITY_SORT ASC;]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_條形圖(前年度)" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_TABLE"/>
<O>
<![CDATA[col_ros]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2025-12]]></O>
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
<![CDATA[--加入排序且將指標行轉直(成功)
WITH auth AS (
SELECT DISTINCT
T1.USERNAME,
T1.REALNAME,
T1.COMPANY_DISPLAY,
T1.COMP_ID,
T1.ENTITY_DISPLAY,
T1.ENT_ID,
T1.MODULE
FROM V_TRS_DATA_AUTHORIZATION T1
),
REPORT1 AS (
SELECT
T1.PERIOD,
T3.COUNTRY_CODE,
T3.COUNTRY_NAME,
T1.ENTITY_ID,
T2.ENTITY_NAME,
T1.DATA_NAME,
TRY_CAST(t1.value AS FLOAT) AS value
FROM TRS_FACT_COUNTRY_REPORT T1
LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID
LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID
JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID
WHERE REPORT_NAME = 'REPORT1'
AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')
AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'
)
,TABLE1 AS (
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
COALESCE([col_income]A, 0) AS col_income,
COALESCE([col_pre_tax_income]A, 0) AS col_pre_tax_income,
COALESCE([col_curr_tax_payable]A, 0) AS col_curr_tax_payable,
COALESCE([col_paid_up_capital]A, 0) AS col_paid_up_capital,
COALESCE([col_accu_surplus]A, 0) AS col_accu_surplus,
COALESCE([col_num_of_emp]A, 0) AS col_num_of_emp,
COALESCE([col_tangible_asset]A, 0) AS col_tangible_asset,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_income]A, 0), 0) AS col_ros,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_tangible_asset]A, 0), 0) AS col_roa,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_paid_up_capital]A, 0) + COALESCE([col_accu_surplus]A, 0), 0) AS col_roe,
COALESCE([col_curr_tax_payable]A, 0) / NULLIF(COALESCE([col_pre_tax_income]A, 0), 0) AS col_etr,
COALESCE([col_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp1,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp2
FROM REPORT1
PIVOT (
MAX(VALUE)
FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,[col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,[col_tangible_asset]A)) AS pvt
)
--select * from TABLE1 
--where period = '2024-09'
,TABLE2 AS(
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME, 'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,
col_pre_tax_income as numerator,
col_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,
col_pre_tax_income as numerator,
col_tangible_asset as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,
col_pre_tax_income as numerator,
col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,
col_curr_tax_payable as numerator,
col_pre_tax_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,
col_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,
col_pre_tax_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
)
--SELECT * FROM TABLE2
,PERIOD_LST1 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)
--select * from PERIOD_LST1
,PERIOD_LST2 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)  

,PERIOD_CURRENT AS (
SELECT
T1.PERIOD AS PERIOD_1,
T1.PERIOD AS PERIOD_2,
T1.*
FROM TABLE2 T1
WHERE T1.period = '${P_PERIOD}'
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST1 T1
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST2 T1
)
--SELECT * FROM PERIOD_CURRENT
,PERIOD_FINAL AS(
SELECT
PERIOD_1 AS PERIOD,
PERIOD AS classification,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
DATA_NAME,
ROUND(VALUE, 4) AS VALUE,
numerator,
denominator
FROM PERIOD_CURRENT 
WHERE denominator != 0
)
--select * from PERIOD_FINAL
, RANKED_DATA AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    numerator,  
    denominator,  
    RANK() OVER (PARTITION BY classification, COUNTRY_CODE, COUNTRY_NAME, DATA_NAME ORDER BY VALUE DESC) AS RANK  
FROM PERIOD_FINAL  
)  
,TABLE3 AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    CASE  
        WHEN RANK <= 5 THEN CAST(RANK AS NVARCHAR)  
        ELSE '-'  
    END AS TOP5,  
    numerator,  
    denominator  
FROM  
    RANKED_DATA  
),
ENTITY_SORT_DATA AS (  
    SELECT DISTINCT
        ENTITY_ID,
        ENTITY_NAME,  
        DENSE_RANK() OVER (ORDER BY ENTITY_NAME ASC) AS ENTITY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.ENTITY_SORT
FROM TABLE3 t1
LEFT JOIN ENTITY_SORT_DATA t2 on t1.ENTITY_ID = t2.ENTITY_ID
WHERE classification = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))--視年度更改語法
AND TOP5 != '-'
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
${if(LEN(P_COUNTRY)=0,"","AND COUNTRY_CODE IN ('"+P_COUNTRY+"')")}
ORDER BY 
        classification ASC,
        VALUE DESC,
        ENTITY_SORT ASC;]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_條形圖(前兩年度)" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_TABLE"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--加入排序且將指標行轉直(成功)
WITH auth AS (
SELECT DISTINCT
T1.USERNAME,
T1.REALNAME,
T1.COMPANY_DISPLAY,
T1.COMP_ID,
T1.ENTITY_DISPLAY,
T1.ENT_ID,
T1.MODULE
FROM V_TRS_DATA_AUTHORIZATION T1
),
REPORT1 AS (
SELECT
T1.PERIOD,
T3.COUNTRY_CODE,
T3.COUNTRY_NAME,
T1.ENTITY_ID,
T2.ENTITY_NAME,
T1.DATA_NAME,
TRY_CAST(t1.value AS FLOAT) AS value
FROM TRS_FACT_COUNTRY_REPORT T1
LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID
LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID
JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID
WHERE REPORT_NAME = 'REPORT1'
AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')
AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'
)
,TABLE1 AS (
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
COALESCE([col_income]A, 0) AS col_income,
COALESCE([col_pre_tax_income]A, 0) AS col_pre_tax_income,
COALESCE([col_curr_tax_payable]A, 0) AS col_curr_tax_payable,
COALESCE([col_paid_up_capital]A, 0) AS col_paid_up_capital,
COALESCE([col_accu_surplus]A, 0) AS col_accu_surplus,
COALESCE([col_num_of_emp]A, 0) AS col_num_of_emp,
COALESCE([col_tangible_asset]A, 0) AS col_tangible_asset,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_income]A, 0), 0) AS col_ros,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_tangible_asset]A, 0), 0) AS col_roa,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_paid_up_capital]A, 0) + COALESCE([col_accu_surplus]A, 0), 0) AS col_roe,
COALESCE([col_curr_tax_payable]A, 0) / NULLIF(COALESCE([col_pre_tax_income]A, 0), 0) AS col_etr,
COALESCE([col_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp1,
COALESCE([col_pre_tax_income]A, 0) / NULLIF(COALESCE([col_num_of_emp]A, 0), 0) AS col_emp2
FROM REPORT1
PIVOT (
MAX(VALUE)
FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,[col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,[col_tangible_asset]A)) AS pvt
)
--select * from TABLE1 
--where period = '2024-09'
,TABLE2 AS(
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME, 'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,
col_pre_tax_income as numerator,
col_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,
col_pre_tax_income as numerator,
col_tangible_asset as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,
col_pre_tax_income as numerator,
col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,
col_curr_tax_payable as numerator,
col_pre_tax_income as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,
col_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
UNION ALL
SELECT
PERIOD,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,
col_pre_tax_income as numerator,
col_num_of_emp as denominator
FROM TABLE1
)
--SELECT * FROM TABLE2
,PERIOD_LST1 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)
--select * from PERIOD_LST1
,PERIOD_LST2 AS (  
SELECT  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_1,  
CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')), '00')) AS PERIOD_2,  
T1.*  
from TABLE2 T1  
WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')), '00'))  
)  

,PERIOD_CURRENT AS (
SELECT
T1.PERIOD AS PERIOD_1,
T1.PERIOD AS PERIOD_2,
T1.*
FROM TABLE2 T1
WHERE T1.period = '${P_PERIOD}'
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST1 T1
UNION
SELECT
T1.PERIOD_1,
T1.PERIOD_2,
T1.PERIOD,
T1.COUNTRY_CODE,
T1.COUNTRY_NAME,
T1.ENTITY_ID,
T1.ENTITY_NAME,
T1.DATA_NAME,
T1.VALUE,
T1.numerator,
T1.denominator
FROM PERIOD_LST2 T1
)
--SELECT * FROM PERIOD_CURRENT
,PERIOD_FINAL AS(
SELECT
PERIOD_1 AS PERIOD,
PERIOD AS classification,
COUNTRY_CODE,
COUNTRY_NAME,
ENTITY_ID,
ENTITY_NAME,
DATA_NAME,
ROUND(VALUE, 4) AS VALUE,
numerator,
denominator
FROM PERIOD_CURRENT 
WHERE denominator != 0
)
--select * from PERIOD_FINAL
, RANKED_DATA AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    numerator,  
    denominator,  
    RANK() OVER (PARTITION BY classification, COUNTRY_CODE, COUNTRY_NAME, DATA_NAME ORDER BY VALUE DESC) AS RANK  
FROM PERIOD_FINAL  
)  
,TABLE3 AS (  
SELECT  
    PERIOD,  
    classification,  
    COUNTRY_CODE,  
    COUNTRY_NAME,  
    ENTITY_ID,  
    ENTITY_NAME,  
    DATA_NAME,  
    VALUE,  
    CASE  
        WHEN RANK <= 5 THEN CAST(RANK AS NVARCHAR)  
        ELSE '-'  
    END AS TOP5,  
    numerator,  
    denominator  
FROM  
    RANKED_DATA  
),
ENTITY_SORT_DATA AS (  
    SELECT DISTINCT
        ENTITY_ID,
        ENTITY_NAME,  
        DENSE_RANK() OVER (ORDER BY ENTITY_NAME ASC) AS ENTITY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.ENTITY_SORT
FROM TABLE3 t1
LEFT JOIN ENTITY_SORT_DATA t2 on t1.ENTITY_ID = t2.ENTITY_ID
WHERE classification = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))--視年度更改語法
AND TOP5 != '-'
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
${if(LEN(P_COUNTRY)=0,"","AND COUNTRY_CODE IN ('"+P_COUNTRY+"')")}
ORDER BY 
        classification ASC,
        VALUE DESC,
        ENTITY_SORT ASC;]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Country_TW" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
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
<![CDATA[SELECT DISTINCT
T3.COUNTRY_CODE,
T3.COUNTRY_NAME
FROM TRS_FACT_COUNTRY_REPORT T1
LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.CURRENT_CODE
LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_CODE
JOIN V_TRS_DATA_AUTHORIZATION T4 ON T2.ENTITY_ID = T4.ent_id
WHERE T3.FR_LOCALE = '${fr_locale}'
AND T3.COUNTRY_CODE = 'TW']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Period_max" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with a1 as (
SELECT DISTINCT 
PERIOD,
Cast(concat(SUBSTRING(PERIOD,1,4),SUBSTRING(PERIOD,6,2)) as INT) AS SS
FROM TRS_FACT_COUNTRY_REPORT
),
a2 as (
select *
,ROW_NUMBER() OVER (order by SS DESC) AS RANK
from a1
)
select *
from a2
where RANK =1]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Table1_max" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH COLUMNS AS (  
    SELECT   
	    '1' AS SORT,
        'col_ros' AS COLUMN_NAME  
    UNION ALL  
    SELECT   
	    '2' AS SORT,
        'col_roa' AS COLUMN_NAME  
    UNION ALL 
    SELECT   
	    '3' AS SORT,
        'col_roe' AS COLUMN_NAME  
    UNION ALL  
    SELECT   
	    '4' AS SORT,
        'col_etr' AS COLUMN_NAME  
    UNION ALL  
    SELECT   
	    '5' AS SORT,
        'col_emp1' AS COLUMN_NAME  
    UNION ALL  
    SELECT 
        '6' AS SORT,	
        'col_emp2' AS COLUMN_NAME
)  
SELECT  
    SORT,
    COLUMN_NAME  
FROM COLUMNS 
WHERE SORT = '1' 
ORDER BY SORT ASC
]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="2" fitFont="false" minFontSize="0"/>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false" appearRefresh="false" promptWhenLeaveWithoutSubmit="false" allowDoubleClickOrZoom="true"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="P_SCENARIO"/>
<O>
<![CDATA[Per Audit]]></O>
</Parameter>
<Parameter>
<Attributes name="P_FILENAME"/>
<O>
<![CDATA[cfc_summary]]></O>
</Parameter>
</Parameters>
<Layout class="com.fr.form.ui.container.WBorderLayout">
<Listener event="afterinit" name="初始化後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$('<link rel="stylesheet" type="text/css" href="${contextPath}/css/template.css"/>').appendTo('head');

$('<link rel="stylesheet" type="text/css" href="${contextPath}/css/scroll.css"/>').appendTo('head');

]]></Content>
</JavaScript>
</Listener>
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
<FRFont name="微軟正黑體" style="0" size="72"/>
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
$('<link rel="stylesheet" type="text/css" href="${contextPath}/css/scroll.css"/>').appendTo('head');

]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit" name="初始化後2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("div[widgetname='REP00']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP01']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP02']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP03']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP04']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP05']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP16']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})
$("div[widgetname='REP17']A").css({
	"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
})]]></Content>
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
<FRFont name="PMingLiU" style="0" size="72"/>
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
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_ANNOTATION1_c_c"/>
<WidgetID widgetID="09c9774d-1ca0-4106-bd11-1f80523b2640"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABLE_ANNOTATION1_c_c"/>
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
<![CDATA[=IF($P_TABLE = 'col_ros',I18N("ros_formula"),IF($P_TABLE = 'col_roa',I18N("roa_formula"),IF($P_TABLE = 'col_roe',I18N("roe_formula"),IF($P_TABLE = 'col_etr',I18N("etr_formula"),IF($P_TABLE = 'col_emp1',I18N("emp1_formula"),IF($P_TABLE = 'col_emp2',I18N("emp2_formula"),''))))))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="1162" y="85" width="540" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_COUNTRY"/>
<WidgetID widgetID="5cf4066e-5c14-4e90-ba74-828b1a22ad0e"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName="LABEL_COUNTRY"/>
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
<![CDATA[=i18n("country_id")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="84"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="960" y="45" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_COUNTRY_"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName="P_COUNTRY__c"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-13203982" hor="-1" ver="-1"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COUNTRY_CODE" viName="COUNTRY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Country]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="960" y="85" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_COUNTRY"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName="P_COUNTRY_c"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-13203982" hor="-1" ver="-1"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COUNTRY_CODE" viName="COUNTRY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Country]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="952" y="2" width="105" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart2"/>
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
<WidgetName name="chart2"/>
<WidgetID widgetID="99ac2a26-4dfb-48dc-a951-2ec57a2e6343"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="chart2"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="1" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-1250068" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[]]></O>
<FRFont name="simhei" style="1" size="128">
<foreground>
<FineColor color="-11316397" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Position pos="2"/>
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
<FRFont name="Microsoft YaHei" style="0" size="128">
<foreground>
<FineColor color="-13421773" hor="-1" ver="-1"/>
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
<Plot class="com.fr.plugin.chart.column.VanChartColumnPlot">
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
<newColor/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<AttrBorderWithShape>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="true" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
<shapeAttr isAutoColor="true" shapeType="RectangularMarker"/>
</AttrBorderWithShape>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
<Attr showLine="false" isHorizontal="true" autoAdjust="false" position="9" align="9" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="微軟正黑體" style="0" size="72">
<foreground>
<FineColor color="33023" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="微軟正黑體" style="0" size="72">
<foreground>
<FineColor color="33023" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${VALUE}"/>
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
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="center" showAllSeries="false"/>
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
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
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
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr content="&lt;p style=&quot;text-align: left;&quot;&gt;&lt;img data-id=&quot;${CATEGORY}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${SERIES}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${CATEGORY}${SERIES}${VALUE}"/>
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
<Attr enable="true"/>
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
<TableFieldCollection/>
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
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
<Attr enable="false"/>
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
<Attr alpha="0.65"/>
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
<Attr position="4" visible="false" themed="true"/>
<FRFont name="Microsoft YaHei" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false" themed="true"/>
<FRFont name="Microsoft YaHei" style="0" size="72"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<PredefinedStyle themed="false"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2403478" hor="-1" ver="-1"/>
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
<FineColor color="-18944" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-13816531" hor="-1" ver="-1"/>
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
<Attr gradientType="gradual">
<startColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</startColor>
<endColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</endColor>
</Attr>
</GradientStyle>
<VanChartRectanglePlotAttr vanChartPlotType="normal" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor themed="true" mainGridPredefinedStyle="true">
<mainGridColor>
<FineColor color="-3881788" hor="-1" ver="-1"/>
</mainGridColor>
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X軸" titleUseHtml="false" labelDisplay="interval" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="dashed"/>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<styleList>
<VanChartAxisLabelStyle class="com.fr.plugin.chart.attr.axis.VanChartAxisLabelStyle">
<VanChartAxisLabelStyleAttr showLabel="true" labelDisplay="interval" autoLabelGap="true"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
</VanChartAxisLabelStyle>
</styleList>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor themed="true">
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Verdana" style="0" size="64">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="true"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y軸" titleUseHtml="false" labelDisplay="ellipsis" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="NONE"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<styleList>
<VanChartAxisLabelStyle class="com.fr.plugin.chart.attr.axis.VanChartAxisLabelStyle">
<VanChartAxisLabelStyleAttr showLabel="true" labelDisplay="interval" autoLabelGap="true"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
</VanChartAxisLabelStyle>
</styleList>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="15" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="無" valueName="VALUE" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Rep_條形圖(前兩年度)]]></Name>
</TableData>
<CategoryName value="ENTITY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="238ecf1d-6e8a-4285-a5a6-c0ec24d47036"/>
<tools hidden="true" sort="true" export="true" fullScreen="true"/>
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
<BoundsAttr x="0" y="0" width="550" height="365"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="65" y="282" width="550" height="365"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c"/>
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
<WidgetName name="report0_c_c"/>
<WidgetID widgetID="4f2d8a12-5922-4cca-99d5-9663da9f728a"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="1" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-1250068" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="simhei" style="1" size="128">
<foreground>
<FineColor color="-11316397" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Position pos="2"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,457200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" cs="9" s="1">
<O t="DSColumn">
<Attributes dsName="Rep_條形圖(前兩年度)" columnName="classification"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="1" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?`0!P1e^4kq]A)6hJ-Ym;Y,iY1EB-2VG'^SdPRlM4O.JpGaZRqdDYZ"a@4+jd@<fZ0BADd:8
s>R+X0`dqBd\X#mp_g.\tig6q-%llC:)qp[@kTk?Y0%4aX;DYM\NTpAWm>]Ao,X@L"Ldaohth
j?k[iKkT9f?)UZ]AC[E^m55p;$b!;GEuTHcZDC1R5O6a9fcY@pGml3C[!j1`#g.:9bLBlBT.c
(<gBqPNUmhENJSCG%^>o@'MBSh$oRh;$<+heS4.ph]A%`;AIunNJRA2kpP2mW6R3>N^Z?(>k0
gJ18[K]A13[+`o\%a[rr%.sTp*<JPOSRn/5P?fbn0IrY&TcD)Z`44S*BINA<==.VBi(>AFXib
@fP&K<=*;i(=nAhJR1"dY$[U/bsHcf!mVn2%o9EsrpQ='S]AG.?fIIf_IC&@PUu7UpEY[M*QI
L=O@h%AWHgN.FMd'7l/u8H_RsRZp@\I+uYR$'VlASqa(-IgMFMUlj*E&)BcK*5hOS\'NiFi\
rE4`I5"njPMbBBaq,.PPL!>nN=$\TGt;d'8>j=nRoLSus@e!07!rt3P3EGE*5_Ej*DhUha''
("!6f*&b2&jkjBWmogN53"6Lib..U[`dcL8Zko81n#ofPV)RG]ArMA?k"!`(@m,Tq0dEe]A+Yk
gh2!EJh^9YFs5pKDnGMK+,?=02HKcVe@l>"CR3O]AHiAm7#obX5*Q%8n!n_[hUp"%KV!rhaaI
I^WR>R3.Vd7u$h5(%"&3BV%Q$O2iU-1%W=EP_)er*JThX"^1u!O&FD"g,kX<QZs"MYr>A,:V
/"Kjk'3Ro[nV`n(j;LQV\c6EsY=5Gb:DtB8"T>j-(a#K`U9UbY5"$nhZT/lV53M79V;3)j1-
f_\5"><#4JIC2T7!!!.=hnj]A:WK=X.T(</Ns+OY2Gbe;sYh3KFtILh[od%M0,86!6qFF]A)A2
Og`7EDe\?)EUjBX+g]AC0N()>BRiLjAuAc&6UePS!H1ng*nfkLeW3K6R<'B90U$I;Gu\"(Ykn
5*@W[N1=+t;S@bpM;o?rnm!s!gM,C1IEgC?;/DhoSU%7hZ7(R_c)\0hYCYCWi@At2(jn2)nU
[e>",PmhY;p]Ah\4Ql+:1K9'Q7rp<#35/Jd+/:(#IV[)KsRcct2F\_2gU-]AR1n*aOZnJNuD@@
UoTGR#qj@VW7@96eahYIe`V0Ng\R?A'\i>qT!P3cm]AiM&_PUboE4FKaKjWmjF*7lfAP=d5:,
^7u^k;OmcQmhr.p__LMrrb+NiH24dg?XOVq#,sWjHDE0a`dEf>FHGU=*p=a0V&oiHVT0!IA9
8i?npSeC-VZ+0(Q#]ARRD((ejT/<X8Qp[@S*Yp2:?`\eu]A]A>K<[f\4pB;?4LpEE"d7PSPu#B8
5L3jt;fkjt`Tp$&Q3(E->)$.lY-OGJ/C;>3_g.m&Yb\&.8moZ2kNaVRl=]A#_9lfL@j@=VnH,
6lsZbdTUPO=A*:RNp9j5#=MLY[8pCGF<Jn40gZshm=l[2jVYa[>e7$0#B*2/N),Z@(f*l%lf
`YK^3F?K*qW&2qPBj9H"O1j(bWbj,Vu7lJsgqHp+a'qX,b[iQ(u&rJtB'5^!4sWH+M^W_d^k
OmtU7Db@TLo^m)rH::iFE:iA/=HfYZ^j(m!+QT,1l8TuU(mSf*fFN#l5Z"K'8IF[;C*RfK?W
V>N;r4Cl;;72E2O7/W&j#RuM<I!L,831;ORdu\%IkG\jeZb<kPJ4@>AimQ<Xe#gg[cK\Ilt1
6^[*1/+ZmRi2@"e3R9oA$&e%V:MrE*7W':uOL#VkiJpP=@lXLYr.!^8lrk3O"FTZGj%S-`Ns
0aaY7*"_6$GtMC-Fcd(bRK5ci>(*(k`Rs5aQi*Zc(PeMmNG&NeK+ZLI,kq%:X*E^b'[CeU$P
<d(o'!Y7-,;.IJe=p9&>PA'B;-59^_rMVeQf3)^?uSt]AT(B<kaK*pDu2*!mHNu1T5n(3-P:j
ejIM=F1J!\:,b4H\Fh8PlG%I-2kL`H4m&=#1mc?uMUREJtndi4I>K0;dZMJgu^r>RC4:fN]A?
Y8HScNqKt0'BL?b?4_KJ&R),?:`rQhgEKM1fWAOO3g[_*U[1aPrb,gdAQEbhj44H@k'nB16_
UF^2=7):4Z\U[GG&_KC+fgm1RFr]AA)!#S7]A*l8L\3\NYI,34p8BknO(?US)%[^Zq*s2JLd)?
0jJme9%nW3[G\VGd*@-$=OeGE_$G_XEt\Fm-g-*nPZS%F]A9ST+U#^s6W`22sbJ#_Gf1h54%Z
#X3US5;*&oRXTM</<L%fRYJ(N'@CI62-s,^dL0JKucO<2#FTCq@b_Ub,*q,T$*Z'8,6'q'BE
;.+;fo:):M7]Aak4s<t#W988@.^@jNV#E>;hf.K1CqP[&A]A7S2&8r4'7N?>*%(c`_7Yr5d,+;
C&8i3;=eLLq*ub5*)%Fs,<.[a'rRQop)#ZAsSTPKo%`HqVnW.%U$+"?K3>k-:KP(h;4PX*sY
,`@Z@1+bqCm4o5Olar><C)JEK^rIg_r(OE[b[Ek-O#FgkZH<Rm42eq`3RCLUbgGXl3g]AJAPe
(mU;l-&7pgQj1a=X]A(5*e0^3@;<,q06TJ!+%,OE.-9gVlT/@b`RQIarX9.mbZF4t#!Qut`7Z
bggG1K.gm&J/'95\AT=(+teFEigA'>=2^I5"$7_qgs$I+`9gcJtDpo`&?bXO),s?o2d0a?mg
IMic^XC[rF\%qm;6L@0Nn%Wb!5DOp$jf3IB5-]A7j::T?)+-G$;\=qqS@*p`dbo0s]Agk"^P8>
[F)s*^^dIko2\);=NVlL(9$>qcM\N-AU@uI>Hpph:k!t/r"^nFKURrV!F#XmEF-o[gnNtEB;
6uGP<GhJ+FN"i'H_"Xd?&ala0g[.?A1MQ4U@Pd1nio$2[(,e3>(cNdSaePrq7C>Om:L]AZ\XL
K<qW4d>P?`l>0(@cGme>M#[*pf%'TBS!7m<2l(URS!lH%9'7dJZDXCCl65:>ZO;[?W&l-mQq
:$u2PkR/F2X?cF97=h.OD@[hM#?\/mk-sGH?Q#q&?K;Af'P^fL-nRL"oFJkNm[uWCk'UVr?c
]AJlCO&Rp.\^,m_=WS(cZD193A%s$K5=-5XWkj[p_iR2^/,WL")]A%6s^q-%0SfiGDTtZs[X`8
a@ZUq/3[3R[Yd.W<UMWQ]AALp8XEeG,$RA[HZjN(ma6I+*91ACEp,V.hF-QBNcl6`qbk"^0%F
96.iYVB+K^-QFqF>q*#pd?[&jcnC3[_9JQm;sc>NkN@h;C,9ck"D[N3?!ntOgW!s/0a.9ehQ
io\S*D+D)4/9Q($d\MITi8LClF=Y@poFC.4"S\j=#`q0CiD181:14K.4ig@Kb!EsBOc"fjO`
oj_`$lU8XUX=$L>C%&O^brW6s:k9p^]As73\WomNRdEIjX*:D-i,MA7)Ij[Er>?u"a!1b/:UJ
fDXP9#M-9J8.Wj&t)AK)f?kijJLL%Sk-TNF,a9"]AqbEO,W8]AnRU<K!;!`?c+BR:/b7d,$1a(
FL8>0FWa_G0bK!mSe1)!`]Aj'Fm[4+.'71)W[*k<)3F)bb[PpTJZqZhCSDr>YMC(onPJHpLk9
M>oUGkPo]AoRXj\qVfp#]AEng40Tsh!=Br-i2"^4_7(tC<([?3*%5@TI4jpe$H@k;rA3giYp^f
3,k:Vgr562SuOtf3(rSP76:3Cd&Y=O3Z+2Am=p<?!7)FVkj7@/l%Y5,+^B]A'/b@iGB6Z@tFB
r,sDlXq)Mr[oq;BjN/U;p:^^?uFaWg0tRn*Fkr#-Nh,+9)O[>=Nu\"$%GNfWhK2i49*.99;b
,aI"<Yc#ZDI,J*4rh+9HoHdX@6.Vl!6HVO"f;d[O(7n*4cpJ=GT4DN+3A.b/K9K$p')3'H1r
b(&8VV+,YX^!;*mQj16"!IfO!3kRJ?HV?QPoIFh@l8=rCr0Gu-i(YQgB);K_uWs,ol-tJjmT
6V)uaf_./mA07U3gMoDHo2&V?()XjN;RSJ(r&JMSI?5A4s4EIl%tK:i5[NtH7Fe0gkTW-_(#
))OOQ%j#9U/GRIA;@:!k3tLZ+Q/gR>VK)rsaZJ32_(N4Y%Et1_;C,59=UJa:IanU?=qt,4n`
UX6?k1=k[a)c$%d)&!Y,CHkDl7coQUrdR=tRBfX*Npd?#(E=30Wg#fB`%s_pXCE#?IuZPe"$
nq+hR$f=A!1BqEk3m,q]A\$U>6dhnCZN)0ij"P0n&p^@1*E=*%"L]Akmlpqt]A9,SH0%t=/="53
7n;(,Q.2SS,df30BBE7ba6X_EM&\4!J%AtAcTWoTL7irs%8#kZuRj-;$$B.?)msU^BL$D*e<
^^=KOLqp(kFF=9&_:!A&a)YQ,HS!a#F1?i_g/"g@tB^]AIU<$h400psfLYfNOb/!,E$Gq1d.>
%KO:VlP6jA7H\sCMIqIpMYZ+u/*QB\.l&JrX@Vd7Zm'ECs$&<s6lWjDO9]AG]A]Ab7!b@pqZVUC
"^6$N~
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
<BoundsAttr x="0" y="0" width="550" height="90"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="65" y="182" width="550" height="90"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart1"/>
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
<WidgetName name="chart1"/>
<WidgetID widgetID="99ac2a26-4dfb-48dc-a951-2ec57a2e6343"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="chart"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="1" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-1250068" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[]]></O>
<FRFont name="simhei" style="1" size="128">
<foreground>
<FineColor color="-11316397" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Position pos="2"/>
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
<FRFont name="Microsoft YaHei" style="0" size="128">
<foreground>
<FineColor color="-13421773" hor="-1" ver="-1"/>
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
<Plot class="com.fr.plugin.chart.column.VanChartColumnPlot">
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
<newColor/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<AttrBorderWithShape>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="true" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
<shapeAttr isAutoColor="true" shapeType="RectangularMarker"/>
</AttrBorderWithShape>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
<Attr showLine="false" isHorizontal="true" autoAdjust="false" position="9" align="9" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="微軟正黑體" style="0" size="72">
<foreground>
<FineColor color="33023" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="微軟正黑體" style="0" size="72">
<foreground>
<FineColor color="33023" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${VALUE}"/>
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
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="center" showAllSeries="false"/>
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
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
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
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr content="&lt;p style=&quot;text-align: left;&quot;&gt;&lt;img data-id=&quot;${CATEGORY}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${SERIES}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${CATEGORY}${SERIES}${VALUE}"/>
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
<Attr enable="true"/>
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
<TableFieldCollection/>
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
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
<Attr enable="false"/>
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
<Attr alpha="0.65"/>
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
<Attr position="4" visible="false" themed="true"/>
<FRFont name="Microsoft YaHei" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false" themed="true"/>
<FRFont name="Microsoft YaHei" style="0" size="72"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<PredefinedStyle themed="false"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2403478" hor="-1" ver="-1"/>
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
<FineColor color="-18944" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-13816531" hor="-1" ver="-1"/>
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
<Attr gradientType="gradual">
<startColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</startColor>
<endColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</endColor>
</Attr>
</GradientStyle>
<VanChartRectanglePlotAttr vanChartPlotType="normal" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor themed="true" mainGridPredefinedStyle="true">
<mainGridColor>
<FineColor color="-3881788" hor="-1" ver="-1"/>
</mainGridColor>
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X軸" titleUseHtml="false" labelDisplay="interval" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="dashed"/>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<styleList>
<VanChartAxisLabelStyle class="com.fr.plugin.chart.attr.axis.VanChartAxisLabelStyle">
<VanChartAxisLabelStyleAttr showLabel="true" labelDisplay="interval" autoLabelGap="true"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
</VanChartAxisLabelStyle>
</styleList>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor themed="true">
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Verdana" style="0" size="64">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="true"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y軸" titleUseHtml="false" labelDisplay="ellipsis" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="NONE"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<styleList>
<VanChartAxisLabelStyle class="com.fr.plugin.chart.attr.axis.VanChartAxisLabelStyle">
<VanChartAxisLabelStyleAttr showLabel="true" labelDisplay="interval" autoLabelGap="true"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
</VanChartAxisLabelStyle>
</styleList>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="15" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="無" valueName="VALUE" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Rep_條形圖(前年度)]]></Name>
</TableData>
<CategoryName value="ENTITY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="13f923f3-c6d9-474d-8869-c0208dda201a"/>
<tools hidden="true" sort="true" export="true" fullScreen="true"/>
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
<BoundsAttr x="0" y="0" width="550" height="365"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="685" y="282" width="550" height="365"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c"/>
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
<WidgetName name="report0_c"/>
<WidgetID widgetID="4f2d8a12-5922-4cca-99d5-9663da9f728a"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="1" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-1250068" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="simhei" style="1" size="128">
<foreground>
<FineColor color="-11316397" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Position pos="2"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,457200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="1" cs="9" s="1">
<O t="DSColumn">
<Attributes dsName="Rep_條形圖(前年度)" columnName="classification"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
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
<Expand leftParentDefault="false" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="A1"/>
</cellSortAttr>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="1" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?il;;VBX:.@Zhke>C7"e(;6le#6)AC46/ZQ'S8+IAda>Go\IO;aa%dChgtXlQe@`;5TG=AX
SF5MP<@q)3_"`W?_bI`XilM'G(:rMg&e$s7!`UcZ@D#3G1SRXM+@3CTk.tq<::<TZtX(.mY;
>c&nZO@3CY3hr=V!EcXnDXZn'ROE:A_K*P._PYR*;FoPC"jM$[hFfRm,>mUVF1W&kC>F$?'4
kSS=7r\:e/):S/r8YW!S*,DO%j*q2prB%\YDtgBCrc82O>$XA[_;T9eEP9iI8aFAd2@H1eE?
Q!p08nOi6P]ASr3hpl'LbUUn@)Ye]Ai3`S_!3>8_AiAhB87M_D^jm4F#;GOo]A;Kda,\ZsBUH)i
N%Z>iDj.SH?RV8r4!%qAb>EOT7d,:gkiNMh@s?h8""!eVk%J]A)rFF:io,$O>mj.uK\$"'"gg
ejg;7Y:U\_Bt!H#1uFs4nV(k@(-4ptFJfM_]A5B07<-m&meLfPe3pi?ERWGG>[`'>?]ACS0.O'
J4h@o&d>No<8*RLpX`HUqTMNh-;O"d\(M3$3G5`-ZC0WL-jT".;7K/cB3TI%EY=+IV^:fX:!
pqJd"Ihhb"Q_1s5aIdmNP[KtGQ,eb5-0NX^&GYF"KTc)/2PWMgW4X*&)an<=a6SArkkj7^R=
7k*eKhB,FRp,O7)2skbG/p&KZY))o#%jSf>9<Kig6ljVt#^:F16gR>HJ0d?sLY[csnndd0UC
:3,"do^&g_8)6lHQcL*O7iU%PN'!sS\uZo-hMFSX"r4TMn7on;^\*l9jO]AK%\hQ[*kh(9/qo
k,Hq=Da+ePlJC1dm/g<$RJ9OtL[loXq]AJ"oc*_iA3D]A+W50fYAl#)r0u_W4kIMLD]A[Q0Ja"P
IWh#EOZd2_%DsK;oeY<4VbA`(j$F\QUS-gT;AP&+#W]A6Ti190eK[FL+70_"aepNu05A8Bcrn
u%q6RR02;K9m^,8IHc'S?.*`EjAEkN&J<Q`R4d(;$aCR=Rh"[C]A$0T)\RuA]A4hKWhL913b&f
(cmtaI/1RHF:P.NU5GBCD]Ag:`8;B_42FFXI!^+@:^ZkFBS&b'4hK#&Bsu$*cdcXa*e0--7!4
H.8S%h?3.FcR2J0!sE0Gr%/l?c/#CATc9QjBtYHt#(n'M<V[tVY#fV5Ub8Z7iPD33;0LQ20g
lg-@91dh0<\XM2X_gMJq/S6l.,IBE/$:%2jL;*&@\orasheMF`m*8V.QX!=/ul*U8/0[/;8Y
Y4I`t63JNlFrU#fOp!9&(#pM5/+R1i%QTK$A_cYiQ'?dnYjI81LE%J--AkLqtO=@7G6_.>Gh
E3pG5o,=#ODC;5VqZ1]A6#n,-N[>t8V_mJ+nZ9m)Wb\S9h1M$sGp[\&jgGXb/Q.)"C^:4[cmY
K2+$Jc'f^.UKfab@N9E*L)A^.qZV2>D\HO.uY=43tuqIrl==pK&Y<Q<%K8pA+]AO&S'n9cdJ0
q"W(eF<#)oiUmFq$$Qm7[`5@G6$"fok<V'8cULq)]AtTAIoN,n!'HE;ke3dgqDbWP'EIPkl=i
pX7VFLGH?a)'?I2dd*jfdu;?s9B@IbuhAU:J(G192:Ep('K&^&NN`Cm[f4o$?M5)-LQ)A)i7
l$C4/UW91jUfi)afLoc=RUqnu(bp!RG!&o&6-^6T;Mc&CB`+8J(qU]A8P9$bD0e)2gA?o0?6g
2tL4k`%2XUqKgDc\g5enXQ=Y]At2:\CH0g)M*`*QO(h3;;a.R-/n8=ECPpOiaqpT-<548oXf2
=5WIO?la?cGo"[Pupa1NqZQom?A#ugb@2KJ"6L,ki0!ba:Nd*jA;1V$j7NUr<q0j@Rh3]AEE3
aD#uOq;k#1G[Eo/5DnT3oRhR]A@S:@p1$M'#$_>lQ5GL,s^.Ff7d/Tj3Q6<fHa[*n?OB(D0+>
dD.#TkIkLlb#tG-Ha/CBp>Y`t2n+CB-"[W01I?M&hC$7aCDc),D$goPErj'78K6"'NEoVU9k
g!0*pHpZo<V<L)@mQ)Dn_Rus<.8=W352_.(kRl9#7@@ABbl\T:MB]A\ke&D!%s>E-pgg>D9)j
@<DY7@_:cK2TK"#UK@hSO75G3IZT+5jgcj$_/o.*`JgW1uKiZVO*L@P7iF=@d+']A/9';^m?l
F1qTS;,AUh<,L+n-gne6P/PF%@Uml]A)/9i;%7ItY"XB@Cu!L"=BFPG*`"SRg#ZNg9"ESnX8?
g?7\nlpS0UIWHXG<W#a`',B_uXeL,^']AH*ZI;#*(eF#_T!c)PNCY\diThJCn7]Ab8i^&_0G$8
>J*6S%e#Nt;lD,8n&AWId4Qhq4Wi^pg6(WE`)pUt]ArS?e0uo-?0Rc^.=3N\pHseI>HG6M^V?
P7#Y^3'F7ICZD[58-bX:4VMX!4nGlFB$XPQ:;%@H=d+pZrlN_>>4J/KlBlcYHVP>nKY!?k`#
4$El41Y/8MAOa)>C;j*Z*IJZ<7*1jp^.o!^)t8Y;l!\S?f#!&NW\C^XSWG_)5@4'VC@Sf,")
T9J?HeGRA;pDV?YGt^;G`Lpd)kZhK*V19eBO9j'9%>$(9oYTlrKD84-#pQF9%.G[O8a$1J@P
]A,fVL7^5I4'[m_5ern`G.bl[)C?f*9ZP[Jih@q,L^HNm(]At5Ho;RgjX?E66^[UN#&dmSq8N[
5uu8nX?[1GIIl%.]A[<VYTdf#Mn>(b$X[gr3bIC9Ns2b!=2QN_rFt]A]A409#^FB--Rc]ADLA^Vo
WD:EA!?[5;)miY(e8MB3Ff$`(X3%J=*,)ql_,T4*phr`r%9b'pQ0%K%K`Q?nPkl]AoPT%Uq#c
]AW\bL%d%'R#+i'1+J,TT]AfKrr0bK#rFrNYi%!:uT;VO+of09s2QoK&k:E'hqG@*o8asr./8*
CKZ6K`\VH:Elkg@MCp2D9!m8ZS\#=0R=n_9pr><]AKSjQl94i8o2UL,dCA;jb[FTEOa,ou$EU
6u*NhrbW1DLFJpdj7:iPj)TJ\>,7@p>O1EUaG4IV.72&#O>s&@3G$9!E)-6$Q&dER-40c<R<
`&M4^5UTn#'-Con?F\:&38bnND:l&4#AZ'j-4%'SK5,\HD7G1_u[56l>+/X0KP/XDgPDPe;n
lWk6t>T8X%)r<Rh:-nEjb\SD<HZPn:F5h$'H?WX'Xf$lO:^f.]APDR_RNHke':_V$%L"ZIjS&
pe\:I.9<s<s1IfQ(tYN2,\0+GRNcP^s>bP*qn&_4o-2]Ae';9kn61iQQoS-E?>/A52`#M<CbI
8s:t4Ht.W6K8XsuKNB=n:b7jpu[d&gr%0gWeQirh:\'LLC2l&Z)-TYWF,kp&_&Xh'LQfn=82
8%.q+1>)s37qULT7f5fkH_5Nr).qcmF_p0O,DS]A-46EcE#%oHGqr#UY5ar=$0=34cFoiG8Z7
Ecea$LXIUi:b"/<VMapjrU_#F!')U4>M!h,T=T#]AT*P]Anp?>C%Lr-c;L#CNae`B'Ih49Dr$H
dV-dg[@1?rP+=JPMO3;j,3X+Y>1ZcR)1$4+(W^aD6=ak9uf9Hi1KYGeXF^Cj:mGr]AEK#YJf[
)([m/P[_1Z1O92#gD0A55se+:5UW149,E6@HsP8pDp/`IkMMni<dBNDBh98lk^`<XiEq6U=X
bEaGj@@R5UfnqF82s0?.#K,XCUheXiqV_04YS&SYa*:;,]A3`.<56SLrZ+L,jEO26e%XH\&kh
KJ1S\-f"?pBAjcSSq`&EmEI5,n(Y*Q^>?AC6L&lDY^!)X*`6lh5Wf7dKLTn52RMGMoCOD0HU
sgEieLLgJY>=+N9;h*N4JT[l9k.^SG*:&4A^8ZQRAj7dr+E_kOM$"SUmCuk[X"4K<(,nk;Oe
@k.htYW_M+Pf!pp8hl\c9j2l8lN-1JG.6h<'=]AofDe%h9O.GF?*La#CX2B\lXq)B7$&.FL@_
SF<sWunm:;rIQgN<n_oRZX1]Ah-eA5-U[?7I#P+`,3DYa*QDMa6q*\K&J?He8I#>o5G>t\<ut
sq8"<,V'8T(8VdY<aB%Ge9nDC(q>Z62:IcZQ"+7^3,]AjI<Nb*8-RdRU;f.@CiR?<B]A]A#t..^
?O>$bZueYs,Bi2cc>kn2'u>+Z0)RMB^_A]AaWsXqWkZJo%43#'!6_i2&j)q\`,'"o2e^"QSbl
7(B^['+LNV^i08po'Xgta+>42Y6C_6=f!5%d_fii7nZd)2s*5i\$=I:q:2?-P5GM"f@-F7#9
WA"eSl>%jU`(0YCFKbdj*TnO7cBVC+q>55jm3Mn'^m>AkiS]A_G;WTCiq4p.qDDI\./)Is!Q4
oM!:oActqpR:pX[<^HcP^q$5F_p?;P)^Lh3EYTsrk!X^~
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
<BoundsAttr x="0" y="0" width="550" height="90"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="685" y="182" width="550" height="90"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart0"/>
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
<WidgetName name="chart0"/>
<WidgetID widgetID="99ac2a26-4dfb-48dc-a951-2ec57a2e6343"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="1" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-1250068" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[]]></O>
<FRFont name="simhei" style="1" size="128">
<foreground>
<FineColor color="-11316397" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Position pos="2"/>
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
<FRFont name="Microsoft YaHei" style="0" size="128">
<foreground>
<FineColor color="-13421773" hor="-1" ver="-1"/>
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
<Plot class="com.fr.plugin.chart.column.VanChartColumnPlot">
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
<newColor/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<AttrBorderWithShape>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="true" themed="false">
<borderColor>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
<shapeAttr isAutoColor="true" shapeType="RectangularMarker"/>
</AttrBorderWithShape>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
<Attr showLine="false" isHorizontal="true" autoAdjust="false" position="9" align="9" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="微軟正黑體" style="0" size="72">
<foreground>
<FineColor color="33023" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="微軟正黑體" style="0" size="72">
<foreground>
<FineColor color="33023" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${VALUE}"/>
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
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="center" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
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
<Attr enable="false"/>
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
<HtmlLabel customText="function(){ return this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr content="&lt;p style=&quot;text-align: left;&quot;&gt;&lt;img data-id=&quot;${CATEGORY}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${SERIES}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${CATEGORY}${SERIES}${VALUE}"/>
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
<Attr enable="true"/>
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
<TableFieldCollection/>
<Attr isCommon="true" isCustom="false" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
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
<Attr enable="false"/>
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
<HtmlLabel customText="function (value) {  
    if (value &lt; 1 &amp;&amp; value &gt; -1) {  
        // 将值格式化为百分比  
        return (value * 100).toFixed(2) + &apos;%&apos;;  
    } else {  
        // 将值格式化为带有千分位符号的数字  
        return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, &quot;,&quot;);  
    }  
}  
" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Attr alpha="0.65"/>
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
<Attr position="4" visible="false" themed="true"/>
<FRFont name="Microsoft YaHei" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false" themed="true"/>
<FRFont name="Microsoft YaHei" style="0" size="72"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<PredefinedStyle themed="false"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-2403478" hor="-1" ver="-1"/>
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
<FineColor color="-18944" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-13816531" hor="-1" ver="-1"/>
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
<Attr gradientType="gradual">
<startColor>
<FineColor color="-12146441" hor="-1" ver="-1"/>
</startColor>
<endColor>
<FineColor color="-9378161" hor="-1" ver="-1"/>
</endColor>
</Attr>
</GradientStyle>
<VanChartRectanglePlotAttr vanChartPlotType="normal" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor themed="true" mainGridPredefinedStyle="true">
<mainGridColor>
<FineColor color="-3881788" hor="-1" ver="-1"/>
</mainGridColor>
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X軸" titleUseHtml="false" labelDisplay="interval" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="dashed"/>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<styleList>
<VanChartAxisLabelStyle class="com.fr.plugin.chart.attr.axis.VanChartAxisLabelStyle">
<VanChartAxisLabelStyleAttr showLabel="true" labelDisplay="interval" autoLabelGap="true"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
</VanChartAxisLabelStyle>
</styleList>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
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
<FineColor color="-16777216" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor themed="true">
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Verdana" style="0" size="64">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="true"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y軸" titleUseHtml="false" labelDisplay="ellipsis" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="NONE"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<styleList>
<VanChartAxisLabelStyle class="com.fr.plugin.chart.attr.axis.VanChartAxisLabelStyle">
<VanChartAxisLabelStyleAttr showLabel="true" labelDisplay="interval" autoLabelGap="true"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="Verdana" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
</VanChartAxisLabelStyle>
</styleList>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="15" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="無" valueName="VALUE" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Rep_條形圖(當年度)]]></Name>
</TableData>
<CategoryName value="ENTITY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="9d2675a8-f9a5-4034-b3fd-1968070c6edb"/>
<tools hidden="true" sort="true" export="true" fullScreen="true"/>
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
<BoundsAttr x="0" y="0" width="550" height="365"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1305" y="282" width="550" height="365"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0"/>
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
<WidgetName name="report0"/>
<WidgetID widgetID="4f2d8a12-5922-4cca-99d5-9663da9f728a"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="1" borderRadius="0" type="0" borderStyle="0">
<color>
<FineColor color="-1250068" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="simhei" style="1" size="128">
<foreground>
<FineColor color="-11316397" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Position pos="2"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,457200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="9" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_PERIOD]]></Attributes>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="A1"/>
</cellSortAttr>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="1" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?hTa;ca[R+%-g=.4Vc.[O8JWXUJm*652aT>\g-9XZ/Y?i_mo3,\TL[Jr3G@LmBJU%A;5e*J
#%V+A2utOs3P$#/cUX#UT\kRZPLAQTdm0Bg;<,kC%U<_gd.05NggCm_(FFd^ORITGK[C"onY
:CM2jT!.a@'s(iLg$7kk9'EDBTGD0op5\?'M#kn[BX9@"K$FWSoqsTDtQS//g*mfUoru@T]AZ
uY'l-$HeP]A<u!n[O`ooe&tXAkN>u`ZZssR]AI5Kbp8uSA*m40UBW5$O/%bqp3d9OolHAIl'TA
W#3Z+M3`h%D$(M_U=//_`rR2&XJ.\6'>\JG6ZE)=EGoI"!KI`N=7Fb^]A6h4IBP3i8k=(^Ms0
BWZD^iKnk.0e@mQ&l01FhXdo!6RFt"RMdpl9>)_OqA,oGnDL.le`EoTFY#'MYRd2-5aIt`#5
1&@&JI&Ukml`q<mc8;qF#r_0-WsSLF'+mVah4^9F/TEp:5)+m=lo6rVKh\YemZg*a[>?()5%
elLGm/<($XbI)Gt1`A?@pXakf9K<TeIghjisBa$n7Q/B@p`CA`[(oT!IN,l"of3tDTiI"JqG
-QZV--ZoP!Zcban8(U(NTq&$_1NOO.cX0b)UZBV2e+)4:7-.`(+a`GO>G"f5Qk>PUiqFW:R"
R$1nATLEFT.LZJ(/(U4Q+;8"6!Yrh]AP$/<66uQ]APbOn4HXR2Q'*JBRmmjUZRTI?RIdMNuF2P
W"th18e,;fXhIYK=2r$b)C'ZQEr?'Le:f7u`n.;"^[)Gc]AtmT6"3Q0a*&lC6P[I6(7QU#5i&
ITo3e=Z'XpgjN&bH\NXk1HS?klO.mlS+:($tAJ0LkWnM<@W2B'o*3CIcjB*!]A>,@-S0J781!
eUE&sd1BRq=n0s(8/qr)_>)(o%5\j!LERrn_k?gnE[\S*?:SU;L:%Fa_Z>,)W`guCqch7Y0h
&IU"1G#1cXN6OM(`9\-Qo).#<F!Kf4jcs7+/Mf`5tC)$ep37pAT2^]Ao2Qg?\+4Go]Ac&@bQ[H
M7*#)7=<44SdWTlCHra:KSM0u0eKK!VN'/e)U_q;,DR8&mj3Gt>4W/\;P$a5]A)#c(2*r6qp!
l]Aj:7Gn`-%,Olf/n5?")PLl`[?%$B_.\%W";H6s)F\StNjU.C^g;(_MUL?@ENTkhB>E2oQd\
-Rd)=hDQm-C<g';,s7)>+.JpK[6Z"VF`^""LuCP&RSSZS.@nP2mFL+Sq&E:#f">eOM6A1WI?
fm[D9P_K%\_s!-([8Dj9La@<>GpZ')anql)op9qQ#&*qXFhTZhIP<:cSZD<j@7Z>H8.-/jgB
`Vmm1#+9t$^CX&C-$H<L938rb(Wr]A&Q@5Hf"@Hj^5fBmDMl8?>[?h6dV#!ml7@Wo4B2_[JJS
(9-7NlnTHEhB0r3B4f6Hno?*\9cW$9S$=5B0""Q%(p$+<p3)W[<6/C-HK#r>SG'^r-:;J<Tf
mj/<noR3PIhYOoer%VWpZMTs?QW@ajBaNff<ZUkk&]Ai:XIpH8Ylrh7kFaej8c$d)(Uhf#15_
ABZ.R@)uBTsh;*'D.I$l&C-ET0icXmN4c1Y]A.S?UiKu4[JR,^j>X2JW%`0HeF.O8Mlp=Pc7F
.BkChs9k=n=nngMF-u6hkA:-4^nCL$PUEN3LIt)I3G]A5^-^FI=[VTQPBZJiP9IDEW8c$B=-d
#E1/2V4K7ot."fd\`WmBPO]ACIM8TA&PuhT<B;<8qNJ7gA9*Wqf9I6-L,F'^TlQ/=9i[?IPL?
uXKgAZd=Zb'RneCU"GEcJRP=i9/1Jp4?l%XO@fB<i[oo$]A#hqo.c6AJ8J53_H[r0ZKa#o*2R
7"l_4>:]Ad,^M>X`2$bSM-$l58#20Z8f><9ihTDE<p^I;K_+S2J=CN3W8)&u^E*Nt6$qG(M#(
X$]AiKl%mCY/^`H6mrQ!@sKZ3.`A7Jg37,,<19"3.`A7Jg37,,<19"3.`A7Jg:&?_BIEL/)ce
&JV#u`>B\W,]AqK!\dHCK5~
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
<BoundsAttr x="0" y="0" width="550" height="90"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1305" y="182" width="550" height="90"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report400"/>
<WidgetID widgetID="b55d132d-4292-4705-a4f1-f6c4d76bf00d"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report40" frozen="false" index="-1" oldWidgetName=""/>
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
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<ExtendSharableAttrMark class="com.fr.base.iofile.attr.ExtendSharableAttrMark">
<ExtendSharableAttrMark shareId="d0466992-328a-4ccf-ad67-6cbc844d669c"/>
</ExtendSharableAttrMark>
<SharableAttrMark class="com.fr.base.iofile.attr.SharableAttrMark">
<SharableAttrMark isShared="true"/>
</SharableAttrMark>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report400"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="0.0" description="大屏背景色：#F4F5F7
数据来自数据集：采购计划
F6、G6、H6、I6的条件属性，需要根据实际情况修改操作符">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="report400"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="5" left="5" bottom="5" right="5"/>
<Border>
<border style="0" borderRadius="5" type="0" borderStyle="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="1.0"/>
</Border>
<ExtendSharableAttrMark class="com.fr.base.iofile.attr.ExtendSharableAttrMark">
<ExtendSharableAttrMark shareId="d94654d2-e2d7-4c0e-91a8-cc1e6462f9d6"/>
</ExtendSharableAttrMark>
<SharableAttrMark class="com.fr.base.iofile.attr.SharableAttrMark">
<SharableAttrMark isShared="true"/>
</SharableAttrMark>
<FormElementCase>
<ReportPageAttr>
<HR F="0" T="2"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
<USE REPEAT="false" PAGE="false" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1152000,1028700,1028700,1028700,1152000,792480,243840,792480,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[17145000,4381500,9525000,9525000,9525000,4381500,9525000,9525000,9525000,4381500,9525000,9525000,9525000,9525000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("unit_twd")]]></Attributes>
</O>
<PrivilegeControl/>
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
<C c="1" r="0" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="0" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="0" s="2">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="5" r="0" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="6" r="0" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="7" r="0" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="9" r="0" s="3">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="0" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="11" r="0" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="12" r="0" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="13" r="0" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="0" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" rs="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("entity")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2" showAsDefault="true"/>
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
<C c="1" r="1" cs="4" s="6">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="classification"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 2,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A2">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B2"/>
</cellSortAttr>
</Expand>
</C>
<C c="5" r="1" cs="4" s="6">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="classification"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 1,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A2">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="F2"/>
</cellSortAttr>
</Expand>
</C>
<C c="9" r="1" cs="5" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_PERIOD]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<Expand extendable="3" leftParentDefault="false" left="A2" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="J2"/>
</cellSortAttr>
</Expand>
</C>
<C c="14" r="1" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="5">
<O>
<![CDATA[Top5]]></O>
<PrivilegeControl/>
<Expand extendable="3" leftParentDefault="false" left="A2" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B3"/>
</cellSortAttr>
</Expand>
</C>
<C c="2" r="2" s="7">
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=I18N($$$)]]></Content>
</Present>
<Expand leftParentDefault="false" left="A2">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C3"/>
</cellSortAttr>
</Expand>
</C>
<C c="3" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF($P_TABLE = 'col_ros','col_pre_tax_income',IF($P_TABLE = 'col_roa','col_pre_tax_income',IF($P_TABLE = 'col_roe','col_pre_tax_income',IF($P_TABLE = 'col_etr','col_curr_tax_payable',IF($P_TABLE = 'col_emp1','col_income',IF($P_TABLE = 'col_emp2','col_pre_tax_income',''))))))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N($$$)]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF($P_TABLE = 'col_ros','col_income',IF($P_TABLE = 'col_roa','col_tangible_asset',IF($P_TABLE = 'col_roe','col_paid_up_capital',IF($P_TABLE = 'col_etr','col_pre_tax_income',IF($P_TABLE = 'col_emp1','col_num_of_emp',IF($P_TABLE = 'col_emp2','col_num_of_emp',''))))))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N($$$)]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="5" r="2" s="5">
<O>
<![CDATA[Top5]]></O>
<PrivilegeControl/>
<Expand extendable="3" leftParentDefault="false" left="A2" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="F3"/>
</cellSortAttr>
</Expand>
</C>
<C c="6" r="2" s="7">
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=I18N($$$)]]></Content>
</Present>
<Expand extendable="3" leftParentDefault="false" left="A2">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="G3"/>
</cellSortAttr>
</Expand>
</C>
<C c="7" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF($P_TABLE = 'col_ros','col_pre_tax_income',IF($P_TABLE = 'col_roa','col_pre_tax_income',IF($P_TABLE = 'col_roe','col_pre_tax_income',IF($P_TABLE = 'col_etr','col_curr_tax_payable',IF($P_TABLE = 'col_emp1','col_income',IF($P_TABLE = 'col_emp2','col_pre_tax_income',''))))))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N($$$)]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="8" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF($P_TABLE = 'col_ros','col_income',IF($P_TABLE = 'col_roa','col_tangible_asset',IF($P_TABLE = 'col_roe','col_paid_up_capital',IF($P_TABLE = 'col_etr','col_pre_tax_income',IF($P_TABLE = 'col_emp1','col_num_of_emp',IF($P_TABLE = 'col_emp2','col_num_of_emp',''))))))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N($$$)]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="9" r="2" s="5">
<O>
<![CDATA[Top5]]></O>
<PrivilegeControl/>
<Expand extendable="3" leftParentDefault="false" left="A2" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="J3"/>
</cellSortAttr>
</Expand>
</C>
<C c="10" r="2" s="7">
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=I18N($$$)]]></Content>
</Present>
<Expand extendable="3" leftParentDefault="false" left="A2">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="K3"/>
</cellSortAttr>
</Expand>
</C>
<C c="11" r="2" s="7">
<PrivilegeControl/>
<Expand leftParentDefault="false" left="A2">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="L3"/>
</cellSortAttr>
</Expand>
</C>
<C c="12" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF($P_TABLE = 'col_ros','col_pre_tax_income',IF($P_TABLE = 'col_roa','col_pre_tax_income',IF($P_TABLE = 'col_roe','col_pre_tax_income',IF($P_TABLE = 'col_etr','col_curr_tax_payable',IF($P_TABLE = 'col_emp1','col_income',IF($P_TABLE = 'col_emp2','col_pre_tax_income',''))))))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N($$$)]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="13" r="2" s="5">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=IF($P_TABLE = 'col_ros','col_income',IF($P_TABLE = 'col_roa','col_tangible_asset',IF($P_TABLE = 'col_roe','col_paid_up_capital',IF($P_TABLE = 'col_etr','col_pre_tax_income',IF($P_TABLE = 'col_emp1','col_num_of_emp',IF($P_TABLE = 'col_emp2','col_num_of_emp',''))))))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N($$$)]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="14" r="2" s="4">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="3" s="8">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="ENTITY_NAME"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J4 = '-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F4 = '-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B4 = '-']]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(J4)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F4 = '-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B4 = '-']]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況4]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J4 = '-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F4 = '-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B4)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況5]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J4 = '-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(F4)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B4)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J4='-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(F4)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B4='-']]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況6]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(J4)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F4='-']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(B4)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[情況7]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(J4)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL(F4)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B4='-']]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0">
<cellSortAttr>
<sortExpressions>
<cellSortExpression sortRule="2" sortArea="K4"/>
<cellSortExpression sortRule="1" sortArea="J4"/>
<cellSortExpression sortRule="2" sortArea="G4"/>
<cellSortExpression sortRule="2" sortArea="C4"/>
<cellSortExpression sortRule="1" sortArea="L4"/>
</sortExpressions>
<sortHeader sortArea="A4"/>
</cellSortAttr>
</Expand>
</C>
<C c="1" r="3" s="8">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="TOP5"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 2,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="2" r="3" s="9">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 2,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="3" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="numerator"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 2,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="4" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="denominator"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 2,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="5" r="3" s="8">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="TOP5"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 1,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="6" r="3" s="9">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 1,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="7" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="numerator"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 1,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="8" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="denominator"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=CONCATENATE(YEAR(CONCATENATE($P_PERIOD,'-01')) - 1,'-',FORMAT(MONTH(CONCATENATE($P_PERIOD,'-01')),'00'))]]></Attributes>
</O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="9" r="3" s="8">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="TOP5"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="10" r="3" s="9">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="11" r="3" s="11">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="ENTITY_SORT"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="A4" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="L4"/>
</cellSortAttr>
</Expand>
</C>
<C c="12" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="numerator"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="13" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="denominator"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[classification]]></CNAME>
<Compare op="0">
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2024-12]]></O>
</Parameter>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="14" r="3" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="4">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="4" s="12">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="12">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="4" s="4">
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
<WorkSheetAttr direction="0"/>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微軟正黑體" style="0" size="72"/>
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
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Bottom style="1">
<color>
<FineColor color="-526345" hor="5" ver="1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="ColorBackground">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Background>
<Border>
<Top style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#0.00%]]></Format>
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-1513240" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微軟正黑體" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[mC[XJPNV[)N*<',.aVq$/6`>d1*"L<Ol@c5i+@^@Q9YG$"Crh4<3RiKffLT,ZB5`07\kWd$j
dJ3J.rkEO:WN[OT!r8oOC,CchI7KqY^(M&#$28OSdi-Fe.igpN`BPY5A(oMYT]A?Ii\<NKS5#
Caj9.Q!WP/,+gE?flYXFEqMM-d,U?2D-Kg>*geF]A+C`esqB.+q;5(*(YSR5U8qD$tgj"4X:5
.9p]Aj%d?@&)ZKp7ljq\Q@XH;([lQcrbUn:DYC>Bjk:4l8cFV<J+_gdT3HKj9I+f>l9KJ,iZB
5P(b*mCkqD"pEs6V%oGjTf2+O%Ykdh87.4F8_0SP=3<hTtV/>to_D3F\RZh-o1Op1f\R`(2`
F@S>lXdsgCf:a^LNrEGs`gRRlbOb=4o?5?eSE^ihRLYo4'>Hu6)i+5>7$=#L)X9epd*dlir1
t4`Jetp=N4.WU<$D8eS%aaOh(`&li5X2X#@LUKk9#S3)a&2-bl-ss@ZOu.`=HFo$%6M-C/pR
uNEVa3q\[BOaN@!>PXo`qmCV#U"afHj=r(4&M!;!tZ0t(UBaVj*kt?f7BOr@)gl9o,.Yj*jQ
*'Q3[a:oKV\8+Ylp]A#@'$?br)UVR5K@+=1mKj]AHV>@MpZ&ojuOkq6C<'eR!cIUba/nRYV8bf
F/n+[_9n?BNE5O]AUG]A=k%uo'm>GcB+K:NlmX/hd;TZ9_&Z-(eGd2M-5ra/aXLEaZ?c]AFYgKg
88CqoFY$)DTgdQDL-2q&mF^#8?ro7!og0tFpOO>NRp@sm]A9bBnTVO4i-nHcUW@'>p"1OZQPS
_/dXpXI61c$+QA_EWTC7V<</""WYl>/(M]A&f@6%pJiT4aW.ARL]A^o[1'LK^@"3Fqe7'cIp5o
Z^tO4dmD4+h2I5jgUAS>b4u@'N@KDDrIaWVA[m"9ZSu[oTQ[DK2+G5[h=*3[A:G)=<17(Ku)
*HZ"/P9?<&,-O!jMU!gf*$ns_3Bm$A+)^"'XNE)r,^Vu*nT.*PSE33*BI?G+>/Kh<G)\W(>_
pt?hsbg$TsKX<[pj4i[-aM6s+UqZ`IZKL,//7TDrjs>Gt\i+sB`]AbN<"EgXlDslSg+!;lO)<
q#Y)1C8YXB]Ac]AbUIS?b&VSOrolFdHenarPp-.t;iVXVpY@U+[lSc5`fq\p9i68%"d`#t>3=M
=XrISh0C(NU]As'iMYc^Dn>;g.,`j2mQPc5PJn4dDK)CRU#F0#E#NM>pBrg7UUJg[F!;nVnmI
2/`Hn.bH+$04'TQhH?H:dCMGk0]A7F]AdmM(4<aRDI-#Qr6ZZk9`0+Z8SLe3kbrS9B\%biQ2Lp
a-IG60j<GOIr2DUq\VARI:KA#!R;DI/B?EIl=op;'YA>/^gi0dfpVcj7*mm_8):j+fEQdiS>
$G%&f@ehP%s$7-Bpp`4l_h&h^p"epKBZccL7:\6=\QP%<_tlod=EN^';?Cn1I^S%XR-ZAi!^
klfm5cBRN^W-tYo@+o(\=d1&AYE:ca99[dBr!TLdd)`Dn_C_f$WRMN[q9A6,VTm6Fs'1,pN3
!uB7n65dp$G'XPadsM3;)Q*GujX#Lf0f1`f&7d?,?2Hb4o`3>WWQg/42oXP"oFuTWj]Ad85U[
;P[1F0FOql+c$#rBi"7pl4?nf=YM/hrY=$rf3bRFuXrAqOcUrh'AYG\>Z9*/I^O,fDN)U$7N
9"7bhY8X\QP0fg6:MTI,it@R&-JTW0N[uj!$/gje+pk)?X.u`c$IWWQo]AXc5&5WW"K;R'CJ5
#^B&r`F8EidR!^6c=\l!6i"jrbr%_Bm6<j=3TY8cFR;CMq'dEe@CjAO;+^2:ZYk+UL&l>nt]A
hftADihT+e602.pMD^q,d:BUQG%Q8e6:J*GMI*T8B(2%b[;fa6E$d9i_P(u?o!n3k)C*1MCb
$=AUb>Tlrp@b,q_K[LZuSV\:RK04]A9VNPAQ+)&@D%J<aJREf^`nTU<Kn35?Ha[9V,COGLcY6
CcnThmN7oem-rLae^]AJ7l'r@T?noW:$G6O?gEcQ,Q1D5K99Vjk.AUmc#/<**UDVgMAnNa1[U
Z5FOoSs+4r=_2Yf:&Q*m!t#lRLtKc8c#O22)'6HQB,AUmA(8.5eDNJqd)JYh%,YGqL1)XHp%
+iZ86n0n>TRX*GIIck#\\r)L7:k1]A%i<0BPrCT&-5WZZJs1]AS]Ag5Ni)EX:O1\lOes]Ao^X+W4
2Bba.SE>eW,%o[M[Tp6Lh"),&G1r-5Jdj3j2pX_Hlf\ajp@G4`6NjtgmoXIoHL[C?]AE`Z'.F
"cVMTe$K*S#[@">cqYXlfEN4)_P4%:hN<"e@ZHfGMV2,S+E<X4]Am^Qk[ri[)(doBE\6*HUjo
\$B(iI[r.ulCNc9E1a3#Nj:M/D/Z41Q&)DsMUSRR[PCNg.S#Ro]AOj#s4($)du`>R#]Art+;(H
PfmY_I]A6nCT:DkYrF#//g6f!J8qM<(_/]A?mWmoL$aPBGQ8*4V_tJD"1JT?Z?Sl#8lD=4>Y@"
sm1kTU]A_RNPRH)O^=&dUbFdoDXpMOd'4SgW\@jPYGf_;'V,7^ugs>nQtaGVlTQdW"GRWOA4.
04uOr\g7&ckHfR!lYY(:ga=kK70nD<C7j'AT>=[DA%RNT*Z]A[[\%C(27J-^?$(M^ZQ%J`qR*
7\WqcIE4@TTlq[rZRl%=W$TmWatP'RRbtTgTH@)lIn]A5<X-a,(Z8Rs$El0HnN.&3?R4hLXI1
0S#S@*7.ort9@NMO^o^(^.\*I$Z=NAQ4q9;Sr]AeB/E(8CrB]A6(&)b?nNCiFEePBn1Cr_1+/m
@,t@+0_]A5H2m5SA&''J\LRWi;c7L_7X"[ufPT`l+H$eW)+!Q\Mm$L0(S1>6W:g%\d<5gNGPd
.,nqlK+1["SXYPoCVHt%:!&<T3)df0hQc'f8tj?%:D\=';gn4QCBQEeqFB!F_oT$p@.Y9YCe
aa%Ym8DJ"WY\ad;m5,_^j>n-"r.(i8.0a9Z^u%uA;F$D>TekaXQ5=),@\k_LoK8rlP`U.gf5
24`0^OVHg'<"J<]A$A4"-@Vl$g?p&!c-3s4TP/NApksK:R'`68RPh-@OXeC'(EE;(U9pJ"4ll
XfEd;!KS3jVLM\Md@c=/D)q_%1X2("p$9f;p!:#r#5mo5JpoUVrS#e9_Rds"'OPA6JlF_*Ek
$<K`=dI*rlfBdjg.OS]AAqX#H`:a>!MOFO&Rk1qj#RfQB/^`,s7AFY-V;9U0X-_.\4%P&*]A(U
=ZFD+tj4<*X31h`P7m$"$Ef'K-W*crb*eBnq"_O!cq$\Q3W\G,$Fj(+mllt+ij&e`u4A-tq9
`+K]A)m'TVi[<kn3CB&@!P'mUYA_,NrEW9a^^?+$c6QV5QigtEXh=h$<]AQa&umru8)Bc&Zn&&
bDZc?,QZa=1*0k7DLPg]A?-t8t!/j)dNZ*XB>r)Jf.4*JF)q&b_gPU:JO(pYeGJ3[CWq51_IO
BIG$u@7P3!H]A0haj]A%SoH%-[16K"4sjgq2"l:g5,eG?3Y2H_IuuQl5CP*J-(=b`4Eb!FMCg.
4jkl(G7&R`%Ym?h/;-:3UmTq`M3NRb$9.bp?$[4,\'sZ[dMkeGFDTDXG^:\St(;CB6U(KGtA
*b#V$H<.h5I#91TJ>fS8;GPp9V5l\0j9Eh\Of'2Pt9qSIu?r_Q%>2II%J&6ak'bn'T2&N#s)
n8W[:]A.RA]AqA[^$1Wqtaj7inYAdjb;\4S6*h%:K/GL,Y0Zm9#^'jt>OXbN#'V+ZlU0XOkkA1
J")A*I+D*r@=8#t[69Q954.<*$H@H*jP;fR+>HDl,*._Pq;V=g#aNkg7`R?m:ENkuo5%-IAO
(_A+X$qi$;`OrZj+IMW/JeN=$G=\S%=d<6;a(>Dh=N+EDI905C7i;*UN`JR]AMcm!^!%++beD
[l.j-QGTlZ8[+J9VZAc+N#VL(EoJ_4ZI;.BL=J:=&LtY:jr;iPjK?E[X<Jh/amm^IR"U,j_i
moTEC``G:j\2SG1:]Ami.@rAT(90(Lq.[B\m^SliCK@aW]Aua_$]A]AS2HV$7N[kBChGk8lZrR0[
J5@/T@BO*T=m2&uZ1]AO\^d$km?]A@JcDqTFa1f+Stq4aI]AfGu41%<\0jf^<MIE2k@L6l*(B5a
3i'1E)QL=Xma)<<KUt@ps<A/Wa68K+@[shj*!D.t9#hh8+HE\+'fCB).%[GC92(+[t[R4a!J
RWIa2(U_,+h/[pVWA<8jh+aQ$!*d8_\KPmm4]AeVMGS-:=(hJR\8Z(,M/`r_*^bA$^RpHUW=\
(t%-D9<mCZc;i;[R1)8=s?"S(Z=+%30Aa=g8YOj8qhHK6BlK!S:j:[Ss9!TYT=K":bA!sQF7
nQ5=J@Eb.RTr&8uKHKg!_N`M0LMC:Q$@W,JKqH@'\uHKXQ1NObfl3,HYP-]A"uS!*Xd+LL8(+
;VZNcmni:NeQZSV2*a9-L!l0pP'opaYIFrpaE.O`Ho&$%$(]Aqgl1E6MLfrI&Q@KXS\0_5e_-
G?gdLAqJqo-"H-2]AGt^EoT('KhY56O-D`d"(2U,ENnZbVcZ%*j,Mj>"l+1D$UHr1RSJc!-dE
*!dOsO$cJ,?nRT`l(BfmIZG,ub&cMnD9ZDTiE/`)_LYRPAGWdjms6ECB:N20Qa%S'2O[)NBI
bhl6lH\3"7=;+Km`+J^`InqfPkOS]ALEqJ"W->`Qoj9NUk*uT8FY+ZJ^BXdYE)U_Y(!W@I@P-
n@`a<XujbtfN-E118]A=\CRE#c)a%5FsQ91PXdr'-_/lT/7-6St<&U^/qo^5Y"F$HH$F+E@W+
K6nMPFWZ4j4p\]Age^$_kR:q3KDc`h>GR.9WFXs-9O1jj_9oBrT+J=pPFIR7g:*eV+^)/W_,Z
t0#"lbMjn*b^&pmbUn^"Y\?)NdFQ]A,8LoH;1Ph$tb7>=c85Dh`fc=._I;.9+q.H-I2N\W*n2
m!W79fa5HK$SR9&L<O)VuUOCtZ51r=lAao>ua;0osb$V)Mb;<?CO,?6X(LF!%`8Q(?$X8>IQ
?WS)?bW-U4_!+%h[[!&-_^/q+)g-PV=`o+")iul*mQ*A`naY3Z$;I/B-]At:SJF5EH+a$$#mo
8UIp6,)kMUW3`^p/KX32kPOpDPjjl$2+lGX=Q9Km&86a0YJ4rk9En2>Kt%M(WcW=7]Aak0^2A
]At>h+MZ]AC@^=qGsI7I"`*972FilHE$@NCJV8k1[0g+u@Rouo$bN.Y*nqr*tD!dBi$")B#R,A
'PF:BAREJ?ilW8.l1@*_Iu-,m"':oW)VJK5l_=$VR6oaUCK\]A.0/;c'bMZ:2p@k#S6Xp/MaR
&T\coD,=(V$#/;_$?$eP`T7k:sA9j:'<SB.%1o)!0d'DQb"\<*^"$)Q:(<IjIo)LhsY#uH:m
of1t7+9=s-Y<E5eY:lA[aNKnb%ael"2T.fA^dEM:D(iO\QdL8LSLkL.B^=L4M&G[m="P*,b9
c-Ki*K]AW?p"8\%<.KdE2=>qaK^R%;(d\qt;F]An<_2I)!DaA+K,75&W:=$^^b+h]A3gG-8qijT
FJph&JP%7dSVJsqo]Asl2E?$cSX@Z=]AeOu;do*r6jSZA<('?@OH+FA<>*XQiu<3=11PHAl'Sb
RtLoM>#R9+dW=po^If[#'=Jho)<n(j]A1"V@dW[CK]AX.VZZH2o"_bmR/oCC1b@6BM&M5=nnVK
UX6p0OYBM*S20MVK-7<,f:T@`>I#c+f\9QN33)Pt@!g5e6<e"s($`-/6bU\hh'$XROmH/N*I
(W6"B52e?:=Yc)q`O3K+Uo"9nmDVB^"S$:#KhIB,6rQZAQ`j8an!5>)jbjOb&ElEY&U5NN]A+
X1+NY789h_<5DiTQ-)J6fdYgc^hOURcbh$oc$['F:XPqWe$TfNC_Pg**?K\U:q3^.8P"NfIW
!<eip-p!lhO4LPJ+ZuTC:K)S*2=V"XY6+j.F)g.bD2Sa/HEPdCJYX#9TQPH:WtZGsB=(LaaB
iju>5@Al>3of<`&oMhP4M]ApE>ACuna3sR9!*&Dhiu+8?1Rb-=8EWBUj"XHG-'TL!<VDJ?*?h
X`,p'mT7;5;HutR*A&3$3DAbPJppWfL6Vs\tr]A%=;nofF)1di'BV`rV1c5RLO2;A>AOtMbR6
ia=ua.t4Z4OnL<jTqlcK6!?X&qPhj1MUPqSe3d[rFiEC=*fE[6Z30rbf$-c/CO!kWdm2g#GF
-e?rnQsJI_Qs\DUuXdJ&DOVO&2<iTd,DQ`]AAG#Z`*gO"L!<pi7BX'i<WH@F44)1el&$3#(ZT
#'\_F0KC?dKOk0K:04o8U%QAVV,gTO`d0KC(m<3pGUWEB-la?>Xqh5C)e'oTZUja]A57/:g^A
16(:'><F]AJK892IPiTN4'(05E;^BF[*Z\<odBi,[XS1aoEitI68O+%P/>/)9=1.IZH^gP'RH
PM$WIt,Wp'[WopUPFA9brFreM"N^@d(0c>Q05!TgCT(Gkkk$*MJn)a^cXlj!`d:p[!baWt/"
bqni+if%b]AGc-C;'DPTapdL^,sL%bdc-pe+FV?W5cieUmuCK:^K"a0,+-(M/o]AbK'aa"a2*b
%`Wm[!:=`7C;(2nlR,mHV<LP'QNB6M%W7.+/)O[fNOLB1:g$/ViiOnXD:8qL-5TE''!ciR;k
Zn:tW0fR3\cUi]Aa>Me,THelXQ?6&%+9%rZMV%Qb.LLUK-Zm]A%lO9tf"$aIU@?-_7IEo+)h/R
WA-q)CK:.tb#Gk\h8AU:4BejAiMn06F+,(*[3>\^(Tu4:,QtPkH['[V"PT%gZOth3=nA$sPE
`#\#J-`p@6@lC56(p6GJ%$%:k__ZASa;t!Yfj*nQYo%@?QEalWmlj=N9G=cVV+.#4[`Ouo8Q
rr4]AXaGNo9h1hi^*%]A/782C*HFBppC_LrZF-+!/g\gBn@YVe<8]AnrRY\+tE+ad<S/ZUP^qaR
.kd5)g*LC.d,Ae<W@?O*mXU!1n4OA0h@8$4[!%Q,FnOa2uujZE_L0c7Pf7"3<oWjA!0I5k>g
C(MH([f`:i+qLnPeujjq#f0s_Y/hc[Q;c_jaV^`Gf1E]A`UZU(CNmO>Y$I<K:RA&a5JV28[jW
DZ,2G9RBnj(%!T`p:MZ;==-+AL9\c7>5"kgnH<VE1r_od:d'OL&I6%"22nhb]A5]AcaG;I_kp^
h5F/!/S5&dg8KnOJflR7k2;$Lg9\f0XPA?>lb105G6u(Vj]A,etP)[ChA0%LGm>Yn60lNs!LF
B79mUe"?B+%[`hUGGm:lgGT&'S7^(dOOeL*S;O]A68@HeN!<CD(r8:`iuB5GZtNf]A+KT3U5Lo
j<e4cjOb-jqK:/H<AA6>uT8a6_FTj*]AiPDQa0!(<g;n`K*\'oq-t0a%8!#im-45ioJ?iZW1Q
kInZ%Kcc79cKQ?b=NXY4'UP7$9BG,\='$9p8.[eOfIR,"DchhdI4q]Aes*B4rUciKR"rm@2c#
O)oA//=`g#E,L:b=-sYcS[qK_Y&!i$A)QkN@$qm;$-0)u99Y<Y#Ta\F`^3'9Xp:quB9sCV0U
]A*"rQGa#eglLbiQaMnb@+\qVB\00S4Y)IpjZ?6N7B0*,$jiAV9eA:O_&dOBq8BP-(u]AL"#E6
ALi05$F29=I&%CW4`\^0_uW3B4tp:Sa3oRT>#(B\9hQA>%0T'U]AYC(ZPeknX+q<LNl(G!4Ih
3tqnlOig+/H80F%iM6\eta!s$O=L'tb#`%+bi_8:oV1br>qTR8j+Cad<EU[OO6Z1/D"r*\ZO
X&AebT@c93#k:A3asI-&SF2@_*Xr9nJtl-$oR=mSf3detp?i1uE[V(1$-h!$L4'tJoR@ffok
9-t<Xb2mBYLqlE=)'K3d2fn,]A\`R-]AinTF_2PBl@>sMW6:M-$0n#_\C$dEH,1jN[:aaaKp7d
bE;W;e9hWQ%>TMZ&Yo$!C[mg.a3C%_^47Ji3"-L.Vk'J8U&&/]AEEt"a<0h7/rM>p?.hu)t4J
"*)+++QX)+'>^4!0MK-51)l_^=4%mQ"PO/Q#W@R4C87M!%e'ka^!3l,60nSOj!piC+*tMT`g
K;\Q$qsn$h0VYlt!k&0<--R-]AeGY]Aih3`"BCZk'HE\CRE6(1Kj6u)g,;?3s[?JIJG\7g<Wl\
!pM"u"Me-8_QeFuLGIp=?g3HMH/6jJ@K_(g(F=,3K<?V8PGBkBUVd09H]A04UA+URe`eL^0TE
+HF2WTq@<2WOR@kud@L]A(CXWtQMD@[rNQ4Pd,hh5[:uJ5XhQjs_XDo9gA%_:!6C]AjZup%e#-
Z\TCQO&E]ARn,Q\%G+_^lJQ>\h4g1(f0#OcU1U*0*fH(QL:*AM;NHmE,=LsubUcj90\K),4;]A
Nke#QO&*YENoitR1%KhH%'L('Z"EHpOa%m871`cJMa6",V$$7:_m7rE;R1q-+*!e1cCnoB_N
/VDq-#6:4o^"=jpI,WIrp'Q%/O@B6J_V?:M(+)s)8K?1Da$m7Eo?dk`67e'>"L>\25?bJ]A2l
K]Aos.I3,A99hKAnFjLD!Ba<>'HDFf9KAFrBKfi55UQq1Q'0Yf=L]AADH)2E?p"+!>KS*E[?$D
1:;BEJn8Us!t?nWL_=f,Mn\J+hZKXaY[ad.06P"+eC;_ACoY"4il?VeG1]A"BWEh*27hMWb!L
>5mI,R0C/RHN7=HL^:(PpXgN)TfHu"qHnOa)KkgGY<>>@JQh`]AG5XSdfo]AOO-6t.ifp#q)Tp
-RcXnT9,a"c-J6G**Fc`fDCu`HhWKQH170TFHQ)j$\FtAJX$"(#7K7)VL)SK>m9,_J&3*XI\
p?Xm"23+h>OZQ&BolmJmu3aNEC(qpdj'h]AM.2J`-8alKlfR.VH*5d/;jo>;hIc"MG9bS;[oE
<qJ#n)1l3U&6O!Lq""Gs,):K(o'qg;CRCXYBYB!p-hl<Rl7R,[<Z_cY+&j99@JC"%"?hagG8
&4!m+S&*-OD=h+NrPF>jP='=R(=@$rmiO]A+J.52$P0-j`Fl>%[2V5lA@"W;&u6YJTN:g;R%c
E^LAV-D)H(XYn:Z>VOcEdkV#3o\kE]AJI*+5,p4U09D<[d8X6>7.`1`hs*TWa1hE50toEGGor
KqWRq1?+1k9fm:pA<=ph^;mi6bHTD!mcW9pHr1r0kU'U!;"gC'+&q,2.T>T;M?:SeT`oP+2@
IcpE\$UmYY*=NpdUoX_d(Ak`jd\k""qfLKoeLGS[S4U2S/o7mN)HiFlq;0'&aWE9U`I.thod
h^@^.s.@#a##%@rVa,(76]ASd/!+"#ie?a!-XGd(g$UgX-Hl"?.AtA`lqGK*b8h?mJaSO&5kj
"!<oPtqd"*[(Qc<toWNXjG5#7b!qV5$D/AaQJ<jSaYGpOljo=_EP\._S(95/Y/=[;5lX_8`7
(Q,4Y,NArfJ+4AJVW,hs)dKZ7P+C=a_?pi0fLP86a/sPu.o57X58K]A_JG:tW./UTkCH@NoC#
POT7orEjR@2j%Sqs.XA(Nb>lN+gc[r8=p]A`tP8S1Q#c9AO$JpLlriEBj_8b\sc;'P21DjgfJ
:Q<"^J9lOL$1re=4tAK'I<-N3G2>jCj/C-h.V2sD*5.4FihU?f]APB_-;p[B6*3!&;kG!>MkL
NLG*rs$Fi;&KHnki_#7^:<4nB22c7'WoNl4c]A[?"(>L5o.=:TUg]Ah%Cj]AuhkbXK/t:"uCXBc
l[[3;kB`>%HPQ>#.fa.S8#)_-;F[!pp"FYS<V@;X3P4."/<:#XlV]Aj=7tl1Lqgs)@mSg(4bP
8i`ZjbbNX'pi`OANh:Jj);*F5[:ajM3"BV=j"ErtcXY4^ZfF[a9H4F\Fh@He,Mm&hF3bO.hH
HP%?NcV,S/oXh[2X7DhCPR/0#=aTaft6U#\SaIo7[*J@lkA>Pii#?]A=2(7PD7uk#%[FtV>mF
ZMRV1,XEQ2/J_fDsXp<R@DQ#bd`#:Z:^q@c^nV\[BCOkUO0A5:Jf(PgnYFf+j;&6%]Ahrqqd)
c?)GuqbVTj\6:&:&[baaap7@t3%;T5R/Fs4jX1*&UTA\$<VFn/0UF_)%c#p:E_%>C8=FFH)\
ugh;5GJ/Nq=)n/!Acs"jiC.AOGO?&Ni+Z2qN.Po$:8?fj%TW94P["/6'0Ep94bCZ`pre\Xm9
G;N]Ah<.f-?=,@YZm5*."gPg`ZsI^(-mX!(!J-Xme<]ApJ1]AVJTmgdaG.3[Cj\od&sqg@6hT2I
gM3DYMg+*h?YedFYR7tWeNuE_1X0sJsXl=Lq%t9Rnm0r+@t[hI(hAL8?,#D5#k2G(ToC97s]A
ak,a9iaRi"HdVkP!>7D&)$hu32tZI]Ag\'f696+'3PKmIpOM349Gf#SE,VQG<=KI8u4pouBNV
B<?W$m]A+9*BHGrmqi,L=()QAc]A?Xm"A-h*P^;Zd`/4+MLEgN.FEps%mMr^"Vd@e$\#S8R28\
.dB5WgS_3&6&=;)]A'B5Z/[AMaMgK9Kjel<\CPA&Q]A@#oo24O2B\b+5'%`-o86<q0VKQ#abAj
mm`Yr@Ca0!`4*;XU/Jd="4_`N54fJsZQk$UAGM<c7St"?)G(oC8#I1R+&",C[5O<OkHrj=s:
>cJnoK('',IEWAX>$dX7Cc*9l`Q6PXd^!A0,)[6'kIl+huDqohY(r4lL<^\90SRT<4@Cm)5n
*%rG;?jEn6Q3SuD'bYK-^rOgcqFp3<H1_kI(tJrM)A\2(@Md+aTuJ-:kY7RJ'4,!cB9:kWcj
,4D$lh20[F"5r9tLm[@E_Q4eg!r/Tb>ROoSani"]A!7#OdVsJ+7h92Jo+Qqs(*I,1KfR/^O<=
/u+nn/G[`"%.E((2Y1qH<(=>q/Wb-lQI2'^j@JG]A=Ul!3!*+d$9pXK;J@D;)6l"CJqkK4Rj;
(kF_0QW77hZ]AGdG1NrJ`gK8HgoWE$?SWK]A]A!',Ds<^>,Kac;X3k1^Hpf^YXDPn=B.,H_5QL@
r/cQYZ(t^'o&g>Zq#Sl,JHQ+Y%4K_a,jJ4Y[.t.h3>E+6ii3*-4/PteI`1M6`bY3OU!)\Xih
61''_re#+"i;(L!,J8HTOBV,qc;0f6,tD1-.GD'[S6TKo+,-3(<NV;W`B_-5B>"/VO'3S,_@
QfYiHV=IkjA5onF>f`bnJQ.c>8+&,k]Aj_H'qYl2_muhK)+3Vl0U;T'"^TMDLfOM;e@th**\]A
?Ea]AOINY:MPDYEIor[T;LsnaDlWU<qaJ04`qeo&!WqJi*?ea]AW6dKpF+i!62\!#^"DWNINRG
YjncgjG&*"M<6ip:Qaikg&mA_3&:WQ2DmFcg[Hq(QZ+aA(%m7`7DWbWh&FY%Xp47^a9!,UR5
Rcj7+S^#/geM-K>:um21o06+oa<A2maKNlQ'q>:-/q\.T2farP$=CL!'J4Yb0j#:[MQFDQ5a
9m>?#ScOI0dfZI7uqM":hlXZWGPau$WaXRE)S\SffkKS08Ng#"_lO)+7?MNc7pJZ/P/CplM+
Zuo,K<JbInCpHo6F&pPQ[9`BZYf2VcT3%ZNPXeq`rA=JlGDB:Xc9;6]ALB:f=4t;p-OpO'$P@
T"[D"KI^eN9]A\4#l%9WBIW66G<1'+M[Mt"3^]Afo>%Hne4hL/ZamOo)/p0IhpF"P7]A%YYn4-e
1E[<IQ&#;_*bW@s60:k#=j50)V%Zck(q14?GIsD.WEs&gg3lFHGZ7sXKlIL2HMC9?CKl3kiW
,acWa[A!*1/kbi,38p/>(c&>)'HL;6+$3pTsu*b':7r^8ech6-0$"Y,"YdNp96'^Y0bUQg0S
g\7dF2Yr3eRsH%u_1IsTXX5&Et-\$oNVWn(/0D]A]AfY\`u*=,pFtBq(e(C[:^`d99]Ar*I]A@-_
ju>NiTiYj2AV%f^4:$ITN_7"@h6@4F8B_i2EV";WS;3eq>C=f,O*9\]AopZS(WuG3\`/A$k#:
r&%BJatH\kXEn&-A7(+JVY9^M9-8of_/.hlLn^&"gP',qhRbqDhAUl/-q0o*!,%01Ah`*Xp8
Ye<M.YrMtW[EtJ9ScJP\VeOS(PKd6$3YR74Ij-6b3VGWpWGNBN2N?CXk@gEk43#tWRfn\=/N
)CrAC2LU<_%?XT,:o*o4/@DG$BKi4"SESdg`kHl\@MTaI(G#_/t--r4pqWcd[.[:LS*_>Yra
'+c*Y,[7t>im^,=D,p+l,9FI+E=7C=B;gWrm]As%&!L3rGtR2]AJ/_?N'F_Xd"#5D":nsf$Ne[
g68O%onj,)gnqHF3;fY?5^rN$3$+5DQ\CSTE9PMo?QX=DG,PQO=<S(66-h?L9^$>nO]A8jVpa
3hkfBChZqJl=:,sJ6Z$M9K%Vhp*Z9/GOc:^?>tU9.W"V5m^\IliT!0M!&Xj'J8$C:Io"J_]Au
\K_\KU.]A;Yun@J]A^b2'du>$t#ETQK0JKl?&a.q?R/=I@%oKo^.T_7;&-1`bH8NRSoM1s*7i]A
W32X+SN>HSDSYdd4<_GpKOj%$KHW/I-HS=i>!F8>FPf'!ISPLT=+r+gIH6[!n:A:DR#^\EP7
Z\'o,=D*\,q7SCDU:$8e"Im#M71ApXp`I50Xg.Q-<B\?LXa;e%aL?1@Q6&+T>X)RmI;I,$iQ
fqFo*jJT.JJ@@TNo%[RG<VX!BPC4!KnMU0UY'YQGVm"1[f6tGdq$u[&[UmKb]Ao>(fEhZhu)u
@7__LKCPqC0\;[af1h%-$UsY>SQ1U2[i%J;6,dEDr0?;FV*)(:PW&4k3%:hX)DpBij6@1TN;
Ue/R(Aa71uSfjjWU>)Z'8S:Ckd`dQhApE@7!)8Aen`c"N!f0pVoUb]An+^5j;1V88U^q^<BhK
_)jD!c4'j=3@EK5&hZrb\<9*<L;48R=>.FHkf=H6l;m:#f/]AsbY*0W*kfU<cF1%?52lS_Cto
OPc43#8[Olc/!,2.lL$QUQXM3)D?f/A5jrN:J[gRW).b<ZF<Z"6-!5g8g'$'[)f]A$+`g=j2c
L\8*q6tD/b%=^:[r7;0(cu*6bbB1\7^XmZ\"8A2_[&84ME8<T8:.M.+B>-gT3W<DW')U)`C%
4+GnC)0mo#3<7e("&-,3%$;[n58^kl5-q@9mO-X'9s8O%qW'X:GY/p:p"*_0jtpi[DN@^eWT
]AAXD9?NeSR@'sSIh&`f,t5Db/MPfs!+4]A.90Lq.i!+s,8!;ph"uXQbQ5jWsiI7t6#;G2Q+6!
:o,uUJ-;FS6r=E:nPu(E%iTUX'm,%91^g8[(oQgH1ds"b?rO&7,;6J=Q%ha]Al)`o<@`qub#A
W:m&DL/kE[Jl5k9?TqPFn*e\Ea@\NnHN;*ak%2uqp(Ut=]Ac2dA`JE)A>WN.^[m\BEIXDJD*U
X%CUEqfGV;#Ub#u4*hdIZj6\:kCPX<a#*36Y6uk%>Hu5q;<3;..T,B-W-)XqjR!,6]AVm!^*.
3)ZYQj/)PBOAM^e^q#cH?=LY\7a;B[gst%[cM,lcaBdK+js-V!RUme^VRW'9HDMOJ553nn@6
g'ROP]ADc=1-!e'?P]A1rPuk*#H=<4N4A3is]AKN\Lej%aIM6UH1<4fIo@]AV$D)_LWl<P"AA&Ur
4rgUQas>FbSJr\W)<idR^fZVb;f;/V4I\rpOi*G48G?Ph_I1jZ-u\:8GQ0Ir]A2EsJ[Bee&A/
r4Wg_XK!n4g2GC+IqZZ?1A\PL:&.BTL5k-nqah(KFqp]A:;CXCcQSjhIu:Zg'OEGo)ZhkIm5j
A>i(/,3Wl9kb?MB-+cc`:bc:Q[/LbQWQ2MKPc=%c0CAgG:7e4icp",N]A"-N]A`9VdU<grZ?Ij
_;/^&DZMC?Qe3%0">NRmWSaj9(=ol)rOt;h<VgFCWN@O$"sfA'h193*dqZ';8)h8$AT6pF+J
U*ViIiH.a5-mI<C@mc(;t^_Bj??q7,%oWmk;"+T7K:3;`><:-X=eT7fGkfSGWa_bD!m?*1hg
E+HXn=[IK$TXI)%pRBB%^+(j4&ota:A7PN:pGN;@!?3'ptq!SG6LFbXNI]Ab>&KLe:fR>JZ,7
3@O$rpr2MnEN<\Ln<h7UoK5a;8_r\sS`[_U,m7Q6faAh<_XIsingh)c%0gsC,D9KrDu#(3(\
BR_/0n&UJhX)[a6+1,'ept.,q.lmP"Mf#*C6*Z41<AjjoU&KMurA`:amUj#YZsPc*c8q/7UY
c/1\DmGL/R*-/"3`!5gY\5QoGnWa,l@E-6?EZdYsVeC26Z5qAaj%q'j\3gU\2GI^Lep3^>eE
>!hRYQY61$Rl3=gYH2fnGB)Hf69t(G>?clGi;pXG[AB7WLY4WT>4AbN@\(]A!%g3cghDX8/VV
7ce>`X#oR5JJbOa;\q151>sQUQd2[aMT&()L57q^-[bLpa@SV<;.`-e*]AJ]AXWZ)bl!R`Sd<S
]At:n2'h[@U>'e`ph+<qP;\#A83,B;U1O9tt2:ppk<]AUAt;g/GiZQba'/$"3-i&+6m9FSJa-O
(jp;\4FT&*<!$+CaXIK8Y?L07rrV,8.!T]Ao1"Pb?klWV[,SpR\,GSD&TS_,?'p@8C8pT-ULk
\>e407V^&1p5%RkjRE_$<Qg9[_S0<`1ELnPc1#rt('KTa+Z4]A<1=Kl8Ra[QgI+opLWEYG.)7
u[c#sX?Wh*\[l6CkiY>OM3)Uf_JXECFEN)W;eX/DemsR&@chL=,=F3anX-_=&@NobHeB2mbG
1,-11c=UiM6S49Ztc=R>XmW_<MkZ%q09^JC5T.=0k<7RMW"1lGl]A?h@n!gg;6Metk7:7E-Yi
,AZAJSQ>07;Mci"AU"5TT_%I,mkOqBg6c'-MR?akKJBl<1dJYWb;GUPZi2^V&qZca+A!n_;P
^uP6:\]A(Tf=-I[%#`IR#ho1+g&WbI$-l$YbL3DDnH'DF;<&S_7c$=6leW$r=ZqGuR&hQ8YI1
P+`SC2%#@1^N!kE"0'UT;$,kp"g'PjT`GIkRT+0b_g#8TOoOAQp@0qbhNH]AHOGOWG;!IIUV0
:h%a\Xc/$i&h6ZdGr<<-9'uQAK+sG?\nd\TQ*(Qeu[h6(aIU$L$>\(1;[#!"WQ&j'#AVEIlg
U?$7qrJD+Wg\qL9XjiA<KcB5hiVM`i3GLG;R`MupW`2ZbL($!lIqRH>j^UbW/-U,J4`$)"RX
4I5*6%^j'Be&SujmS1Cp97*P(+GSZg9IqOJ/t+nsP^5Q56ZI>V_3h4Y\b_T>ih!6Z^=G3Fg?
\2j$<F-8b>j7\fX&fIU30PCTufV93QW9=9$;o,Xr8IgMR14g(iOX5Tb5j+8[WV7B)3Q&.3;7
qP:#iiM\(TJ,s)0*rJ.71XqN'5,?R#T9Jrpoap\j&!LOE_sSEpXm*EII@8`2/:<p&V*#]A<h>
qpE^be/1@K:EC$WuP\JCD%::/Zeu"1nnbp2M@%V:IVmg4?s"?k"q+4dAPSd^q0`[/W7uX+#c
(n3i'C.:]A]A[C9SYltQ3Lt1/eU'HLb^3#.,VoZ4k<%4&,+Yp9Fk=h)h_R!d?a%*]AJIMm+,'^/
1:I%^>NeuI/'7.l:I0O@H+a[.LLN]A6cnRF+joU$h6Pmi.*B@N3tD^25?'"['8lmr%`K4]A,fO
;L)/DQb:LhAn&ee7X9M9]AZWb`/(+]At(0P!.H'(CG6jg#\D(IJHe<qQT)I4_ikqCA)D3K\!K.
AcM),l"Xg2-(b2A(>!(]A5sM&G3f6So5ZJQo[;-n8u-'1N=eT4Fk&=44A`Cd+d.1_+W71IG6'
?BjP2EUkN#H.-7)!1Q:WZ-fE.@R5N98Ml/.f?muO<UV+G!7TJJo'j&(GkC:^Q;flA/8L3:*C
qU,n\99ZgRMGiP2eZXgcPD%`g>qd,!bS!6nZ`EgXsQ@\cFc')c0%PU<@k]Ak59me+":$0;Zbr
t`.:h%;*M;HCG7jd8<(4e/gmMZ8IJ(+!q09RU:#?bUb@e<`3o^D_>S81(R5u>P9B.chCer]As
RVusJG4AIp".^%fo[8"N02EN,U0$J;7EYG@lh3Y#i^<Pj%K,=3X[HJ]A@7b;^a-#dfNLDH<#t
8,%r3-"qF^$&11Uok/Q=a^gg0C)#1_dJkc9_+<:F.Gb+Q3%jBV&MLJApD.n&H<_rM"=YOg5q
e66oaI\q,KQ8.HNY1M#`R<kE@JQp[ZthIV8F1c&.:]A8aVWeoc<<FFfZWlM>YWn@&//(4_\.B
7g7-F*pmJFtCsAij_V6Mu/dCP;@kUbC\+rK,>8IGkk[ZpZ\l[H"k-k+f:-5$h6-:L`gckp"h
-&P>[;9SSD/o3KkI/3'*SSJ["$N]AO`IPN,+\F->6=!h-\JQGZJ(+@Z!+ZWVPnU\8i_L35ici
IAa[(U=LNd[#n,Xr3rk#ND$hIK(+>9q%2`9;-D?*=S:j"DXMu4XQj_KkpXZP9sk#/__e/42^
g!3C5?gq$-]AB#eQ&,[V%Voh7i#)_7EM/*d:5o$C?fLI9\LqSMT-=\"asQWo3C%t^aBB8Hlhl
BpF2Z<5a-PC&6G@%*s@k_2fMQbn+c1oT'!gM'sKH;+B8m"#T^M[Ki@HN0`s-`j'3"&VGLI]AQ
Rjl@B=-(sS;$js-d-Qb%94Z`$\%ibg)D\#U]A!C[<7F-Zl.X(0Ejg)G(]AY*V=^L9%'#TWsD4!
;W*aHL`GK/MdWS1<Hs1T1&4s.tSF.KG'oF_Ri@M_Mgm":a:9sBh.nnddiY.c&)?f+U6%B)@;
;7PC0.1b`Aa7mn35#H[Cd10_E/.8DYeR=*mOFaZ*fOQc;io!IjBJZLBEs,;7Qh8hA/L@7_l,
a4%e^m?haP)U-=+sSrb5JB^!5#SP;a-m#.m<aM7(!91qCV15in8#$mY!J393kmOjD*NXr$_W
aZU[2&3.@[iS1O;&CIT!IY'o<I2D5>TruL(Z'0Gs3gKb(%El9&+]A7)Y6D8--$GqS(^5iiZVZ
f7[`L9a^umU/L43RjI4Y")%oBI$baE0c`/#gnC^BuL)r%\D*son.TTSpQDF5NFV`@#^k'R1P
.*QmS%F!dHNSI0,s[N>73^[KjrZo/'8$B)`3D`-$.t9+e86;t-]A$8GV^?Q\W^i7P+`dQ\-gq
R3H_oF`ci4fa3\H-ci450XUAsO6U9\N$rUX;"Mt5)]AOB+o,2%FZ#QHuDKieLUT<V+&9u1OP`
[?R?[$66`0:iaQ+\H;1JtuNHd,*X@r8h/o_kp"+(u]AnkF%L-5eiq#BE?5;k^'2$MMP?VllNT
D?I$X!Z'0Cn%'"1lKft&=1Wl%*=FUb3qGiUJ`=Z-hF;J&t"?R%WFLe5nZdGB#[bnjG%`SX8Z
p5;sH>u/S#Xds\Tp&V*6/_enR0eX,ELJQh$V\PZq)"M="Pl;D@,J]A2%2/,K*_n/eg$6u-8o`
30TnghrX[[?QC2aLm*1l7h^F\`enN41J2.'eq_!C.:q%%hXm]A6R"P]At0DUiCMRJ6\+/3]A<-$
OHLkPeY#5\;oJ*G=PB8p53?KLKtDi"/h1%0kBSdj#F._2?c(kCR2HE^TOIR]AiI$Z[]A2s4?,V
'#F.%%VT&NMl;mV:C"s7'E<6p3WUXsl3De,AFNfi*4#Sd_.QQ>qh&KqVrOc`#h&,/CC*<Q+0
#[4'"R.[T.#L]A/?X!$YY0X7a9I65BpQ":WEU?jWaDb>+aj]AZ^"jGOhR`7#"Z2!VSI&(ZSP&*
MYfkW;1$VqJ==0^*LCINP]A=j$J`8R9,nFpqGfJWh4g4\F+5nbMB,h[+*-.9]AM12pPg-+b`.J
LIUa8?8Wm@[,CBcUHaX8ErgWl2T$iB.)l62T-^Ms)a?%aBJLA2pJjTe^imNcWkA4K`Gi9no]A
1-2;-l+t)1B6g]AZBc(J_@&3@"D/rt/49Vm;U\s.55#fW$f%sQ[L;sNAAk8';W,W"%*EQ$dq0
??$HjqBcpTm3<2)O$b4`'*E?AGG9Yi-Z<Yo;QTo<EZ3o#WjCXh!.cdUJ4h^;X(On7&2D]As@!
npeA'`W1QsdpnCB('G<t\H^C`X\+\sD@49[*lH7+6gC^lM\$\3AA)/Lm0rJ"e8\VnK2hX@MW
<qNI@hX6+Ot8-e=0EmT!A.Vb@i8!_Mh)Q1AT*Q\[o(5(l5o2U8N]A(7Jk*tu_[^k<V?h5G"Ft
/SVlSFod6-3ia$/iU`PAh?AM(gi7Es*WRdosJ<AqaZ:J-@0H_o"N$j5\N^T`;=hM@><Vf-d;
7u/0oQiH8po@ior1rc;(<tD4&M>o8\U\J]A'/e-Or(o[NFJ9ZHc3.&_D(Kc0/B:dS6j.X20O9
)'qU:Me=Otq7R&#<)[fg&]AYIo>(G@Wj1j\_>#\%+N*B<PI[5F8/$">\JA%s84H<7S,aH'=L:
$\r\QP@.&9CWpHD8m-gEhg:[m\mR?"3/5EV)UmCirH&6$Calu!><M@]AT#EWVRF:^sR61)Bu7
'(i5n04I@8$&o.7l%=FLOL#B^@&e+'eXW,q@\l99\!73<\M_jr9V8Z?3nj=4Z(3c^$^o%]A3@
914p.s)Vf4]A9EV5KZQ2/-8ch\fKEEKIALLgf*V_8Cpg*Q1Rcr)<PCQ+M7B+VQ3P_]A%21U"#?
UC;&N')Z,VTUE@"s+FPJFl2hLNHCZ.@VSO1KGFm:'FeS*X+lF<GG`>`@3[;fWrnoFHZ/ngaJ
iu8&t664.\B\ocS"IKL5f9;k*3,u`dSGU4q82`A=jNaY7dR:j-Rp_">f+VI)_@l=Kb;XMc\#
%:PFO7S4@e)AU&CTm:H!P$#UF7q<tp*=h\&qPP`moW>7]AG'Bt'/U<m,hAc#IPMTIo@2SJ&hC
'-Ys]A%"Sp?t/r[7'c[:O9MO23S99^e-Bat:`D#e<>6^r`K>hQpfFk9WnR[pl^;:\RXaeN0%*
.AZZWfKH@U4m#9VI?"^[!k3<0&cY8`>U`u92h70%EelJV[@D-kAI>#oA:5hsK$s4]Al96b$Dc
ahGpB$_3ZdC"gsSHC-LE9Xi;H<iHs#`k--(QWA8=Mg1ao4;-_+iDahf<I$%6:[:)afloB1NX
Y@<eW"+Z+*TC%O@C%X\gG4l1\`kc>"BeYm,f&T(Sk^5LZ8'rq,t(^=olAcom[g4LN92sl>D3
?AF?(i%CZ,eZ`M)BLt7blBBEl2S7bm>r_^7%6TcaDeqXo>Vq3PB[tO6DD)J0$.H;j[H7jh6>
'I-(15VU8^MW/JkVg/poa3K`6`"pH=\s"lqcoDh*)r@ahYRP]AQtEf%W!*%s-@V7L#Q7o^+t\
Y!;G@K$_Ys%O]A6.&h:b>O*;,bYSW5a&#l)4pP*@7V&,mT]A0*Cul1g-Y]AnP>M[hY8Fr=&G$\;
41r'AD7_l(>7#R!N+/kiGH#L_6Ygqgp-k7N@^p2n.U<Rj.Jpq#Jbjgb##,H&9$kt0&@,j6d5
UYXYFR+_OZ20aBHI,t[jM#nB5D>GU\7g/A#(:Zqgds?rsmGA15.C4>ig4.8#fd:Rp1@2h,<(
h#B$eJ/r\+Ts48P-`*6'T.t2ZP+^7@`n1N/l+Mn3a^CHp)pCf,/8V;!Vl=>W$1Z3OOA1f)/q
U$Rh'-@=c,Q?m\f8HL/P2<VYD#4)o\7>G7IDDb5Pu=,N,8B[#_+,AS'kU,\gh*2_f*u3=bBe
>)/shL!9Gs4PfcPVI(.BZpG7j:#98QgWahcD2d*t(e1ZpYPdjlCD$Ir`[AE-900mC$?[2C_%
B94+*^&s1lCZJ4$Q0D#L4Ogd"M5+8q%U-mQaFJDjT5_;?g4lph28aX^qm97n]AdHNF.bd:Mrt
:-,c*=?FV@;'dB_se`[oFqLR]A(,$LJHb(E;Ek["!<pen6!B^4SuB5&VH_geg0+ADNP5IYh"P
a0G&8;As`HD/QHq$[=(O`?@m<,$/1+eE&OibV1<^6fR)Zj`(N\UN2q9jKp`(Y_*YNRrj@]A+W
=LK1k%!eukOk$(g&i/-dY!BFc.e^('eLk<4%S&@p%8bt6HE*_MDUaric\3r`di(.=s3mr0th
m:_%?4;)87L>R[>#(S/R`tj(QV.pHhko'>MU_UbBrC5WahtD-krTrQC`J*^&s\--57@%4$Y4
0$?Rg_+f;YRD:Wo<7`53"J(S\lD[p"Oi:IWNY]A2`Vk.Mc.A2@s[_;h"O@ZucQe)CMn=`qXpR
\))'JEG]A(kV!=Kf"RB?f<0sBuC?UY*8c$;1fBgoB^\(Z^A5.,ctL]AB/&R?&b(M4P_12&Ne?(
O)3,0c54\9neY=T<r7LBPUP?q"!H/ae(;'%D@]AqQg-P*hf"ZtYN'A=Jl/3@WY>":.ah'Tc2e
;TYAd4)Zl7^EKd=A<\[A+`%t_nC2T&Qd03omTXc\^C0F$q,g^R-rG>T?`H_'X@I9BkE1)%An
A"\GrEP,dl]A;5L*f&"+Z'%n[p61eJhR2Q$7&Vm$k]A<Hl99PcL.uueKZ]A>S\jN5KMUoZP'Sj'
BhOq>oa&1,ALrj4naq#k>T$IIKNAD&/oXc3aNuDb;SShk[bYN)po\iD(FaC]A>qB\?[7MjQWm
D>?m#0PKFe'rhjr1H/a.EeqELd3L6XeJl9I<gp[BNc3Y)q=Uk<[+]A]AdKoD@J&LL6>IU^[G3F
ZW[[#]AH7k=KC;j=UhYsa[MLo<CmbZO,l;VZgH*SKTIei@X;?=a3[OBn+Wi9APgd%G:UmuB5I
kpQY]A1ae,5_"d->0<K8=?'1!JU;1j;!6YFZ_[kb/BC6JWB(KmL]A9?+&Y)(@mpBPl]A&bVf7Sn
m7ij@6X>*@B<.;E,OpJKNEdqf'teqhnI1\F"F1R_"OknV2q-_[ppK*,TH^V+W`3K^>rqCN]Aj
PH2_J^nN!I=+a%hIaVh#\ekK)/ji*>+gViQM]AJFYAZF@RcrM12>]A.q-GaTD)[qq--7bRMkZ+
O5b.mLlrkXt_kDl>Y<4#ancT"hQ*31DZ]A&rh*0dC+IGB.V>sK(9FSN-^tl3`U5f&R0o!h-3R
UruhZJN]A)%@ma"mT9/Zoh*(]AjQOQB33S9ijdAHL'%ZDh(P#r2IdX(bE+HeE;4]Aplj%#(*i*U
cmZ?MV`,*'VDaY/d[TjF%XmFP-dhIo2I^jh.!rSjIO73K=JC70mSWcM^hJ!;S8$P5SF%5;R6
I7pN+4.KISCKn<%kAL\j8mmX9Jhg/Jk-$`\6Qpj<)[CJW4Og%=a0<1&aX^YI'C.$;r0IpOn:
4K68C+hdq,0/=k(2ghlBNK]AD4o03Ga@H-RCQD\q0)a\skJ#G7DD/Z?nGDp`so6[#X,PEZ3E6
pHKU<m<^k1aB2@ZCr,kRI/JK-pAdUAhPB?Be+3BXK:6<[`Afd*o\iRLcgtqd>W8T/1RJ]A5H?
r]A'C`SRIUG:$`nO$ZB?XWfsYq!bruiF'8j@uRrMuIiTUTU$d<Ubrg,f]Apg?akG#\.V`X9p:U
6k<LGMbV3_B-,@%R$YdiGWW;g]Am%+Ph&/nIMV>mUc0(Y0>4JbWT,1?WJE'OkXtJ)esU]AI?^E
Aklu^$!7cR,D70V*^4)[D8n;k_h]A]A:GBV<fdh.,h*%jl7us]A8&uu%6%iX4hcO/ZsYT]AeZY<E
`5f5e9<jaIWJS8I<rc+8?Fc;4H_`J8c/bu92;/3\0i9$u3`O`Le^^?c&nc.;\;>u%drtWJ.6
RueHaD7rlD5hjp5t2E&*\rV&tLrf$j>:Daa=_G3.&h7MVp<F&.-CKe\`L:RtND5Z"atL56;A
,R^YpK`lR(=V"`uN2X^K)i3/C<^D]AIWTu;EqpG8;0ANR3S"oGmL;pVS;C&pB(l1Ks^?V(G;-
%!E#\%riCWk\0^@]A&o7#h52HO8h0Q,2Do)+\)<k`/UJ&fk6cpLTW"Q9DU6cEDl4a\3VjC^Q%
E"7I&c#DZ/si"7GCICBkVSDNEL&L%6pMqul]A8pe$82D<u#dp#Mc(b4B[QpN,eEof*$NEo-X!
<Q4pWDL^$;EmK9&#H"q?gglGJigP"DRp]A9%6q8eV\-TepMtJU]AF=*V"(S.e6?We3q@sY]AQBl
KubCg3Fr5h^sQ"qT"*J"IkORWo&*/4qkP_#f8=ZJ+iXhTFTX:CX/NE@`se?gk"nb&3J/YY>l
&AH25aEoV2`FUJ9e%uAWa'h4a/X1ah([7[6NAb5n_?sa*!ksYd$p^gBp;IaqJGVj)/ZJ"(nq
ZWtmX1T^Z;H(3qDniAr<?0+B$C]APl#1Kl@qkVBB"X'_FT34(&^"S\5e2&Eh[jt;b_EEgJP"]A
R-4+40^VQ,q&Fs/WN*h!3<$ne",(%L!0)]A/6L;$7I?Eu3'#iS-#db?On5&Fai6=rSQ.fF?@1
efJbZIQQke!>[<+m/Pkidua10\6WR<`8-(oQ/S5ZmKrWm%H"n(<>(h!AR:SI3:ZIT^r.Ts0_
b5\\q)@-YKac\EpVHD=Vo@b@]Ai7e9E-q<q"!&q^bc:%jOR)Vpck;/Z>-_FX8Vd"ir%@;\^:@
h-_"sHAn*S8PM)>Is*lBE#I&m]A34mXR3Hk#O2L)1(]Als,6F"``gqAS8+AM11#F8>Wqjf\@PR
i:4E[X\,MF:'_400X$\fA;\gr!CJLIJ*%"Vs!^PX+mi&,$#YdhT\UP^h^OJ\@,fMqWm&,=LS
0H,C"Y/mitU)qs?=q2hX,C2hX,C2hX,C2hX,C2hX,C2hX,C2hX,C2hX,C2h]A.m//maXnYPuc
7&9t*UDi,*jrAUD]AlI]AXpI^e'h^`2h?i@*i[NW:,]AHOp2]AHOp2]AHOp2]AHOp2]AHOp2]AHOp2]AH
Op2]AHOp2]A_]A`Ze,NOP5kTp=#`W-3Rl3l[)o<Q2)o<Q2)o<Q2)o<Q2Ii$s`DWT#P_8*N(nS]Ac
;c-M[QjS8'@"T~
]]></IM>
<ReportFitAttr fitStateInPC="1" fitFont="false" minFontSize="0"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false" appearRefresh="false" allowFullScreen="false" allowDoubleClickOrZoom="true" functionalWhenUnactivated="false"/>
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
<BoundsAttr x="0" y="0" width="1790" height="354"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="65" y="686" width="1790" height="354"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_TABLE_"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName="P_TABLEBK"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-13203982" hor="-1" ver="-1"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COLUMN_NAME" formula="=I18N($$$)"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Table1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="600" y="85" width="330" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_TABLE"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName="P_TABLE"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-13203982" hor="-1" ver="-1"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COLUMN_NAME" formula="=I18N($$$)"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Table1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="591" y="2" width="174" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_PERIOD_"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName="P_SCENARIO__c"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-13203982" hor="-1" ver="-1"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="PERIOD" viName="PERIOD"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Period]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="390" y="85" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_PERIOD"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName="P_SCENARIO_c"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.ParaEditorTheme">
<FollowingTheme styleSetting="true"/>
<ThemeColor>
<FineColor color="-13203982" hor="-1" ver="-1"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="PERIOD" viName="PERIOD"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Period]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="351" y="2" width="126" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_PERIOD_"/>
<WidgetID widgetID="ae412ee3-c761-45b7-afbd-af33b5b4a915"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName="LABLE_PERIOD_"/>
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
<![CDATA[=i18n("period")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="84"/>
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
<WidgetName name="LABEL_TABLE1"/>
<WidgetID widgetID="5cf4066e-5c14-4e90-ba74-828b1a22ad0e"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName="LABEL_TABLE1"/>
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
<![CDATA[=i18n("analysis_indicator")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="84"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="600" y="45" width="330" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var P_PERIOD= _g().options.form.getWidgetByName("P_PERIOD_").getValue();
_g().options.form.getWidgetByName("P_PERIOD").setValue(P_PERIOD);
var P_TABLE= _g().options.form.getWidgetByName("P_TABLE_").getValue();
_g().options.form.getWidgetByName("P_TABLE").setValue(P_TABLE);
var P_COUNTRY= _g().options.form.getWidgetByName("P_COUNTRY_").getValue();
_g().options.form.getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="SUMMIT"/>
<WidgetID widgetID="26a80f7a-b0d0-4aba-aa84-ce38e1218caf"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=i18n("search_enter")]]></Text>
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
<BoundsAttr x="1735" y="65" width="120" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LAB_TITLE"/>
<WidgetID widgetID="190c96ac-fedf-4612-93a6-dcd634263137"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName=""/>
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
<![CDATA[=i18n("entity_level2")]]></Attributes>
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
<BoundsAttr x="65" y="45" width="300" height="80"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP00_c"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report2" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetName name="REP00_c"/>
<WidgetID widgetID="b68299a3-9ef3-440c-81fb-76b7d7153e10"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="PMingLiU" style="0" size="72"/>
<Position pos="0"/>
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
<![CDATA[381000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[723900,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
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
<StyleList/>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNTo#%8!"TZA:O:T=g3CAU,!*()4<]AXb;:\%t=[ea[[.n@P9:jp
;V\Qfa\5gfnfH:3$3T4hO#h$kH*&8;\D[!]A+sX$@uk$!Gt:Ke\FKP\&CCEh3Y;T?t8;Z?0;G
I(h/MUm87h-_ZHQd7_,;L;=5iVPWR#.jc4@O\YIqWmO3:D43AT*NcIY#UYJ`7.!Ln;asEVU+
QGF'-]A#h6\,Is4F/(Dk_gs.j19hNn&@Fe)10Dd>$!*sF!j"Du0oQE,F)M,@BLba`$DL"tNbT
Tb3i[=%l_rB3XeT&i[>nuBeN0^Q<9pL6;6<gJb/*V20l.oG"ZqP'l0@H;c7,Fn!!~
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
<BoundsAttr x="0" y="0" width="1860" height="110"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="30" width="1860" height="110"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP01_c_c_c_c_c_c"/>
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
<FRFont name="PMingLiU" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP01_c_c_c_c_c_c"/>
<WidgetID widgetID="ddfea19c-f955-44d4-a9f9-8a262f974d71"/>
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
<FRFont name="新細明體" style="0" size="72"/>
<Position pos="0"/>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNRq!FZHrTLen1WJ;<-[%]AZg*()4<]AXb;:pTO`1X5hM*bHB'rf5
`9:dkbD+WN/#Mc/SZaZ[:S21BR5'fXqsGH%2"u`4Y&N62&=F?p3N'Ff5)&#DgW4J,HT7R.7u
+8In3NZn1,>d/o1YQpA"da"FU/i2H:HoVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\o
VhD\oVhDTPchR)0j+e'DK,LmXag8a@3L^:+-'HbHirOuYW;m*'(E-6=pnI0JX-\F+F8bB`)L
.mE=eDn"L2cBo;LeKc(g^t232JneNBjW<:d'N;9bl)7l??B*n<BQGuXC6k#'BBbq<F@F#YNE
ei*^$4C.njei>$5!<<~
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
<BoundsAttr x="0" y="0" width="620" height="510"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="153" width="620" height="510"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP01_c_c_c"/>
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
<FRFont name="PMingLiU" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP01_c_c_c"/>
<WidgetID widgetID="ddfea19c-f955-44d4-a9f9-8a262f974d71"/>
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
<FRFont name="新細明體" style="0" size="72"/>
<Position pos="0"/>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNRq!FZHrTLen1WJ;<-[%]AZg*()4<]AXb;:pTO`1X5hM*bHB'rf5
`9:dkbD+WN/#Mc/SZaZ[:S21BR5'fXqsGH%2"u`4Y&N62&=F?p3N'Ff5)&#DgW4J,HT7R.7u
+8In3NZn1,>d/o1YQpA"da"FU/i2H:HoVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\o
VhD\oVhDTPchR)0j+e'DK,LmXag8a@3L^:+-'HbHirOuYW;m*'(E-6=pnI0JX-\F+F8bB`)L
.mE=eDn"L2cBo;LeKc(g^t232JneNBjW<:d'N;9bl)7l??B*n<BQGuXC6k#'BBbq<F@F#YNE
ei*^$4C.njei>$5!<<~
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
<BoundsAttr x="0" y="0" width="1860" height="375"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="676" width="1860" height="375"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP01_c_c_c_c_c_c_c"/>
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
<FRFont name="PMingLiU" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP01_c_c_c_c_c_c_c"/>
<WidgetID widgetID="ddfea19c-f955-44d4-a9f9-8a262f974d71"/>
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
<FRFont name="新細明體" style="0" size="72"/>
<Position pos="0"/>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNRq!FZHrTLen1WJ;<-[%]AZg*()4<]AXb;:pTO`1X5hM*bHB'rf5
`9:dkbD+WN/#Mc/SZaZ[:S21BR5'fXqsGH%2"u`4Y&N62&=F?p3N'Ff5)&#DgW4J,HT7R.7u
+8In3NZn1,>d/o1YQpA"da"FU/i2H:HoVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\o
VhD\oVhDTPchR)0j+e'DK,LmXag8a@3L^:+-'HbHirOuYW;m*'(E-6=pnI0JX-\F+F8bB`)L
.mE=eDn"L2cBo;LeKc(g^t232JneNBjW<:d'N;9bl)7l??B*n<BQGuXC6k#'BBbq<F@F#YNE
ei*^$4C.njei>$5!<<~
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
<BoundsAttr x="0" y="0" width="600" height="510"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="660" y="153" width="600" height="510"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP01_c_c_c_c_c"/>
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
<FRFont name="PMingLiU" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP01_c_c_c_c_c"/>
<WidgetID widgetID="ddfea19c-f955-44d4-a9f9-8a262f974d71"/>
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
<FRFont name="新細明體" style="0" size="72"/>
<Position pos="0"/>
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNRq!FZHrTLen1WJ;<-[%]AZg*()4<]AXb;:pTO`1X5hM*bHB'rf5
`9:dkbD+WN/#Mc/SZaZ[:S21BR5'fXqsGH%2"u`4Y&N62&=F?p3N'Ff5)&#DgW4J,HT7R.7u
+8In3NZn1,>d/o1YQpA"da"FU/i2H:HoVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\oVhD\o
VhD\oVhDTPchR)0j+e'DK,LmXag8a@3L^:+-'HbHirOuYW;m*'(E-6=pnI0JX-\F+F8bB`)L
.mE=eDn"L2cBo;LeKc(g^t232JneNBjW<:d'N;9bl)7l??B*n<BQGuXC6k#'BBbq<F@F#YNE
ei*^$4C.njei>$5!<<~
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
<BoundsAttr x="0" y="0" width="620" height="510"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1271" y="153" width="620" height="510"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="LAB_TITLE"/>
<Widget widgetName="SUMMIT"/>
<Widget widgetName="P_PERIOD"/>
<Widget widgetName="REP00_c"/>
<Widget widgetName="LABLE_PERIOD_"/>
<Widget widgetName="P_PERIOD_"/>
<Widget widgetName="LABEL_TABLE1"/>
<Widget widgetName="P_TABLE"/>
<Widget widgetName="P_TABLE_"/>
<Widget widgetName="report400"/>
<Widget widgetName="report0"/>
<Widget widgetName="chart0"/>
<Widget widgetName="report0_c"/>
<Widget widgetName="report0_c_c"/>
<Widget widgetName="chart2"/>
<Widget widgetName="chart1"/>
<Widget widgetName="LABLE_ANNOTATION1_c_c"/>
<Widget widgetName="P_COUNTRY"/>
<Widget widgetName="LABEL_COUNTRY"/>
<Widget widgetName="P_COUNTRY_"/>
<Widget widgetName="REP01_c_c_c_c_c_c"/>
<Widget widgetName="REP01_c_c_c_c_c_c_c"/>
<Widget widgetName="REP01_c_c_c_c_c"/>
<Widget widgetName="REP01_c_c_c"/>
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
<I18NMap class="com.fr.plugin.i18n.bundle.configurator.data.I18NAttrMark" pluginID="com.fr.plugin.i18n.bundle.v11" plugin-version="2.0.8.4">
<Attributes languageType="0" default="" backup="en_US"/>
<I18N key="col_pre_tax_income" description="欄位名稱">
<zh_TW>
<![CDATA[稅前損益]]></zh_TW>
<en_US>
<![CDATA[Profit Before Tax]]></en_US>
</I18N>
<I18N key="country" description="表格">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country]]></en_US>
</I18N>
<I18N key="col_ros" description="分析指標">
<zh_TW>
<![CDATA[營業淨利率(ROS)]]></zh_TW>
<en_US>
<![CDATA[Return On Sales]]></en_US>
</I18N>
<I18N key="search_enter" description="搜尋">
<zh_TW>
<![CDATA[搜尋]]></zh_TW>
<en_US>
<![CDATA[Search]]></en_US>
</I18N>
<I18N key="col_roa" description="分析指標">
<zh_TW>
<![CDATA[資產報酬率(ROA)]]></zh_TW>
<en_US>
<![CDATA[Return On Assets]]></en_US>
</I18N>
<I18N key="col_emp2" description="分析指標">
<zh_TW>
<![CDATA[人均利益]]></zh_TW>
<en_US>
<![CDATA[Per Capita Benefit]]></en_US>
</I18N>
<I18N key="col_emp1" description="分析指標">
<zh_TW>
<![CDATA[人均收入]]></zh_TW>
<en_US>
<![CDATA[Per Capita Income]]></en_US>
</I18N>
<I18N key="analysis_indicator" description="篩選">
<zh_TW>
<![CDATA[分析指標]]></zh_TW>
<en_US>
<![CDATA[Analysis Indicator]]></en_US>
</I18N>
<I18N key="col_roe" description="分析指標">
<zh_TW>
<![CDATA[股東權益報酬率(ROE)]]></zh_TW>
<en_US>
<![CDATA[Return On Equity]]></en_US>
</I18N>
<I18N key="col_tangible_asset" description="欄位名稱">
<zh_TW>
<![CDATA[有形資產]]></zh_TW>
<en_US>
<![CDATA[Tangible Assets]]></en_US>
</I18N>
<I18N key="etr_formula" description="註解">
<zh_TW>
<![CDATA[有效稅率(ETR)=應付所得稅/稅前損益 ]]></zh_TW>
<en_US>
<![CDATA[Effective tax rate (ETR) = Income Tax Accrued/Profit before tax]]></en_US>
</I18N>
<I18N key="ros_formula" description="註解">
<zh_TW>
<![CDATA[營業淨利率(ROS)=稅前損益/收入]]></zh_TW>
<en_US>
<![CDATA[Return on sales (ROS) = Profit before tax/Revenues]]></en_US>
</I18N>
<I18N key="period" description="篩選">
<zh_TW>
<![CDATA[期間]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N key="col_income" description="欄位名稱">
<zh_TW>
<![CDATA[收入]]></zh_TW>
<en_US>
<![CDATA[Revenues]]></en_US>
</I18N>
<I18N key="entity_level" description="按鍵">
<zh_TW>
<![CDATA[以公司級別顯示]]></zh_TW>
<en_US>
<![CDATA[Show at company level]]></en_US>
</I18N>
<I18N key="col_num_of_emp" description="欄位名稱">
<zh_TW>
<![CDATA[員工人數]]></zh_TW>
<en_US>
<![CDATA[Number of employees]]></en_US>
</I18N>
<I18N key="roa_formula" description="註解">
<zh_TW>
<![CDATA[資產報酬率(ROA)=稅前損益/有形資產 ]]></zh_TW>
<en_US>
<![CDATA[Return on assets (ROA) = Profit before tax/Tangible Assets]]></en_US>
</I18N>
<I18N key="col_paid_up_capital" description="欄位名稱">
<zh_TW>
<![CDATA[股東權益]]></zh_TW>
<en_US>
<![CDATA[Equity]]></en_US>
</I18N>
<I18N key="emp1_formula" description="註解">
<zh_TW>
<![CDATA[人均收入=收入/員工人數 ]]></zh_TW>
<en_US>
<![CDATA[Per capita income = Revenues/Number of employees]]></en_US>
</I18N>
<I18N key="roe_formula" description="註解">
<zh_TW>
<![CDATA[股東權益報酬率(ROE)=稅前損益/股東權益(即實收資本額與累計盈餘之合計)]]></zh_TW>
<en_US>
<![CDATA[Return on equity (ROE) = Profit before tax/Equity]]></en_US>
</I18N>
<I18N key="col_curr_tax_payable" description="欄位名稱">
<zh_TW>
<![CDATA[應付所得稅]]></zh_TW>
<en_US>
<![CDATA[Income Tax Accrued]]></en_US>
</I18N>
<I18N key="entity_level2" description="跳頁頁籤名稱">
<zh_TW>
<![CDATA[國別報告獲利貢獻分析-公司]]></zh_TW>
<en_US>
<![CDATA[CbCR Contribution Analysis at Company Level]]></en_US>
</I18N>
<I18N key="col_etr" description="分析指標">
<zh_TW>
<![CDATA[有效稅率(ETR)]]></zh_TW>
<en_US>
<![CDATA[Effective Tax Rate]]></en_US>
</I18N>
<I18N key="emp2_formula" description="註解">
<zh_TW>
<![CDATA[人均利益=稅前損益/員工人數 ]]></zh_TW>
<en_US>
<![CDATA[Per capita profit = Profit before tax/Number of employees]]></en_US>
</I18N>
<I18N key="country_id" description="篩選">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country]]></en_US>
</I18N>
<I18N key="entity" description="表格">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity]]></en_US>
</I18N>
</I18NMap>
<StrongestControlAttr class="com.fr.widgettheme.control.attr.WidgetDisplayEnhanceMarkAttr">
<StrongestControlAttr widgetEnhance="false"/>
</StrongestControlAttr>
<TemplateThemeAttrMark class="com.fr.base.iofile.attr.TemplateThemeAttrMark">
<TemplateThemeAttrMark name="相容主題" dark="false"/>
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
<StrategyConfigsAttr class="com.fr.esd.core.strategy.persistence.StrategyConfigsAttr">
<StrategyConfigs>
<StrategyConfig dsName="Dic_P" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Period" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="dic_table1_bk" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="ds1" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_ETR的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="表格" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_表頭" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_條形圖(前兩年度)" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Country_TW" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_Table1_值_輩分" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_條形圖(前年度)" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="dic_Period_bk" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_Table1_Vakue" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Table1_bk" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_表格圖的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Country" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Period的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Table1_max" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Entity的副本" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_條形圖(當年度)" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Table1" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Period_max" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_表格圖" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_圓餅圖(當年度)的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_條形圖(當年度)的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
</StrategyConfigs>
</StrategyConfigsAttr>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.32.0.20241202">
<TemplateCloudInfoAttrMark createTime="1651036965697"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="669fa05f-b01d-4866-b4e6-a190fdc72729"/>
</TemplateIdAttMark>
</Form>
