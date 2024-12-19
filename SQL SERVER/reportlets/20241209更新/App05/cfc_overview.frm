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
<![CDATA[SELECT DISTINCT
FORMAT(t.period,'yyyy-MM') as period
FROM V_TRS_FACT_CFC_TAX_INCOME_TOTAL t
order by FORMAT(t.period,'yyyy-MM') desc]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Entity" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="GP_USERNAME"/>
<O>
<![CDATA[umc01]]></O>
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
<![CDATA[WITH auth AS (
SELECT DISTINCT 
t1.USERNAME,
t1.REALNAME ,
t1.COMPANY_DISPLAY,
t1.COMP_ID,
t1.ENTITY_DISPLAY,
t1.ENT_ID,
t1.MODULE 
FROM V_TRS_DATA_AUTHORIZATION t1
)
select t1.current_code,
t2.ENTITY_NAME 
from v_trs_dim_entity_cur t1
LEFT JOIN TRS_DIM_ENTITY_I18N t2 ON t1.current_code = t2.ENTITY_ID 
JOIN auth t3 ON t1.current_code = t3.ent_id
WHERE 1=1 
AND t2.language = '${fr_locale}'
AND t3.USERNAME = '${GP_USERNAME}'
AND t3.MODULE = 'App05'
AND t1.entity_type_id = '003'
AND t1.country_id = 'TW' 
AND t1.SHOW = 'true'
ORDER BY t2.ENTITY_NAME]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_Scenario" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--SELECT DISTINCT scenario
--FROM "TRSDB"."V_TRS_FACT_CFC_TAX_INCOME_TOTAL"
--ORDER BY scenario

SELECT DISTINCT ENT_ID,MODULE,USERNAME FROM v_trs_data_authorization
WHERE MODULE='App05']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_ETR" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="GP_USERNAME"/>
<O>
<![CDATA[STAFF1]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2023-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_ENTITY"/>
<O>
<![CDATA[P00001_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_SCENARIO"/>
<O>
<![CDATA[Per Audit]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH auth AS (
SELECT DISTINCT 
t1.USERNAME,
t1.REALNAME ,
t1.COMPANY_DISPLAY,
t1.COMP_ID,
t1.ENTITY_DISPLAY,
t1.ENT_ID,
t1.MODULE 
FROM V_TRS_DATA_AUTHORIZATION t1
)
, ACCOUNT_BALANCE AS(
SELECT 
	CONCAT(period, '-' , RIGHT('0' + t1.month, 2)) as ym,
	t1.country_id,
	t2.CURRENT_CODE,
	t1.period,
	t1.MONTH,
	t3.ENTITY_NAME,
	t1.T2_CODE,
	t1.scenario,
	SUM(t1.ACCUMULATED_AMOUNT) as CURRENT_AMOUNT
FROM MV_TRS_TB_ACTUAL_ACCOUNT_AMOUNT t1
LEFT JOIN v_trs_dim_entity_cur t2 ON t1.entity_code = t2.entity_code AND t2.entity_type_id = '003'
LEFT JOIN trs_dim_entity_i18n t3 ON t2.current_code = t3.entity_id
JOIN auth t4 ON t2.current_code = t4.ent_id
WHERE t4.MODULE ='App05' 
AND t4.USERNAME = '${GP_USERNAME}'
AND t3.LANGUAGE = '${fr_locale}'
and t1.country_id = 'TW' 
AND t1.CURRENCY_CODE = 'NTD'
AND t2.ENTITY_TYPE_ID = '003' /*此版MV_TB只有002*/
	${if(LEN(P_ENTITY)=0,"","AND t2.CURRENT_CODE IN ('"+P_ENTITY+"')")}
	${if(LEN(P_SCENARIO)=0,"","AND t1.scenario IN ('"+P_SCENARIO+"')")} 
	${if(LEN(P_PERIOD)=0,"","AND (CONCAT(period, '-',RIGHT('0' + t1.month, 2))) IN ('"+P_PERIOD+"')")}
	GROUP BY T2_CODE,
	t2.CURRENT_CODE,
	t1.country_id,
	t1.period,
	t1.MONTH,
	t1.scenario,
	t3.ENTITY_NAME 
)
,SUM_AMOUNT AS(
SELECT 
	t2_code,
	SUM(CURRENT_AMOUNT) AS STANDARD_AMOUNT
	FROM ACCOUNT_BALANCE
	GROUP BY t2_code
)
,PIVOT_TABLE AS(
SELECT [4000]A AS CODE4000,
    [5000]A AS CODE5000,
    [6000]A AS CODE6000,
    [6500]A AS CODE6500,
    [7000]A AS CODE7000,
    [7950]A AS CODE7950 FROM (
SELECT *
	FROM 
	SUM_AMOUNT
	PIVOT (
	SUM(STANDARD_AMOUNT)
	FOR T2_CODE
	IN ([4000]A ,[5000]A,[6000]A ,[6500]A,[7000]A,[7950]A)
	) AS PIVOT_TB
	) AS TEST
)
,TABLE1 AS(
SELECT
	CODE4000,
	ISNULL(CODE5000,0) AS CODE5000,
	ISNULL(CODE6000,0) AS CODE6000,
	ISNULL(CODE6500,0) AS CODE6500,
	ISNULL(CODE7000,0) AS CODE7000,
	(CODE4000-ISNULL(CODE5000,0)-ISNULL(CODE6000,0)+ISNULL(CODE6500,0)+ISNULL(CODE7000,0)) AS TAX,
	ISNULL(CODE7950,0) AS CODE7950
FROM PIVOT_TABLE
)
SELECT
	ISNULL(CODE4000,0) AS CODE4000,  --營業收入
	ISNULL(CODE4000-CODE5000,0) AS CODE5900, --營業毛利
	ISNULL(CODE4000-CODE5000-CODE6000+CODE6500,0) AS CODE6900, --營業利潤
	ISNULL(CODE4000-CODE5000-CODE6000+CODE6500+CODE7000-CODE7950,0) AS CODE8200, --淨利潤
	ISNULL(CODE7950/TAX,0) AS tax_rates, --有效稅率
	CODE7950 --所得稅費用
FROM TABLE1]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Rep_ETR_CFC" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="GP_USERNAME"/>
<O>
<![CDATA[STAFF2]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2023-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CFC_NAME"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_ENTITY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_SCENARIO"/>
<O>
<![CDATA[Per Audit]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH auth AS (
SELECT DISTINCT 
t1.USERNAME,
t1.REALNAME ,
t1.COMPANY_DISPLAY,
t1.COMP_ID,
t1.ENTITY_DISPLAY,
t1.ENT_ID,
t1.MODULE 
FROM V_TRS_DATA_AUTHORIZATION t1
)
, v1 as (
SELECT 
CONCAT(YEAR(period), '-', FORMAT(period, 'MM')) as yr_month,
t1.*,
t2.CURRENT_CODE,
t4.CURRENT_CODE AS inv_CURRENT_CODE,
t3.entity_name,
t5.entity_name AS inv_entity_name,
t8.country_name,
case when t1.TAX_INC <= 0 THEN 0
ELSE FLOOR(t7.tax_rate * t1.TAX_INC) END AS TAX_PAYMENT2,
t7.tax_rate,
t7.tax_rate * t1.TAX_INC AS TAX_PAYMENT
FROM V_TRS_FACT_CFC_TAX_INCOME_TOTAL t1
LEFT JOIN V_trs_dim_entity_cur t2 ON t1.entity_code = t2.entity_code AND t2.entity_type_id = '003' 
LEFT JOIN TRS_DIM_ENTITY_I18N t3 ON t2.CURRENT_CODE = t3.entity_id AND t3.language ='${fr_locale}'
LEFT JOIN V_trs_dim_entity_cur t4 ON t1.inv_entity_code = t4.entity_code AND t2.entity_type_id = '003' 
LEFT JOIN TRS_DIM_ENTITY_I18N t5 ON t4.CURRENT_CODE = t5.entity_id AND t5.language ='${fr_locale}'
LEFT JOIN V_TRS_DIM_COUNTRY t6 on t2.country_id = t6.country_id AND t6.fr_locale ='${fr_locale}'
LEFT JOIN V_TRS_FACT_COUNTRY_TAX t7 on t6.COUNTRY_ID = t7.COUNTRY_CODE
LEFT JOIN V_TRS_DIM_COUNTRY t8 on t4.country_id = t8.country_id and t8.fr_locale ='${fr_locale}'
JOIN auth t9 ON t2.current_code = t9.ent_id
WHERE t9.MODULE ='App05' 
AND t9.USERNAME = '${GP_USERNAME}'
AND t1.PERIOD BETWEEN t7.start_date AND t7.end_date
)
, v2 AS (
SELECT 
	t1.*,
	case when t1.TAX_INC <= 0 THEN 0 else t1.TAX_INC end as TAX_INC_ADJ,
	ISNULL(t1.ACCUMULATED_AMOUNT,0) - ISNULL(t1.AMOUNT_TOTAL,0) + ISNULL(t1.DESPITE_PROFIT,0) + ISNULL(t1.DISTRI_CN,0) - ISNULL(t1.REALIZED_LOSS,0) + ISNULL(t1.NON_CFC_DISPOSAL_ADJ,0) - ISNULL(t1.FVPL_FVCHANGE,0) + ISNULL(t1.FVPL_AMOUNT,0) + ISNULL(t1.RE_FVPL_AMOUNT,0) as cfc_earnings_pre,
	DATEDIFF(MONTH, t2.START_DATE,CAST('${P_PERIOD}'+'-01' AS DATE)) + 1 AS BUSINESS_MONTH
FROM V1 t1
LEFT JOIN TRS_DIM_COMPANY t2 ON t1.INV_ENTITY_CODE = t2.COMPANY_CODE --AND t2.START_DATE < TO_DATE('${P_PERIOD}', 'YYYY-MM')
where 1=1
	${if(LEN(P_ENTITY)=0,"","AND t1.CURRENT_CODE IN ('"+P_ENTITY+"')")}
	${if(LEN(P_CFC_NAME)=0,"","AND t1.INV_CURRENT_CODE IN ('"+P_CFC_NAME+"')")}
	${if(LEN(P_SCENARIO)=0,"","AND t1.scenario IN ('"+P_SCENARIO+"')")}
     ${if(LEN(P_PERIOD)=0,"","AND t1.YR_MONTH IN ('"+P_PERIOD+"')")}
)
, v3 AS (
SELECT t1.*,
CASE WHEN t1.SUB_OPE_EXEMPTION = 'false' AND t1.BUSINESS_MONTH > MONTH(period) THEN FLOOR(t1.cfc_earnings*12/MONTH(period))
ELSE FLOOR(t1.cfc_earnings*(12/t1.BUSINESS_MONTH)) END AS cfc_earnings_12M 
FROM v2 t1
)
, v4 AS (
SELECT 
YR_MONTH,entity_code,scenario,
sum(cfc_earnings_12m) AS cfc_earnings_total
FROM v3
GROUP BY YR_MONTH,entity_code,scenario
)
, v5 as (
SELECT t1.*,t2.cfc_earnings_total,
case when t1.SUB_OPE_EXEMPTION = 'false' and t2.cfc_earnings_total > 7000000 and t1.cfc_earnings > 0 then 'true'
when t1.SUB_OPE_EXEMPTION = 'false' and t2.cfc_earnings_total < 7000000 and t1.cfc_earnings > 7000000 then 'true'
else 'false' END AS IS_TAX
FROM v3 t1
LEFT JOIN v4 t2 ON t1.YR_MONTH = t2.YR_MONTH AND t1.entity_code = t2.entity_code AND t1.scenario = t2.scenario
--order by entity_name,inv_entity_name,cfc_earnings DESC
)
, v6 as (
select
case when IS_TAX = 'false' then 0 else TAX_PAYMENT2 end as TAX_PAYMENT3,
case when IS_TAX = 'false' then 0 else TAX_INC_ADJ end as TAX_INC_ADJ2
from v5 
)
, ALL_TAX_PAY AS (
SELECT 
	sum(TAX_PAYMENT3) AS TAX_PAYMENT,
	sum(TAX_INC_ADJ2) AS TAX_INC
FROM v6
)
, ACCOUNT_BALANCE AS(
SELECT
	t1.country_id,
	t1.current_code,
	t1.period,
	t1.MONTH,
	t2.COMPANY_name,
	t1.T2_CODE,
	t1.scenario,
	SUM(t1.ACCUMULATED_AMOUNT) as CURRENT_AMOUNT
FROM MV_TRS_TB_ACTUAL_ACCOUNT_AMOUNT t1 
LEFT JOIN TRS_DIM_COMPANY_I18N t2 ON t1.CURRENT_CODE = t2.COMPANY_id
JOIN auth t4 ON t1.current_code = t4.ent_id AND t4.USERNAME = '${GP_USERNAME}' and t4.module = 'App05'
WHERE t1.country_id = 'TW'
AND t1.CURRENCY_CODE = 'NTD'
AND t2."LANGUAGE" ='${fr_locale}' 
${if(LEN(P_ENTITY)=0,"","AND t1.current_code IN ('"+P_ENTITY+"')")}
${if(LEN(P_SCENARIO)=0,"","AND t1.scenario IN ('"+P_SCENARIO+"')")}
${if(LEN(P_PERIOD)=0,"","AND (CONCAT(period,'-',RIGHT('0' + t1.month, 2))) IN ('"+P_PERIOD+"')")}
GROUP BY T2_CODE,
	t1.current_code,
	t1.country_id,
	t1.period,
	t1.MONTH,
	t1.scenario,
	t2.COMPANY_name
)
,SUM_AMOUNT AS(
SELECT 
	t2_code,
	SUM(CURRENT_AMOUNT) AS STANDARD_AMOUNT
FROM ACCOUNT_BALANCE
GROUP BY t2_code
)
,PIVOT_TABLE AS(
SELECT [4000]A AS CODE4000,
    [5000]A AS CODE5000,
    [6000]A AS CODE6000,
    [6500]A AS CODE6500,
    [7000]A AS CODE7000,
    [7950]A AS CODE7950 FROM (
SELECT *
	FROM 
	SUM_AMOUNT
	PIVOT (
	SUM(STANDARD_AMOUNT)
	FOR T2_CODE
	IN ([4000]A ,[5000]A,[6000]A ,[6500]A,[7000]A,[7950]A)
	) AS PIVOT_TB
	) AS TEST
)
, calc AS (
SELECT
	ISNULL(t1.CODE4000,0) as CODE4000,
	ISNULL(t1.CODE5000,0) AS CODE5000,
	ISNULL(t1.CODE6000,0) AS CODE6000,
	ISNULL(t1.CODE6500,0) AS CODE6500,
	ISNULL(t1.CODE7000,0) AS CODE7000,
	ISNULL(t1.CODE7950,0) AS CODE7950,
	ISNULL(t2.tax_payment,0) AS TAX_PAYMENT,
	ISNULL(CODE4000,0)-ISNULL(CODE5000,0)-ISNULL(CODE6000,0)+ISNULL(CODE6500,0)+ISNULL(CODE7000,0) AS TAX,
	ISNULL(t2.TAX_INC,0) AS TAX_INC,
	ISNULL(t1.CODE7950,0) + ISNULL(t2.tax_payment,0) AS INCLUDE_CFC 
FROM PIVOT_TABLE t1
FULL JOIN ALL_TAX_PAY t2 ON 1 = 1
)
SELECT a.*, ISNULL(a.INCLUDE_CFC/NULLIF(a.TAX,0),0) AS EFFECTIVE_TAX_RATE_CFC
FROM calc a]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_SCENARIO" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT DISTINCT 
	t1.SCENARIO 
FROM V_TRS_FACT_CFC_TAX_INCOME_TOTAL t1
order by t1.SCENARIO]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Cht_ANNL_REC_PROFIT" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
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
<Attributes name="GP_USERNAME"/>
<O>
<![CDATA[STAFF1]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CFC_NAME"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_ENTITY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_SCENARIO"/>
<O>
<![CDATA[Per Audit]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH auth AS (
SELECT DISTINCT 
t1.USERNAME,
t1.REALNAME ,
t1.COMPANY_DISPLAY,
t1.COMP_ID,
t1.ENTITY_DISPLAY,
t1.ENT_ID,
t1.MODULE 
FROM V_TRS_DATA_AUTHORIZATION t1
)
, PROFIT_1 AS (
SELECT 
	t1.*,
	CONCAT(YEAR(period), '-' + FORMAT(period, 'MM')) as yr_month,
	t3.entity_name,
	t2.current_code
FROM V_TRS_FACT_CFC_TAX_INCOME_TOTAL t1	
LEFT JOIN v_trs_dim_entity_cur t2 ON t1.entity_code = t2.entity_code AND t2.entity_type_id = '003'
LEFT JOIN trs_dim_entity_i18n t3 ON t2.current_code = t3.entity_id
JOIN auth t4 ON t2.current_code = t4.ent_id
where t4.username = '${GP_USERNAME}' AND t4.module='App05' AND t3."LANGUAGE" ='${fr_locale}' 
)
SELECT 
	t1.*,
	t3.ENTITY_NAME AS INV_ENTITY_NAME ,
	t2.current_code as inv_current_code,
	t4.COUNTRY_NAME
FROM PROFIT_1 t1
LEFT JOIN v_trs_dim_entity_cur t2 ON t1.inv_entity_code = t2.entity_code and t2.entity_type_id = '003'
LEFT JOIN trs_dim_entity_i18n t3 ON t2.current_code = t3.entity_id and t3.language ='zh_TW'
LEFT JOIN V_TRS_DIM_COUNTRY t4 on t2.COUNTRY_ID = t4.COUNTRY_ID and t4.fr_locale ='zh_TW'
WHERE t1.cfc_earnings >= 0
	${if(LEN(P_ENTITY)=0,"","AND t1.current_code IN ('"+P_ENTITY+"')")}
	${if(LEN(P_CFC_NAME)=0,"","AND t2.current_code IN ('"+P_CFC_NAME+"')")}
	${if(LEN(P_SCENARIO)=0,"","AND t1.scenario IN ('"+P_SCENARIO+"')")}
     ${if(LEN(P_PERIOD)=0,"","AND t1.YR_MONTH IN ('"+P_PERIOD+"')")}]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="Dic_cfc_name" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="fr_locale"/>
<O>
<![CDATA[zh_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="GP_USERNAME"/>
<O>
<![CDATA[umc01]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH auth AS (
SELECT DISTINCT 
t1.USERNAME,
t1.REALNAME ,
t1.COMPANY_DISPLAY,
t1.COMP_ID,
t1.ENTITY_DISPLAY,
t1.ENT_ID,
t1.MODULE 
FROM V_TRS_DATA_AUTHORIZATION t1
)
--, v AS (
SELECT DISTINCT
t1.INV_ENTITY_CODE,
t2.current_code,
t3.ENTITY_NAME AS CFC_ENTITY_NAME 
FROM V_TRS_FACT_CFC_TAX_INCOME_TOTAL t1
LEFT JOIN v_trs_dim_entity_cur t2 ON t1.inv_ENTITY_CODE = t2.entity_code AND t2.entity_type_id = '003'
LEFT JOIN trs_dim_entity_i18n t3 ON t2.current_code = t3.entity_id
JOIN auth t4 ON t2.current_code = t4.ent_id
where t4.username = '${GP_USERNAME}'
--AND t4.module='App05'
AND t3."LANGUAGE" ='${fr_locale}' 
AND t2.show = 'true']]></Query>
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
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_TAX_INC_c"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report4" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetName name="REP_TAX_INC_c"/>
<WidgetID widgetID="cdd35233-c2cd-4373-b174-30d90ed1dfd0"/>
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
<![CDATA[723900,723900,670560,670560,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2592000,2592000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="2" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("tax_payment")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="3" rs="2" s="2">
<O t="DSColumn">
<Attributes dsName="Rep_ETR_CFC" columnName="TAX_PAYMENT"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[=$$$/1000000]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="3">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="3">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="4">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0.0 M]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0.0 M]]></Format>
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m9"X5''Qs9BsD#ZegtC$g,;!O>NVLbQ)0nJD.[NTAo=9)+lEPuAN<JaQ(sYD[&E&'mYXPLC5
HUVW1^qnW?D<i$7Z)nS6u5,m_+,*qp.G"SdX_#*hMi)]AR8W64n&!VG>>\/WG^)8TVSBZl?rN
n)'u,erpo7KFg@;&d$'J^8e,t+UPI/aB2-k*qC`$sok'NMp_dk-XEWO3pL2^`hc\`[ZdZk2q
Ga?'7IU#:e%*NfS?RHh-E?Xh]AjJlI?Ck#(5MK?92Ah]A?(&$dL5N.pj@J8?9J&D2GpKO-,0p`
=;IW+J7B-4"5N00GYqb;@,NI8Am3sK(U#sH'GM8P3?Qs(.`nb)gBIpeU-lKKhdpBsCTI\W]A\
./+gH<?#75O)(h`OY$n$9)!^*YKN[>rp]AcDYNl+R/A%EHZ(6<$IUip0:eT1:T]A2mNX+($-b8
\^MTbEtVh33mp3?Oi!cZUN?BOGPEGAZY34uW8TS_@l_,6mHdrfI?d\WC9;"lfd7+8!n6VA"!
UWB"h[.D3I:GJO^G7<nMif:q\6mPlWtD'tl4em'6bj0.C3Z4N%5DXKZC5r@a]A#']A7?pEt24%
<tm-oK7br+"YK(c\'3*ELlV**brG"8^PO=Aj/-N0IDr6g?)OrS:.:_V(^*"M<Ef=<q_h3eoC
'4N;UL#?b"_9_lRp2Q^_4'2_-?UZ?s:bp*@4B]A"oSFG,Vu"f(3?]AX7QO/T[[%"4tZd(EIC!s
V_X(pfip`t-8&Y"Bq+GPB9Fj7bO+HN7A.)JAd65EkNP"*\a+LS>1-D0Vr`icFM+hl=fbE)hg
2hNSa<RVXk@:DlS@1dl^XF8cB"@U1$"H[n>(7O@Lu/TRXJX)>RQZ`23ilbF#JX)C4@^hPENq
o1iH"DdM6ML]At:OFUh'Y;rEI@:T\NJPbo;XZ1W@G,j6T[9>4.*AY[]AW4>7c-*(laGM6\2b@^
V.D?/Cojn49'S04R^u^f3IF+$*G^G3kD%[VjNbeh5@G@2_K4*n/Bt)cu/C8%8!jB(>j3g-Hp
U6$@EY&]AgA-\paUnU@W$iIYCJ;=*=Ri\.NPJo,R*5`Z')BC]AA!=J;R''`2dfMV)SRRjf\`=-
jBHhNPSqQ[R=,EU>@-A(m/l#0l$*J0UEe&T6OagC-,?nAm^Ph-ArL[N/o+K><90j-SBLUEri
"RX)pB?O;8_)!!Q9$j/_fKWS#W-tT&=6l-uB`Gg)&1X>;]At9>a&b)S5U@h,YO9WFsc8b\8bN
Ur97nlE*<u7GJATs\GH9o,<TllVuNj1=O^3i]A3)r/O^2m)l"`sg-A>?ESi\YUjN-ENRk9#>5
J4NoI%-j;;@Dd4Z=^[h#(^H-4/eIdD.),]AcmHjO@J5OG[CF*@h+:1T=!`cgd_M<U+P[h)O6a
reg3d58WW3@sL(!5Ol!YjBgQp_Gd7*Ue,We=gOY$B`fOh-n^r;$VelZ+.EXcjYnY_ooFF#"p
EFNHG&8-"##6a`"b`QV?pHRO?rSTTK5Jd"T'.)Y2X^Ym,@Qas%?\cTQGif1#pgm%&e_n<gQ1
:Vln7t>LHrl981P[jQ1I"!B[7+)NgjYM'1=[H^K::kP9dd-SFVmr3BW58cApMmk!X&;lH,>M
dJF5N`9@JsA)=#JlUPbFE#,PIFVXp*dI*Apo0/lMt-LIi\#RNV5ft>B@d*aN:!s6oG#!i;),
04V1,g$`.]A;L.m34en=LT[5_,(ALh=91qgXM5'0.4dRLAp`$h^:eNs9bYq\W!4g!Zm\"m*e1
JO/uc4GIp`e75+QBXp.H=5?T7eh3JY+b\Tt&S0GJn9ichghbc2._KA[s+[0;TpQXE68P<Z!]A
CsVW.UPlg@F1?(iSAjpXN'&<!M.tQ2P0iiI(>Mt'5$W`aa*d"ZfCBcH2;?C/&L!Y<%jm?9?q
<h><t.>8kmJ]Ao65IS-=JMRJ%@ZW0CX[#<hjW,E2!)g*BZsaGCTCs;>/:)d.?Bq8OHtNO"+\&
\S\?Ojgb4WpauU*ddJYj0OZ5%MnFd#P_'jl1=I`Ua`".&j436'__s6M/HWZcoRlQ$V6lg"<`
.9H6V_1I3+,pX?&c"g#@=A21ot!?*9ZV[QFJN\NRu_/Vdkb0&rm&!j7c4C5M_Ga_UG=AE<<+
Qrb*B,A$2Y1TNR`[0NW$TEkX@YL[U6&XZMR_kqqW_\#D<`U?I/J:,MppHJ<b]A_3m#9rh]ArT%
oqOIIlW]A@L&42I7YEbNT2^mQVbc)2Yl>ACX#D&\W-gU3KWJWUsd$WJG*joMMHKZXBbcn,oI8
2G-GTZ7N0.G^RjI"!$mRtmC3-$Ep$C=L6clh*6oBgn$a417mpC@5(<Y.1a(TA,bAj*H!67le
0![`3(='a;k5`rIH?6hbc4YB<A#]Au_AHa%41*p<mrNVAjU5gRpaO=!o4)4)+O]A#FS80:33$"
M2F*g;Zlk4=E6mE)t<bdlT_Z18-FM1o/n)lM<L/WBKGmZklX<jfh;+2+gJ:efPce]ATe=UNSA
KQg:LC0LR>B-"JgI_1$EBs^]AVQ6-Q#Q#1K]AF.ZP]A'iR_fute43>r\[Fe05U;oUq1k#*KC..1
q!"]A?3S%qK2Xq/2>+o9-T*BaZZa$snW=M:9DQ@MeBA4Yt;Y7T?/9H+-HXAm?leV'[A2Ir8FJ
'(sKt>s]A/GHVX:M0,[T7=FdddaO=Y&G4u8DHT5)#@3:H,i&1enH*3)Lk+-/A'7GrV='%W\8r
fhZOaHCShJt8n3'3Qk\0=_LQin`g>;#=4n9F'Pj4J+IL6gTCjP:>S21LG12S\9=?`dXp%*-'
'DNW(Ydm8&n<O:O#9KVmJ*6L,-V(0T.sB@d3O='[3Yi@U>-`^&XcY;VMS#qSfVcbRTRq'iXY
pmj\!;P>)G3#e]AdL:4b:\"/=^'s3=Pc1/\R6+jfoleodD2FBs?r]An3'"44koH%8,?\<5AGN.
,pE]AM85VQfrf;H#\V@'/*?^)1%J]Ac3ppERkR&W+h=8?[&G7FX55cu3/KeNg)D38n3H4Z>15&
N2:qj^\le+25Z*;1_7Thn@0Lm&+K2UbKD1oob/ABl_RJhmFE*Lcb<1FOiE/KSPGBdXL!q:L!
u]Ai-#b(l=j*F^"p^$j2-L%5;s`Y;UkuVHHH(@*c/hb`cf@-P36Z"tjXM)BL221=#cU.o<8XQ
Bc0-(R$S>BHr+5hl81hRC5_#kK8^_CeHMfGTSP]A>$_%#(;EQrYo<!eiPYAgeV'CC(7]A_<CQY
rQKK#EdQQ_3jS8>^9";?/(CPMms?>^3[]AtPJF71+RN\hUBee3?:)l0(<7"Jqre)f+MG6nQts
<r'>/le^_mH%p*!ap+q_lSG@n>,b;inmrQ'^PMIP':>S3RInFOW36]A`oue-h3Y53Sr02MU[B
fa^F`"ghCN#KIn-:9OG;l?A3s,sGm21UEfVAFe3aWREn@_FRZUrsHSY"U,0u;9IPPmN;RH.S
Z&4u>kc%>T5ktY.(fcSPNg$UG\>Iq:Y>CLclZBgJniVG[uoWQ%*lhUHGOlIHr^`p*TO;a["\
'!m+68ASldfEX!geM7^F4M@\ANNqRmJ?+sNp-DP_>im!8(nL4h"jU,8Y#Er`uX9o1fWM7n%X
Oap<q$i0,pV7B)"U&gp5*gl(2N1nCLZ49'Ys(/[)>2;%7"Jd6sprm9O$09\(t(]A"6bUATu#F
LP`V*ISO(&0Y2[Ooh&d*F$;rE)?l%eY82:/(oD[d/VL[L#('/K^?O:6@$p_33MHA4h6+!.rS
.?O!LLuI(S5Hr(&%4a_L]Ao8pIG+QScSTJ3d2Nf=+.q6Dq_I8]AI#h4g-3<S@oq^h`(Okp=(3P
-IP?Y7=tV;pp2*cFg\0Q:NYZ*boCZS_,(2t#XZ5Fj[>>tn667kK=qSi',T!H<Y,oVA`C[-f,
K3D31gCn8>VcLi/G?)3eQm(kXhA2J&oXlVo/g%>-]AYG=SY)X`pJk<_-fP/HBZF(ONb+_g=sf
.0,sDTen3KfgK\RVONW4H.i]Al+]ANU9:"O\]A^U9mMg_qR`h4TI^O,!48Q1;J;LZB55X&Xr+;k
o'ruec!-aEAR#,^NQj>-#qGp^nfs>Q-gEulP'rNu4.X'qVVU#G+\si^!.'8ThRY4("S$D)2t
X?s"u0VBW$0(Y[.[0Z7(5O?>XaKgJmM4ELN(dp39LaAIC$g&U0(-2^/FA@El\(J>t*%m*l\2
Y%=C557IT[DE5$Wd8O7-PUGu>s(5R"I#70Q1<TGMZ0,bAaFsiN-@a_2qld21Q(i5]ArQW?kBJ
Y=<3_a`b!lp?B??i9(fWD/o4pqXlOB2)Z*b=K8d*.a@aQ[$Q'5=$'q9a/]A?94@n7X<Rtd;gS
)'H<(&!k@",9d:OT46EK'GA''\mlNf^,B;]Ag??.h!0V4]AUjDMOq3@7@3u)8]AT3'%"+.>1IM!
3k+ug6fgYV^(E<P).1E$'kjdhH0F7mD8(()%0PN5!GmUH6gMeGiTW!aIne5@*R3b?F@IM/ch
t#B=n#,:!BaI6^.+;W6p)olisp7SdMi8."L+DmW[FcgO^m.k!*EOfN]AV_i;]AG?[6-L[O#fel
TY^7/G!m&)o0q]AH]Aa<c-\`ZdNgYG$=?K;jX6`[:b,CFgu;m?PQ<fOa=l\]AOpLiDN\Q9Rc-6E
M5%5@:n#$<e*3?*RC4br5/)%<Cl$E;aPXWX`#K8[>%uo@h0jYd?1NY`gb+cW;U+r"%T/Yq:I
`5pf:n>jeLO6]A@`bAS-\bZ5eS0uR<VH]ARN959@`tgV.D>*,%`#YGg!TdU8L(uC'VCNs^'9M/
2&q21ZkO?()%t:HDZ$%/)s<O#'ZH/#E&C1KJ<"'rl6@g535etDQ8VrV;!-"Dm1s?#d9,PV7T
u"DQ7#;DeE/uK9JENee_@>bm$9gukCo>g:%[SYk]AE_H6[GS#8N"e.0niKi5:,^[Sq[Zb\iO.
:9<r)9Ke^X)7)F`,"O2b6dH<4a+sTp^"VIqT(H^eqG7\Urj<]A3+a8t:RXJZ)5'A*$sco6?ug
d0M"D^ntL4qNrdJk\l[=!LGIR]A%(893ZS[+h^19=3C4m=MDHjP;S$#gue,!7bMYLT+!IVQ="
s/)A<11Ug%ZYS+eK(Su6\c8MnSJ1!/p,Ga54[>.F30_V]A8s:TLP.p45<H4<D5h`#RacBsM?F
j%cLiabC7L8WA#nH`(qh3<CNH"ZeEu&f5gJFR#2B5C6rQ%$Y/"l^kH,Nu)A0:uS`FAmCk^(7
P3oku2C^;*GR'Kn)jd+$iY`9'[i[V*3-,*^/Y'mET*OH!(Aqr/Mea4qEIgrPr\dM;XE`Jn0^
67)]AY,d8gQ,p43H3[l+9E-uq`FHnjl2b'rrT&XdMFQT3`M:teT>1*nrk;IJ%j+gtQ_9n,-=;
scILJ,ntMr;0goTtS"Q]As0WHKm'=(^3JmWOfYJBQYmfJ?DP3f]A=ob>?Jp.Y"=LgUZ;,^LCYp
N1lD9KFd4-`('Za,HBTF)&P658\K^uPKH`0FJb,JJiW!]Ar>(fb[X*9Gb>.FB8r&+1;!b-;U/
e!"W$j5%Maa`I@&)H2f;]ARi3R7>T(tZg[P5AR5@3690P$>7,!sXt_?o/dG/%[^8X'=.j4ZD0
ZeA]A5!=#_bB[AP^HSAH^*l/&Kk]A9TePjidFfgnN1Koa(9;4i$LPCPC@qeFjl5UVVc<Z&6pIt
HUXnW41/8FS`Zf*+G_r9K_c_2I,/MnILI@o^<t0hidJGm.AUA&%0sYaK?5*OXl;1O0e'&-8E
$s2.`?Z0M/\\_RF/mG.)=2&95(&;"pU\HYiW9q\UhXR3;r]AR6T4^_32oIApQ;*B[!NK205Jk
XtNVUKl:4C-J8oZkr;hnn<H:([rgl%^$E8rVWYkCpt)ui7($]A,s8jCH=($Qfe"V+&OLU/rJD
L]Al`K<d5+:Z-it4eW6X*8:2u/:8m9,+t'(1mIO9GAs.$3rPEdEe<koIa;:)\(k,C5!DnHC7=
BWd8N&Tl>!dq)0&_:fP$:]Acs&ne"S]A`"-3rA*nKBRa6^oOZj8o)cB^\]A:#m&Z8ENL:D1s%,E
<C)pJ-M2O7Ok(LidWlgriTUkQ#kiC#miMVL`-O8h-80$ujI-rd@n9AiQ7O_FaX%\*j?+,Uqm
f<1Gk>]A0G'tT7Mh\<u#kRQ\45&tW*EP6M<ZQuqdSt8kC4>ogNDR"G*p93_f-DC?Cg%c%%09.
K]A2<U3heN]A\rGhi&"*]AJ6F24iqZnZ%iCoickV*b/XrVVS\G7,;R)H/b4b4P[D1f.[mp-%NoC
&)7+j*DYmIGEPq\\Qi+eD(dBVgNC&`!3"u_N\'7fdBOC9KZ@Dn!BGI@Dp^d9:Q3'Q=2@9]AIV
og-P1]AeN1sCI0cTI\c:"54%"L)9pjhu-Th9EpfcJ^HjGsp'L7%-,mnbr#gp6*!s4nEjp?cD3
tY3@kqar<tOpb!;P6U4-sm).rY!$nM5$52sk4h)_@7kT59[j1BP+d:;KVc2QWZ-tA\)>917h
>keW&RpNUK.;?jS-#cD:D,crEkWSlKUT<Re0LrJCdJqF#.-14_NWKV%aIX$a*i?tTVl3$]A/W
+SmLgUAJXX%7_J@3NMfQl*6L'I^V2CEA99?g)pAK\SMm:$'Prfr_9nU&!Rnei-A!S1VN5*KK
?\!eggc]A%H@V9m[TC2Td\`C\')fP3Yp;)EZY?Xs!]Ac*3)s58d'_.<>^Z,CZM;"'rlq2*ZKhU
POn"^=]AR3Z!,--Z_\X[eK`H=jaN#Nn"MA_E.kP>_8'R"QJC1%(Qg/pJBFZE\0o-Yb!PQ##FB
\FLW'&\3(F0?uT.W)tU_O]AB9+*K<9neZrW3D@q2jWghWeUkmeZB5)";%CO,2>QJI5fbaVkrD
7b"[kdpQNdNsii:;?KaEYa<(.<b=.*`$(&aX^mnQE6p%(dDd.G!TTE@V/E]AW4frhDnKMRIsW
6Hf,AW$O&o(nY:dJta5QuCpfZ4@D7e-3QPY?n7tr)GX/k.NNrUHW.lj]AT,;[YL`$&KgX*<.r
ciK%_Qg]ADUOB2hpOnWc2*3;+b[_uMlmjRd@^fY2^CQOofDBAbF,Q[Sn,8Yf<?B?G5n,7PLV\
)^R?uD+U=+A<*kpZN,q08g&0>?\ThWJ+1ZM/"6Vt.o.2T^WK?RqoeOWa\IqlTkp+%B"<me8r
/pTo\U_4l[1Y1C!VU(R6bkMiEPTI24^"pnn^8ORpp5d='\=[ni57"bO6:D^#L5k(9^[?N/_l
^Q#soe"FbIY=Q]A!=Jrth1k2i[kMtW1WE3lbT4ti#:IP/r@PDMddQ!mC4o67&Mh)\pO*#S/\U
ENH;m(k/S01SISL/=0O`R95!C9FDEr5':HgUq?dpHg>'H%^*0G07q@8p*]AFYOKh0:;#\;Zfs
Cdd,fHa6\Be(o;V?3uid&5#d+r,''Ck?*/rPo4l8TKG;3%nIT`QGN^/2tkM!b`;_0peJD3=a
f.mAt,89T=%Z/lBu!E9RUTfMg]ArYMr//5=RXR+QK;5%e(f:=R"ts4HNU<()eK[?1_\<eFh<7
]A<OnL0,.m.RA]AHrF&#\4.?k8LSU_>%#le$Xsd_i%!j-B5Rk3TBQA2*$P*u0`%el6gpk^=?@/
/:'7rS./4i2<#8"P.st3On<I6/4,X;I=hB8%()B&q4lHZIbdVA'P3(F878q_A.\R5^B9Qe#\
aci&I+JF59S_pI4/)s-bXYQUOB'=W%krA>[kG*,BpWSE56_b"gIq'4sfSf))?lV<YTa@Mj]AR
XmDj^*TX<O!A>WhSC(2Kdlm6q6h&Im@mmb@koAk(':3?9-oEMbSSC2`84UE*_`se';\9PJ<R
-*'?kcf!D'?jd/:kt2HI6g:5HJSF9'c4t=+]AD%L(n"FAs/j5\FJ>!14(g*&_-8%a1J4WSp+a
TAV*l(*q4`:T>O*+:u^0BKCT&=+eEJ-iN<-d7o`,3Ig%75SKTKbl%YW=EE&*.qLlHrMBH^'[
a]AmX$uT"DY]A8)DmETp%RuHAq_bA'q/>j=7'arR7A5\fFbMErC:NU+n))-R(4;gA;JEcEk.a/
^$pj.:b9"?mAqGO>D"^c0G;*"l+s$]Ae^5lYU_H\$*3q\J>ALW]AK<-Ju[&Knl:cJnS_&Hei>i
.Jr0(*j26EYD/b.Q`b_6TeM^Uk"F7=dnh=DH.p`;j7sLj:^$I[KA+)8q3tI5*eIV]AnnbUZ%6
-b%Wn?2.)aX:(-*7(,F5ca\'=m$eN_j:Qa<'VJNa.\+08C7?5QrW6JI5AL!YqY!"Y*?"$N.*
#'WYfO=8m73S?uHaClR1Es&F+)q!D*B>hZ6O$EBa+Wh9^!TF.]Al$EBa+Wh9^!TF.]Al$EBa+W
hBAbknEjaI5sC]A?921l^;XiPd_3<unqC/cS%k*Gs#^(:9%U1p>Vn_#b*hiU\"fci0&?:]A~
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
<BoundsAttr x="0" y="0" width="360" height="126"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="518" y="162" width="360" height="126"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe" pluginID="com.fr.solution.plugin.form.widget.rh.iframe.v10" plugin-version="8.27">
<WidgetName name="rHIframe0"/>
<WidgetID widgetID="6c5398ec-8cf0-4b15-abb4-488c1158fbb5"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="rHIframe0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="false" scrollY="false" method="POST" contentAdapt="false" customUrlEncode="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr" pluginID="com.fr.solution.plugin.form.widget.rh.iframe.v10" plugin-version="8.27">
<RHIframeSource class="com.fr.plugin.form.widget.core.TemplateSource" pluginID="com.fr.solution.plugin.form.widget.rh.iframe.v10" plugin-version="8.27">
<Attr path="/App05/cfc_summary.cpt"/>
</RHIframeSource>
<Parameters>
<Parameter>
<Attributes name="P_ENTITY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_ENTITY]]></Attributes>
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
<Attributes name="P_SCENARIO"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_SCENARIO]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_CFC_NAME"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_CFC_NAME]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[write]]></O>
</Parameter>
<Parameter>
<Attributes name="P_FILENAME"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("cfc_overview")]]></Attributes>
</O>
</Parameter>
</Parameters>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="30" y="643" width="1860" height="428"/>
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
<FRFont name="PMingLiU" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart0"/>
<WidgetID widgetID="0066a4f4-edf8-4259-92de-af59520d5fa8"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="15" bottom="15" right="15"/>
<Border>
<border style="0" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[=I18N(\"TAX_INC_BY_CFC\")]]></O>
<FRFont name="Microsoft JhengHei UI" style="1" size="88"/>
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
<ChartAttr isJSDraw="false" isStyleGlobal="false"/>
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
<FRFont name="PingFang SC" style="0" size="128">
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
</Attr>
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="新細明體" style="0" size="72"/>
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
<FRFont name="Microsoft JhengHei UI" style="0" size="64">
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
<FRFont name="PingFang SC" style="0" size="72"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="2"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<PredefinedStyle themed="true"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-75060" hor="-1" ver="-1"/>
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
<VanChartRectanglePlotAttr vanChartPlotType="stack" isDefaultIntervalBackground="true"/>
<XAxisList>
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
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor themed="false">
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Microsoft JhengHei UI" style="0" size="64">
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
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X軸" titleUseHtml="false" labelDisplay="interval" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="NONE"/>
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
</XAxisList>
<YAxisList>
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
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor themed="false">
<lineColor>
<FineColor color="-5197648" hor="-1" ver="-1"/>
</lineColor>
</newLineColor>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Microsoft JhengHei UI" style="0" size="64">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y軸" titleUseHtml="false" labelDisplay="interval" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false" isShowAxisTitle="false" displayMode="0" gridLineType="NONE"/>
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
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="7.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="15" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ENTITY_NAME" valueName="TAX_INC" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Cht_ANNL_REC_PROFIT]]></Name>
</TableData>
<CategoryName value="INV_ENTITY_NAME"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="9c3c8888-3b50-4570-84f5-a3b5f0212077"/>
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
<BoundsAttr x="0" y="36" width="1845" height="295"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="Title_chart0"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("TAX_INC_BY_CFC")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="1" size="88"/>
<border style="0">
<color>
<FineColor color="-16777216" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1845" height="36"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="45" y="294" width="1845" height="331"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_TAX_PAYMENT_c_c"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report4" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetName name="REP_TAX_PAYMENT_c_c"/>
<WidgetID widgetID="cdd35233-c2cd-4373-b174-30d90ed1dfd0"/>
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
<![CDATA[723900,723900,670560,670560,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2592000,2592000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="2" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("effective_tax_rate_include_cfc")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="3" rs="2" s="2">
<O t="DSColumn">
<Attributes dsName="Rep_ETR_CFC" columnName="EFFECTIVE_TAX_RATE_CFC"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[=$$$]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=FORMAT(ROUND($$$,4),"#,##0.00 %")]]></Content>
</Present>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="3">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="3">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="4">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="4">
<![CDATA[#0.00%]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0.0 M]]></Format>
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m9"^7deDXsg=!+O<ibS]Af(46g2,e6J9efe;X_6tZW[T*K3_01^@NqNjd'(+[AuXNYdCesje+
*Q='>/95X]AU01k7eMZN"?.i'G7l??u<[9q>L;Ac?[]A\j;_Lhn,Y_FpZHsO^#%Z8^HR!bh>>s
`#64bi^AP/Jk5g*5?1tbfC>2@=19(odfJ!9q`6iMO/#PdNeG%?MaXj1n,01'<MK6SU.qN%dr
(S=J)oB2Wcfb:PrnBN6kRVaC?+oU1\%)'>lF.^V]AXkB6Ec,#ND%/FE?)-TDLOY/Oh#Mikj1#
Qa4q57'@/Ic%8"UAaP%bB2Li'Pg8Fj!=aqiD@Dou1Y4@&>TdoW`XqT>cNfA'(Rf)ghF%5A(g
J8X'omP$m\)s%NR4Q.-"jh9:5>60kcf`rS51H2l\E5;L@9B=6SUt#G]Af3N/&r%5^.(#VR?qU
K/L<EH7%Hu[SSe`iX;?3&pO?a<c"q*BH9E2ESe0#5J6rcL<qr3.lomm$aagmj`1(__+@1#IV
rW%NY:p$+G@oM_C0%!gA3S:rn+5/4hBpX$mTTtH0D7&sl7Dm&W^>G&nkYoc[VLHA4&a1a/JZ
C_i#gm5#/JM?7ZXK?=5B0]A$]A%.>Hp!]APV,mq*ipn)'^18gB,".^2<cjs7RA]AA<Xci"4hPY/9
T.Rf9iNEu$k`2sPa]AkEJ#O98gTO)GM;e#3C-pa<rANkE*kCr0f@R<hE]AqSBVU=M`S[n2tl03
<Sj61(D09Fh4j&Rn%$Qcb+uJN>k"j5B@C0bem&5Bhs2dIOm8e0?u"R8.)/4m-Qn7El5AQS81
[3Z%MB'kZ5[rp3g2rPHPN!h^G]A_QK_bMJ]A`,0J@%J#"m^-b//ra>Gj[6]Ar^''1r.:@5RR,+B
1&!%c9]AOa$d"3g,HDW,4??Fo1Zq[!h,A>CX^##5!ngdt`uM;sHR1skmjKsD$hJfR0Ph3!AWE
`&uHC^huqn8e&o5>OR@BG[udIX$<$L(Rcal]A#)P8,QVO:U]A%$e\/O([(PNbTcF?'cP/s/K*(
_DZu_hAS0Ca(hdPaY+LfHdC0/p8>@K?K^WS$n&7]A@sU,[_5Iiijme[+RpXQamgT'9%#'WpgY
R-O8N]A3B$49R/K25>r>'W.1DRahr.g^:P[J/QaC<-sGjgI,a154=%5P:./(h6\1.lIo9)3nU
sc;nq>L\j&b?/q.Yr/dC._cGWsf.(7gJtDP#'+p7[PO%"f7krotE*oLC;(9l)a5D'jmj'qb)
VJ3e1$)3JlV5K/I9db5Z.!?mp`@KmTq#c2E<Ssb=99fF_qeOpI:qJPEW[]A+In=;T58e0::LR
F/GlRS7".V5d>dR91MEDmkcW2N)(Rpe+B.YiX-.5!M'38(upoQ$1urUFm<p/!@3gH,5NT!Tn
U8q]Am^&2:BDIB)+;0/mu7)QDEteK[K:krq&s\#ouJ<kP?sSeficrqi)p_fSYXH@hfMinVouE
@,tbfquH%l=60/"Qk*n>(_PL#JQ4:>r=rTRP>Rk6QLSEC1$dBIs&-@O'YUFskq1SEUsD6Vks
j+^c%S8>\5kV&rLBLa/Y%erOrC8c3"uM$k.,%uckHSr<LJ`"73t%;:@@:qTY$uZ]A9DNkGmTo
+g;JfJL,)&hB<pHa33XO&J)8WQCLZ47Nn1f]A(g?6\JocD%0RS3n=hC-]A5*%$:VD-s:1D7Pr_
>$8,(l']AoSr@u"'dn%O@?bK/jt#<6?"!b+XuF[+00h%<55qh;RY]A?<'6b?mGUdu8)?0M\Anc
9+%s<Fd[jkk^6D0!L]A48M@Nhm;*cKs<p3KZGSWZi\'&1?u6duDos<7Tdl.'5ukS(_1nB%hN)
"7:9L"aIZE@TnT@8%7G"lmikr%i:BF'V!J[S<>cLRCEjsSOkX&[ZE+ENu&/B$StDSYli'60o
f-c/=g10*;5bi@PM,[hfa[CQhZcX4ZW=UgsjlA7^oO5[[FX4l$$B%00[(U_i*SJG)H'JXTr!
miTG#'bqqQt+Cle%1E"L`)?sdiVDe:;\jK+`BL8n%fC;]A-G87`>:nZ,Y]AkM"FI#j@W160KZI
r"?89/5@H+rr(o+pH=GBB1W)Zq+HcWKY*-UT5rC\]A0t&)U`rc*&?c9)l<ASUBG1K@,e"A&J6
6.M7co;2@WB8M".8-irA.b8rO(q)UHKL5Ctm;".$P0574djl-n8<epAQs%7G/JZsJfDqBb"L
@"?&lF7)Rt6)tD_'iEC5ELkBfBS'CP@'E*(]A=&cPV%[:=GT>O=Pl2"^0FFr@Y1Io<=BB!:JM
.U[n7/Nk:=qO"4BH8\+RsHtGl=CJ5DLHlb=e,=V(S1Hn8K!VI9W*#-o?El`+A:Irj/APbX"8
0'AoV-d4e'7E1pP%r-AnT2&gHUiCOl.\r7QKCnG5NJL,HO!KEs/nQ=NR+--71BGGY&dFXToK
JRK(a@aTJ5FRc4;]A-?CqD/Wi%(]AioZ)fEn#>$!nV:n^FAmQF;l\$@O^su4)FBIQJ6#DUa+=B
`:XTc8GF$N*sIKl;Og>u,'@IueO5#j`dLAY%#R__j.kVjm(XLP/RSPppgTEfD9g6N3W\6n$G
m:X]AG8R!*iUk'lA@ui7q.GSNbJo7_&;V&qsLkEn%&/CWfd<BJ@8ppl0fXq3*$:!*&UM;sVQL
S.1@K#?3Q?dd#$Q?iZ4\$GAf:lNTjm`r^b`_TSN%%!@PiTgO8-M^mI9t^QL`NF&a8!QAVIQL
T!O7&b[o>;-Y5/te6YDL_H)?[(+nsrZFIC,P(&#BE`Hi704M\0K_[B]Af)1'A"ZI4R^@Td`:b
\>Y9>PIK;g"h!!-b8)V`]AMqmfJBG$YUiSmYE=nI@u>SiV)VD\IH`L7D4KUdOKq?i[F0l<Yj/
TX=MbZ7RT%kV'87_?'57m/M`6WoqVoXE$TCB//"PEU*.u8Op0Wk7]AlG/,ib)&Vj!8&$#[,c1
<`X_"K'ePQCEa1G63an6\0X8FT>]AnpTEn7B+)YVE)g0pF-nQ%Yb;A7dKs%(6g^l<^/E6phY6
kufJX=W%dEGI55LL.2>/>![W+>/heJ"@6+JG@qjVMS%[Y;,'d+X^DrFie!B4@i/m8#*0`GAj
ZNEfno9@0bs=R:WV,D/o"%!IY8\)DSdU0rV/CbIh6V/:^0MT)dK4^Ib(H\`VOV'Z4)H[*<\"
K$WAfi_%RkXdb_/6h\W4ReI-&d"pp_k2jFeQ9aX.425Dp1-ibRK,VZAZd`B.m@aIE$JiMm()
HQ@:G49J.n_>-+dpX&J_Bn.3C@b<d7I)F(98!ipoED@!rc3iN@":&ORI72K'J$q:k\\cQ%*"
?MR$ACbJoj!Yfa$/DGJZJRo]AVXcX!g3?6EF*r0@WHCq'.NlcIKojKn"ToH=fK>NQB1*_<&9J
Gjon+LJ&/$a`I\Dug<h3@7M>Q9SQCt$)`144s(eS?T:1LZamTDh=."mi2$#q8l;6=WaaToYf
QcF^>mZXL"f)3r3CDj?eQJ3r-fbGn=JoJ`662rjR[-TS*9#5:;e>gJP\nF:,]AA`!%YAbl,aF
q2PtY.X7q[XJD\ll^5t8(Y3XTUrXb^Mm108`0c1.!F,(0^ocVU^$m;>[O+F)ratQPsgY.:EO
Z`>e0buQfh(Vn*4FDMp7&;:_99MEs=aEEu`q^.44g)AuJGu?;6:39sXoZZ=VYOZ&85D7t9nj
?)purB3;#k%L;l]A&=)1C`XbIm:<X*m?R1OrK&MeTQ<hRsHGUH/mhYaMKHSLGl'l/;$jNcC(o
hN3DW>>MKeLl;kr7'iikZgX&$iO9q;cLH&).)91ko`_Vgsa%keXO?1RCSo44Z=am6Et$pEUr
B$IY>@6n`VrD/X$B/)5mr!'q+p49hjA;"2a/FIPbTM"5^rnsO,?iJTU>,iOrXV;IdXd#aDjg
?+3nS:Vu=!,<qEmsNYaQ&nJF,^iuABlIP3291_I5!!0Ol'.P6KY(*ON^XDTpO:6qpu\AkHOo
dZNX*c1#hEt.X`a/Gku[<^m7Ini0F-B4c?gAZcuA>>]AHD`<Y'\?$W2f+U>$nnn>jYjMp28Yf
>DfXX[[rCK;uPCk/:QTO]Ar]A-CjF4%"Aqu=:)hAZ6fS(dQ`!7Z6b[+5H2<.O/eggA%?.4Sf)`
@Fjn%`c$r27N'C$&?a1$f<9LQRA?hH@2n93Z_:a9+qSo9TNF1'cr^b`T2l1XlETLrclZR<Ek
`_uof\]A]An0`i$gCu-lm-,+!2PeaW<>6ICZh%hKNqI,#gCHGMSXX/Bg`?VjrmRXG+8cfQn:D]A
tI><j%21XDm#6;^2dg"`A=!")YaC$f'KQD>"\Uc2HA.Rj>rr/W).sTY+4@H/:eMV4*U1S0Zo
sR3BOZ0GC<O?VccUZS6k="nYsGG-6jG'n'JPOhlh^>I\PDg@'W(Q@M)eLnZ2>1+lUNXj6rD1
c29sh<]A=mpRSaXV*%_aL+fdI9koM-QqtgOta:MeJ`EpY?mtUG,^U`f>D^'c"MD6-jRI^6^E8
q42*!):S,dR(,akeS!]ArYlP5'%u9f$R#*E<aN0@XkU41GXs[7KR?',=IK_pNMYZDRV`aLI'?
,:bOcTM"K<2X`mcrkkLdP\8WA!LZgNBSC!SESf>X_=NqQCefH+L=B3CS4WnTaY<s8/^>p-'"
j>=M:*+%,a*9q??VbE]A?u(\0"8I,6>.X/mHO1JA8s$E/3n:=nK.g9%A]AZaq1D3RToASHOqB$
<$-*:K"XKt0G9mqcY#"s#3M"/h[`u,3m.+>P;(EdM\cCbTiaZ-)#9"O0@nY&Dh/(>S5`kmVr
o93>6Z!4h"*8fdLK9.b;cP^OsLMQi;dqHL2CuuhiYu[F!/qkGd>+@.R=eY!Qo0'kpDi"_-71
Q\NJV+3S><OreL?h&@"LUpP@\tPpEmYn(lh'?/f\3>/^,@2a2FX:\5n1K?^(Bo89k4a%=Mej
MGZ%9J%p),*DG'f(6s+<;TtWCn0gNb#WU$_KGlbbO(FV<s>Z_7)VUM=5miaI1$NkY06OLC+:
4nJtI2MJXUpMsn$7f)L5F,i?.Q;@F3F8e>@IB<+5D#Nk#k?Whl1'aejB3(DVW$__Zf)`ug<R
,qrqY`caCbT8#!qhp!f.R&8Dt`]A1QD=XN[N>`[/CV.WJFq>Z]A;[,Ck^=bdBLYfR?4/=V-1S/
\hB=gCH,2n9;HN9GJE-^4;]A'eXpLH=)*>74np,0<n[>b9hNLiP`;*%;YM(OT#G#otPaZjOGi
d8+fsUf]AqQ-e0j,jaK8#B[&/jq\.0WIr6o6)6Q(9S".3`QTNnDbT$U=?,"Semdd%Em5ioVh2
OWl(#O4@TPGbmc7Q#*)"ZDVP93p@hR<^k6I#mtfWqO<D(UD'PPN%T:`a_c.k?iF2pYJVFKlm
qb=k/L,Vh,M_o5KM;6b!,ST_cf?,clQ:j%37cZ><fOIYr%*b(<e/341;uQOK%h6Y>nUa;)@1
0V!dQ:7k$(1,8VH<@3iAF_<ITk);n^8OcPb[,UWHO[S<d*1>E[%q)<YOCGE;C;:B<O(mXUE?
i'\LGfd96jHJs1Rl<niN=F.lSq=UT3kV#2k=bFA\PhSf>>RHj%T9P<-\M\_fAo;gp%3L$neW
!&QR[>pCB6J+>Ic'bK+XqkqP1jKDi!*^HYn.jO1YCj8)2K9/I/nLS(AB&@H>@"llJ_X4\rK0
%Q,;XOoru[ort5,E]A10gSH$Lj7]Aa2IkY;;KAh<H6;^ee,-OVL@Si.!H;*l%'?J"jof9l#[>`
G\oN8OI$75W.-o&/ge)]A]ARYSh9t!FlrO*U2XGsLMd+Tc[sl!tIA0II."AiRp\e@*oYho<9X\
ba9uCG@0XcgVq!psNG\s4K24dTYKXQh`%ZXg3Ds(F;Z'/N(l\U]A(<q7[P_U>7JYM,.B8`9nP
42f/KiNIl,pa'N3/P3=3;sJ':4*T+QX/Z50n9$Ac>=ZX>;(%)`kI138;5:_Zp<s4[m&8b.<1
D^_Jb;lPEH8=!oJ50dE1dm4(Vob%l\=C?PdHG-MKc+B!il/uo**lsnXA(K6'h-+oMb1t8,#o
-QoLkq"/>TAP&Y_$dlE;s2bCkCHcn/fGnIlE6`:+EOU1Xer([hOY*m[NkB=`^M@N<0e$VZ1c
*IZ/rb)@[Cr>IfCg%.`h+$tM'd\l&R[gc7cAH;T.HLQ"hiofK=\H%_Zag9Il^p%_`L%PKV:o
Fkp?/.OZL1=XG\]A.J0SfdC(g\W?Ds.k^.M-rGW7)bZ11m(6d-#MU-%4Mi"Pe-\Vt`;C*F3bt
6)gDcc)\II-,E>EKVlRH;W7_nZOFFI,r%=hKQj4e(=dOpS>&PA2\B6GcOL$M]A+j"NN;JkWX2
U$#4.2D]A_Ec0m;10&RiUfS4i)km>"1`U5*k;(BT0+p_idYDRrDIk-3_>l!mC96k3=-UE[R(i
cPKjAh1K:K(bN4]A@B(7_).@-2f7.A)K,)=\mFq.ZaZc*]AnR660M&F2Z@(90tN]Ap)prquFu%;
rU^H,pAqSi[opRr>,!=2@sHp?H#>Nl8c+-<g.aI&ArMA6,Io)<KY\\d[[]Au"=gktB<8,.A/L
>u24e^0OB:]A#kO(\Ba4B>*]AQpT<,U`gSfC?c/Vk2ZN$PBCjdn7!3[TE:M7>AV:kPok3G:8J:
5H@?XL637'r(F.pp5A_uINB\r_nqh&+4?56HBEF]AG."":/3e_o^,?hOG)g]A0\WF"$;DeZi8+
'q"<<Ph1(\,cep&<_F]ABC(Y_unN@68N5a,/:VB?[B.>aKfQa(a$kS?q?g+5+@_+=:$V"[U2b
0b7jP_;[.QMP;FkbPL5TOCpETk[cce+MgN[SLQ]AYY/P5$/md>bS$K==D[&GgsUY(,iH%u0P6
d-*%*#i&2-hA(L%\,FU7ourAL*9aX2_.-AUPe43.*+D6rKq@N(>kErTB2DL(s;>JWp!pj\kd
u`kV(h9keh.]AI@XsCUNK6N_dNgeR(1>Z]AAKg'CirhdGa[@`M`\#L]AHj770>lXYju;#jb5\)0
T_2T@e()XEpbu:PFVFt_^%-VU^D[+)RD4^(\;\V@N6A_ibIEMS\;\V@N6A_ibIEMSpjWWX>,
`,#Q1d^Mf1_/6c%S5\?Mkqgp*o'U$NP-Wdg*>=7=LiA!WZ>/I_/hd!1s".3651aB_U5IT:\8
44r/G:IfK~
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
<BoundsAttr x="0" y="0" width="421" height="126"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="935" y="162" width="421" height="126"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_TAX_INC"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report4" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetName name="REP_TAX_INC"/>
<WidgetID widgetID="cdd35233-c2cd-4373-b174-30d90ed1dfd0"/>
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
<![CDATA[723900,723900,670560,670560,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2592000,2592000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="2" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("tax_inc")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="3" rs="2" s="2">
<O t="DSColumn">
<Attributes dsName="Rep_ETR_CFC" columnName="TAX_INC"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[=$$$/1000000]]></Result>
<Parameters/>
<cellSortAttr>
<sortExpressions/>
</cellSortAttr>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="4" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="4" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="1">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="5" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="3">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0.0 M]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0.0 M]]></Format>
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m9"(%;s1`P;J.hbLOoV)lTo:5J5W4o8ZYsl"&LAb5i>JS!=076&<^]Aq;,M#-":ugg74M49,n
Z:O^hPP(,74PZ+X/8\KHq*7S'36ZHJ:[Yrk!C1[17PcrN,\ZDh%5)p\,0DZhNSMID(t#?+Ud
R!\HY+h7#m?+H*[rF7DTgQ%uZ$C(SJ.n%cEi*)A4*'eHOWW'a_*s4eV1J+LZ5HWGQ]AIUMEK,
q`C\FoM"DbPQM#@l_Y4m&DILfUq9ZmJAZhepH;k2-nsD]Af=^'p*`u`(pso(^"lm/>]AIDC]Ac^
iYoh!r<Y+nbtM#NG^1Q9X!?UW@VBj:kN0=2V``i[3TN=MZP`Rsm#.#mrg]AS$4.(=;_pD9QT'
kT9D@,R(P(0@C<:)k5sCnjuaG6I<h:X+c8>F#uZ1q8tVBlLqeHT\IgV[c-g@G$9D;GqZTcr#
%"'FEVD=`7ZI*qCFocm5J.YSm,Pa%lCLFCYkq\rd//@7oUHEe*F^#/"j$PH/VNgZeoA3U9A$
TN#/>[6348W`%=DuZu4\,qd%Z8(DRZF"d$V1,#r#Ms6%m1gklc1bt0#"$B1>dbl)jV;<.3Id
@I4MfB0o/dsb^3XU@[R[>eDbP7>lBK#sBMCqQIPWoI:*'0\Gj*QWqH:64WL>uE<rFs:LtHL(
7U:miQ,!1mP/m*-Mi&q<)2Hto4!]AUjEchbcUAU6R.-@[3!1hn]A^8e.jiJkd,/>lnj;1S,R-]A
XA)p)Vd]A-RHpUiKeGEr5LaPdq\uD\0,n4[.gu:3jqeBa1:F*%&<a'Q)^>k.gO\@C;(#7\ZG$
E7/Za,)!jQ4S5"=ZI%;n1GJD6o_$gZA?/QfdPAbS"U/Q&0hbS]A3&fO\eo*)@aWW%\hm';r6/
47V_O!C\%*g;?dJL@\OR;coaJIO7lO\'sGai1%@_m"F`0A<YMH@CQ4T\E]AGIFh^u)7k_mXui
.iu<^_"6Y0Qm+EPFA2`.D73!B:Rcb6<!d-7q#:PUG[c,C6FBI%SM1am8+/7#bH@!5#Y+#.TK
JV4Nam(Y?78\H`I26)l%m8>Y1Q<"c8:uG:;BU=,F7D^a`;epWTBFpe<1mj2eQL.",b.]AlIh$
lBC>tqVM*5`V,Q.V6ZLsa)`6kD:XN$Q!69BR!1cY8jegRb"K./09l5>:cbS'i'`YCcj'g_V@
XW;8&A!nP9Aa*6=G)T.#_$<-(Rra7'U_c!dIg#roF\ZPI'!;lX<*`a8Ns%j"KUcX\?8XRQsJ
pH^W3?KUG1r25eBMH_QSC]ADa_7\Vq-/6]AO]AQAkCC]AAZ;GQj(W10[mP+l5=pVMXNU5?S6:jWA
a1_c%nK8'.PrPCem!"VX,DtR/PTHd^?0[*K2&<*K\36Mf`J>A?qQNq;4oO`c5r5.6q6jDldl
R#[J*-S5-JJNV^pM<8BJ%FptYpN"r)$cYXPRc@B%B]AWXu>TE+[^[3!Jdle11;J#VtlIq:jnX
U[#4L.a3uS1]A;Y`'TYbQHW,$A3)3o)JHje`qS=\NNHXI#X.H=Ipn(<J`-hptl'R;EQ6@TeCU
OSh[`asIS(!%a^L5)J*[g+A`A@Xh>*Yj`>Arja/f.ZT*P>6'bo"Rq_NtR-G>5g,MqZD6ChDd
B)P8Ee4<0i$32R4(04JD_c%!FIg,@@8ZA_Q^LP,L26@"JAc,HO7OiMP#P,]A`_V?V]AX3=;4\R
8aU>W0h&3piSFi.R[BP2-"_l_G%<`DB/8uAE""<$Xb^GYQIV>[:OJ-9gnPg0<s0;>.G9?Hr+
*6imm;JS_Nq(31Wg>&2NGoem]ATmIbp)@]ApTCQq<q?]Aeb))jH5iM1GH9aNNmkgp!pU=ta^E]AZ
%9cdYa5uCUOo)`hEU+k=mKQ+^EokY&"`pP(jQa6jrlbK9qi'8?T4+cMaj""I*`6Ra>7FlW#5
?4*99hsI`rSCf9R8r^S\-R&W%4!b<\9nJ;h?.7"Z1`\M\7)q:ZseN?oZ$`@e#oJpY%"f@UFC
p56D:t;AFhQ#E>f`gSs<L9o<74VM.2Ml$hT^#YUO+)[=*;>e%P^ZHM!R&NNBQ[GC[l$`L[J"
UXeXo-dQ:r=MRde<<0F9=9nP9XLpV\=BN%9C0DgGf+(pj/"3<5ph6m/Km;KF'L'Bp=R2Yig4
l_Jo;X(`H]A51.k13JdsF;lHD_QoigOusRP6/V)FPGD+eLA`m]Auj/Z63N'S``2I#eS?!G4UUn
7G(8=G-'UV2/3YsVF,C=3*prK8`-HC4$F9Di;lOQ]AcKJlnbkUikL/(qNj=]A9-@40h9(kmLCg
VS/ppGd<3VK=-YN#dI,H:I4TscSNrG[lXc4aktP+I$kh#@]ANGcYW^*A1&C/Xd2rdsq3L1Nkb
rm8"`rb%Y\"Z:Aa*io`^M_o3BIp'/iH?+dDIXg89q@k,;=ar`cbd!uIIh(X(R".F5Hh:92Z'
bgP)iT'3e2)a$jBZA*5o/9_53+ZYk_Z'%QH$Z(JeVdJ)UtI'QriVi;P53[JK\9u0JpS`Xo1T
_ZftRK+b&t(K\0YfMs22%lI5Ba2F!0,h-97&CokdmfZ#WQ$.AZkC0'!/t=JH0sdLDX-NRK+!
i:kcNqR09Meeh[0LO;=\:.0oNa@r@0[kkI2X>*;6mi6jZc]Ak!7)5f8kYd@O4l<nc6+W&-D\!
#eFj9>A$5!*LmG7%]AWEr1K7V5di=T17AscS#@[J(<j081$I1g?A'L#OZ'[7#00_K*P>T4&3N
FkqQ`e4hC`%/K`PYle/saC)Y'A1^^sfkgW#ar[KlZ9:%-2$)PK-Wom,(Cl/GoV(<s3@IGA+`
co0O"'[0]A6TVSB?P1)8)J?RpP2flaWn9XuXe81gEpX.F#3.6n,Jr08:c(09Gq4Q,:c,s.gGl
1'p=CWun1"0f_>5Pir'Z)tAC<h_3UHQ*]A0@r89Ri_uB&P+p7f(mIB*2)e@TA:\%AI5W`8"VF
j`m[SRjM*GWcH0WkIHL$9@S+6nfRkLP1A%G'cCj]ASFh7Z)Fn$c``Jo.1(t^.4b]AQ:"JHt!]A>
SCd'5n^",mEs21(MG$6eumi#"flmLmJW/+KHV1Atam75W37iNWk)E7+kIebtSMg8":INW!lB
6W"jRV]A>+0lDA<pZlm\j/6A,Yq+H?2YY,2-`knOl-4PubEehp>1EMhlr]A^V.c&Sc%daEpZV!
\4EhAJk?ZQgj^S;uF3ZML,OJK%^:ahVZErgAXhtJV5pUas86aET9FFoKi<II,,#lK!nq,-]AF
U#AH0.P!T@^m9Erm/jAI/YRCd`,F"i`1X)?'B=iVgFL/!pjAKG9rm,2eo]A[gR<[t*YqENZqt
pTNRjq0[*A+_^-fO"LW`&Z_JEMYtGi;!mLkc]AYMU@%F2_-%/cYW%c<QhC"/7C#R@ZeUmS8^]A
:dQk4.1V?s_]A7gQ>V)CR,A\7+k'Lb"FOd:2I$S9_5E5g#,\fR<!FqT(0I@aePjI1OisA,^.=
P(9OH*=onYd>go1?Zg\"B0->:m<;`F=$F7YTa]A$'(,`!N]AX%\_\rIh@bWN=P!foeM-i*lbb-
\8bB"u1:(eU"SmZqSn@1Dt>P?ntM&<W!7hi]A3bJC%df*eh-'[qTg:,")qK3AUEIoP+,S\6JT
.Z1L#kXCa\`>Y?grkPN1BL6eoY$J(SBK@0G[f>QRp9Q(%`a;F4&+\Z'6"'G'M&RR;EV6JW2,
i<.R9GG]A3LMX.pc"8R^uFMgj?RDK*TJdr2EaRk6a%\n?pQB\q6=e^AW1NeQFOdtFRdqSqlUV
EqPEUtH=2fjA?l>D29ZV!i)Y`k=l-h]AOds(ZL1oPHjZKMVQ$X\4n`OP?qVTsX'nf[q:M!\,r
C2=TfsSMih@5.@td_$QUDCL`1<nYsW79JuKCK0-?%(@=ggpLCF#'d]A=_FE/jpq>iLn^MhGTY
9BAJaF"q.M,0?:YI&?NPcCnggX421/UHD5Vg%Li`<7/ujI5tmF>8Q\(#.66f=k(f(MuuY)pe
qe8>sPrnKL)*f@,^4mgb\u:\DDuTV9XYlbR3UHIp8e*6><H,UF+32%GQ=3<F.72D=dD/$7-a
.^cL2A0H6Z`d<IjA=[0,^<Ybo`T0=+,J0j;2;j]AKCd./Nr^'X^Ui$gp`OJ[eRj!@Xn8fN[<=
i^,0`k?IBbZDo:J006nFq''^sYXhLu6O!^@VQ^-3#3_mm<9W4FoP6d.QF*.2jM/aS!Zk8H9Q
Y>]Aq)9I$orTn.,181#4Utdg\8rl;incS]ALY*\[mO>Ht7?O..$d2So$Lc2F"3+1(Th2of1>U0
kCjZaDEl*p"4t9%Q"#?]A[3_[T5rTW4Jl!#KU\7`c!YR\a==Be4ArL1.d/pT6a:K\!cdp?S8o
nD>ds;@!FQgf)28W`gpfb\;#dP`U6aS'+:3m#2"E:nHUh6U3U$A1JFemWP@'oP]A&(:YK9L_r
1R1/]Ad(V51T8_OX;Y,!saWM'7,)*kqd5rDlVXC5(.L8UJV>ZNA3r15_j]AE"ZRAl;N<NCB#SC
IJgq`,`:HUKkKH$H._!X_.h9OR)Lf\'VSg>a.eb;_V^Sdig$Q[[&`%>/;H@WY4,E6Ba@?dYZ
^ZYp=mJC4?&pLSbOGO1SNEo\=9!2I71c)V.n+@.eYX3b%fBXV&F`COS0JKOB3=gPY\F!11ai
'hJ.."P>4,dMmbp>YBMA2J@sB>BMQaF;_U\hK8$EiK;*Q<[$j^6DTt,"9L6R.e36KC\qY@B\
F9k^SgH+)pJ8k6;>"kh*N_q,Yf&GDWMA3=tiCUs\]At@=[f*&9>D=N/EM<_[Be1q+\R(b#Zjt
5!U)]AdVP#?9P(9%7-=pgL?A[#MA`+S/L\<)(BA6!m(M&kjU6*G!ROSH""rs:3P\!OIOJ4*qD
0O6TbtEN]AN_6F4D>Yk<)uKq:)ChH8b#0j1UiepcqfER#Ge8(nk4qND*,[Uk#oVaLbU(PdDpr
o1bre?0,efS%GHAQ/;SS[gjO,m7#b5)-)*Ak?pfj`I,"mhlO:I`UMDp7C;DHNelfD';htIdA
`O"mh4:4iS]A(MF&r]A[7bfGL0s"h1:f=(MM@e#qdR%omd8!fmg,Z+PdjtjW!K<NUYS&"!W"%>
C&(uair]A>%6dduLMc[2r8#?r5$Vo<;`hI[9Q9ftj^L<q.bAiQ6CJdJqA=qBZ`H:#*c9Mg:u#
fS8:GP`%9qi[B.nKXi2=p7"oSs"Pb[GDe%X1!^7<Ma:uc.NONA4*EdBmP<`.2WoB0hQ/p@K1
=^ECsP:h;j_`\5eB@kXoW-`YI1k\=DS!>=m_]Ar3LmuISAR@W_`=7)3LmuISAR@W_`=7)3Ln"
eJ(S4F5dKO)bf>!WoqM<<cfTlX^U45rc<@DV#Qf_KbF/Y;"g3e<ci<sL@o9o*7tG5Olcd3Jq
g?/\fb=AF^B"~
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
<BoundsAttr x="0" y="0" width="360" height="126"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="89" y="162" width="360" height="126"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_CFC_NAME"/>
<WidgetID widgetID="64e06c35-79fb-41d1-ae99-05eb62c44e21"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="CURRENT_CODE" viName="CFC_ENTITY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_cfc_name]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="778" y="0" width="190" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_CFC_NAME"/>
<WidgetID widgetID="5cf4066e-5c14-4e90-ba74-828b1a22ad0e"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("CFC_NAME")]]></Attributes>
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
<BoundsAttr x="810" y="46" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_CFC_NAME_"/>
<WidgetID widgetID="64e06c35-79fb-41d1-ae99-05eb62c44e21"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="CURRENT_CODE" viName="CFC_ENTITY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_cfc_name]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr/>
</InnerWidget>
<BoundsAttr x="810" y="81" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_ENTITY_"/>
<WidgetID widgetID="64e06c35-79fb-41d1-ae99-05eb62c44e21"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="CURRENT_CODE" viName="ENTITY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Entity]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr/>
</InnerWidget>
<BoundsAttr x="600" y="81" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_ENTITY"/>
<WidgetID widgetID="64e06c35-79fb-41d1-ae99-05eb62c44e21"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="CURRENT_CODE" viName="ENTITY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_Entity]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="582" y="0" width="190" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_ENTITY"/>
<WidgetID widgetID="5cf4066e-5c14-4e90-ba74-828b1a22ad0e"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("ENTITY_NAME")]]></Attributes>
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
<BoundsAttr x="600" y="46" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_EFFECTIVE_RATE"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report4" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetName name="REP_EFFECTIVE_RATE"/>
<WidgetID widgetID="cdd35233-c2cd-4373-b174-30d90ed1dfd0"/>
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
<![CDATA[723900,723900,670560,670560,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2592000,2592000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="2" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("effective_tax_rate")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="3" rs="2" s="2">
<O t="DSColumn">
<Attributes dsName="Rep_ETR" columnName="TAX_RATES"/>
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
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=FORMAT(ROUND($$$,4),"#,##0.00 %")]]></Content>
</Present>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="4" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="3">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="4">
<![CDATA[#0.00%]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0.0 M]]></Format>
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m9"X5P%iZpVJ0D-c^>P)Ze]AZHgeq'c>2?KT6I@MdLKqoK6(hp1I9Y4#7a726QV<+_'N'EN92
\&2;FD3K'LDq%'L]AA?I&H+toDS@\nU9SKc[g-s(Vfk+I\,l9Y5A3(^[&URiqUodbLS=&0JHV
nH0im,"+u<D]A'keNg6#6gcOg83".l*>%\-*C)BUl-/l$qd9dhr93fuWDXgmoU]ApI@>gibZcA
-_ArmqR'7QnS5[bLZ4n8)r0s%Xc#AJT@d6lU&"/"QRsc*`(\tiP$Zd\c&)>>r'#FmI;cL]AXd
m;Fj7HQ:S3+VQ;GLZ8M!W6((mMYV+:Y,/Y[IKWC-o[-0p5fJsIg>G+n'T<EqH7I3B;-rj@<n
rmG*;"lE\SluMpQ^u4LDS\\[hIpTM?.g(Epf8S9cp$D\P(iK8_,l-I0U^NF;.PBD@1*rqFm5
Y0LO5onpGWj"QAV">ZM(#l%p8pd0kLl/j<r_3%\PHe)&[WrCS2b6mQ"(qq<S^\0DLT*oH(o.
9+KmN'PQV"%302QuI$m:Qki'u!N]Ac2>&h0GAm#e*Ao:V^$Neh^BApRF.4nK=0_^D`Ll[p[=N
`LG)2ko*AlL=@M\m-1B]AAK6_IPZ<DpZ7,Kp.jD!l0@cG"JV0\EHW/h\7MAu%O-]Aq-:U%`FdJ
m5<ge%TH#c-Ho@D&0XsVHAqslJ_]AlC%,nS%@LA18`C):P-l*OP7J]A2_+M*O,->=^5a`ljSA!
#8iisO^+$$B59l0NCpcZ@dF(LF_2&GRIlBg5S$gB+=oM`V'.Q=h=e>;OAK,kDig"_9pcmk>6
XPjQO8K]AR8HB+m\kd*Z_nWl[3+HMLqrMrk7Ck#J1:g6]AO$A-/@Gnj8HFq.e"QQ)rp14HAf$D
NZ;%r-:9<)3^?rC@W&&e<ZB=A"N&)BU[$mCH1iK3Y0EmZ#bN%-GQM'@,T@U9Z9)0o%$<B"SQ
Hd"9[;Rt9ZHI#P%<#ouTh4`-fga0"mMNM(2K4kAKi]ANmARukIQ4sYW>`p92OT>d'ZEm6\4I@
3/O?91'\E&%l;TrB*eZclWQ<fgG(*?RZ:5'+\MUkTuo%\^^S;<8e1Y?RXZG#D\Vr#I+jRSc'
NBg0P9'2/AGQCo/8*/p:KP7Sd[ec)L0S,Ejedb@8hDVfDn%_FdPKsul".GB#58$7V=$FP[e6
:uaN0?dU:N,'t+c$F3&b5h-jm&D;V^4I*VIqb??kQ;V=%p^^D\Y_>h@e3&&DmQ?Q,j+'g"?#
Z0YkVb"iT,eH65En<u5m4C[tHb:3:U/LDkYYam4g4i@$g5p901@MS#inTGhtGKmEf8fq\(/^
Ir?3V.Hn<SThQLX7=YEI2tXSADn<?i#7P"b<\6PaUsHJOa]A`GA,N@jT_^>LX[,Nn?Xt24P*3
@Ho@)JO+7N4%;lC)i]AIVhsBde]A=jjDGAn%Ga./4?=p<<eH%%<4:pF)p[TF7WZN`XF.:40>d(
Ip?4!5#*mjFe,]A&R"70ebHi_ohK_#Z,;gaQWi*f7g(4mk9V'CDN'`@g,DS_#B<a=unQHRk*j
L?sO?:4EfXk7Pdr2[UJ+GSXj?RLR/Z(Hd5;S-*QU.0_DcZ`0!&g@,M"/2?\#2=6(>7nnY/uD
<km>"'cKCCq"a$9)>6lXurc$=2[b7@O-+H+o[]A]Af'`Y.WiPNM^3VsO%E.ORg@M(M+om`a1,I
m5mNF.t=IX^K9#)<5`iH&2C!67RXW^8P$Q.S-(Ss$qfn[69[M(Q-F,GEFgn5+*2kDm5M!m0=
?;@%=$_YUW!r&*8ipF3S7W>TM0GZ3k%;%cp-EpkQ9jfX7J"(>s<H&o8=m!X3,!7"c^Lc78ii
+lN"ET..eX\#$"V!or1Qpt<uE(oDHj(Rm<04bKsg5?bk=KTtJ<k/M+HLd+,!FXdFX8:_d6-t
sY:WZ)?1h%?bOGHj7L15M:%'^@Om]AC6WE5(5a.GC-9AcLM)7.OWpZ2'=)Q"[<k[q@7t;eq_A
Cd;l1I\XTWOeb`a1kW(T1e.$!sU^a-Z$D*:g\-g+aTc948]ADWZnjZ`_Z4^TrW\St")p#/6b_
1K<mo['2]Apg)gVqrl^J7r[k21VA-%@me_#.^j1dEW![m6;KdO'[b.:>]AHk`Z2A@D'Kb(g(s"
.`l]AGO$A5[le`/\HK;;Gg,jjWTIBtSIJY*`b!TS+=1os<Ia7p]Ai@F[*hik=b%:]AbcJ1<?AL#
R5<B1X8->0YDOun2]AE5P]At5+1N"1+ho1tG=7j5dm&gCQdB`G;FM3^g79?X0DX,WXb_?)4Ri%
;KK4o-8;b:k*KO%;O8np:OnI_&A@p#/.@SJ"freeREm1A%$?cQs*n\V(!m81b]A!M#99A4Hu.
[I-"YV[okTF["ratW=kRHAJ7a3h$BY@7HWClF5T(cU8jp\_c'cIlC7B_fe58VY>F&(m?m-9P
F$tiaA<t]AXSTrPi5$&0JS"/m/bR^hQB"nIXc]A\:9u3`=[LBW?0*m_:Qf1Ab[U5Ar]A'8-Zb*;
0L-BJ/Tq*b#$o62E5Gc=B"_RC@j;un^g&E;7uT[p"GEl[(6!1!`ZaSMQ61Za&'5u^qS[#E+-
9/WU]A-ZK0>"0PLe>NfU-8>4i.m`L@&ks,/NFHbq.#iPG-X0+t[4;pW&W##0GiQ\<Z0flln=$
Su15+W5bb*sic#Jq0#P9Lid6oU/ieWf.3V`N(b\5u:-<$4"9)q#&<ismH`_4"X`-$Qr"O$3r
HP`q>_:0b>_LGVM0[7e%]A9$5=tM!BD1R,,04(a^0<;0h!?TrT=j7Va-G*s1(5951eiP-di-'
_aLUht-W$"\p?r/OT_D:qV@P0Ihfn<LF/rRHlh:FjBq,G8R;VM$8aiUk4`/RHtNSCuu5PhZU
VAm<$j&i,ctV(qN/cbSGjUh8ie"=ncucK5(B@+()Tp\bRGo0GYYO0?[9m4$j+j@7\s@'2(cT
BZe$P*oajJpt#L?n+1O6s+,LqOU=26^p=R.&Cs^>WB7>?&=Er31j'52U]A2Od-DKbjR?"X?k$
*]A5.B>O1RsK,?#(MdorscMT(+7o`H?Rqn*e*H/Y"h49(3Zi;-l!(g7h7Q)*,6bN7:YSu/8A'
]ACAbelS!NS*^kO'=L4]AU,0R%CIc?3&Xg_I';DKfATk`,<!i%kcBapCaK*cA:$7)RecVt2T))
EQnngH*^dJ:\E/<#1)V[kWMMQ,:b37T4mQAclPUo:j1EiGm_D3+!;M+DR=VJGKiKf>>21[#g
6:I'qN:b%qba.M)?r6pB;sr!`H0=WMsV,dEm.Q6]A(<V8>le;^7hboGW544*&&`csC$U*$P"(
Rto[jZm8"0RQLM)aHmtlODlY+kd^aSin'<m_V>MkJda;E@fgUJ!rh3W[s\GJXg\3U\I?O5Oj
3>-an`;,fP!b1k]A6ZJ:Mg$r&n1qGaV><8EpEHTc%l$dPrW#b<Og(R6Ao]Ab6+jDh-8un@@hgW
F!D1/ERJaE,(qp+or$BLrH[NJWIGF5Y%Y+65^([?PhU\DXe4d"$j1G6"[&cT6G,nC[c.X:io
?Fl.hsW7aa>I&NE=Lm?k.LXr[=.Y_oeJ%EXWESn.o06FGJfYt96Z_I4s%`@0#gg5I3b_-/Mo
OuP*d!$i#$7%Ej$a+PBPgA'5aYiBD@8f!]Aida>OtH%p@.']A5>nL3\"4j!J!'Y>f:TY?haJ?j
<>qtofMPZ3pJU>U)><fnY<Z526e\OumVWTg(1(@DrR6s1gESl%E.4(L<FnWp.PO[[E-4boR;
9!sdeE7B[:^:>OPlo=9:N*@pu?9k.R#b`a6gV;/qY))Z9T@R;m1ba4+i#HT'"O>XEA(?6sFQ
.]A]A<4/p>Yu4s(1PYBYV*uer^\N-;W83m(F_0_0;jXMUcl9%pXU6[f)6@RiBj'?gd[Bo[D"Ql
X(\oZ7>jKr=;'&\&g==g_RNSFjbMU\/%7k\CBCA\"J!>p2?QD^G2O,jiHc6O5767[d/&2]ACi
ml:;U'mQ9^,gopr3s?!L?jP`XrQ$6-FI\#,_K6*l@79:MLIKr;$WW#jd_eFjGmoqP_LEr\H!
R<Q*5P/,r4i<J*R&2bg@9"HoY`Snmien,2JX)`c43\nroXUCK!8TTM-c4p[jA(=13gTru!eL
L$8*r%O*-s<hP\I;=LYSNlHUIjAoIk3uK7.aQ=/,#ZnlFE[4I&9JQ4u#noLaeVVL8@>R,;)G
_?Hp79@9lE2)`@=)\\tIQrPSON$FZTV"5L?MIV6!r%;l<:1`.!qfEb*<V[!P8>JX?+il--[J
Ja#$Z_d3)aK]AcVY=,9jfoZ`_$Pop<gHtEL%?W-DD99fNa>Pta#<*c)F1,2tNgt+HO;)p?@Pe
<lNdORUU3</gZq2qIPNoRsrr(MB)E60#d1ASSIlmVP@RH1VWB/-ioWZ@2V2pfT\9Zd2;JbWa
R-"N=J>:,Vde!&@k6n6hNUkA0bB(gj_AS<1J>I$@lq9;0**X6g;U7/aFHV??^NC^r:"4\m<%
`qqhj63<DI&2C@Es,!i8^O/q)WAp<U'_8jU`Q.LLN[Y^dTssWQqqC5n+U7N@f1hF8K#;/Saa
6)Paq=![5*M[D,O%a1XhB5TX=g"V]A'EVKL(g^1heY1sOR0K\egPOd087Mfl1?H2O\F^/<Jn'
VP#7g/%5jo;jQ<;&iQsL!at`2;+:5MojU6pc:$$@l1Nd%M/XbUZ`L!7F.5M4=kiV!9fs8[.^
/1Z$q11WW1ed?3:QYF,pgg,4pQu0@1=!5&a9&[b"Knl@"$oE8T:)]AgmtM%\i_)W^.)(q&(,M
5LC]ABJ;1,aL)+0ep[?1^51X"gq_Grr2f(5PU0=_%#]AU*]AJl>YN8J3P-#;(Qn,5Lf3g&%YHUA
>aSije'W;aLr<5q$;22-3Zfr>3=N(Sj[o[;6gL)LPkmo!Sm=R_YcYnk:@H86rbMo^jA;"Y[d
Rm,kdT<bQ@-<I#V"`Rdno/ZL)\j3&Aqd.$Tc8qEaE\0S8/Tsh,gpB2I#CSJ%p4mR'Z86&rA4
3fF2Wdc4'U;eI'Q\8GQ8IgUE?Fg/7(X2*/5W%6Nr;\ctgc]AC#WT)!i8(dPpqA$WfA2$"<_]A.
VOLt['Z'R<L,b;O,oUI.&mW.!*F&90'u,t6<ROT+BDdrfUA/lb(m9'(d_9a^`:%bAQ_HNG]A*
pe7^7)ETcuU-LlbaYo&l:pn%0#+e:Kblk*0$u+%Q%EM"^%/)8C]AkZlH4;Yt]A]A`q*MXIi,l>4
4=Z\S)hfD:iupFWMHS<dj7?'(1\K:bA!Z@A*:fl#'_"ddZWFq_7SWiO#]AXT"3Kcp:a,2=Xlb
nZ5;?L-h_E)oncs#m#r$$r\kTABN';kkr.P308nf,RAJamD6.qV^RbqB_W+PTdp#VFD!k4SQ
XZ!&S=qLqV(,n5Ou<#SL4,CmAp.m:IoF@@[_tL.bEY@5,bnsCZZ06:*JtF"7b(XIlkD=%$\H
Pk.QQLe+s?E<7(]Ap4M!]A91-cDVPQI.kZe;0Z:.=@[eD?[C6B]AZZtR2RMFU!T%bjYH-g]A@S\#
`8oDK:cn(K'9fd5^59M%0sEiV]AKK081W+f,i51f/-Zek<D4-3K)17P'C94S]A4\k'KS]AB**5`
hl4:Yj4*UR)QZ]A5puG*dA/7fYTmr0TWpU<%g44+T`Ga<UQo42.rO0B#44ET4V.Q`'b&>S*tt
3)'s+<7VR,,qBT'K6RMo;fN?ZhYXhH%cY8+)kVoKrMt7(S/Sa.?%P978!8Jl[F/q)6.'/%QE
Y)-BMQ/@F`4`[.QL)!1S`0mu>d[Z*&5A5<;,[f@k&r,[-=(MWHl%R`PWTEYO&Ls7+#71P&jp
T^(chn\16VV4X)>Lhe"7MXZkDMgm'008*LIj%#KSY!<qc5$Df!9<kEa'$D<%h5#>UU.eafgR
:bsb(RWb.KRVoYH(uM&Ko;o+t]Ae6UDkX(sehaG,<0oWmQg-a$4>CGYGCmf^nG444nqY&Gmn`
/-9Q<grCgBmiaNRPluq@(j00@8@]A#;sQnSa1OZCLbF9Rg^)EAa[fiCP\>SSq_m=DN?`c+L(4
EIu?nrd_bp0Oahg?;;-Ot"Z<*n!m35??FSU4N5AWcF(Ka:Ns/+]A'-A!&3/AVVCZ?&XqXh[-c
TuqZ"Tm.7:/*qqX[$"fXD?JdQr`pA&NPrgX8Ts]A!19Fo`r,52NkZO('$J-"#c.gqRoL<Bgc_
cUl6QlW.!A\8#WW9fb&+fqe3[ef923tH#P#IP&%":;rgTBA/1k[,H\c[S'#h'=HtZJXJ_2p=
?H_1;,+PT7JA;Rd-&NcH$SN3jN8Cid,W@k;*HHWIA(V]AUaY2'_kFH=1=&%.#O!+#eR8M'N3Q
_9OjcH-"fSFE\m(R\<LAB7X`E+T/5QU+31Uk;Bi*[8^O2Y^'lq4.uDrm"s^E`enY&jn(/:><
p0(W0ga!5Np<<865$:Q2-h+=K*]A*#3,.*bA=)WX-/#-bNMDnrg\LbR+",@JL',gj'CSmE2K'
jA1#-K]A:1H%@-L-/nl&g.09u-5)_7Q';Rl\h*$+ZAGgC@ZoNPZqW=1kL<RejUJO\f0Us8MKH
lgbY3@mCjdE'"O_pSS8Z'm[4I[^08A=2f!d$\eCZ,4%Lu)u"UjG'!\nZ)pgD)k\.s]AIL,N7s
h)G/WCf.4"jG%ic^8E^0O;))\=l!d=i\B;<n_Ye.l8kd7ir&V3KLY-<9?NN?^4b'md\[jnTm
G/U_CLfASa#DA"nW9g;n;B\.WktM:91^*&qtBj:;Vn-VFeJU,HH43J8OC9Ap(f"h+TstFO;K
_RUf^EB?m\Yo.SS"SFTY?K;mCl\gfTDN-Fe3`7=NDF7gXsF&C=FiiE"n!9_FSM4EhD_JglB[
?I9;ZRcSs,6YI,g-#tO@>aUi_\qM*W<4]AjA6+tWM$;]A!l?=A@3F<r!DHh"Z$j\E"6oG>2aZO
1@09HB]Ao-h7/0E8D:hR[bUO!UU2UuXmT@!,mKRfW[enF!\qZ<5qF<;(ig-h>>qUG#b4if^Zs
I"/L6_pfuUjPY5H>-6G1c]AAfi5pP6ZJWH)9G$\P8B083XgD*C[=NkZhM@1M=eFRAOOu`f&If
/JAZ?WP/%A*ZbM;3/T["$HSNDfdrEm)5-KYD1V0GdMqbR!E'>^ngTR(rO.T,=)58:qf+\GhN
ojZNDUqE&*NOW.YLf)J5"rng7^cC(NP%ITcuQs\>dW3/*j%#kI/O3QWJ\bfN;*>6>#N,W(mB
0&7qqCP8ui/N7`f;E!4mnV&&eKOQ+e$JWu/^a@o(7j7_bg3TiP*Zb"RDk^HT;+Dr"X">AoD3
;!A$=2mCkV,oH]A;.S:2^(Ok8S_k]AKSsrIB*8k;ru!F:=O`am+H9QZhl]AGXkr?FhWh6"lE/q.
Xkr?FhWh6"rl<[ubs:[4YB9pP1dN^18)A`*E-p@;+'oq&Rig6L4k)h^e3cCK6Trpd4k)h^e3
cCK6Trpd4k)h^eAHc7\6h5"q((k$Wt.$(E:DF/g'_!N>[OGA]A[$,]AcM[^YPL%0Z*KAOl,s(+
4q"Q$)%mOCtDZ~
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
<BoundsAttr x="0" y="0" width="421" height="126"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1413" y="162" width="421" height="126"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD"/>
<WidgetID widgetID="2d9500b6-3419-44de-8980-c9f04caf76fb"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy-MM"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=DATEINYEAR(now(),1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="390" y="0" width="133" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_PERIOD"/>
<WidgetID widgetID="ae412ee3-c761-45b7-afbd-af33b5b4a915"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("PERIOD")]]></Attributes>
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
<BoundsAttr x="390" y="46" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD_"/>
<WidgetID widgetID="2d9500b6-3419-44de-8980-c9f04caf76fb"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy-MM"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=DATEINMONTH(MONTHDELTA(now(),-1),1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="390" y="81" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_SCENARIO"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="SCENARIO" viName="SCENARIO"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_SCENARIO]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[Per Audit]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="981" y="0" width="126" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_SCENARIO"/>
<WidgetID widgetID="5cf4066e-5c14-4e90-ba74-828b1a22ad0e"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("SCENARIO")]]></Attributes>
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
<BoundsAttr x="1020" y="46" width="180" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_SCENARIO_"/>
<WidgetID widgetID="c46cc176-c4fd-471b-b0c8-6a099e21a097"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="SCENARIO" viName="SCENARIO"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Dic_SCENARIO]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[Per Audit]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1020" y="81" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var P_CFC_NAME= _g().options.form.getWidgetByName("P_CFC_NAME_").getValue();
_g().options.form.getWidgetByName("P_CFC_NAME").setValue(P_CFC_NAME);




var P_ENTITY= _g().options.form.getWidgetByName("P_ENTITY_").getValue();
_g().options.form.getWidgetByName("P_ENTITY").setValue(P_ENTITY);
var P_PERIOD= _g().options.form.getWidgetByName("P_PERIOD_").getValue();
_g().options.form.getWidgetByName("P_PERIOD").setValue(P_PERIOD);
var P_SCENARIO= _g().options.form.getWidgetByName("P_SCENARIO_").getValue();
_g().options.form.getWidgetByName("P_SCENARIO").setValue(P_SCENARIO);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="SUMMIT"/>
<WidgetID widgetID="26a80f7a-b0d0-4aba-aa84-ce38e1218caf"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=i18n("search")]]></Text>
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
<FRFont name="Microsoft JhengHei UI" style="0" size="84">
<foreground>
<FineColor color="-1" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="1739" y="70" width="120" height="45"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LAB_TITLE"/>
<WidgetID widgetID="190c96ac-fedf-4612-93a6-dcd634263137"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("cfc_overview")]]></Attributes>
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
<BoundsAttr x="60" y="46" width="300" height="80"/>
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
<BoundsAttr x="0" y="0" width="1860" height="124"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="147" width="1860" height="124"/>
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
<WidgetName name="REP02_c"/>
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
<WidgetName name="REP02_c"/>
<WidgetID widgetID="79eb4fa1-4df5-4ae7-b4cf-bfe9fc602196"/>
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
<FRFont name="PMingLiU" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
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
<BoundsAttr x="0" y="0" width="1860" height="354"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="278" width="1860" height="354"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP01_c_c"/>
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
<WidgetName name="REP01_c_c"/>
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
<BoundsAttr x="0" y="0" width="1860" height="428"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="643" width="1860" height="428"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="REP_EFFECTIVE_RATE"/>
<Widget widgetName="LAB_TITLE"/>
<Widget widgetName="SUMMIT"/>
<Widget widgetName="P_PERIOD"/>
<Widget widgetName="LABLE_PERIOD"/>
<Widget widgetName="P_PERIOD_"/>
<Widget widgetName="P_ENTITY"/>
<Widget widgetName="LABLE_ENTITY"/>
<Widget widgetName="P_ENTITY_"/>
<Widget widgetName="P_SCENARIO"/>
<Widget widgetName="LABEL_SCENARIO"/>
<Widget widgetName="P_SCENARIO_"/>
<Widget widgetName="P_CFC_NAME"/>
<Widget widgetName="LABLE_CFC_NAME"/>
<Widget widgetName="P_CFC_NAME_"/>
<Widget widgetName="REP_TAX_PAYMENT_c_c"/>
<Widget widgetName="REP_TAX_INC"/>
<Widget widgetName="chart0"/>
<Widget widgetName="REP01_c"/>
<Widget widgetName="REP00_c"/>
<Widget widgetName="REP02_c"/>
<Widget widgetName="REP01_c_c"/>
<Widget widgetName="REP_TAX_INC_c"/>
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
<PreviewType PreviewType="0"/>
<I18NMap class="com.fr.plugin.i18n.bundle.configurator.data.I18NAttrMark" pluginID="com.fr.plugin.i18n.bundle.v11" plugin-version="2.1.6">
<Attributes languageType="0" default="" backup="en_US"/>
<I18N key="MONTH" description="">
<zh_TW>
<![CDATA[按月]]></zh_TW>
<en_US>
<![CDATA[Monthly]]></en_US>
</I18N>
<I18N key="tax_payment" description="">
<zh_TW>
<![CDATA[應納所得稅 ]]></zh_TW>
<en_US>
<![CDATA[Total CFC Income Tax]]></en_US>
</I18N>
<I18N key="business_tax" description="">
<zh_TW>
<![CDATA[營業稅]]></zh_TW>
<en_US>
<![CDATA[Business Tax]]></en_US>
</I18N>
<I18N key="gross_profit" description="">
<zh_TW>
<![CDATA[營業毛利]]></zh_TW>
<en_US>
<![CDATA[Gross Profit]]></en_US>
</I18N>
<I18N key="mom" description="">
<zh_TW>
<![CDATA[較上個月]]></zh_TW>
<en_US>
<![CDATA[MoM]]></en_US>
</I18N>
<I18N key="effective_tax_rate_include_cfc" description="">
<zh_TW>
<![CDATA[有效稅率 - 含CFC投收]]></zh_TW>
<en_US>
<![CDATA[Effective Tax Rate(Included CFC)]]></en_US>
</I18N>
<I18N key="title" description="">
<zh_TW>
<![CDATA[稅務總體概覽]]></zh_TW>
<en_US>
<![CDATA[Tax Overview]]></en_US>
</I18N>
<I18N key="actual_payment" description="">
<zh_TW>
<![CDATA[實繳金額]]></zh_TW>
<en_US>
<![CDATA[Tax Payment]]></en_US>
</I18N>
<I18N key="period_paid_amount" description="">
<zh_TW>
<![CDATA[當期金額]]></zh_TW>
<en_US>
<![CDATA[Current Amount]]></en_US>
</I18N>
<I18N key="gross_profit_margin" description="">
<zh_TW>
<![CDATA[毛利率]]></zh_TW>
<en_US>
<![CDATA[Gross Profit Margin]]></en_US>
</I18N>
<I18N key="search" description="查詢">
<zh_TW>
<![CDATA[查詢]]></zh_TW>
<en_US>
<![CDATA[Search]]></en_US>
</I18N>
<I18N key="revenue" description="">
<zh_TW>
<![CDATA[營業收入]]></zh_TW>
<en_US>
<![CDATA[Sales]]></en_US>
</I18N>
<I18N key="QUARTER" description="">
<zh_TW>
<![CDATA[按季]]></zh_TW>
<en_US>
<![CDATA[Quarterly]]></en_US>
</I18N>
<I18N key="YEAR" description="">
<zh_TW>
<![CDATA[按年]]></zh_TW>
<en_US>
<![CDATA[Annually]]></en_US>
</I18N>
<I18N key="profit" description="">
<zh_TW>
<![CDATA[營業利潤]]></zh_TW>
<en_US>
<![CDATA[Operating Profit]]></en_US>
</I18N>
<I18N key="ENTITY_NAME" description="">
<zh_TW>
<![CDATA[申報公司]]></zh_TW>
<en_US>
<![CDATA[Entity]]></en_US>
</I18N>
<I18N key="billed_payment" description="">
<zh_TW>
<![CDATA[帳列費用]]></zh_TW>
<en_US>
<![CDATA[Tax Expense]]></en_US>
</I18N>
<I18N key="yoy" description="">
<zh_TW>
<![CDATA[較去年同期]]></zh_TW>
<en_US>
<![CDATA[YoY]]></en_US>
</I18N>
<I18N key="value_added_tax" description="">
<zh_TW>
<![CDATA[增值稅]]></zh_TW>
<en_US>
<![CDATA[Value-added Tax]]></en_US>
</I18N>
<I18N key="tax_inc" description="">
<zh_TW>
<![CDATA[認列CFC投收總額]]></zh_TW>
<en_US>
<![CDATA[Total CFC Investment Income]]></en_US>
</I18N>
<I18N key="PERIOD" description="">
<zh_TW>
<![CDATA[日期]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N key="business_income_tax" description="">
<zh_TW>
<![CDATA[企業所得稅]]></zh_TW>
<en_US>
<![CDATA[Corporate Income Tax]]></en_US>
</I18N>
<I18N key="ytd_paid_amount" description="">
<zh_TW>
<![CDATA[本年累計]]></zh_TW>
<en_US>
<![CDATA[Accumulated amount]]></en_US>
</I18N>
<I18N key="profit_margin" description="">
<zh_TW>
<![CDATA[利潤率]]></zh_TW>
<en_US>
<![CDATA[Operating Profit Margin]]></en_US>
</I18N>
<I18N key="net_profit" description="">
<zh_TW>
<![CDATA[淨利潤]]></zh_TW>
<en_US>
<![CDATA[Net Profit]]></en_US>
</I18N>
<I18N key="by_company" description="">
<zh_TW>
<![CDATA[各公司]]></zh_TW>
<en_US>
<![CDATA[by company]]></en_US>
</I18N>
<I18N key="SCENARIO" description="">
<zh_TW>
<![CDATA[版本]]></zh_TW>
<en_US>
<![CDATA[Scenario]]></en_US>
</I18N>
<I18N key="TAX_INC_BY_CFC" description="">
<zh_TW>
<![CDATA[各CFC應歸課之所得]]></zh_TW>
<en_US>
<![CDATA[CFC Investment Income by Entity]]></en_US>
</I18N>
<I18N key="CFC_NAME" description="">
<zh_TW>
<![CDATA[CFC 公司]]></zh_TW>
<en_US>
<![CDATA[CFC Company]]></en_US>
</I18N>
<I18N key="effective_tax_rate" description="">
<zh_TW>
<![CDATA[有效稅率 - 不含CFC投收]]></zh_TW>
<en_US>
<![CDATA[Effective Tax Rate]]></en_US>
</I18N>
</I18NMap>
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
<StrategyConfig dsName="Rep_ETR的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_SCENARIO" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Period的副本" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Scenario" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_cfc_name" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_ETR_CFC" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Dic_Entity" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Cht_ANNL_REC_PROFIT" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="Rep_ETR" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
</StrategyConfigs>
</StrategyConfigsAttr>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.30.0.20240920">
<TemplateCloudInfoAttrMark createTime="1651036965697"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="5dc175be-2cb4-4267-a971-cfb325a2a099"/>
</TemplateIdAttMark>
</Form>
