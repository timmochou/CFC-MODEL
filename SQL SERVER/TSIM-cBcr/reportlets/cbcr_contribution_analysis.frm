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
<TableData name="Dic_Country_TW" class="com.fr.data.impl.DBTableData">
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
WHERE T3.FR_LOCALE = '${fr_locale}'
AND T3.COUNTRY_CODE = 'TW']]></Query>
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
<![CDATA[2024-12]]></O>
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
),        
REPORT_SUMMARY AS (    
    SELECT    
        T1.PERIOD,    
        T3.COUNTRY_CODE,    
        T3.COUNTRY_NAME,    
        T1.DATA_NAME,    
        SUM(TRY_CAST(t1.value AS FLOAT)) AS VALUE    
    FROM TRS_FACT_COUNTRY_REPORT T1    
    LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID    
    LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID    
    JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID    
    WHERE REPORT_NAME = 'REPORT1'    
    AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')   
    AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'    
    GROUP BY T1.PERIOD, T3.COUNTRY_CODE, T3.COUNTRY_NAME, T1.DATA_NAME    
),      
TABLE1 AS (    
    SELECT    
        PERIOD,    
        COUNTRY_CODE,    
        COUNTRY_NAME,    
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
    FROM    
        REPORT_SUMMARY    
    PIVOT (    
        MAX(VALUE)    
        FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,    
                          [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,    
                          [col_tangible_asset]A)    
    ) AS pvt    
),
TABLE2 AS(
    SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_tangible_asset as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,  
    col_curr_tax_payable as numerator,
    col_pre_tax_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,  
    col_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1
)
,PERIOD_LST1 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
)
--SELECT * FROM PERIOD_LST1
,PERIOD_LST2 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,    
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
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
    T1.DATA_NAME,
    T1.VALUE,
    T1.numerator,
    T1.denominator
    FROM PERIOD_LST2 T1
)
,PERIOD_FINAL AS(
    SELECT
    PERIOD_1 AS PERIOD,
    PERIOD AS classification,
    COUNTRY_CODE,
    COUNTRY_NAME,
    DATA_NAME,
    ROUND(VALUE, 4) AS VALUE,
    numerator,
    denominator
    FROM PERIOD_CURRENT 
    WHERE denominator != 0
)  
, RANKED_DATA AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
DATA_NAME,
VALUE,
numerator,
denominator,
RANK() OVER (PARTITION BY classification, DATA_NAME ORDER BY VALUE DESC) AS RANK
FROM PERIOD_FINAL
)
,TABLE3 AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
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
COUNTRY_SORT_DATA AS (  
    SELECT DISTINCT
        COUNTRY_CODE,
        COUNTRY_NAME,  
        DENSE_RANK() OVER (ORDER BY COUNTRY_NAME ASC) AS COUNTRY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.COUNTRY_SORT 
FROM TABLE3 t1
LEFT JOIN COUNTRY_SORT_DATA t2 ON t1.COUNTRY_CODE = t2.COUNTRY_CODE
WHERE 1=1
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}  
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
ORDER BY classification ASC,
         VALUE DESC,
         COUNTRY_SORT ASC;
]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_條形圖(當年度)" class="com.fr.data.impl.DBTableData">
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
<![CDATA[]]></O>
</Parameter>
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
),        
REPORT_SUMMARY AS (    
    SELECT    
        T1.PERIOD,    
        T3.COUNTRY_CODE,    
        T3.COUNTRY_NAME,    
        T1.DATA_NAME,    
        SUM(TRY_CAST(t1.value AS FLOAT)) AS VALUE    
    FROM TRS_FACT_COUNTRY_REPORT T1    
    LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID    
    LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID    
    JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID    
    WHERE REPORT_NAME = 'REPORT1'    
    AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')   
    AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'    
    GROUP BY T1.PERIOD, T3.COUNTRY_CODE, T3.COUNTRY_NAME, T1.DATA_NAME    
),      
TABLE1 AS (    
    SELECT    
        PERIOD,    
        COUNTRY_CODE,    
        COUNTRY_NAME,    
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
    FROM    
        REPORT_SUMMARY    
    PIVOT (    
        MAX(VALUE)    
        FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,    
                          [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,    
                          [col_tangible_asset]A)    
    ) AS pvt    
),
TABLE2 AS(
    SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_tangible_asset as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,  
    col_curr_tax_payable as numerator,
    col_pre_tax_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,  
    col_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1
)
,PERIOD_LST1 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
)
--SELECT * FROM PERIOD_LST1
,PERIOD_LST2 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,    
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
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
    T1.DATA_NAME,
    T1.VALUE,
    T1.numerator,
    T1.denominator
    FROM PERIOD_LST2 T1
)
,PERIOD_FINAL AS(
    SELECT
    PERIOD_1 AS PERIOD,
    PERIOD AS classification,
    COUNTRY_CODE,
    COUNTRY_NAME,
    DATA_NAME,
    ROUND(VALUE, 4) AS VALUE,
    numerator,
    denominator
    FROM PERIOD_CURRENT 
    WHERE denominator != 0
)  
, RANKED_DATA AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
DATA_NAME,
VALUE,
numerator,
denominator,
RANK() OVER (PARTITION BY classification, DATA_NAME ORDER BY VALUE DESC) AS RANK
FROM PERIOD_FINAL
)
,TABLE3 AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
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
)  
,
COUNTRY_SORT_DATA AS (  
    SELECT DISTINCT
        COUNTRY_CODE,
        COUNTRY_NAME,  
        DENSE_RANK() OVER (ORDER BY COUNTRY_NAME ASC) AS COUNTRY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.COUNTRY_SORT 
FROM TABLE3 t1
LEFT JOIN COUNTRY_SORT_DATA t2 ON t1.COUNTRY_CODE = t2.COUNTRY_CODE
WHERE classification = '${P_PERIOD}'--視年度更改語法
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}  
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
ORDER BY classification ASC,
         VALUE DESC,
         COUNTRY_SORT ASC;
]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_條形圖(前年度)" class="com.fr.data.impl.DBTableData">
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
<![CDATA[]]></O>
</Parameter>
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
),        
REPORT_SUMMARY AS (    
    SELECT    
        T1.PERIOD,    
        T3.COUNTRY_CODE,    
        T3.COUNTRY_NAME,    
        T1.DATA_NAME,    
        SUM(TRY_CAST(t1.value AS FLOAT)) AS VALUE    
    FROM TRS_FACT_COUNTRY_REPORT T1    
    LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID    
    LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID    
    JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID    
    WHERE REPORT_NAME = 'REPORT1'    
    AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')   
    AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'    
    GROUP BY T1.PERIOD, T3.COUNTRY_CODE, T3.COUNTRY_NAME, T1.DATA_NAME    
),      
TABLE1 AS (    
    SELECT    
        PERIOD,    
        COUNTRY_CODE,    
        COUNTRY_NAME,    
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
    FROM    
        REPORT_SUMMARY    
    PIVOT (    
        MAX(VALUE)    
        FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,    
                          [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,    
                          [col_tangible_asset]A)    
    ) AS pvt    
),
TABLE2 AS(
    SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_tangible_asset as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,  
    col_curr_tax_payable as numerator,
    col_pre_tax_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,  
    col_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1
)
,PERIOD_LST1 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
)
--SELECT * FROM PERIOD_LST1
,PERIOD_LST2 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,    
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
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
    T1.DATA_NAME,
    T1.VALUE,
    T1.numerator,
    T1.denominator
    FROM PERIOD_LST2 T1
)
,PERIOD_FINAL AS(
    SELECT
    PERIOD_1 AS PERIOD,
    PERIOD AS classification,
    COUNTRY_CODE,
    COUNTRY_NAME,
    DATA_NAME,
    ROUND(VALUE, 4) AS VALUE,
    numerator,
    denominator
    FROM PERIOD_CURRENT 
    WHERE denominator != 0
)  
, RANKED_DATA AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
DATA_NAME,
VALUE,
numerator,
denominator,
RANK() OVER (PARTITION BY classification, DATA_NAME ORDER BY VALUE DESC) AS RANK
FROM PERIOD_FINAL
)
,TABLE3 AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
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
COUNTRY_SORT_DATA AS (  
    SELECT DISTINCT
        COUNTRY_CODE,
        COUNTRY_NAME,  
        DENSE_RANK() OVER (ORDER BY COUNTRY_NAME ASC) AS COUNTRY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.COUNTRY_SORT 
FROM TABLE3 t1
LEFT JOIN COUNTRY_SORT_DATA t2 ON t1.COUNTRY_CODE = t2.COUNTRY_CODE
WHERE classification = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))--視年度更改語法
--AND TOP5 != '-'
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}  
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
ORDER BY classification ASC,
         VALUE DESC,
         COUNTRY_SORT ASC;
]]></Query>
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
<![CDATA[]]></O>
</Parameter>
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
),        
REPORT_SUMMARY AS (    
    SELECT    
        T1.PERIOD,    
        T3.COUNTRY_CODE,    
        T3.COUNTRY_NAME,    
        T1.DATA_NAME,    
        SUM(TRY_CAST(t1.value AS FLOAT)) AS VALUE    
    FROM TRS_FACT_COUNTRY_REPORT T1    
    LEFT JOIN V_TRS_DIM_ENTITY T2 ON T1.ENTITY_ID = T2.ENTITY_ID    
    LEFT JOIN V_TRS_DIM_COUNTRY T3 ON T2.COUNTRY_ID = T3.COUNTRY_ID    
    JOIN auth T4 ON T1.ENTITY_ID = T4.ENT_ID    
    WHERE REPORT_NAME = 'REPORT1'    
    AND DATA_NAME in('col_income' ,'col_pre_tax_income', 'col_curr_tax_payable' ,'col_paid_up_capital' , 'col_accu_surplus', 'col_num_of_emp' ,'col_tangible_asset')   
    AND T2.FR_LOCALE = '${fr_locale}' AND T3.LANGUAGE = '${fr_locale}' AND T4.MODULE = 'App04'    
    GROUP BY T1.PERIOD, T3.COUNTRY_CODE, T3.COUNTRY_NAME, T1.DATA_NAME    
),      
TABLE1 AS (    
    SELECT    
        PERIOD,    
        COUNTRY_CODE,    
        COUNTRY_NAME,    
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
    FROM    
        REPORT_SUMMARY    
    PIVOT (    
        MAX(VALUE)    
        FOR DATA_NAME IN ([col_income]A, [col_pre_tax_income]A, [col_curr_tax_payable]A,    
                          [col_paid_up_capital]A, [col_accu_surplus]A, [col_num_of_emp]A,    
                          [col_tangible_asset]A)    
    ) AS pvt    
),
TABLE2 AS(
    SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_ros' AS DATA_NAME, ISNULL(col_ros, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roa' AS DATA_NAME, ISNULL(col_roa, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_tangible_asset as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_roe' AS DATA_NAME, ISNULL(col_roe, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_paid_up_capital + col_accu_surplus as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_etr' AS DATA_NAME, ISNULL(col_etr, 0) AS VALUE,  
    col_curr_tax_payable as numerator,
    col_pre_tax_income as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp1' AS DATA_NAME, ISNULL(col_emp1, 0) AS VALUE,  
    col_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1    
UNION ALL    
SELECT     
    PERIOD,    
    COUNTRY_CODE,    
    COUNTRY_NAME,    
    'col_emp2' AS DATA_NAME, ISNULL(col_emp2, 0) AS VALUE,  
    col_pre_tax_income as numerator,
    col_num_of_emp as denominator
FROM TABLE1
)
,PERIOD_LST1 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+1,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-1,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
)
--SELECT * FROM PERIOD_LST1
,PERIOD_LST2 AS (  --B  
    SELECT       
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_1,
    CONCAT(datepart(year, CONCAT(T1.PERIOD,'-01 '))+2,'-',FORMAT(datepart(month, CONCAT(T1.PERIOD,'-01 ')),'00')) AS PERIOD_2,    
    T1.*
    from TABLE2 T1
    WHERE T1.period = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))  --把前一年度公司清單找出來，但 PERIOD 改成當年度月份
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
    T1.DATA_NAME,
    T1.VALUE,
    T1.numerator,
    T1.denominator
    FROM PERIOD_LST2 T1
)
,PERIOD_FINAL AS(
    SELECT
    PERIOD_1 AS PERIOD,
    PERIOD AS classification,
    COUNTRY_CODE,
    COUNTRY_NAME,
    DATA_NAME,
    ROUND(VALUE, 4) AS VALUE,
    numerator,
    denominator
    FROM PERIOD_CURRENT 
    WHERE denominator != 0
)  
, RANKED_DATA AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
DATA_NAME,
VALUE,
numerator,
denominator,
RANK() OVER (PARTITION BY classification, DATA_NAME ORDER BY VALUE DESC) AS RANK
FROM PERIOD_FINAL
)
,TABLE3 AS (
SELECT
PERIOD,
classification,
COUNTRY_CODE,
COUNTRY_NAME,
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
COUNTRY_SORT_DATA AS (  
    SELECT DISTINCT
        COUNTRY_CODE,
        COUNTRY_NAME,  
        DENSE_RANK() OVER (ORDER BY COUNTRY_NAME ASC) AS COUNTRY_SORT  
    FROM TABLE3    
)  
SELECT 
t1.*,
t2.COUNTRY_SORT 
FROM TABLE3 t1
LEFT JOIN COUNTRY_SORT_DATA t2 ON t1.COUNTRY_CODE = t2.COUNTRY_CODE
WHERE classification = CONCAT(datepart(year, CONCAT('${P_PERIOD}','-01 '))-2,'-',FORMAT(datepart(month, CONCAT('${P_PERIOD}','-01 ')),'00'))--視年度更改語法
--AND TOP5 != '-'
${if(LEN(P_PERIOD)=0,"","AND PERIOD IN ('"+P_PERIOD+"')")}  
${if(LEN(P_TABLE)=0,"","AND DATA_NAME IN ('"+P_TABLE+"')")}
ORDER BY classification ASC,
         VALUE DESC,
         COUNTRY_SORT ASC;
]]></Query>
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
<![CDATA[setTimeout(() => {
	$("div[widgetname='REP00']A").css({
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
	})
}, 200)]]></Content>
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
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_COUNTRY_"/>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("Dic_Country_TW",1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="941" y="9" width="105" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {
        _g().parameterCommit();
    },
    1000);]]></Content>
</JavaScript>
</Listener>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("Dic_Country_TW",1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="780" y="2" width="105" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_ANNOTATION1_c"/>
<WidgetID widgetID="09c9774d-1ca0-4106-bd11-1f80523b2640"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABLE_ANNOTATION1_c"/>
<PrivilegeControl/>
<WidgetTheme class="com.fr.widgettheme.theme.widget.theme.LabelTheme">
<FollowingTheme styleSetting="true"/>
<FRFont name="宋体" style="0" size="96">
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
<BoundsAttr x="952" y="85" width="540" height="35"/>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<CategoryName value="COUNTRY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="a3707ad1-d3ab-4db4-88e6-82dfbf2e6701"/>
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
<HtmlLabel customText="function(){ return this.category+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<HtmlLabel customText="  " useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<CategoryName value="COUNTRY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="f3ed2067-8023-4770-8a81-626331bea236"/>
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
<FRFont name="微軟正黑體" style="1" size="128">
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
<![CDATA[m?[QL;tm`9UU;9L"c"Qo0iAbZJttX8R2+,J-qG@%KL%5CQQZcl!$Opf$FD#,X!S7?eD_4dO;
&8CR&D,u%KR/8J<6QP%=s0D+=&*DH.]Aj?epY<gJ)G@u3M3Y0rdNICSNWSCrP\d#k0GSC"+`_
,c^s\("pA,erUJRJEE-Ll`ASM8Z7J-(GN*Y_:K!5C]ADW(]ADrgSc:L*sUC[:^jXP;YpRC^Msq
"@/VQ;>4VZh<S>*FIYXNc+RFJ&]Ah'gh/p%rXZKgcQ<[DptFfYOc)LemdYo[1/=H&'bh@H12E
8p\M0VpC,iB&ZQ4&p\%6>>ED;_@[8DM:<`EHUR@9Nn,7s'$1HQ2i*q.eM=fO(lr)se70brf`
H8kP/:R1C>MtET]AAuJA&e0W)7b6^p3[;>qj<Bd&;4a$AV^+&79r`H0TJ'Y,Wr)7TI=n0P7rO
28p6r$DSg6)F*aC^onFeFnNGc2AD=91j9%Ku'@lMR*[_%CeEm*E0>KjBOp%$t3(#-0[@64]AO
]A+fl*7;f\PV3er]Afkm_!19g=2*k?j_JhM"j*Iur0<,4hq%Z&BQD5+toa#bX48iYkF/qk.+\2
#+s/gH"M7^$KS[NW18R:KDMUb*u\q3_bKkV\fq;;GS)$@LWZF\3[ot),TN8%T[-0f`=;5,uM
4S30?#knh,U,>Ula=c]AurmHZU<6oNRf4?"R9pT]AiG"79)dB)"Da67sZRpn[n/hbE&QeIUl^H
Z@*G%#'//g*IDq4#!?EWYfH*K>rW^%3sQqcH@H]A>+0fm6GSEi(]AYt;>e^I_k(#%?M6<W%eh$
t7=JtqrhN/FAsoM3@"PIj4A*!^?Wp]A'Iss7%nQ[>/Qb#'_O;`[ig_bFp9RR&?YAF1\J6D;<H
^i:J!]AEjP&9;PMMRhm9NYRm'AnKWg%bB'saAroU;+ST+kIarhQg]A#ji?M=CU1/$k4f>kZb:K
?V_:i2mRhO<')8+FT!MBpYRbfh(SZ+j7TP`G/H[A8#eG&2fTuC\C)LlJ;lup%d`Jea>(g#!T
d;\hLF]AR'1hCm%k\]A_NEA!Z\qt+[175<L$n=fo^0Y4oY!X_\78_OUPq\qel-oF&F$sg7@ec!
ESjigDQDpQs(,LB[!"?<5h=.S13h@n%g<+o5@n#?OqNLa@)':-i`<f7VlHM22(,M+f"8NR*B
N=iLED,UQcjWke3K(HK2SV@Xk`u8"P:Mba!r%]AKuZ3_Gd/!O;rp9o$W\I^;lT#P>2&]Ank"8C
,S"@qS7DNI9F;!kEop(uM?_,l@!mTm=@d6V.olY"DfJ`f6?Xt3Vp:pDN0[`dO]A!k?[IgIQ4l
GWcFdNrA0.ZY=!QH!iB,\i]AA"+N]A-#^$S[.>>h>>(j+4jM<)#.#Z=91ekYp2t:Bi&eb=[iZ&
VejYr)i4e&Kg-BuW3dO-Gd"hYC=%+f':1i)G6rWU063drCAL.BP[%j&"dq0gkaF2UF"L[nmK
3!&S]A!M\V8J,34l_.f\n4&$dNbFk'jNnnM'p=;p47RZjuT@OoaJnkn7qY[P?=p.:T%nLDC:E
WCgN5?YSMT,X:[#0LQKkJ\f("u0JMf_O-#G)E^Xi#ub-)\RZ,/OGb@Lb<;\A$B$m,U(/:TFq
k_F:1C;QLkk2Zs<Mo7_p_l8qT/4e2IR`02LgXIE2L)u(6D_8"UKRA5TQNm^`N,:@Jo'#t8N8
iFQUC.c[SF<tTj%WPhiDX1r6]A<&AJl!r+)f*LRJKC0E)&[&#/D<M):%,0=2p$@^hKk+Ap\`&
,DO)nSc.\FRpo;L!u6u<c"+&dV<qs4W%bO1FO%s4c`'g'e%GNDQ<k8ts]A0>_8#jWq/RW)C5l
iPqn$>_=P]A))FRD5Y.D*jHe,6_]AAt>r*A!PWa%@KAV_1uPbK%LV/ON7l!qR@\Qdje+\#KH3Z
1$Zb(s(C384:&UQC#JcA/gXA-e*KAANQM,eJ1B#TPciYgNbfZ+/VQ[QUmhq]AUIXe2#Kj"1UT
Rm?1*05j%=q.l)fee4lq`iB0eh(s$g,B!b4@jIQ=9AEeO9p29bsQ!:Gb*Z]A%7PW+u"eCtfEZ
GrnCWE=5)ot#C8b(CCs:-W![S,09H]AN)p>)_dds2cG1`6a/2sme;O9:]AgOaF`.Z;nmoJnVHb
3d.W?'p3EMNuE%:,.\9MiF2d>.5oiWk<T!r:?d20nX_iIi4Mc[!ubjN)PouUM%h'_6,=u:fL
)''-GYDtUh!S_d83VVN#07.E=,6d5[*YX3tGtq4,8/?tWk3h3##a&1ZAD)\?=F`e3CZo/d;i
%nB2f^\1B;t/a^3H73c283\+lG'50h+/mo1UImMA>>amfD='s-Fp0"A1d9o8ic<j-1G+\$5^
^Ym(sX?[kY!D1;i`C`%X,gOms,B]ADUO.->,P>+@qW_;I/Z,*^AB?8asKZuN<ArSp(`,t5!:<
N:J0gG2tKUqF!gKH'gZRW#N<!<AVBB:s/!=aqeDmQtR[n5e;7%<kuV[Q.&mi<7V,`MKT/!uV
?):pN_bUd;'uq>NYK6dB:`U2mgc(F;Gl3`TiS,[@hr=\)+V;^RuAa0N&sQNAnWn'2:^b-j5J
(7m"m?=kW,E6Ga@olsEa`$8]AC"piV&GG0ER80.'S/#!=)62;Xa220ZdKg9%9`^8dWWDt`=h7
>7[jG\@=-P]AZu;*T[jo:1;U&uj#J`EI@&NE#>l<rX^ANe!bKBd@5@rgo2"i<"l1ON[bIVDfU
sA^r@bc39B3?''nl;'pRrm0\ZXS7`1aQ`ZOSHdpM]A0gT0TmaJ_iE/^PCh.87pnBZ/Pp_JJIU
AG'BV(W*hXag`pR<$XRZfZ+jnd*JNdC\V2SW"92*uUO)XX_dX2$Q;_Xsa)Ga]AunU?'2KN*q3
u0U>:XjOKt>_#NOdqYh%JiX/(\]A&D$9ok2^8o./+q)4PW32,A0ZIolQtf&87mD`GEAH^@87e
ifN]Adc$TLXe&<5.R@R7<$-dG*-1?'Ki=]AnU5lq\#]A%]A*7!\:QKqdQka"Mb"^"dO4bAP]A4E'e
WBZ+s+^s21<!BC]A`CH#@1,1r\7H%4G8L&CWo!nl24D@+T4e4L:*E+$RAT[m#[L=_M6/[,<IK
g9es1G5+DB"l801P^?<,;f2r$P:?3'L^l%XXXWE7pr%RA'^Y8:Za"5q*7CUWZ8CHt]Ah5dL?M
DHVZHB7FK1Zq`p9YFgV1%dud`hfKEe7S!.:2Ir&%92R85^^dEIR9/V43=:(J/(=Z4dXKab<-
gEhRbkcZQcq[k(_Y8SDF_%o@q6J/Tda6V1U[nAX79%ge]A-pBJl/b\#XT!$`QCQ.:)F/V#9oh
LX02/S1/gVklE,-s2`:(E4djGbXXUQ9'=Q9e%EQ2&%,/9$qT%bflBRPd41m:W5UCm4Fh+7Gm
9jS:NASVH1PMjqSPbs8LcdW*X<d&HG8Q.gD<BUeqC9/R6_UH0n+n2@\mr4^\??P/b-J6fg0s
nY&Vf-kITGE/XQ5[j7h98)aE\8K!Z?h"5*<\<hAD;L^GGs&8BFQ6WjR0_p;%h.:_@2_*-D8\
5#L\"1$4a-eV5*(Q8.(82Eh\XmHbG'?!sBil60J%nltT&UCb*A;[b^cA0B??nHX<.;&I3hY8
ZO"nE#77Gma=T;:KP`EYh8WaA4$YV42/\6Y#]Ah5pQ%E;>]A7]A,hu<fqja\^<W=XY;W(ED%>HY
KXZY(p#;#h$Ba5EjO@@,H0UF%:3Z05`p$IEcJ@;RXEK7ubl[sl:?=&/DbGao]A6n[HXb`XROB
c)*A6UuT*=X*tYs8(tSanFE[%gEec<9k=KBo-#-pEtpQT'Dd]A&DDi_>7jo/n)K7a4/M$DoTG
-#J5WBNN"31bYc"6">L_4>u(YaUm:/PD(Yg:cK`2j[d%i#8I$)76KIEI0peSk%1C=RH%99[e
F$0+n]A7sjc;01*61)^+8FjR)[8<()i#T%;/2[OQAN,X,afjJJs'"fWJ,=:8>0u>@]AI&2;(s]A
;+%a/KQ`U-Djc,s+9pa*QWH>ZCOrSXm+K/VomMIhOWBC`Wsp&?pH]A;u@4#Dpm=.$KVubcl44
ctM*&e^,5cY_G$:@1@!S_]A%+1L,Jmq@0IVmF/el'I;:]ARof@FL^lROqOn1d~
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
<CategoryName value="COUNTRY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="adf60a03-8f6d-4447-a548-1d8c00eb5402"/>
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
<![CDATA[m?E)sdUsQ?^SPM0K&oUC+BVpXl^'ZU+4DL)c!2dReup$]A/5O?TME)A:^6gd-jA'Gr3E'I&ei
MutBbH;$JT7N<AL7>kDeO_4'G(?d#XeK%J+'$._fPS-4nncbm^`)Tq7N=qdIC^DY0J+N!s%6
tI5pd:!*C[Pg1saD,4Ld[QN=nX3BAqT"M&PB)Ya-"<@`_Xl$%cUZHTg$kssC0[0IoiIBU/`m
sXH/U"8a[J)p.b\nd)3f="pYD3&kslHDcn5+-`^=+.aNPJVBT417iQIr"lo4rf#5AW-bmKOo
t<-Ro5.4G$7-=e6pPo'*-H90c-?'m5fu!!!g5oP$SnXZc+-I3o8oga!aCf/GL!Vb1ZIO1I'7
(pobP`r;A/Zn8h,LbS1o?":qS""&'\#6=,3o_Ae+Cn,4m$37!Hce]A"fE;=eS61Wqjdt.QTJ,
'Z.+?7/A5$bs^H_VK=nlmYI"?-eTU;rF'T>Y,)_dhAE_lVAA3E9>n;?u6fB[f^U8TR@iU.^p
*10-P(eZ0J()c+LhMbCP"J<WaX;++U2gGH4)R5ME,HMd:8b=,9a_S#XXO_0'DC3ROU2%;i^c
.g9$'F$B%A&>U)1;"05>:G:c78f;'*W;K(fD0GEpTqU9M&+oS*U56j2H^kBOH5Z&YfA07/B&
b!I,0qcX?]AdVJL"%CQA,4VJuWEke`aV1!nTD<bX+3a/IMnZ5Y'+\E_UH]AT+lo\S6#i5e8EU-
n>SNQ4ou.9S0M&h_33Tq(In[W$8;@bkMb/X8:4R8C%hu[bSYaL;r/1aM.L]A'\p@4$e("'/)h
g]AJ6&4V?A$Da!]A<\u^S)SQh2%2/N*!uQF7CTjNlOq]A7du(PG@%DXCniY5l8X^<;j\ZT(p^+2
>2i<H'B;rr8.AYXb;8Ysqm32I>O"\ga<[!`8O$[DVB_/3l#+9#L!*N<Q-u4Z5ZJR@9lXPNH\
Wctb)E49i/TNVn&u&!J80K.^Pkdq^qO&/E>X*"E^23/.?skOLZ?hiQ8.DQHo*me"^1]A&p`.e
RkO<J\^PV>bL+LLCbn7?a*kIXs^&@RrZg\>B:jHQ9ea@h;7Mj02`9,)qGdpiYGW:b9k3s06;
60&E>;ao=sEi#"-TU(o^FrNO8Y!UNKb!5+(mHW5$[dM=H5Hj2Bq>F.2gY'Z=;^aB]A2D*K9s7
?m[BTtB39"Z:o_GcrPps#I'PHmAas8,k=D%HMUFeV]ATmD<D=8#:*.-IM1IZPDA%pP^2I<R#/
9lmc*qBZ*G:O2*6QbaTW9'J-g!rJ!3"+O$"ml-#P]A=2]A_X4I]Aie8s_cg4M+5%9ahMbl^ENL>
d1q$5b+$aO*(RA1B4Y&m5\F%di4BK+M/mt]AVp[EO6oL*c8500S2Eb'gQ.1VqLfA@7/-XI-Zk
A<M%Bntd?r\<aD<Xop>WDq^+Kg,7D#npOlLP#P.TZ"_83J-R2A%UbmaC^c:?s%@_rr<Gn`s=
oFtPBL`382QB<kbWeKQbJES1.bkFB7F5FUAs",/F:gk*5MFEmP\5pN62Sbu,kr'Jb.!cOUF:
l'XVl%]A3ZQ7W-2R^KL-a4rd@?.))UaSK*VNUDe>8XtiDA#ojegH\o</-k=4O0+$C-3"i4J"`
+fC]A<pkuQ!e4W#qV_j4_3Q,acRqG;8h9;f>#8RY9bbb8XY(caXZE&t=<fa45\\t*.-)a:p[X
1IY7`Z$$4Nk;Q$,62Oc:&qijD=.;RBQ:;:('aiTD7AVWQV6kE4AR)DDhJL;i0O+P^tVliE6Y
;""`S_NQ9096NnH-KB#j8**OB7!b`:@248-Et_cFQ]A)`5ou1mS6P'n,:JAA^]A<hEL~
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
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_ENTITY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("entity_level2")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_PERIOD]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_TABLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_TABLE]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD_"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_PERIOD_]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_TABLE_"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_TABLE_]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_COUNTRY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY_"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_COUNTRY_]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem(
{title:P_ENTITY, src:"${servletURL}?viewlet=App06/cbcr_contribution_analysis_entity.frm&P_PERIOD=" + P_PERIOD + "&P_TABLE=" + P_TABLE+ "&P_PERIOD_=" + P_PERIOD_ + "&P_TABLE_="
 + P_TABLE_ + "&P_COUNTRY=" + P_COUNTRY + "&P_COUNTRY_=" + P_COUNTRY_});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_ENTITY"/>
<WidgetID widgetID="4df7d4be-22e4-4501-85c4-bf2ef973c2cc"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="BTN_EDIT_c" frozen="false" index="-1" oldWidgetName="BTN_EDIT_c"/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("entity_level")]]></Text>
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
<BoundsAttr x="1635" y="65" width="220" height="40"/>
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
<![CDATA[17145000,4381500,9525000,9525000,9525000,4381500,9525000,9525000,9525000,4381500,9525000,4038600,9525000,9525000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("unit_twd")]]></Attributes>
</O>
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
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="6" r="0" s="0">
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
<C c="7" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="0" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="0" s="0">
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
<C c="11" r="0" s="0">
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
<C c="12" r="0" s="0">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="13" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="0" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" rs="2" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("country")]]></Attributes>
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
<C c="1" r="1" cs="4" s="4">
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
<C c="5" r="1" cs="4" s="4">
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
<C c="9" r="1" cs="5" s="4">
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
<C c="14" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="3">
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
<C c="2" r="2" s="5">
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
<C c="3" r="2" s="3">
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
<C c="4" r="2" s="3">
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
<C c="5" r="2" s="3">
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
<C c="6" r="2" s="5">
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
<C c="7" r="2" s="3">
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
<C c="8" r="2" s="3">
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
<C c="9" r="2" s="3">
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
<C c="10" r="2" s="5">
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
<C c="11" r="2" s="5">
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
<C c="12" r="2" s="3">
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
<C c="13" r="2" s="3">
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
<C c="14" r="2" s="2">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="COUNTRY_NAME"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions>
<customSequenceSortExpression sortRule="1" sortArea="TOP5" customSequence="1,2,3,4,5"/>
</sortExpressions>
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
<C c="1" r="3" s="6">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B4"/>
</cellSortAttr>
</Expand>
</C>
<C c="2" r="3" s="7">
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
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="3" r="3" s="8">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="D4"/>
</cellSortAttr>
</Expand>
</C>
<C c="4" r="3" s="8">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="E4"/>
</cellSortAttr>
</Expand>
</C>
<C c="5" r="3" s="6">
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
<sortHeader sortArea="F4"/>
</cellSortAttr>
</Expand>
</C>
<C c="6" r="3" s="7">
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
<sortHeader sortArea="G4"/>
</cellSortAttr>
</Expand>
</C>
<C c="7" r="3" s="8">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="H4"/>
</cellSortAttr>
</Expand>
</C>
<C c="8" r="3" s="8">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="I4"/>
</cellSortAttr>
</Expand>
</C>
<C c="9" r="3" s="6">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="J4"/>
</cellSortAttr>
</Expand>
</C>
<C c="10" r="3" s="7">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="K4"/>
</cellSortAttr>
</Expand>
</C>
<C c="11" r="3" s="9">
<O t="DSColumn">
<Attributes dsName="Rep_表格圖" columnName="COUNTRY_SORT"/>
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
<C c="12" r="3" s="8">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="M4"/>
</cellSortAttr>
</Expand>
</C>
<C c="13" r="3" s="8">
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
<Expand dir="0" leftParentDefault="false" left="A4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="N4"/>
</cellSortAttr>
</Expand>
</C>
<C c="14" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="2">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="10">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="2">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="6" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="10">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="10" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="4" s="2">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="13" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="4" s="2">
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
<Style imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微軟正黑體" style="0" size="84"/>
<Background name="NullBackground"/>
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
<![CDATA[m(?t5;d%TSb30,+!pZE[@_bT*WIjaT'a7HlMGg6C#:\(fW%&-(9o&iP+X.9A4%P?eM?.DmTp
%c7J,k.R:]Aa5V5+kigkPO]A=bl)t7&'R$qkFB6Z>46dp^"5H/YNT]Ajlo;5%K7eeHqr7Ee*$!a
j*#r2?r5K&',^7f:`kh119DeY?l[C9=6ecquhRFpJptIOXHb$Vf,K.&]A4?3=e_\)4qo/5MtM
R1P13+L)),Cem^]ACP:`_0.E54^mJ+$;]AduIuZKr\8U9XVrkasf-"k5?4IXN?^Yt\"o=Y)$,J
)Y2nGDM"3jsmD7&r\mMjt@Hl//5HF5riKTuTs*@K#"O+5K%%ZH''B+oa-/)tn/;QEL(a10;p
6sN,`H)]As6D_^\^R\n/sO=i2*^-u>k4.NYsTbJ0#$U)*c(+?:eIVsT#+?6klTZ+mjEN/&[['
6_44*l>F0Biri4QD4<:hpMe0!r3pqFfM0P/G,-cisAK<!5DM[rR2VLk.eK?n*eM>Pa\Q>mIo
046@WPMMUl5$iYSOe$E*4\=,FkUP%VdRg\Zli<il,Y?H5,I^ju2!XEES0ta5#c]AUc"<"2hs#
[GWhH:KdQSqZ<AXH0@Onu*fdepICJZ,?,`TY2CT;]A6U2onS,^eHHGOrck73g%<YY*,d/<"_.
2@#8pR@]A<0&^0[HX\:i#AP?I>E4SMR'*#E?t<0?bZ;_3nT!NJ?@%FH_fo8ZOFUZBTSugT3Y'
f\);]A]A*FI^:_1!(nuU[Hd9N'Xb6cJDs4P"oo8uT3+tt$t5NEaKrVj>)-ok0ml&.=\f]A^M2Ba
8K`57Lut!:'7m4n'bF"cm+EFk$G;pR9^M89!]A3?L_Z`S+\\0-2]ASX\/b.:j1kT+&N1OVD.4/
)GG'Z<ZHkhZ\F<9V-W[^&[X=aN&hf\YUE7?UA1rFtD6(dA\W-#aI7"r)p_*s<)VGk2ZID:.S
0Fs)0WT'3rp=@/nl06/)hP]ACpMUl6*lqh!8*lRMg_fcW[ZH*5_-Jd@oUh^*hcm\<X%b2,.Z-
gK`+$A_Q$T5Wldig.i=thr.m:qB$>PoC.CJT-["ZmsG2qQNK2cs10#[V"/]A=rknc?5-^i:I*
:D6[&jDO2WWbh3F>.eU.m34^+"$Sm1fTXHD@\`$RbiCn[\"b[Xe8Pi>ipPJY`Og?ID81_;o*
:TgACQ7XNc%&L`^!mf#IYE,DVDfb"DpR"+ohGnSS]A6j(l&%]ASh.F,N4b$VIs-ZQP$3p7<t!a
sAKE4W6`(&cnO.f6RM%F'EsUC]ASSk(?G5U]AAPH*@N64@%03fX$T'FjNo#X)[A=LdVin"QRAS
`LBabm/gtH8J@o0]A]A.Xq#1U7s5A:YK%_N#<PcC2A+03b<>Y3D:3G(L"bEJ9TtE<kaPiSaE9g
;gaS8nX)eS%QPE;3t5OFojd&\\W]A%D71WckYHWGp"UZ`D2)m&$b//cG83&MN=nW4&l_AD,R3
juN.Kpo.#HY[NZo[CL%\-cUqG>&b]Ap5;ScI]AR1f2W%OUO=4Rp+IeW30s(FDMMUf*<_CCOu0L
2V^-Fr2=cEqBR@bqtMQ3c`>oK>9E^oF4,>Eu9^R(\u=gdH#`4\0KS_BnRCVoJ<>Oec7^%o"q
G1$\b1GSC?F[)H]A+WXeT("tn\UhQtF)MccGtEEE)0mT/;ZomhoVCH0?2gFd,*8;CmLD5r'nF
`tOj`85Xf_[(]A?Q3k2AAp#Cmr1f"g\O"u&RpIPf2?)>WAjMtbI<Ku?UHJ#FKGa[20V)oo<QC
mnbgfqOKO!"T>V3(HG;SMaj&Nq@p"=8%/rR6]Aj1H6V(C3OeN>\g#T@"E`+K`W2eP9C:]A[:a:
r1A4jXlb:t4!&J!!b&V.fXl@4YJc!_7TDWWK,B)M0W3s4r;*h)j9ei,OL=52=kWBS\+9-Grs
9@9_Vp>#6%aA"LJ1P^_kPhpC'q#PM4CE3n`$qQE"2ih!\T0P@_YP:'.6g73ahM]A'W+7=&onM
Qon1Ll'p%NZcS;RY-k38C7RV2Z[Hb'T8T!RW>(1P]ANc'j(9RWnS6FYIl*Pq(IhPTpfXl%i<:
@<d)><st@#@O-'3k+p`)dmNl*C@?(.>N@=D't<EFGfO'H'VjK=0'0Jk[&HQ;qP[/K^gR]A:5^
d"'%qOfq<"ulcZR$]A,-AE&Eh0><6EahOqenkLX!$RLXB/V+Bj['"(/PJ^5h=?iCKPtmSl-FX
jnenD6VHF<d1Gd+_-]A0o2k>R*;>9YmCYcN6]Abt<!.0,;hPf*KNrrq>W?1l7N/KA+&VrUU8_f
[]AVFR7*N=dQ@Y6oc%b_Hti0YsYSMD,$SfllS!_JK:pHi3I,D^R3#+"*dqP0?^LbcUV/#_("i
o5Y:HQKN-c"Fqa]A::4C=#=&`a&DAC5Whpt?`@Z=rh*!\\sn?[28rYL>h'DBaSal"M9:2mkfp
ob8EEZ]A5ZJFOM*P@3?f2bk'uEI0VPUL&H"-!2HU1JoOaoTZ1F372rcQ'bd>)IF(J_M5:n!*D
f$g[7hM$&md9a%2ih;#GdkgC%dkjEoVTi)ur]AQDJajYY"J'QJh4g>dfSlV1'"J71Q)=\ol[4
;k:Km=iM2cf^5Tn=E1%^hce"LfR(%X-N-G]AHbTm;DDfe-rsb`hTpr\_C69U*.4b)f<1:G1/P
T8-Zu*ptb'U-s>J+$MH^8NtZP.0*&D"G18]AigM3Z%Y7BEOms\'3H6&mEM'VAV5@6MhJH<+5W
F#*6LXl9Jd9W(u>7j`8!nl8=jgH9jPG`IBqLieBm\5`WqbpP5pNa4pf<k#>J3YHjqZ\.@=\8
kW^QA.TKjU2IXDDJI+kU9XZH_=1N:X)!4(AQ>j$]AV`Et$0m/qU1`c!A*12:nf5ju+%EB&:Af
mGIp<*^b[*PBrf[F5-ZWI3NXl"`iVSffrVnhQcSm?L/Adhds-9?Nr8@!Mro2ih^Cl!*PN`Tn
3SMHH6c">IF<7(jg=?&%^_c6NNag1j'8Mu:&BA\#ZQ&fbTX5c1WR;F=#(JJEeXm)E^5ON?p=
G?`YJ>."b3B`*S#tki?TC(mKjCN83:>(7E,Gi/@_JT=H/t&ain_Jfi>j-r^qk#&feF1'ebb9
IM1Efj]AK!u$b:EF:5aUor#C]AMLMC2^P]A&D_VU>)A:l-Q1gqJhXGC:j\-G$2#*Y@Cq"`os3&1
T"'H69<K:oMP3ATD%50W\jCdctloW9*=VYnWN$+3`pM^#eAppZT&GVL%OS(IarNuTPVYWVF4
e,!",b.b8TYZ(s4S^gI2p+<g0:h$-gm'g(<Vd@N]AUIJG@A:ZA!ee3#!TU>i\91lid9uX#IR[
5?*/Cq0UCeP!f>anL:NpD';nB;`rJDhCh(h3@]AeLejhD1a-L`3TXd<k7^J$"4spebB4;=X8I
YX9+k=Ln#4P91M*mc(qI80]AirI/=22pu,G]AEsWJPl?P4Bplm(2G+FW>q[X7=cPNaY8s$42=r
>NBsAkONf5@Ga6:?k"CdUV+t[@=JI'V`>A*J2s7h2)Q4<&I-Nd7nlls3SHp*_DC!r5[VSDtQ
g@UH/!"F'*L9Q>bpfSa!`TSgRS4+(Gr!%2OIT[Kmq^_[khEF0mnV\nO@P>/>91If<"tFGRUc
W55_!LpX"BrXnI*B16!%dP_OHVp8=(h3WEl$!3<_*XCcHs.=3c:J@.r!qBE;/l>Fn"#iOQrs
7o3_p@Zn68\N$l)eN$s5qkWkg:s19FOdDC1*3do5YZ=UUU\nB1[IT2Y$.NcocN1_eDjR;<1p
3sE&D5aVGgT+e50/@rPFITp9_t@NVZLa9=2nma$b/G3Z4/'m;m]A,QrUER?Du[Jf8F&,bR*YG
#-`Z6CkAp!%@Rpe'eJgJ+d'Kh@"+E6^`%m/*NG#@jL`Q-@:\&QiX1S4u1,4O6/uO5l-HddZ)
]A.E@J03X5R0#aH(/tpV8tEtU:D;/m5.?a>oNAsG?hWgEPMM#-o=Up/+"03EDQI+@Fu]AfYmZN
+q:#BZs^+qW`KiWuuN[-[KjMeY7NXDaW\U]A,kl.?E@Y.7?>1$T0;H@@c#1h\&L108n=arj11
9R?0_IT)LKO76J;^YsQZ4WX>aO+oAQm)jVMH(PR.8,?I:*W*);%s(PEEP.Su20O;Q^4CZ]AgW
jVGH&F,n0PoK7oF4IU[#nE#3RK0W]A5E%%.RmgF`BC`L^Lp(V/UAD4khld._h\q45iHOYA,,J
,.VhoiEI]AoF[l0R/*$l]Aj$fY`f[r!7t,sJGl3[%qbYo55N!4$uIMus[%LmC$&rA5'F(Q5u)^
-S0n)_lgrBX%[.*jR[XEi2ocD.\_u#mk=0jl/6uknFJQIKAErc1$3$V(h910%fN5/bOIDPUN
0&c5-n"87-)/Y-;.C\9EooiRBU4I@eVL8?#$i>'cBO^e>!8(nf,H!LO@YnTT-H/-bi@T&7Ba
a)(/6E-L?uSnPjKhS#)/X*FU$35F<[nS?%cF^nWE<o-&-4lH4k@u`CD^WN@*Yh-I1hK#LKmE
.VE[&@9qGKC_NLgCo)nuGn2:U!Lr;NnRO_X55E]Aof?//JCKm6XC3</9!,3Uc]A=GJUYj@pCEd
),&qBcdis:OeZDS?Io:lrGat72#RAZ,GH9*.>RrYWiopG9ghc`A\Q6Meg-clK63??4O+_IbK
j`)=:sDJ</;56c"!:I"&15(0og%W#HdSbih%:OMRG7Q1be73@\p&<b(S"eqL`F(V0KL&X4Oi
1X=I*q32W2[W+(1&$c7/<ea`i6k[foWmn!bJG%>u0b<lprH=0jr]ACK)4PD(&@'/=`$o2lSe'
(`]A<ZA5(V9]AMOA[]Ahn'2#$d:Qr&:une#2h*r6+LnEP@3Xl9V2WH[27^d>:#L\$If`B"RjaV4
Hjd&]A85r;D.CsYC0f\6E0LL5?Nb(IQ8A#_$%X2(^;qb>teP,an4Jca$`Z*+_Uc;+%-5q4M9N
;Y]A2L#S.ZT$XM,O1%9gmmSopJ1,,BFH+%AYG(pXGi%^5<\A_q^sX54IiiH<1k!-qi9C3[ZQB
.;RU)[Hn3D`Zi0[U.g0_+94,+JNQ,R\DY/@LL4^nU<"P"!sg,ZX%Q6_h*D<<ZI%M09I:AqcV
8h=$C5f6#DoC;K6DD<fj=dq&Zds#YFMT2;`Z'@tN'Me9FN(.93eL>H-j;/N]A;H9U/c5A&e\7
eYsWnl=Om`gH..!G6?=b"1MhD(&AGbB'NUGrjm4#,u<rp0HHa%kr8/E$7#p,jL_hQ%hElY!F
%bH<E%>C?L=pbS0&YpY[0Idci68C)R==!fVLLL+B)6HNIH;M-Bo,4;SLa4FS_[gWcQq9pUkd
S0Ft<Nc$fKGpnqDi<<ON;>4LlGZB9s6Ko1/taK4(QZQDq!ErU93">25bS;qF1`k=N\]A<`UPY
g%kR!:k!o9:gB5lOUn'YX,6oI*3#C4<H[/M\S?#/th-77PBU[XEls8;k26/?FPGY&^qf`%hs
grX43fP'pIJVU<e.)Id]Adb"?GBmT7-hq*<:%]AO%%?5lr!kR;4nZG-RnNF)r'/NqVdWK=[V[n
Z_aU^C['B3E?9Q<9HY(2#=A?B.ViT0Iud5^;0ChB?[%tYNk$u)hloc7'^K`5_74W<p*)rk(F
WqWqBM.fQs5`MKUkcda;(T@Wb8uue.Pa)4[*\;+'YMu69IL"1V2EoZTdq835n%:Cl/Jg3tC9
,Pmmh\mnUBc,/c'gfB0W<V9NW\4nsd9AaO=\Oj&*3HdB&k[rSjfr9Z0r6hOs:.WYY!a)Eo`L
J2C1?)3ecVfZ+G9oN8=]A(tk^gI%eM:BK2ZLpat%\*;;h-kjC4Y!i6p*+):H*In9g:1&O<+m$
oUXj5?:GS*mUmB53m:q'D)E1H6ea-jL"n7qJ9((FJ%HtOqJX&[LjeY>Lph>=0*+h*@0;CeWR
l(a\!a0qf;>L*@YS!,Dhe5OK\2<nU0PnSf%T\Kk^`mIsihuLfPk1BI-a>autoPuK0AJ\M.Li
r$<nPp.82f!n)iU3V\Y@&a:*]Aq*"5PlV@pN1Gs]A??ei$b(F5!aP!IMfQl07>-<8?DLVY`;hN
N]A1%6k+`rBZ+PN[ijuN8('CY.:TPU)4EUVK0S5FatS6k^S>MpL'7Q<lHD)fa@@,XE3Ti1k#I
!_Y=a5R:P]A*8sKm2!LY:Atda8@e,D<glS7K1&[)\IiOS]AC8rO#?f0d0*Cf`57<%coua\QC,F
"%lDmPm3:if3-,>q9i0sSl6&XtO]A$MEuG<@<RADPBu*QOljm$(m>!jlFjS4eo6hCim?qE>[2
DD-N4/gDPc6Li;u\.hqhQU,g`.R6pCU>#12=#_qIX^SSr;FSm'IX&:5L,A39k8k'NfkL8JFn
Y$98e@X>*u-S14>5)dCD;SU?9X!!J&N<*K>n<KbIYJ(h@F^E3)Nl[DYAO/Yel2AhUJ[UcEgG
N_%(LgSPh?4YYm_lQ!=^KXae>2VG?oRpYmeB"e]A1o1DAGCC^91ejY-f`JQMJ[&A[Inp=NlOJ
e29p?YMphqc^3c@Y1eq)MM>'9Sg2a/A1Z?aV^[pIPMK+V6F*e!/jkhN-d?J+7kA14EW^0YFl
('<5a\*6SH<n*]A@34=&!8a5<e3sYL5u2"Fq^>"7Ef[d?:"2.=tCbF/tliX;5lkC2Eu2Ylg7U
A:_LB)8#aq+V'5H/FpQ"@sH'T@dr5GQ^V0WL/4Zbr!M1Jo(B8h`QT<t.n87h*;p.T5!5p]A\g
<^V5g3Z-IC3%6TP*NHTWFXn@Ot9(dV*>UXQm!4S)cpjan/BMR]Al<WO_n)\$5$5uDs^*;5AV:
[,[2&JnRoATZT\*T'PaOf]A8=,f69U`,#9q@rpTaq)XTeXFES$p*;""ka4h&8K[Y@I>4,'Dh!
K/RXs+H^G?AKG4CFfZ-DrC"OU#HR$1bT&@FRch+%dR`2;j=rS3qX)"X$`-0T#ERH2-Fk,?'o
18i&7P@JFddAr?Pr+UK5q7DP96.$%kD[UK[#6YHtnRbFES9Y5U[/hT0/+Rt=n<5S,a+]A5Pu<
J5"J6'aCb[QI_d<3I?VbL>92o.Z[(JL]A393a;"2r`<[StI#;.:6'CK_k+H9o-/D>m)\!)6R8
k%",Q%6fr6e-\^ScG.RoUc)3J#-D`_#%;De3u-,,)gnqCnJ;5tFne%/GIje!Ufii.AEn2cX*
Hf.WV>C[*Ge=u54['DTq\'HiP-2(4pPg'hBC\pB5Y%r<20'Qc,&0M)L8fC;`^X3H!)46tIP.
/OnX3VcZ&9o<eq4k\%j,D9XUX\Y!EQ5NkSg/3NW<Y^M;"qloKMp/;$J)S-1Cc>hJ%g.%K%c,
WW:nl`AKAYT@S`05J"ZRsM9<Y#uRN3IXU'+Rr5P"%\CK%(o:g(t$6sfqj2B3ll#S*XC.dH*k
!5\3BOh6T(FXOo;5cZNGCZ'cnZ!aT_&6RIGLaITO=KV]A'p1-CLQf%mcPn%Xo4BB))bm2:t^d
6k9ITQXoc_e?[eE0*\[LiLGNWFYG$5Q3UPd,"M[\jd8?J%_6!j%jR"g+4JSV(N,'6+Ef8D.,
SP[>IF=V1-Tmrj8^$2GSAiYu"sDe/^q8Rr^R6KS+3*#r"g+YF-:/MFKV,ot#V]A!]A6.(;S)/N
]AU_bef5tGLe%1pVd\^-'#'Q:nnSU&<9$8d+NTJ(V("f?)g#E*Yk!_$:=hU2X/),JRCLG'g>t
]A9"4NeFnjD9)@l:XEB(Hjoo`u3j@@XiQ<GB4U4X&D[hk;?J=U.J(4/J:1ArTolhj(;s%g>ug
J6"XkOl%7S_Y&pT_@fbf).Y"C2Bsbc-[GHP`G.k1ZItj8VG$gc&GKFkZ4[/'qIS*t'BGGu.f
Lm4[ePA]A>,lG[Wse]AS@!YRl#&8R[&WK;uiQV[,m`N&mnc;=GU0AGrA:g/KM0Zgfmf5MmJZ2!
X2U^^li5_6"74uBTUHn:p5Tn8Ch27;MCR2%;pJO*2,7UX!3&?BP_Fmm1rX?bM"O'&bLi-d:/
T]AKK?eBi`D%$rqk5&Dar:Bn_bt-P-W?A+EeZNX8=TDE*<dhd"bjY>&/*R)):-e$`His]A`%Z\
W^U"\HTM-Yp!kt?8pZ;Fh39>h6H/!nfLn*R]AH-1"cI'%oRA:9BDKOgarW\*9(N1YVc5)kR1^
L-lk3S;77s]An+Fd3TI2mrft"IMMqX),68kA2&lm5[k\QMakeu\o>r_T7<S(4gL2-7N?>E#45
-u_Qg3&BkVTIiTWSBMceT&uRJAJXY6[-]AlMh9V&RNimV>^'sMk0_@qkYiA<.S#a2a%sE_gHe
AY7?`FHT[H(/;#GjVdnIOdQ?"d^e1(P$8QLQopg:$?s7Rfp7\'#*HO@Y2=\POoK8K.fQHk0q
<4[2nIc!DH@@';.G%P;]AsG36TA.Yo"!3$uC.SR8CI!X#Fo[TuH]A@_-i\r4>0qSTtq7rmT*5"
$^Z7KUT/$SLoL>hcuo)b]AlTmIep;3(':P-MVe"YrA]ArUt>7<]ABJe5l&t8Ln_3K?Nl%$'1jgN
"a,dgq6fo4l'#ee-f39SfEi_\MC'?nEeF_?6Zc'hSMChT!IrM#GDbGQ7&qps_hDm@>h@HK&L
l,;3LMtIrS?G9e^T(EmAeaPDU=a,NY+:5,m&:!0W`*pbWXs>N=Z+DDbC]A80)lA*ISMDjIq6>
8(Z\/e?(T-hRXF?[jO;#!.gZ"F"X</>"Z;kn<rab>p#(]AfV#&9(EeCQG/9L`/TaQ-sK"F&%%
:gM+%[pHQ1:qV$\D,@e8cV.p6m1Xs;o<go,Wb>kR!uA4>M/=[:G\oXB%c.+c`^Zq>"At-$[2
+jH1G;/jG_H3S*Ui8G-J#Y@tG11ppm^/<b#Xr06>$8pNAN;TgO%'.k38#e'XIt7M"?@?gS&=
q5P4s\WX+&PP4&lR60:jmV1#Q0fB5phdZR&YkLBYr5j6JlFEo7L3FWaIVpY^OFcpXI3iPM[s
*Td!YF!LXUdrHFL#,9P@$oaYDTh&^t0S)b:#WFciC*RApHg8WoKp,e^qj5gNR*,Q,\Fa-Nl&
e?mVuIK(LnjB_Jnk2L;onl$_;:/>W'qQ!+1+qH"I,T/kqpKINFfHfC='UZIJ8PC01(kaoOsd
bQlA`XWtlLN.g!P=!U4%W'@*_K6V;7L9:qk;))O9oaOtp,]A'@`<!>I7ffiW-1O354\!JDPX2
sp?ekF6UXB@Y^n1Qh2?%g]APcir@mXeh,<+kdkZOK*.TBmI4+]A[_"OT`euCs42&rD^,V\"4]Ag
<rdD>[Uf:4#_"21eO>Ym.RX_$FL$99SL=u^S04d]A=Zo]Ar0p5-t_D.MK62t,Z1CeHS<\d7IEn
Lm3C3^3?3Vf$$`D*KiQN<[\bRP!SDmca9^M1h+:'r%iG6_=$Lu$.Yd*0Abp^(]AeQc!N7]A@C1
&pGV_,B`oFKNXMQ?iNbVV0?)eeWY?GB26GTJo;hF2S41R8QZCq]A\Y]AP.Q)t;\Y&Mg(o/Acho
'fE#@8t"lJn%m\l^m6G^#Q0i/l(0qNVDs:gLK0;UNi"Vau;-\RJK_&qB,<sS>"5IqFn>lBsD
0JeZ./4>?1=+d)(;HPWdgDDl=;Ykc^d5TkZMm^mZn.&[aNb*[@-??AFu]A[tOoZYdkP?+g7eh
X1(M/(V6BLT]A:$Lr?qs3*'?W\_M.sG1=T58?Q_[el,PD&c7Ll1kXR.PJ(-WdDgEu%'H>3R-K
V^2#+>i7-PqIa!kpmRb@B%#4E`RYc4i,SWhf/@UYSf^Iqt?#S_`N-N8nO5]A<I!qMreX+*%V'
?Qi!9.RT9I'Kt?#RTHL$nPe5L_jpeq6>[\3PH<0Xh[uPsX;Trq5+f:f@e]A&oMXBtN=rp/=7e
[5q#clAg@Dm+<YfL(+Gajjkh%hO,KI26kTZ2^8;29>AeXO@D\7[$rjb\HZKmea]AFTlu.kO@?
TG7eQA1@M193i1Bb[+LZeAM$,&.#e@CEeFB:O!TVLcP$5smrk(u(bo,1nrK-KB94"$[B:IWG
FipmeC9s.W*rE!SgNDk0j$f6545^'cP@0LnXR?CPT[&5DPBSrbd4`a^+"6FIoc,"shV^;;8o
'-B_j(UH+gk6P^8ki?V&LTRn(nA1eL:@!<kt8[<@Ri_/VPi+p\;m&jc>+5[BDp)\#Ud''V0M
M!?u-WR`KSd9A"DYo0RP4)R\n3Z+*(g*F)nQMLgEKHNg=L^1FF4Goe.-S3Yk`,PmBhTn*D"R
.@+5=9L7(ZMj9#]A;q01/VI>);+1tAfIju[MFBre#+%lR7i@qBXa4gH(BrT/bHstT>W:nM8dK
5*W-\,=guUNIMBR72_#K:i16Qq=fnKf*Oip#Q*I=E2F=XE*iQYOI6<Y-,A2i"fe/^m&-h!\6
0C`9ADYsCm@m!T5M1OR[Y]A#:mM7PL:^__\a:PNb-r'?sXX*@eeJqtbfDr3aOf:q.`Y$.FFGX
b5/=9GG,dD)^h!MNLHW_?$43]AW[4'$Vg[/k6H>"jLl`<B6kf.+FO5SX,e4>jf/`DUN:B2YTd
8E=jGqS-;dVNI#XD`CZD"n]AOu)%lAFeUn4I(.=`E"1G8Bt/b>HWS1S(4GC`-.YS6W)&t5<MU
&-1t&bL^TBNka+8F"B`dq^83b$ko((=Ej.IM`(4D\3X+0Q>+Pn&B^>]A>OG\+\bQL+L:'n7NV
&Q+f^+8ZJg073#6$#n]A-+lXP@eWhGK(s'r:O)kmZJ&L3R>+cK8n6RsOYAOS+=#C:A_]A+tY2V
hB:46PRs?LFn3FFWNToMO.KmC\<H7?+3a,,Qg9ruMlaSSWaZ;5VAuD#i2%,45s!O+S2-:EIt
iAO_=YU+cB,QZ:hb>t8@,559M*VD;SUbqImMLH+%MsF>b=d/<li-HD4dF#lZ)lj;G/a)$!69
b=R\F>+Cah86-#GmBR'2c<T[cRdEf>mGZ/;'k!l,gBVb!G<Ya.0nu'6c>*:E4LK(8C\3>Z[2
[PiK8pfjGBT*N862bi2Rnj3V9^hW,:i6i`IY^)N5#>;9;DJ@NNX$`*]AO&(s;&:ojf(4\nW#f
)3_q7uuq21H;e!gO6;S.1mACqs^0njo6KKLGE+sf/Y[U2gTp>'ES$aRjDZ9c8VR<:mmJ_ML@
KHc&<8u^(#.1Qt#\OnSQVnJqqX^ia@]AlGWQ;IqTjS-hu;76F6NI6eNc%/oh)'W`h0k\@WH"^
';AQ'5<+We9l,<rWoRrF:E%L\fC_[dhPN)Q+!4A^\e595%obs/?;uDq;Y5*P]Ap#Fkg">aVTS
_\gI0s&)6.-q_%B-T?akYU3:!KV,cM"EtW$nUc'b^E5kAce<No+'uE(>ebSsgUFm/SmS_FKK
PhUW42[9"^&gt]Aj)Z,QPoKPL1oL0-kF@VJce)7!pGZse7'_0>)/B(p:p&KnR.Y8=UeM^WK=U
V[0k5Kb?Rc=??$r"H]A,.HoB0=_2`W?suqmV0U!J@skTO=FS"3YX.q#/AhdOd!KD2%C7QgcO8
"UbLcnJPeU$NJiIgb5^l4VF8LHpcTM<pc^-(fbg]AdV0*0@h6sDOju*g2s6pZ%&Zni```(/Di
^?qk?3m)pZoEXfB!j-.P&'3n_pEAnkcCs>$##LE4W?Z:;k">5)@2qq#prWq/4aTli\B&<6oq
`Q9hCA^0;EBc5:KD.3$Ook!@%V,ICa!oK;je'st'deG]Af\+e*8lP!r*\6Yg.'"h@$3"eGK40
-s(^8VC7>#m(e%`&$^b/R9sRiE=9CTJM9Xe9K\!Ct-26>5Y>7Hc_btCTaD<3UR@`(&r28(5-
3`2gT3@r'3Lh'4J($#1R'@n,8'.AB`8%&NDd!Dmk7r?F`0<!;$Up/OqU?ngq-e9?@m\C:6Nd
VaNlC4CS)>XrYb5/-[!;T&7M)pL%++J*0%rf0:lrUXEsmS*[@BVE%FHO2/%jNI5u<1R'fOmo
#5p*+EYHTfK^Q"oG8h7=9UT>_UL!H?d34j]A[.0gf@b#6XCNipPWCC`2utA1@8)u#fWULaWm#
u?fg&A)Jop9^.292@V8c>mA"uLKlgKCndA?=fsf\JjOsR>]A(/J'@<au[numkB5Q=eQ9Rl^'f
SG@C@A(uP5ZD<X#+TkOm6%_X*43`jAE47Tj]A4Y#8!ZYomFc,_G*Qe%R-=6RP&3]A^%`WDL`qh
0N]AhV2No9sp_^l*1'F_#_>'=C5[:7G4.4&P<f"W,H?QG.i2lY#AZ/q(YX3HV%Ii:EL/R)4/V
"cbT)%K"u[h+62jcn9M^F31jnU*=e`WMnRsmBd%Q):,/nh:8,=+J+7Ik@1h5Q2'M8e&Kc29A
W#X*iE":lDg*WUa[AZV$85V>V$L=r13&aIjba&fp'&GY/_+IDEhp^k4uEnk31:oc*b,dW5*N
7eMZAE]Aacq:>0H3?r%g^*Jr_kVT2&BhmeQFo*0UDn&>?6U8NHI.I]Ae[)N>A>qWpjip3Uk*f8
gQ2'R^u.o&bHmeHSc*1Z5XAr2?d'Y=fme:7Q?A5PQ7:o6U*pj=Z#7:%QGmPLk7e2l/1FReJT
A^dI1$u[3JIKQS^a$(`iGK6.6$_:8-E<Fg1/=rm^S:&np8)T00cR@Cs7ZJ-WT@2?T3&@<97$
584P-?p-S>H5A>OH]A2o-<deq1o_m?H1TOLdq9I>6>&mfc##-jTP/g`Qk^@<anpTAc]A'.1^E)
@OQc#P`=g!I3?^2d"@;Wq'55@"^X)mDc0*O&!(l:[9i-Qpf$MeGC+!m,*r8k,!38dVl2D?#N
\ah5l>$kGG_kY:gO@As=->MO!&O+^#^&NaX[:,Bl0#+#1NjT<71[Haa98g]AM7Rp!"HD#_6$5
Tq.@f,,,2,JHe7D#<PJEo6b#!!;OucYML6QP!M;2CfD79$CNP:Z8E?<\lJQ72CfZ4Adj-\;+
-iOeU2j2u:(POXSR(Q`66e62<b$hB07UY8!h;JN%3i0-."8g8^]AI0>%C?_Ah7H)VYS:W&Ffh
q>KC2=k>k.BP#>hki.F.6VR=bE=2nCgFn`Ok7Xe$aS/Hh=9&39AKr+'/1;h=MEoTblPY2sX/
=Nk1Rqi$%(u,'?-C",FCf:[+e_?Fl1E:22BiSg'F8MRh)!BkeD%Rm[HFK*`5mSp;5K?M^l>8
ZG9_KG^LZhQE^P<1$e7.&,5t5)*]ANhZ+.XKOjo+!6B\EJP4+dL^\b1SlLP*DF?Vq(4.J<%^7
L"CJ;:bYH\^]AaKK.*6DR^RLnO)58om<iGq0*lGpa+0'^[Y=[TL?W?Iat5L0rsq'C/=XXK#TO
>7hCO`ipM'N:@f9Zq;L]AG#5\8CpQ&kWd-i%VDID#f.q7B8thaLrQo0uuU#@):2BQdDtMQ+\l
oo>CoeI@_Fc.'Mj]AdPd>;_f+%I-g==+XcNUSB`-I'_0^qOafRqIGdHQ:4>d*r=V'$B]AB.kCD
7c6s.%!)-i7q9$q"@;CC6$O<c8hC58Q7-Ia+PX=GEb'/J!.ne!*kT(4NYI`Qa.Z4n%ft`^uE
h*`2ti%8CB>Q<uKC:Tb!q1d2'W[#EC6]A0)Ub<%ujj#nMge)H-YDg?470g.`IYQ.fKj)r.?Wg
5K=X'.4*)3m#&skY$A_VF0.&28KA)3Eri+`trF(;/.(gIH)[n6FU;,X/)VNhjXU@ZY6A'Plp
tPVNuT.UQI"jfFL4#XHUL=9&<0;6-^cK[H1K9.F5mVK`UR`%TTPQKFfIP>V0*\q&c>s,7,!j
[Opn40q3bqn+VV$D:#j<g9*GbT>fRt3+?U;*B,";YIa3XUGJFde@I;:D5l-1lJ%e`\9&n(AT
:WQX9_c"*2i;F'%rcUX8Qd9i\S!@>^ihVD$.t"p,TX9mRu_kbM2>h>(7Y<@D-K6Bk&>OgWh7
D%0EBjpC5Da>"S&Fmd=D>g?^#W/jp[aXhX,a^IPWSF3j'nPa(DfBYq>1mt8ffr7CoV,Kh4%@
Q&"=(ChtY@TXV[9&7s!95P<j-.)b'?Ir9NaUW-3S6\Uo.99#4%EM![7'2IsaC^0WX;H^__td
H_DX2FA=$kpgbJ;iOh=n%7>H5@7@A[*^;B#3.b$'\)c(*%!?V45qoAoOLB"F"`m&K:RQ@Fa%
^XXEm?iC8"YeLL.R:#]Aab+JW&-d.lg(lK?Y]Aj*8<<'0iZUFdG+07)h8s4A8G);kGgrWM3Ilp
ItQ4pQ,peh^Hd]AUtm\l"Q%E+jt9'k%*E'+mu6(s!-#ipU+-s-Je@';&=+lA#pQ4Cj"cr*!2H
;CtknX"&Z4sR(?.E3Gj8"GH(%\0>?R8YKn-2>01k$fm\#T&O42G=Z/$M7Fb(]AJ&gTW*5VEK;
asQ(L3T/%fE%cqmi=&]AkSeSV*CBjD./!Sp['@cA`WI,"AB9lc/;;PCD0=6;`7^`Tq*WL'g6J
<;_"qOaCYXaB@l#+`MuNAh028"6T&>lZ$)q9X4W8Rt"$HY]A>u!:;d/@#j;N76CLI[:S:ugT7
:@H<0<f;quq\&cA7O(HZX9+AeC5\(tXTQ//]AR%I-lQZM^=6&1BA`GC-9$p2_KXSTimRol-^j
NqN)s.5ZeVWl,&)e-4(cgk,qV%t`"rZa64^&*bB_K&p-_t7>\'fOj><]AZ32I+*U1rb?U7BBF
8#UUhV8IBIi.KtY4?PIn:;eBJKX8hP7`m0f(cWddjbR)IX&,`LcR5pk4S#m^1A,/H6%3'HiM
oVt/X*X$TV3H/gWMl5[JrDm94e\M/<M"]AT<?teq@FhhqBPFl24QuM*\9+Iua5=o:o\5`g:$9
W;iuEREf7`-Lf0[BPhZ_5uPS:['9'XA&C8e2SRSh]Ai?a%W3V9l0;1)0)<1JqSra<?X%JqiTt
''>DC&GFRY=mYIQTaLZ2D3^O+L6C^_\lDi)Q5Xt*C`mm@/gsC>OkWB<MLLSWIW[>[b?]A7cOK
1Dg$O:9W4]AqA"#((k_mQT@))rP&VTc(-GFI0I*$VAOc]AAnL*6F&".0sQPHqDJ2O_X705Z(qp
N6j-Z/'huI?T+1?rS/+G;lKp$$n2o:RHpP)A>:A,!cN,PXP#WD6>H]AHNhZ0RoC<UKe;bHA^3
U<=]A3[^d!fip822>K.j/ukDJ=<L,U%&0K$2+fYN#nj+.[C/"6.RlP,eref>;!HE^eT%<[e;Y
7IMJUC4>)RFVhC5M_;pF<:3\#!]AFR0AiTWqgAm+lW-DGUn=Y_ZEY;LaofIO'@>FXW%i<-kKd
l^+oaKo97,aCDRA^XH8W)KKg<FD@Q0lT*\mI9:CJa$aY-&%K%aZD?X`7cnkX[l/KjQHj/10n
OC87dXHu;i&\(Rl`<Y?Id6[<<+o&b,6`4(77tZ9C@4s,41mi#V!7mZ;%u8jOin\`+jW>*9F%
j*hBu_2<k4u\C@dYi+0[>hUS8N[0EJHm8iT5DYmtrV440&oXD#`H8rQD[&*Zsck6GR*=+uX%
&ce&^h>^'lBW;e+.%5CD;mdT,!+A#CaQ]AD$uMH[F4NEiQg6M<?/JSi<9A(/_*7*iq[KY/8*5
V'_<CZg!dtH;qJAdt]A%)W=6WU<1H<$m;<eNlF-#2Y?RpW)n[>l_@Jck/;/Db<i[K,`q1u*Os
i,,8]A6H?<_2aAQ!^uWHq&\fq'RS64d"/:6CBYS`tO5X^urK(Z&#H,p"b/M:^AqjV.CujiKWh
C;\^$8dG[?IpW;3W2A/7teS;>fbtl;PYhpiERR+6u!(X2XXKltq&$L,24,A_jrk.0*Q!P9T4
!kAi>;epT)Gj_I3.L7_[*KNd.e^/.iPnEIWeVD@pZF'VbbcS#i>K3jmkmW&pb4U'/Vh%\Bs<
YIMVBm%[8X@f9RldbtLeS`7OX-S:Md1XAlW#*L2m["CE[eRSUj]An1c(VIK/82OFSDT-7(IOn
8NK/2;P(u$5>?_oG%R?k)TpYMj5fq.GR9jE8ZZlV6_@FZG%j;*>qM;Xt[)<]AQQ=gRsW2c-Lg
K``o5d)MeF5WgURjdFWgAgr\OCHj^$f^dM#ISEp+[U5.U%/m(?EG]ArGfEe<Sm8gR$1MD&JTB
q?k;.qm^Ts(]AO_)pg]A5#f==U:I9[)]AtdNbuse52huid#ZEo$?/W3);=n0c\Lb*^=$L17k*7K
kiD4U^X;NsFk:si/caGP_C5NtEMS6.KVFQ0GD=7#BP(1lc`rY3fLnZhm9PX`"Sluj+E*>bD=
M<$L]ArfA\q3-5f3AN"0/+(9Jr(.iZ?0SA(p%+3M9%H?-#H"l+U0B-!^%-FS7+Xbn\H8p9)]A]A
j>).\N$j5B\.Y(_GNRgKag,NZ1uo">j5ndoCLVop%;I#Wsr2"4jrX>u<?6)onNR^&hO-E"(-
jA4(-]AOX"6ls*sQlcB6%E-MIp/$i3Fj`C=ASX)o*)h`g)IW7<dI@*M/C1'\oZUHUX_4AT^S\
h-\mSlrpB]AgS*d-[d%poEoE,huFujk.'1Qa--N(.5"q>Za;K#Mq3e<_(L'.XF6t9K.PN<NQp
p&jK6P0bpYQV]A;?-NL$#Dc1c(`%!AcK[Zcm,E1D69D+2'fZq7`j_[=ZCU)Bt9@h2ciEsCDjl
(6Z_C=6?UWEWl'2Q9\9d]AR^kM3fp>:?[^()d[O8hd(b,D&5mr.\;+V5O5uuNZQ7L%b^Z*l;$
'B"(AMN`8I"%_sW-Uk;-mHOd?t\4BgflbR?jr>tZ.&bBb_j6K%8\?Z3NUKnV\&'_Lda"m'8K
;a755KoTg7eU+0T6p-U"ior-lL\WdJP-ls)j%Q[@Y?I!HcD#+GbK!t4B(;9o(soYe=r"TDSf
[1mTtJDUPM)qb_b$`H)[e:mKRPqX.?l@H;c7^"TXKBl;]AM<or9=,kTX):4ar?+8eDEB.ftS,
6p;2$a:QEGi+K0a0[SX]AVG;DTI="HSgcGur-A#-ZJ,k*8p?0N*f$9,QPTOSVP\g:H%C;QoKa
#Q8GXAmg1LTq1('OLYlgsa&MJg7)E*(d>NHWsgHZAe5@Pm/'FBmmENk.DV/L6eH1,E.n'd=u
-H6^u.?DUd3OBC&lYF!sW(EjZ5L:%)U=\b?1?K<q-!rnJ>2V3,\_V.tq':gS=+F!ILbVI0,4
s+O*'.<;:ek4B30D<(mnXX]A^C\8]A,LLfrmY^H=P7qM35^2dauu!4KTDO=`JO,%3gb20[u^ZT
ZTFZecQ.S<CZE^90d;W7Wsj$ZWN;,@]AfD_F]Am5$gh8Xbdgo:?*m\ONgXC'*G?08NHE`<"+?h
QAG\u]ApgnrWT]A.`mZcR<:=a@c':'*JURfA@0#23dfh1D61J"Q`:Q!OE;M-edAgR=epT)QTn6
fhq&\@dQk*^)bnYQa\NhRKFVjb[b-JsSE:P,bBGb@Ja/G,\L?I5kIrF^8a^:r62EiPLE5[OI
?!YRI?Ql`l6uX`#[l23fM?>rl;!h5Y+SaReBDhBB69c=T_Xq8<1@GOUkicdHKWl"I.AJomr4
4EYUe;hk\0)opkLj#-VC='piqD#p@eWdhmrPH44H*r3>$$EYTSo8]AMbP+bHBrYA=XK57#s/c
5eP:Nso/Zb?Zr?4`tI(?jCPCe)^#`EOJH%bh7=>UC6E2Y,lEb1e4Qa6fO_V<8YH]AhgP`Eo#$
lUZ"?uLmiA<f9s>cp(c*(]A?.)D-It8dV:[o%SYaYd'$dqU<\)O14KhnYd.%P8S2+H:7)*6W6
b=iFA4kH+Frfgp'13_;_NRYtThT<Lq_WF+Ce]A?\8+D%&f"*eLJkM33$s`S7o,EGZc<I-BZ=?
&^C\=L$)o?I]A*SURj-5XU$R%i`c\$\<2WQ4Mrk>@_l0hI-ZHmkeuR)32Sqe$m!%Gsp`YI9.`
=88Y;'*f;Vk"MaLMmXh&c?cKe1']A+]AmR@'8j>Sg^@EM3]A4UH7hDd6Ncop77)a"ZoUlpL\:Gt
;W'gI4K;/^dr+)+_4=oV9\jeeqSEmIE)[MDZ^G1E&ZhA;sg%AdK?h9C80#GIc:J>I7iq[cd"
Q^.P@2H9)g;+7$*":otTA'9^;kUhJ%C/kV"]AS>m9LJ;C!$D2Q\QYO(T,O_o@@[L."j4FY3t'
BADQgbr(/p&QB;L':JeR6IseK"7Sqom4Ei8\&E"2UN/!7eO6-7IG44H@C`&dpF&.."4bFI[?
ULKa7(i\H'q_+,a1lI3g7$;Uj./D=MdMs2kA)o#@1`-)Zb,oNQ#0O=0A;AFm`$L@/:-E=S9*
b9KlcCnF]ApX_Q%GqP#="-.s>E&]AoQVR,YGB><b;+(g`"fWZ%olc&kA8,WJ8\&i7a;nW+u&0(
F$48$i[1[gZ?bP.-X/-%5C]A39cYKSX<D0;P$PS9[&$H862>IBoip/a3sjS*gb(F$tR*2(%nO
2fTH<J#d?`Ve"sOb`[umA*Q%d7=g7`S[3X?Fd8?cV^R(1OYXnpK==VKaUTGB5P#sq3q(OcP:
Rq'6h_O\Urt]A79G;$dHX(MoTk:@r^rq'HYaSMN6Pi$GNR^BNRfkh\?9.pj":.AMh`Of)#[[q
D>UNhPFcD@1GDCV`;>eF6uC>OBE?:9hu5jshNp@@hL%+=i&FtAKG\<T_$BR!E&5@:m%j@-Kd
ZL$`^.!r7;r;:eV\p@^8_tFb[WPNj+"uXB*alu<\)='B!du=VY4B=pA<p22:-.Ie^33afnh-
&%I@_%uG<QiqKgrX6dJK/$,=194?,JPXdbGbs-39JZ`NDE9,TSrGMMW>c`1eK:5.Tdm_51Jq
DP7h[l[-jEEa_5Zo4$o)IHi59[U!Le\o((A6BJ5GZgd7Xj#uQ%kd&+0VZ]AfI.D66u]A-BFiO8
G28`gf=CY3,pNMf)8W8581_\CS>''I8V2W0HrN1(ZOmsh6D_/W6ppR#kT$='\S1gZhDWMe_H
`881W:=.&&,e(s=o3U1<!HeFVnc9Ore^3d3ibU/ClXBr-5mIoF]A_c*HL:rCu)8=Pm)Yn$-eR
/]A_KGkaaajQqA^t`3bKcpsss8;65-+_Ik#M_M;6*(qT54%8US[r/#%jr;nI+0!Lo%mYlZIM.
Z5LMR%#\gCe22enZ/2X'suG(;=?NagW,/fi*?S%$nh2Z%<j592t3M1/-&#QL#8KEjo(fpJC8
,jC1u+aOMKD:\iZ90t;Qo7a$;DAn(288\i:pgoq]A.X^O:,_-2Z2?N)if?IheSm*lP+Kk]A#K&
<FH%;<2M_^;D>3/TaA'Sn/%o]AhK+/mBoC`jtj"<4*6RVBVa&X.DqGuZI@1BNDpNUa8ah.'2s
fCkscn4Lt/S?*GltrCXM9fB=3oT_7uLJZ%R]A',K?:WQr7!^48&RnB*0;!PA_b7DmVV`'&ua?
Nca*;4M2\@61%aE_C(fIcsF@U'kh4?T6!_nYr@G7Fj]AT8&4'AU5>'^KU?5lVkqedll;t<:gU
mJeSBF3<Xo[P;Yi9'*Q#=6:4!tpC2o2tme/lb\ml@O@]AZkoa':?[t;E.MCkc4F3lUig.?/k+
JB8SVKQ"-_@$Q7<3(3:'l4tP?'QuC.53ZdH^&ZYeBls$(+;>+o"4&>@Z-utiL.Z23I]Agh<Bl
J'o_)k-KlHlb8<j'Z=9<bc0ukp*?51I?BY-#cBHJ@?0L'!2a;c]AS3+QTWR=+PX<WM@cH*,_J
]ANSQb<Yhg;e;o'0?8fSV\S`(/Z3PdqPW.+b-+5P=>VVf/b+Gi5!0<K4sV==PHXDU[31PTCuk
o"+D1n81g;Lfli[ft)CM.>F"G:/O#Xk'?GSI8!EkX?4CGf=>`HPBRU5b2cfrqacK<>,Ioc0o
9(8VOr<f>l5Mn"g9i$lI7GaGdUSPYH-/ZDL5>oP>$J>8+UJ"DM"iTgqj]A\@_(.TFjRIBG/#"
ts,V*#?\Agq\[AqkL(*@(TS2IijD_RbLPoNWS*[aj>Srtt\*&TSjViWhZTfG&gnO3;fD+V"M
I^ggon><k/ma[F'UMWW;CFJENI5nC+IsnZm*KTeI&ai!aV7gQgO;?&DGDot*MM7]A6Flsk<dE
#Of8`2"dbm;8\Mcnt1;['qbSK2a$aT<Rn-0'b13A^m*pS=/>^t4VnE5(BAqoP8KnHJ^b'V?h
*W&muP5aWLEs6Vd8fb'!BR)#e72NYN^fYDm5.a9dp9]A(+fsgGQil(4_po'.&6UTVoA;@8^=3
^KFCA5Hhn$nQ4:AR)LSYM&&92$3E++s)W.&kJ6Trp,7e,,7)`cJ1ZkpNk3)-Y:0QP?phq..o
ibU:"s=-nX&)G&4-$[,HLAu`Tp!Eij(FHB22Ugc09pqoig!"?_=/@T:cWnQ10k<0/ji(Yib\
6/l:;a=Ed7*c=;rHSAa0[snN]A6#p0g"!VnSI^0rBDfgqlR@t9N#qD<XPfPq.(PduM_TX%GSB
PB!F(b=Zn%UaH-X]A^iVOu*@'S;t>/#.3B*J04.g\]A7Q.r\IU?%U-qDX__/.SY[L]AStNgh%8p
ZnNOj3f!-UAag7?"3Ye?E\"qhrbRn5F<Ye*(IX*HEnu]A#AFSOeM`ZbA1cTBWTMX:[E8ej[l<
d%S48#VsW"]AD[Npdj0W.nb6?dKs71^:cg>o^cR:+<dG%TM%uJ$/;N_mIW)E4#XeFXfP'WO8@
>T1V(H@>+C-Kb/]AiFULuCkD+7A&gXY=[H30<jD`cY3rY"_e-$,A.e7etIq8G85<#l=V%7F$?
[KJk5Q;Ide(YLd0eQ:<m1Ss#A2R1E3`ZuA-,()O=:Q@D>s27XVL7#[(B>k@:g&F:JUY%DP.u
G%h^EYY2P&ER#XS8*Q$G4+U>W#"hp!m5eu#X]AadGQ4@8c]A4=:)Flkmrn=Y$W%S+3aQ"$FiL[
#7lk[<UuTW\V;l#A*mXg[gn1ik1'`%/V3:;MeYlV&Y,Cu=HF`7@b,FVqd@*;k!W>=Wr:pt!l
Kb=T>*U0m/mV1mr\LM&/SA+i6Z^tWO+i\f5dk5"SWT9UK7o$oucJ"7U'$o3_\<mqGb4p+N"Y
h]ACsGk@-2.Uo463Ifc+Ze%[oS"[dJb3r#To#eu\NoIr,Ur++,81V#86.l;b[kGA\l)&4S%UF
T>=R4%=-ic^)$XKji2$("LL.a=IP`Cu1`:'KapcH?D^(#jJT'H#\#`6AF"CKHs*M+q)ZUB)#
,FIbWSraYQdC%4dbl=4;bF3B:K.504UU%q9kB_UP3fg^aYnSRG`I#_SX)a5"moO6=*Mq+iu5
2l&Xj@VJ>XN'%X+8]A,#3%Em<?B<kpf)n&L\D3MDq1rHWe"gi90_Oq7?&06Yql-hEl:h`&V1G
i#kASsSgY/pR81O\L<!lE4+MNOrleg_:Z`FH/ICDB$g/k:UqUd,3m[#ZRc6(-5@AWup'J)lg
SN=V.aA(=fl,ONEsL2nl\]ATkGD!&Oc.bR_>Z3G@[=S]AD;d:/3OHnLie.Mlu):1KYB*<pg9_2
3#(Pj$N'+Nc!YhF5Dr;p@G-0#Dl^1>>D(^msQnKSOU*XGQ\ag!T>#;Gpu>KcP[gWOn)TsAMf
Uu*VltI\?"$;,6FEg*$R9s-!YY,j:pJFO[YO'Ch3B@,(64a&tTksF#>:>E39K!?t"ZI>q/LP
/NiXi`Q9njNJWegn9"8s,hP%$9]AsOG_2,8',**8-"bLqnh94%V:->l\(4%,rHmlljj'Jnfr]A
F>rT0(mRj5*iFKsGXfEV-(\NhV-3>EkpO`f5\I:VG\^K"IrffLg:XYqJWh$_5'53"H7Bq0=#
.ZLJV^3'B_,FI*n_oJL4MNr36\Ud]A>W5)r3[kiF/9Sl`/U;M#U>^3!:=eRY*Y`R5J#BV]ArBS
kq,7^qe@&Ra%U(>NdKBU6^M'3BFQTaZUtKk2ODX,g&H_F"AY6hjLt12^n19j[TCoeJDC"4)Z
_WL/nUE$iTr3;ZGI>hhaJdA!WWT@E3)"cIChYn"SZ%]A%VK*k5Y*aQT3\d8e<;!P-""+NKDe;
:!oD]A>iO1YkZ'Xgh`j;:]A554ELWM$`.TE;NcH\'Ui<hp@)YqZMg0`>*HA>c$eIeilBUgA@mB
%=c$`[>pmdHD_8:fXBTpr'nC2)Rg7$!c,2(n*9I9ID"6:O__E#?;A8=E?EgiDH]AGebF]AFn5c
=rJrf(L"2eMLu2Lc/U?ZMf;#k'NE8rhFQ4@MqH(B(J[*![?2;2hH5!hmN0'B^KVgR6WW(LQ]A
JW/oA50Y5^*A);)bg%i'E.U4)_\=%eS:H+\TtFW+7o=HP_oK,!JAWok3sL`*[>p&Aes*E*%k
:=r/Elofr@B<R>a(IX7U`sn1o6rQsb]A(C(>6/21!R"o[MO"*15ddl@X0-I86B\Rd)t?M,tJ^
(uP=lWU5)-lY@qA?5BKM8lFI[62<G[l^sr*Q:!!&P*aMJp%IblV:Ci-M>eaq6I1!`rG.0*=(
@/<jYU_.&/[Y,C34Nr@Ug,P^&He]A>(=.A>7$GR<eH!1hdiWN_(EB`1,hWVgO)Hm-[/asHpDZ
&\rUYD>t]Am;<oeri]A<1giFeLapKF]A;nH>WEd/J,10Q:j%cHX5u)3V9a")=$8BHjsa0j[("_E
D+0\"O#`RI2[:[+l""]A:ri=jKkYh`l%d]AhgLnMYcf=\NW=p42caFc;r;iZic3'F.CKe2Ro`K
XTZV,$!.JC=V_I,PM4p-(XC:0S5O;ECOg,R46iub)Qq\hC0@(KNJ*rJN"4)ipUFcoRZfhiHi
FXG(U"1TosZA%R;`c4.M_\MS3[Ojg`mmc;e.hlVe.#K+"lfAOcl3#h3`TG[oPrA-3W!X"*pI
R9`9<8S@dX@X7DK!8/^rm4fSSQ(3NO0MPKP(U=5Pi^2]A\090(*.Slo6*_eElb.+1JU5\9%eC
W//PBe-EFH5@OPt<0m3!sWgX=&.he%H1Y;0sluhahr$Yk>KFKA<:\!H9eDok7b!5?1D_Bmjc
Kb(pkb.BC<cjUYMgFR\d4Z/b$u>V;rDp&\BjJL8d_R5<'h0R2gO7fnXYi=%d/4nGps>F-Y>=
HGbl6mTI/;^gpO5>VpbLjj`sg#=[hh1%A9p=43X7L.PS4+jLU*M]A^\6BB_t*gS+Jqa)#$)+\
<dVN/ih!11ddI^Uf%L(Ka?TKDhX7edhBs</OZ_lDIb3YAh2[!"?;I/,SBeTn^-uI.&[66<Q$
E;spNunM3c4WGrC!4VgHD0-4NX#;11fdhhIC?_[t/]A=^=dnjDqghWdnd^6cB$<-o:]A(!I*]A4
s0UE['J)C;+04jh1D-<:T,-h$n?Ai_(S`pgrg)m08i/kZ!=BopQl(S,WG;$9X<#mPI+R,+Ff
Pu:(R62]AXkXg6J74jU2:;A706)V[R*APh>*49J0U/?h</K2$1J1OkMl[sT)X2]AJ7Wk503O[L
,U>rp&Y`*`!:kVcrlQDc-Tq11K"_R31N4Ckiapn*#M%ic@$5GS$QA.r)UbXk(RCrp(X4p+s^
),?FfEf6DHOa*X)8%"@l*S!3NF]A@\*ekrQE>">u\C)thcWc_;,W7FhJUKU0q%_U@;qdd6'1s
`)eE[RpuEI\4bZ(R&T=eZ>(-2=0mW6GlC),M:&3i[=%l_rB3XeT&i[>nuBeN0^Q<9pL6;6?T
s8%"@l*S!3NF[3@;W3mBCE?q.:gJ0/6&KDf2*7[*MF]A@\*ekrQe81UI?pZFkqB/c-.Gb2'e0
'f#?RK*~
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("Dic_Table1_max",2)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="600" y="85" width="330" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {
        _g().parameterCommit();
    },
    1000);]]></Content>
</JavaScript>
</Listener>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("Dic_Table1_max",2)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="591" y="2" width="126" height="36"/>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("Dic_Period_max",1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="390" y="85" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {
        _g().parameterCommit();
    },
    1000);]]></Content>
</JavaScript>
</Listener>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("Dic_Period_max",1)]]></Attributes>
</O>
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
<FRFont name="宋体" style="0" size="96">
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
<FRFont name="宋体" style="0" size="96">
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
_g().options.form.getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
]]></Content>
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
<BoundsAttr x="1500" y="65" width="120" height="40"/>
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
<FRFont name="宋体" style="0" size="96">
<foreground>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</WidgetTheme>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("cbcr_contribution_analysis")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微軟正黑體" style="1" size="96">
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
<WidgetName name="REP01"/>
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
<WidgetName name="REP01"/>
<WidgetID widgetID="ddfea19c-f955-44d4-a9f9-8a262f974d71"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP01"/>
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
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP01_c_c_c_c_c_c_c_c"/>
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
<WidgetName name="REP01_c_c_c_c_c_c_c_c"/>
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
<WidgetName name="REP01_c_c_c_c"/>
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
<WidgetName name="REP01_c_c_c_c"/>
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
<WidgetName name="REP01_c"/>
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
<WidgetName name="REP01_c"/>
<WidgetID widgetID="ddfea19c-f955-44d4-a9f9-8a262f974d71"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP01_c"/>
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
<Widget widgetName="BTN_ENTITY"/>
<Widget widgetName="report0"/>
<Widget widgetName="chart0"/>
<Widget widgetName="report0_c"/>
<Widget widgetName="report0_c_c"/>
<Widget widgetName="chart2"/>
<Widget widgetName="chart1"/>
<Widget widgetName="LABLE_ANNOTATION1_c"/>
<Widget widgetName="REP01_c"/>
<Widget widgetName="REP01_c_c_c_c_c_c_c_c"/>
<Widget widgetName="REP01"/>
<Widget widgetName="REP01_c_c_c_c"/>
<Widget widgetName="P_COUNTRY"/>
<Widget widgetName="P_COUNTRY_"/>
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
<StrategyConfig dsName="Dic_Country_TW" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_條形圖(前兩年度)" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
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
<TemplateIdAttMark TemplateId="7ec10c1c-4408-4e15-a713-5d2b58e55644"/>
</TemplateIdAttMark>
</Form>
