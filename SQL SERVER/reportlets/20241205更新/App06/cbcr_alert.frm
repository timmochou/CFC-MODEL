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
AND PERIOD = '${P_PERIOD_}'
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
T4.COUNTRY_NAME
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
ORDER BY COUNTRY_ID ASC]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_CATEGORY" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_CATEGORY"/>
<O>
<![CDATA[f]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH T1 AS (SELECT '1' AS ID, 'col_lowtax_income_non_rel' AS TYPE
UNION ALL
SELECT '2' AS ID, 'col_lowtax_tangible_asset' AS TYPE
UNION ALL
SELECT '3' AS ID, 'col_lowtax_hold' AS TYPE
UNION ALL
SELECT '4' AS ID, 'col_emp_manufacture' AS TYPE
UNION ALL
SELECT '5' AS ID, 'col_emp_sales_mkt_distrbn' AS TYPE
UNION ALL
SELECT '6' AS ID, 'col_emp_provide_serv_to_nrp' AS TYPE
UNION ALL
SELECT '7' AS ID, 'col_emp_admin_mgnt_sup' AS TYPE
UNION ALL
SELECT '8' AS ID, 'col_emp_res_and_dev' AS TYPE
UNION ALL
SELECT '9' AS ID, 'col_emp_income_non_rel' AS TYPE
UNION ALL
SELECT '10' AS ID, 'col_unmatch' AS TYPE
UNION ALL
SELECT '11' AS ID, 'col_low_etr' AS TYPE
UNION ALL
SELECT '12' AS ID, 'col_de_minimis' AS TYPE
UNION ALL
SELECT '13' AS ID, 'col_simplified_etr' AS TYPE
UNION ALL
SELECT '14' AS ID, 'col_routine_profits' AS TYPE)
SELECT * FROM T1
WHERE
1=1
${if(len(P_CATEGORY) == 0,"","and Type IN ('" + REPLACE(P_CATEGORY, "''", "'") + "')")}]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_WARNING" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_PERIOD"/>
<O>
<![CDATA[2025-12]]></O>
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
<Attributes name="P_CATEGORY"/>
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
<![CDATA[WITH PivotData AS(
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
${if(len(P_COMPANY) == 0,"","and ENTITY_ID IN ('" + P_COMPANY + "')")}
) AS SourceTable
PIVOT
(
    SUM(VALUE)
    FOR [DATA_NAME]A IN (
        [col_income_non_rel]A,
        [col_tangible_asset]A,
        [col_res_and_dev]A,
        [col_hold_int_property]A,
        [col_purchase]A,
        [col_manufacture]A,
        [col_sales_mkt_distrbn]A,
        [col_admin_mgnt_sup]A,
        [col_provide_serv_to_nrp]A,
        [col_int_grp_fin]A,
        [col_regu_fin_serv]A,
        [col_insurance]A,
        [col_others]A,
        [col_num_of_emp]A,
        [col_pre_tax_income]A,
        [col_curr_tax_payable]A,
        [col_p2_income]A,
        [col_p2_pre_tax_income]A,
        [col_p2_tax_exp]A,
        [col_p2_payroll]A,
        [col_p2_eur_to_twd_exch]A,
        [col_p2_tangible_asset]A
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
        SELECT 'col_lowtax_income_non_rel' as risk_type WHERE IS_LOWTAX = 'true' AND col_income_non_rel != 0
        UNION ALL SELECT 'col_lowtax_tangible_asset' WHERE IS_LOWTAX = 'true' AND col_tangible_asset != 0
        UNION ALL SELECT 'col_lowtax_hold' WHERE IS_LOWTAX = 'true' AND COALESCE(col_res_and_dev, col_hold_int_property, col_purchase, col_manufacture, col_sales_mkt_distrbn, col_admin_mgnt_sup, col_provide_serv_to_nrp, col_int_grp_fin, col_regu_fin_serv, col_insurance, col_others,0) != 0
        UNION ALL SELECT 'col_emp_manufacture' WHERE col_manufacture != 0 AND col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_sales_mkt_distrbn' WHERE col_sales_mkt_distrbn != 0 AND col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_provide_serv_to_nrp' WHERE col_provide_serv_to_nrp != 0 AND col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_admin_mgnt_sup' WHERE col_admin_mgnt_sup != 0 AND col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_res_and_dev' WHERE col_res_and_dev != 0 AND col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_income_non_rel' WHERE col_income_non_rel != 0 AND col_num_of_emp = 0
        UNION ALL SELECT 'col_unmatch' WHERE (col_pre_tax_income > 0 AND col_curr_tax_payable < 0) OR (col_pre_tax_income < 0 AND col_curr_tax_payable > 0)
        UNION ALL SELECT 'col_low_etr' WHERE ISNULL(col_curr_tax_payable / NULLIF(col_pre_tax_income, 0), 0) < TAX_RATE
        UNION ALL SELECT 'col_de_minimis' WHERE col_p2_income > (10000000 * col_p2_eur_to_twd_exch) OR col_p2_pre_tax_income > ( 1000000 * col_p2_eur_to_twd_exch ) 
        UNION ALL SELECT 'col_simplified_etr' WHERE 
            (LEFT(T1.Period,4)='2023' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)='2024' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)='2025' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.16) OR
            (LEFT(T1.Period,4)='2026' AND ISNULL(col_p2_tax_exp / NULLIF(col_p2_pre_tax_income, 0), 0)< 0.17)
        UNION ALL SELECT 'col_routine_profits' WHERE (col_p2_pre_tax_income - ((col_p2_payroll * 0.1)+ (col_p2_tangible_asset * 0.08)) >= 0)
     ) x
        WHERE 1=1 
        ${if(len(P_CATEGORY) == 0,"","and risk_type IN ('" + P_CATEGORY + "')")}
    FOR XML PATH('')
), 1, 1, '') AS TYPE
FROM PivotData T1
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
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
),COUNT_TYPE AS(
SELECT 
    TYPE,
    LEN(TYPE) - LEN(REPLACE(TYPE, ',', '')) + 1 AS TypeCount  -- 计算逗号数量加1来获得col数量
FROM RiskWarning
WHERE TYPE IS NOT NULL  -- 确保TYPE不为空
GROUP BY TYPE
)
SELECT 
    T1.*,
    ISNULL(T2.TypeCount, 0) as TypeCount  -- 如果TYPE为空，返回0
FROM RiskWarning T1 
LEFT JOIN COUNT_TYPE T2 ON T1.TYPE = T2.TYPE
WHERE COUNTRY_ID IS NOT NULL
ORDER BY ENTITY_NAME ASC]]></Query>
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
<![CDATA[SELECT '1' AS ID, 'col_lowtax_income_non_rel' AS TYPE
UNION ALL
SELECT '2' AS ID, 'col_lowtax_tangible_asset' AS TYPE
UNION ALL
SELECT '3' AS ID, 'col_lowtax_hold' AS TYPE
UNION ALL
SELECT '4' AS ID, 'col_emp_manufacture' AS TYPE
UNION ALL
SELECT '5' AS ID, 'col_emp_sales_mkt_distrbn' AS TYPE
UNION ALL
SELECT '6' AS ID, 'col_emp_provide_serv_to_nrp' AS TYPE
UNION ALL
SELECT '7' AS ID, 'col_emp_admin_mgnt_sup' AS TYPE
UNION ALL
SELECT '8' AS ID, 'col_emp_res_and_dev' AS TYPE
UNION ALL
SELECT '9' AS ID, 'col_emp_income_non_rel' AS TYPE
UNION ALL
SELECT '10' AS ID, 'col_unmatch' AS TYPE
UNION ALL
SELECT '11' AS ID, 'col_low_etr' AS TYPE
UNION ALL
SELECT '12' AS ID, 'col_de_minimis' AS TYPE
UNION ALL
SELECT '13' AS ID, 'col_simplified_etr' AS TYPE
UNION ALL
SELECT '14' AS ID, 'col_routine_profits' AS TYPE]]></Query>
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
<WidgetID widgetID="6aa16fcf-3220-4f92-a6c2-ad6514f3b3e6"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_PERIOD__c"/>
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
<BoundsAttr x="430" y="0" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD_"/>
<WidgetID widgetID="6aa16fcf-3220-4f92-a6c2-ad6514f3b3e6"/>
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
<WidgetName name="LABEL_COUNTRY"/>
<WidgetID widgetID="d506761c-b875-4982-a6b0-53670ce8d233"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label3" frozen="false" index="-1" oldWidgetName="LABEL_COUNTRY"/>
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
var P_COUNTRY = _g().getWidgetByName("P_COUNTRY_").getValue();
var P_CATEGORY = _g().getWidgetByName("P_CATEGORY").getValue();
var P_PERIOD= _g().getWidgetByName("P_PERIOD_").getValue();
var BTN_MAP_LEVEL = _g().getWidgetByName("BTN_MAP_LEVEL").getValue();
_g().getWidgetByName("P_COMPANY").setValue(P_COMPANY);
_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
_g().getWidgetByName("P_CATEGORY").setValue(P_CATEGORY);
_g().getWidgetByName("P_PERIOD").setValue(P_PERIOD);
if(BTN_MAP_LEVEL == "1"){
    // 如果已經有先點過地圖上的值，在搜尋的時候才要讓他變二，否則就都不要動作
_g().getWidgetByName("BTN_MAP_LEVEL").setValue("2")}
else {}]]></Content>
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
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABEL_TITLE_c"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=i18n("cbcr_alert")]]></Attributes>
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
<BoundsAttr x="60" y="27" width="440" height="80"/>
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
<BoundsAttr x="626" y="0" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COUNTRY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COUNTRY"/>
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
<BoundsAttr x="1000" y="2" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_CATEGORY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COMPANY__c"/>
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[14]]></fontSize>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="TYPE" formula="=i18N($$$)"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_CATEGORY]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<RAAttr delimiter="&apos;,&apos;" isArray="false"/>
</InnerWidget>
<BoundsAttr x="1135" y="80" width="200" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_CATEGORY"/>
<WidgetID widgetID="60c85dce-6bdf-4cd4-bfb3-16c895813fad"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName="LABEL_ENTITY_NAME_c"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("alert_indicator")]]></Attributes>
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
<BoundsAttr x="1135" y="46" width="200" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<Listener event="afteredit" name="return false;">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_COMPANY_"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COMPANY__c"/>
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
<Listener event="afteredit" name="return false;">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//return false;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_COUNTRY_"/>
<WidgetID widgetID="83d88d26-1320-4dcf-9131-79e4189cceda"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COUNTRY__"/>
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
<InnerWidget class="com.fr.form.ui.PictureWidget">
<WidgetName name="BTN_RETURN"/>
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
<NameJavaScript name="BTN_TYPE=0">
<JavaScript class="com.fr.js.ParameterJavaScript">
<Parameters>
<Parameter>
<Attributes name="BTN_MAP_LEVEL"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY_"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY_"/>
<O>
<![CDATA[]]></O>
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
</Parameters>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</InnerWidget>
<BoundsAttr x="559" y="992" width="141" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="BTN_MAP_LEVEL"/>
<WidgetID widgetID="2a0f196a-0de9-4613-8066-a3158afe57ea"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox0" frozen="false" index="-1" oldWidgetName="comboBox0"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="627" y="291" width="124" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_MAP"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
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
<WidgetName name="REP_MAP"/>
<WidgetID widgetID="8ef156e2-ef6f-48b4-a8a0-7fd5260989c0"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_MAP"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
<Margin top="0" left="11" bottom="11" right="11"/>
<Border>
<border style="0" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新增標題]]></O>
<FRFont name="WenQuanYi Micro Hei" style="1" size="128"/>
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
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="0.04"/>
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
<![CDATA[2743200,2743200,2743200,14428800,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="FR_LOCALE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.NoneFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="COUNTRY_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="COUNTRY_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
<cellSortAttr/>
</O>
<PrivilegeControl/>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="TypeCount"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
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
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?MHd'3?6jVqS:R$ad>WO@Q<'O1#<l*en=m"0#7Ocj(tN,#tj4_F#G2aB7+2d?:j@.juYXm%
Ok#/4p0RiDC5=5bq@h#UF(+"-O4Y?p^5CQKWeQF8"(3RsWGNHfk=iGA$'ps8Du@%Um8W2Jh%
H!.`UNch><X^`+nllcm2HNlY1B1'$h!Hskk"0+$2"aY_j51V:9*RbqdS^YYOU\St9_hHsK8^
YDCCoOl+SURR;9cTKLjg^T1Orcg6jETGbZ^6']AhC,]A/JXZ_0nUC/dbp[JWP?GF0X<H;_NR!3
DIDdr+/S&Z0;*[u_S#Z*6Tdr+SYgod:."_`-:_(>o`bQ0.;d<)-G70!=-_i'[T!9emu39)mY
E34ji+\lsB%2p.;0n<a7OhV[qrc[0ajE[7(18g67[!J.K%QO@Lr2"1o4MGb"Ya7:\Lr\s-f`
WgCerc$3/%((/s*"!BH/%2TORB7L\mPMOPhAQ>Y>A3-'I"n!FRWd0oiir!@EC:rCR>T#AMRC
A)=m-U?Vc8`;=^0/r\GhOlP[Bj9);VpPgQWaRN,I1MFl2XiRag6TIO>K$<u\Co.$>Yf4VgRj
,HhoM>>!C6jHR*H`'&iL3L/D+[XUF(>#L#2O+f8S2L4kWJS7,"hA+Aq^Bp&.>Spsnc5ZUq]A`
.IcRX(3/LtrW3IIa=Pp,IKo>FKh6oXE:e9b%C&,B(rV/)'ERHV+c?3?5bc0l`^m1,j(Ss:a-
97MC#i_-r%nV`E4CE-36FpriH,8PaYBKO>2k_7=ll-2hoiF&jnR4(4.,R5p.V<JaBffk0]AIO
pX7#)ImE,YYkHhDKDca%"8m,TY,NDulH9^MQ-_kKX\mpFJia(_]AA(ZT`r<m:.FWW!YD+)p>W
,e/'!]A_FG'4'3$"BKDU@SV?E!_rULNA1f`AYeGbt@3g70NSXZ?J'<iSt$rN"ODKpSDE:bIWp
q#Qp75[+te='g[2c*XP98;P+)`J5<.[@s4s%ChhdhSq2R!S<P9Y/RLgD\@2%S&g=F^ug>*;m
%t0[rc9(iZ5h(f\?1,`JXBnnboNX:[ISl&JtN>2JtL-@:$N9_0MEBA5Wf=Z`1D0.qc'G\nR&
P:s*);`A;+Ws/6/I\=I%_Gr'DE),E72Q.os3-q6pc1^(P`T\uoim_0*c:0k+;d"l2cLRGkHp
4CgkU,oG:O"C#h0g]A)rCL.mZ<164(;sWVNl(<_c4ft>m/:R'.8UU*O^eguoptiYf@BkK2<IY
6\Hh?#mTef%ASs+2-nKp!*W%]A#;G<S)MDbC=hA[.-cp1R_0sqYB:qTmN:DF1rjp[UKWG;_Q"
49@-WREi`Z'*<p.pWkW=T2h`44Jn&j<S?2;^Y&fs!%8ES1NmfPV8Y&J)UCbG,S)c#@[O76O\
f6^q!!b-iSl=R.EW\U40=PJoSqg'hn4@-@DR9Ij.sUOH2hE*q$G(%.rJu(HkRmK,M6U>:8+S
WOt<IKhIU:`qRBJm^4s-`T=.<De[1`fuWf#M5#mkVPSSm<H/B[hne-j&kbAjg@7#LP<nE?n8
5@PGRbgH,nn<\ns*P4\f+U!cg]Amh/L"9)hOjM>rcq(J9>aM`%!qLp*@e8MJhg)"UVsti&jIB
5WJZThM['rro3Fgi+8ljjW7H_2F1c^RM4.jYH7jpsEpGQq@"8C!Xi8l?'h@j("uu%RA:Ad/O
FM1Ln%XEM:FggQYo^3i/R>Kj.+Yg^NO!9#*Pnf!5$s43`?kHTgr->?I=)k?nY"MBkWo7&=bR
L#%?r>]Ano+rL==[+(692<6[ELd8cnXh#X;7smih/4$3ht@5?+KES,us=CO2,4uq^]A?!]AaWD;
<F[?nVpTl:55=EuTi8!Xr3J$\:ZujBJT2'X?qE9+<X]AQA<Ff*H!&[,s76ga+\[)-l'Yb"lT7
q!bURXL4)WBpN\f;i7rs[*3;hXR;4"ccA#FfcI:$O7kiF\hL@cC9;Gf6:OM8g9bbsN`$QdP+
h=u;oM%bJX+lLGfY99h`cHnJ'VIdB[V.[LKUTf^IL#=heKl/dRladj4HHN)Or$-+bI4%!&b%
ne7-#E>SKC6D0L)u>0JVkr<N(VBbJ@5uN-Nr=Y":pbDqf=u7a8Z.D4r+IkGE5MaDcnAnIIhL
-C7-_TY/;W-(3s#MjUPU2h_-mPE5+53Eim1NeL1pu1H`LrMT@ZW3E>*EAQ&XQmQFTZ]Am2WTl
)9&,e*f@6@are`50;%"_\NDdZ6MP/=r>=THR4hP!TaT95rd$V>KmHVY7,.6H_..<9Ke4bOPf
K]AqSA"aCl4PHJ@:CZ"Frh-*P!qDfDYc7i]A^eL`H8m9THa%_VarOH:CTJZ+5GDj.8Pp3QTcGp
r.N"4+IafYf&N%40\,,9@Bd,q1G*T+o35R3q*eX,JTrG:'?(T1UK3_K137=S$JeEi;N:bK*j
2$f7a:d_u>B7Co<96):I#GPq?a-Y73[r4a*-G)'XfOmCdBWJdWSaJWM%dV:?#u3%P)dr>6=4
Qa(9qJZG5]Ak"U-/q45nbO%1akk-0l9%#Zd[!1Oq-]A@5sK[Be-%Re'j7bhM)8'o(`V2/>rpgA
KnpuD$cWL4E@JP\f!erKhP@dG#7h$G0?DZWZgT><[bbV>c*l9\c`(Zp;m9Jnlu_"clrH>A@1
VSJ<N1RT7BX5IKj4geQXlUo5oiVE/p`r^#*]A:uS<3fuY7ZF8N'V?i+,tIZ_mZ*&an[.p9[K6
_cld$qYGa@<bh@JH+"JLS2hA96o<'`rK_CFa5"<Ot/W5%?F2,.pau@e,7"jAr@or#)/),_5U
F=K\Om='M]A]AH$8GIfZt/h7<1G;.Iu`Ra:5]AUL84KV9$Tl#U\S>O%6`"#H?<#+^7+pmMS\egS
?XNl7enI@P/,Idd1\!,14%*eEXb(i-amF[;>Y=$,f\\nKq;^uJR[o4kG]ArkBLf_5r*0o@4K6
PlLeL4$)I]A9)qUhPZr<C[=)`1=TIqofd0;cBgfr+Q9N</>QE]A[9rg,f!7"WTYIE<DYf%adI,
KUTLl/-eMPu>gW/->0Ll/-eMPu>gW/->0Ll/-eqHq`io=a55QgC6!Xo5u8gG7H%QWO+U/*lM
gQZL+dGkhOH+qT;26m)OCLd2(e&:k*T+9E.2_#Ff?C?+&q(q[8bDm]Aup#fH(Gg2m2I^B"~
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
<BoundsAttr x="0" y="0" width="239" height="150"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="455" y="333" width="239" height="150"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="CHT_MAP"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="chart2" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetName name="CHT_MAP"/>
<WidgetID widgetID="8532f315-b59d-4bd8-862b-ef7fdbe4ce09"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="CHT_MAP"/>
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
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-6908266" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.75"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新增圖表標題]]></O>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="PMingLiU" style="0" size="128">
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
<![CDATA[新增圖表標題]]></O>
</SwitchTitle>
<Plot class="com.fr.plugin.chart.map.VanChartMapPlot">
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
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="0.75"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrMarkerAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.map.attr.AttrMapLabel">
<AttrMapLabel>
<areaLabel class="com.fr.plugin.chart.base.AttrLabel">
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
<Attr showLine="false" isHorizontal="true" autoAdjust="false" position="5" align="9" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img data-id=&quot;${NAME}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${NAME}"/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
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
<value class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
</labelDetail>
</AttrLabel>
</areaLabel>
<pointLabel class="com.fr.plugin.chart.base.AttrLabel">
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
<Attr showLine="false" isHorizontal="true" autoAdjust="false" position="5" align="9" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img data-id=&quot;${NAME}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${NAME}"/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
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
<Attr isCommon="false" isCustom="false" isRichText="true" richTextAlign="center" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
</labelDetail>
</AttrLabel>
</pointLabel>
</AttrMapLabel>
</Attr>
<Attr class="com.fr.plugin.chart.map.attr.AttrMapTooltip">
<AttrMapTooltip>
<areaTooltip class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Arial" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Arial" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: left;&quot;&gt;&lt;img data-id=&quot;${NAME}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${SERIES}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${VALUE}${SIZE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${NAME}${SERIES}${VALUE}${SIZE}"/>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
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
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
<Attr isCommon="false" isCustom="false" isRichText="true" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
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
<category class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
<HtmlLabel customText="function(){ return this.name+this.seriesName+this.value;}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
</areaTooltip>
<pointTooltip class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Arial" style="0" size="96"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Arial" style="0" size="96"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: left;&quot;&gt;&lt;img data-id=&quot;${NAME}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${SERIES}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${VALUE}${SIZE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${NAME}${SERIES}${VALUE}${SIZE}"/>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
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
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
<Attr isCommon="false" isCustom="true" isRichText="false" richTextAlign="left" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
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
<category class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
<HtmlLabel customText="function(){ 
    var name_array = []; 
    var hint_array = [];
    var hint2_array = [];
    var hint;
    var text;
    if($(&quot;td[id^=A1-]&quot;,&quot;div#REP_MAP&quot;).text() == &quot;zh_TW&quot;){ 
        text = &quot;發生次數： &quot;;
    }
    else if($(&quot;td[id^=A1-]&quot;,&quot;div#REP_MAP&quot;).text() == &quot;en_US&quot;){ 
        text = &quot;Occurrences: &quot;;
    }
    for (var i = 1; i &lt; 100; i++){
     if($(&quot;td[id^=B&quot;+i+&quot;-]&quot;,&quot;div#REP_MAP&quot;).text().length==0){
      break;
     }
     name_array.push($(&quot;td[id^=B&quot;+i+&quot;-]&quot;,&quot;div#REP_MAP&quot;).text());
     hint_array.push($(&quot;td[id^=C&quot;+i+&quot;-]&quot;,&quot;div#REP_MAP&quot;).text());
     hint2_array.push($(&quot;td[id^=D&quot;+i+&quot;-]&quot;,&quot;div#REP_MAP&quot;).text());
    }
    
    

    for (var j = 0; j &lt; 100; j++){
     if(this.name == name_array[j]){
      hint = &quot;&lt;span style=&apos;color: #d04a02;&apos;&gt;●&lt;/span&gt;&quot; +text + hint_array[j] + &quot; &quot; + hint2_array[j];
      break;
     }
    }
    return  hint;}

    " useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground">
<color>
<FineColor color="-1317147" hor="-1" ver="-1"/>
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
</pointTooltip>
<lineTooltip class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Arial" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="false">
<FRFont name="Arial" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: left;&quot;&gt;&lt;img data-id=&quot;${FROM.NAME}${TO.NAME}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${SERIES}&quot;/&gt;&lt;br&gt;&lt;img data-id=&quot;${VALUE}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${FROM.NAME}${TO.NAME}${SERIES}${VALUE}"/>
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
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipStartAndEndNameFormat">
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
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipStartAndEndNameFormat">
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
</lineTooltip>
</AttrMapTooltip>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrBorderWithAlpha">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-1" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AlphaAttr alpha="1.0"/>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrEffect">
<AttrEffect>
<attr enabled="false" period="3.2"/>
</AttrEffect>
</Attr>
<Attr class="com.fr.plugin.chart.bubble.attr.VanChartAttrBubble">
<VanChartAttrBubble>
<Attr minDiameter="10.0" maxDiameter="30.0" shadow="false" displayNegative="false"/>
</VanChartAttrBubble>
</Attr>
<Attr class="com.fr.plugin.chart.map.line.condition.AttrCurve">
<AttrCurve>
<attr lineWidth="0.5" bending="30.0" alpha="100.0"/>
</AttrCurve>
</Attr>
<Attr class="com.fr.plugin.chart.map.line.condition.AttrLineEffect">
<AttrEffect>
<attr enabled="true" period="30.0"/>
<lineEffectAttr animationType="default"/>
<marker>
<VanAttrMarker>
<Attr isCommon="false" anchorSize="22.0" markerType="NullMarker" radius="3.5" width="30.0" height="30.0"/>
<Background name="ImageBackground" layout="2"/>
</VanAttrMarker>
</marker>
</AttrEffect>
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
<Attr showLine="false" isHorizontal="true" autoAdjust="false" position="5" align="9" isCustom="false"/>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<TextAttr>
<Attr alignText="0" themed="true">
<FRFont name="新細明體" style="0" size="72"/>
</Attr>
</TextAttr>
<richText class="com.fr.plugin.chart.base.AttrTooltipRichText">
<AttrTooltipRichText>
<Attr content="&lt;p style=&quot;text-align: center;&quot;&gt;&lt;img data-id=&quot;${NAME}&quot;/&gt;&lt;br&gt;&lt;/p&gt;" isAuto="true" initParamsContent="${NAME}"/>
<params>
<![CDATA[{}]]></params>
</AttrTooltipRichText>
</richText>
<richTextValue class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</richTextValue>
<richTextPercent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</richTextPercent>
<richTextCategory class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
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
<Attr isCommon="false" isCustom="false" isRichText="true" richTextAlign="center" showAllSeries="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipMapValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" anchorSize="22.0" markerType="RoundFilledMarker" radius="3.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor autoColor="false" themed="false">
<borderColor>
<FineColor color="-3355444" hor="-1" ver="-1"/>
</borderColor>
</newColor>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.9"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="false" themed="false"/>
<FRFont name="新細明體" style="0" size="88">
<foreground>
<FineColor color="-10066330" hor="-1" ver="-1"/>
</foreground>
</FRFont>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" layout="aligned" customSize="false" maxHeight="30.0" isHighlight="true"/>
<Attr4VanChartScatter>
<Type rangeLegendType="2"/>
<SectionLegend>
<MapHotAreaColor>
<MC_Attr minValue="175.0" maxValue="200.0" useType="0" areaNumber="1">
<mainColor>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</mainColor>
</MC_Attr>
<ColorList>
<AreaColor>
<AC_Attr minValue="=170" maxValue="=200">
<color>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</color>
</AC_Attr>
</AreaColor>
</ColorList>
</MapHotAreaColor>
<LegendLabelFormat>
<IsCommon commonValueFormat="true"/>
</LegendLabelFormat>
</SectionLegend>
</Attr4VanChartScatter>
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
<Attr isVisible="false" themed="false"/>
<FRFont name="PMingLiU" style="0" size="72"/>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<PredefinedStyle themed="true"/>
<ColorList>
<OColor>
<colvalue>
<FineColor color="-12999178" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-7287309" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-600992" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-422004" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-8595761" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-7236949" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-8873759" hor="-1" ver="-1"/>
</colvalue>
</OColor>
<OColor>
<colvalue>
<FineColor color="-8935739" hor="-1" ver="-1"/>
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
<VanChartMapPlotAttr mapType="custom" geourl="assets/map/geographic/map/worldmap.json" zoomlevel="1" mapmarkertype="2" markerTypeKey="bubble" autoNullValue="false">
<nullvaluecolor>
<FineColor color="-3355444" hor="-1" ver="-1"/>
</nullvaluecolor>
</VanChartMapPlotAttr>
<pointHotHyperLink>
<NameJavaScriptGroup>
<NameJavaScript name="POP_MAP_LEVEL">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=AREA_NAME]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[const TYPE = _g().getWidgetByName("BTN_MAP_LEVEL").getValue();
// TYPE = "" 為初始化，BTN_TYPE 還沒有賦任何值，此時Series為國家列表，點擊 返回按鈕顯示
if(TYPE == ""){
	//返回按鈕顯示	
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue("");
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_MAP_LEVEL").setValue("1");
	_g().getWidgetByName("BTN_RETURN").setVisible(true);
	}

else if(TYPE == "2") {
	//返回按鈕顯示
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue("");
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("BTN_MAP_LEVEL").setValue("1");
	_g().getWidgetByName("BTN_RETURN").setVisible(true);
	}
else if(TYPE == "1"){
	// 設為1的時候再點就不要有動作了
	}]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</pointHotHyperLink>
<lineMapDataProcessor>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
</lineMapDataProcessor>
<GisLayer>
<Attr gislayer="null" layerName="無"/>
</GisLayer>
<ViewCenter auto="true" longitude="121.516667" latitude="25.03333333"/>
<pointConditionCollection>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</pointConditionCollection>
<lineConditionCollection>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</lineConditionCollection>
<matchResult/>
</Plot>
<ChartDefinition>
<VanMapDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<areaDefinition class="com.fr.plugin.chart.map.data.VanMapOneValueCDDefinition">
<OneValueCDDefinition seriesName="無" function="com.fr.plugin.chart.base.FirstFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ope_code]]></Name>
</TableData>
</OneValueCDDefinition>
<attr longitude="" latitude="" endLongitude="" endLatitude="" useAreaName="true" endAreaName=""/>
<matchResult>
<CustomResult/>
</matchResult>
</areaDefinition>
<pointDefinition class="com.fr.plugin.chart.map.data.VanMapOneValueCDDefinition">
<OneValueCDDefinition seriesName="無" valueName="TypeCount" function="com.fr.data.util.function.SumFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[REP_WARNING]]></Name>
</TableData>
<CategoryName value="COUNTRY_ID"/>
</OneValueCDDefinition>
<attr longitude="" latitude="" endLongitude="" endLatitude="" useAreaName="true" endAreaName=""/>
<matchResult>
<CustomResult/>
</matchResult>
</pointDefinition>
<lineDefinition class="com.fr.plugin.chart.map.data.VanMapMoreNameCDDefinition">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
</MoreNameCDDefinition>
<attr longitude="" latitude="" endLongitude="" endLatitude="" useAreaName="true" endAreaName=""/>
<matchResult/>
</lineDefinition>
</VanMapDefinition>
</ChartDefinition>
</Chart>
<UUID uuid="bff77675-5923-4b9b-90e1-a57a954f4903"/>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<category class="com.fr.plugin.chart.base.format.AttrTooltipAreaNameFormat">
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
<BoundsAttr x="0" y="0" width="665" height="744"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="38" y="290" width="665" height="744"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_02"/>
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
<WidgetName name="REP_02"/>
<WidgetID widgetID="b2abeb22-6996-43a4-9df6-7a1cb81226dd"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_02"/>
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
<![CDATA[4000500,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1104900,3352800,13144500,8305800,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
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
<C c="1" r="0" s="1">
<O>
<![CDATA[●]]></O>
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
<C c="2" r="0" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("occurr_ttl")]]></Attributes>
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
<C c="3" r="0" s="3">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="TypeCount"/>
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
<Style horizontal_alignment="2" textStyle="1" imageLayout="1" paddingLeft="0" paddingRight="0">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="0" paddingRight="0">
<FRFont name="WenQuanYi Micro Hei" style="0" size="384">
<foreground>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="13" paddingRight="0" spacingBefore="3">
<FRFont name="Microsoft JhengHei UI" style="0" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="3">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="0" size="288">
<foreground>
<FineColor color="-3126782" hor="-1" ver="-1"/>
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
<![CDATA[m<NDJ&m5%?P>BXaQ.@cDAnk&N<194:/i;$dC2.@WAkK4:MWP,"+B(uq;_I1G+dFLO-B,He6=
jSY8kFkm9"B[!Upu)`r5%N@VPeY6npYhuk]AM.kn`E$uhTkTFkBHnbl0bqHqeb5kWN!"@5(;R
WRbCA^eaI_>.fV:_<Ap_OG-&LTaNpcfPR%Iool!VkIu7YUs6f1?]A/+3rp>24a3th?[B>H$4l
ct)>=8qmAWpbsdfT>,n[8QeOh04qQI\-B1gVu,FFmlL.WH@6jhfbN8Y[u:@hd7I%BG!B'#I'
>(Og(<+L:;a'p*=_%SjgI]AaT4Knbm7R4_)H,D7V0]AL<iR0tBtM-"'iMqY'(ftTW;5T?ETFTD
-P?)?^0ssi,Z@l^,[s8d2'YUe_QO$fYL63\2l):tDq'6S)#55A1Hgt]AT`--RAZ2TaoZ/cDZ+
+?McnTbmC(RJDp<:lpo530LgNo7@gH^n3g93j_p")<mYC)q`n9L%^f2=[eogdTU&B0Nh%^>I
/@r\X)h+pOS.gW(lVMG2dQiV):oPrW;j%j5-XeW=QH?[V3Ob:0\i>UQ^1`N.Ohn=Je[^U92P
gtC*m@P#_OV:5kV@258\YCSuL!aogJEY_?VE=>lT5XaLKR#"Zq[9d`!1:C1#ud9i(M(g@%Io
Bo5$>DM4*d_6\BCG+&eF=gplCg[qthVe7TZ0ph!1lHMMt'CGIhHm\ao`:k(DU6?68EmE9tdD
Zb\Ym`X^@1:<unTS*,=T;`UBlTKnQuiW1)N9/ue0=1t>L[KiZi=7RhFB[Mi=Zd7X05i>)-4%
0[Dd+cueF]AHE6%\LV1J<[dUCJhIA+lKVo$\8&%B+HO<qA#'V/KFR>cVf^L+WQBbe-%I\OYeT
t%WKhU<XkK0NEnA-)b*H[aS$G3dCPsQ]A2M>^%KFVhmIrubL*u7eB8=h`B=k_>SqN5RN)id/,
X>D[KA94';e;6]AaI]A4b]A!Y[!,S:/DaeR\`d(G!Iq+@EHP5?JR)ZOid'/aALD]A2;C13>8'f6X
t`YK8jh-3t"M,%_$p/S2KFgaphg0UQfs>#GVOJMD(bnHkcoVa44)4,l,L[MLLsH.c1oq^?2r
L(pE"<ZFG$g"n8]ATC(b\p,j0.nndX%:m13@WJK1'gO?1X'ADDb%#WTHa.j51ri/>LrK4`SnQ
e&VT_PX0RU$q'[Ohcqhq3c932L3+/lA4#<2NS>'_\A/r&R(+Z&n7AYsu4>dZ\G+oA=XA?;[e
k8_[Q0noS&5VtfDUW7>=_4uP&MVM!q]AM>1!%WR5uDQZ!s&E]A`EVKFMOJid.+1\(huGfrAu(+
/<51Jbsk^ZjhN2HN!;9]AGIU3!K?\4(clQiYab%\rV5bBQCdI;Gi&'(j+WnZmR]A3gW[-N_PI3
lg22F).``jn[9?/ok/6dk#e*dNsZkS:,p_VmM<]Aaqu\+?J.CL/c+De>8GB2V3gcA53pKZS@T
AXW"^?7s]A%H2%((/kh@$(nG07[<nPD*cs<*S;Un6>cA.!K.5AB;ELGJQRDoK)QlHKk>17`At
GB]A8WW]A/9;`M%oVKd)2==_95DBUOYU]AEKj_@E&f>$.EhdJdnnk(Ka"mk6`53t:HC!?p.J"t/
fOZ*s41*:#-Y(DduKBBanY]ALurE(E@N!%=<=4lG'oVCDZZ=MN>(h&VXdR#l!Ek;"*:9l(bT-
![1>,)Ud'YObtsXrS'a`%riU@*o:Om(d\g#[Kcb'3VYf^l\7YJ<"N#4F#"d'aj0NMK*<!IIh
m_TFq&s_:U'*N@6gr%H$+g,cdTT"9X#D0ZMUm4qu]A?+6WFj7^dXhI<3snJ5*4@P<)GN5L\^j
e8?so7ZuC:56UX-DelTmak_HQ^:1_DlXUUCd5E]AOBY1P5\N;)jhK126/?\/X01-)d*Y.&*\6
-U*=,,kh[p&X]AjnTa82^thss16X7/L?V_b*i$1"'r<MQ*<1dQ\1+6WX#"$Ml]AE_nH7G>8':f
'!.'U$_?S5%dup5=+>Gh6P/2^h@,#d4P5M^r:X#=aXN0MaQGP-+VU'"KGJGFE19]A:"bYR/5V
@!.19&nffUdn9(oX]A.TF`[=rIqCaYhrgX'`C=EN;,F?`$j03\.f%RJWp6kCBCdjLe(pmWEb8
_Hk^gV,,/IL:RZeO1c&9rRk+*7&L[9\N$DU"8a_Jg\P@t"d',m30KjKYlDV.C0nT1Y9TaYOs
pPkUR3B8Z!h\J"dAsr_PgULPH,B5]A6FoX?@[mTaF`p+u>[6HS$"1;7B:M,2HA;BhYH?g-jpm
'/h"6G-6b@(5L$_[)9B<sn(X^BCSqa8JD\*.JFd'Q>a6;Zp81&lf"^`Q]ADVLM?HP>R8-^@-#
k+T=d)?V]AouGpXt<Z/We(mBVg-re+a13GPl(dJa(4UVi_e2f[4fVKeTYaXO&`9XoScZ;g=!T
!>1"1XgL=nYD:*^3tj5A,2[K+8#;Dq]A$H7kO\lBrn"g;I8N+#0I]A]A#+sHL0^489gJ2U[@m%i
f1kMG?W_&U@@j))ZCoS;*hcEI5-`6Bi^4CH4^&,N/BL*fK;^+!\ho$^D:)a_uqp*MOV)QR8f
SltePmh"05qX_Ap6_3U*EJ=te.*eahI?\j,OQDd)BVBk6oYu#$-t8Vg"u-;Ef>&*XmsFi7^H
S0eCGYX*UFD1+$'VphD61"+$\tf1cZo?58dHFU7bYb(?U##(lFl8`dc^V"8ijqH>o7nO>F,a
(I.A5dLI,]A_EdBL+n?F]At47Q>*-8C63mP07sjZL$YJ$0:6YIu``3RV!hFuns.=`QDq]A\)ine
4LbPDnMjsq';n5C`LguM>O#1W'NMVFc+B:V0&;eW6+_q65lr"=e2b=S4q<qPWZ:-P%g)4aK4
)foO]AnBiYN7&?k8oHL;o(OlS=kZ^emPG%M\SN80^2)QMZjs!mh^ri9'HQYYMPh=;p?F^7"Yh
S#P[XH<DNn,AW2C(5a+Bbj^Q+AVdk::fA$q0L&EOLG%mD]A#?%k'NrJOVJ1mBnB&#e*`sNgcu
<`o+[5tP6`"Y+S1*j2BpT''!("_JFVrdXmA>]A.2r5[F7l?;d&^9:@C>_rkJf2BE!8FiILioU
`aW:q4.I`401Uf9"3[\4f=t#eTj@"8Gb\se&6S18Jm>.C;7&0Z#WF`,*,T.a;Yr.A.SSqPF;
$#392sq7r2R?1%FRNmEShI.lK9UM9Tf3n@*),?o+c+]Adcro=_P0JlaXhUL0B=_=1<7h?iKKB
r0:rM15MG"IlrPHa!jhqOfYO/+Jg"!4b=RKHn;BE!71F+]AK;kN(YRhF?^5H$'1=$6jVmT#F+
]A]Ad<Up9:08\d(A(PjRlm.V+<`[%YS$CEuFLb:q6>H!W<g,?8cKVH<>C-f]AS2%7n6Mr__BN)[
pHs&Eqs<H@@`(7M[^G:U.(H)Y6^^l?,TXmc7g'iIu:tp!_DE7d%B=kB-=.$(m4rK"32;ZQLU
ZPb_aY)h),i*V<4`RYgPC$<4J.J;_sbh1>';bMF`bV#$^cr3>jbPioJ-)(mDcRZ<4SD0rRC2
iQ>p0==\gie[D(*p_P,`!tg'=$+GZoo)%bD%FR1:(-A]A"Wuh;kna3%Ap2NQPGk:F=&-QZS/Z
bCZBNY([\!8;s&IN\fOB5;=+p'OS1I%nPN;_Fr<oQm88m]A3Qm\;/BAW<G?tQ&d,sEc<]A^<Ha
/l`/1*:k@eO"92`U6Vnc#!cK7WE2t3!f@0d@?>Pn5j5d36,_dhI,!FbOE>.DV8SM_>V3,92H
-F[Z6_pCcRjg=7?s]AR/HhCp/JjQM=iW"lj%pL!Fs$/Y>53?"]AIl?>YD_Q$@R,hoXS4U<>q*e
XL?g<J5OT[!8)7+uc^0X8lH,'_c:8CDY0;Li#_e*QH9=A]Ae+(mK6PkKKpGd`X=mE4^,]Aq+CB
aNr9T5F.bqJBQ*%DZiM`ZAG$V.NSFCA7P>hol;jKg`YM9u"'K`:N@hHUq=@2JaLe"^8N,3e>
;aijQKuSro=]AF`:EJOUek;9^Ck/3SSV7gSBFl<)-=Imu%OM*20K(CS\BYUD:Bkc@*,qEf;oa
B$5WP7M*tbQ-V<b$KUomI%b2`H+nLe<1Ar0e1$clob/c<]Ai<mIFBqX(dnOgdDI<306:nEaX=
l7Bg#TS$"o:+f7b%Q5_$f8^;q8ME;/jB#)E*t-%QYC_-d>%NLWrc*Jig.7.;<U5RiJ=<89Xc
+j'-udjV^NY86^B!gJ.NeUaiVAC)9$nWF\GFB=]Au>Vc=CQfKArR5!-L`Ma?=_[d<`INmMAX'
'?$U*]A]AY[q<BN\%c99PHqU8J<WHop$L$e+5g$61FmO-o<snkG&CX!di^(_'am-3[_-cr8&Rd
^6--<nea!^?K<mFgQ<kB7@Om8@'>9q87Ff=RLY'`>V]AKLjc%,)X=hE%9S@)23bW6I><ae%>'
nX*F]AdV5/!IS'6:A3.EqKh450dE"4cHGm#mdo:%<Wo4]A+lLI'I#H`X:f//a&G!j,!#-In%::
=Qgin/R&dKuSA)0[Thk)UO"6R<alkoL,PFqa.I6G'H[pK&/c:,[*U]AgFQkpIp"/@6k!C)jmi
o_M'-pX<!Cnq'N(b1nQm//l#\X\LKEL%,9s-P'Q@f;'?_7H#O4,[M'?@%#[p*624Rd5cGp&V
W,WlJ,&na2X?ZM_@\1#J&[>-]A:VB53^"uNKNZb\#bT/3'_rngs5lB?-*VNYXURkF28&!uPa-
M)Tu%6JR%4ks#f>qB"M>,C+[[9_[/so^0gX2eBKg<9?5qI2-JQkLO%'OnU\s2FG,B/<9ajf*
`-Zd]A'II]AjS@is.2T*o(Q_9p"@l3Hg$b$Jq4N(qQ=PLFl;u;`mFQLH9mZ0>d,?gI5#<IfIi]A
?4sbEN`fP\(rUatb%-9hGqtn27TE,K)MNCUb6PE3G:';teu=+OjO):8G8\L@-8Tp%,-Fg+mp
0oEpe5mm8><bR1hT]A,"A]Am/A>s)/]A</Zb.Xa@mk3FCT_l3U_4S_I=:eqfQ[V)FKsq;N!ad,_
>q/Wmje`tli(Y3Zphd,-;Q'dfMoQF:SHn/A$<@2j!0Ds)7F%(?,lfVi(R;+*!48$Sf+0]A(ZG
U:1P3p^TRo6\OS:;PRfO7Mq/4.R1DS?;X2T!`gE'j^/Z.L.%JigN>K-&)b;+Cs80<E;d2;Q6
AmgU%NagOkp4Jp"Ve[]An//bA31r.p'<X!Iqb_PA6>L0)FP5`$2>!o0)Mm+jTWuHS09O(h1e%
4LKJi9qV;%WlcQ/CV#X\93Fm#i_Yeg?q#4='W:p#>j=R>Xj:k23uq[`)epZ0/XI#*&@HH*KO
ABD.UML@,=4-3S\<'LA:jg.q0c3<^if>G;.#*hKVmWY=r!k(['-ioR]Agd=t*BNr'Sl]AiVcd[
NB-cI,)Z`F]AonWT_V;&O5_#eb.DT0fY5<2EW'$:V@L!%4gi=cUpR(i?!eE![1Fr.k!Y=YLO-
BUE3EXW'+]Ais%"3XZp=Q*Hg_aT[8EAeH0BdH3okSaRn*a<W>UZ!:+VXYg?Mor2pNl!^7g7[u
5I0c,)*`GNRs8i*E7^!TqG=sk5&@;3S6R\FIcZoSCeK.Y?O(2)EARR]A2.U!c6G`_7V^G$53`
'D$p$+66]A;"A^r!LqW.%&0NE0LdIo/WB8Kn=0/nq=,-WkHm:nXT"%M0Rd1j*lY1-l4ni(\^5
irh2!uTWe$+M.Anif$B'NF>e(R1*7!Y@'9<hg]A`qBC+>#)_HgP<!MK\UB*Z;2+]A3U7BA[W>7
8GK(nL0LL,`X-T\4+bn\[H0(M7Yb2Ws#,pG/sT._7&-!)$^?e7M:&MnEO\dG_0>#Yq7Zsbde
AUCFsMI'S^HX*bQl`&'iDa@OVt'n-a6e:,G;nAT0fJ?\:"o8%-"sD]A("/Da_4EIFMHLf)6JD
9U+^_G7bIE%1^fu88VQ+F4"ht>A]AFH=D+s-ERZS(`b#le+st5eN?6VAJ6nt[=g:JM!f9KIs)
d_R3"=k7BjrBcHm$t!CY/sm&iGCG9+UsN>1X5A5FED@aUSLMJ]Ao$%LS!="R+P]AJX*7gu1oEC
:U=q#b,BBB\h(<]A.+knrd\3(uY\ntIbh/7//fpP"-gIRXOn!U.-h]A)^')cS"::,lk8U9"lnZ
$+Rm-T;amo%"Y0!,u<"b1rW-&jP49dJCXfOIR/%QOA:]A^);t1N--9)]AlF+GZ]AXkYc9+jLR:,
BK^ld6)[[9sW9iOZ=%SSp&*44$+mG&=Al4jopqs?ol7P1lAlB&"^Egn3Mlt0.mQR&O&E_>4I
gN/c]ALd^!mKudQaG5sAd"<I4X&mjqtBFHF4"ki1S:o4rl%HrBSCtJCoVjs4eX,%>)h)fW@kD
6l9\mu2R$iSM^i#LdTlms2I1O`5.1VUhmCK*jjG.1CnL+BsT_!aX#p6/g*-8/-2N\5]AOEb.)
HaUHak[uP_VkuM\u29P@G%9:t7lV3tr'bgSP<a>_3GYPF8K,47a+'?06`diE/Z$E4e<O'`-D
F*":B'!o!<<540Tq;T>!@L6qNP)FddUN[l`epOTS\c2U1[;NHh(E,W?,FV0Q&d,Q>f"<YpAW
%4\=]AmLbrW:kCUQ/:+8iEnb`s3qfd2*_4nVssoo[dJ`\)O-SJJtce+P%Y;-H!:g>g)Yfm?HX
qaiA5D:/UK_R9EjKX27N-O,amf\mtEW.&9T.rU!eZD^`=RAd-/"Pl1X#_i/*86iNC4]AqQA:/
&q>KABX,ls]A7`i-)?2JL9Zre!t-aTDi:7N;#6R&,(8,AT=nL>aM9niPEkW=Yh8hpr<auli+e
&o#I#`s&b.@S(,Tn="E'g-nGN_ZP"K?-UB1UB:tG/!dGWEMhNXGDVU(@5!A<L8UOR3Y$pp>(
#(=8LE^32j>4LL6]A^6;AKbQ0;2+0$>MN;&S1D"\,SgZX7a/Q0L]A5;1',VS*NHN[$`4'0QY\c
=Kcr[XkD]A-+!U&oPO.rb>,(,iV*/ZQl-)NJYV^8r:#4L^4RM!A\]AgiE/)(IY?hKG%2M@MP%r
ZaqNm[0eSJ$UMQ,o'm)?[jMO6RZpHr!fgsh^]AeA?b4ufiLK&A]Aj<&j&[a0h^qUbe+#95\Df7
PC_pK):EXB72enHGVUC1Sn5^ri]A:R`/$e9JNbnTTphnO`DZ8QP0t`*dY6\JO$G<^]ADhNHsuR
C/,@<u[U1`-]AiJaOpRF&Jk"\C69b0`e+N1W&,SB\Yr8nf+nZ8?c_FYK?(ub+6CM<H\j&spJR
@<orJP"4lKC?RJY2cTgF@sm*hf71F7;+U@q%?uEHQE:d)'HNaJ6(Ga6W4nBY+3luqZ=iE\cb
C/TpS&sR>/)5R^>Ca'D><ScQoW,E]Aq/dPV`VZ;`OPV7.fBbh!ZK]ATVXQgOG$DD[sAZEh;'4F
"=>h%?46r95';+??NI-P[`%b7OYp9gBk"O!_/$;\_o2:m;>+2r9@^==3\WN,2.1IED!VUAX5
_Hr5;BlL0'+_U5p6sXW(;^Q-[kQ'QGft^:3+XCY?i8gV0V:R-F&;I1AbWh-r<>W)R?tCZ#@`
+,fK3397M#"T.,-/,$84[o\(!AaIW=+]AJGW*I9n9\nL1I@!INrb?QpQI9Kb<l38Zc&4#+>XX
UcQ>/2lW/[32h>q>rg,T!HPo1\.C2*^XGTpqo+D]ARS^>ip*cMF(j%IX`:,:aNU?llsp9;';d
+oSt4_BUaIKEcE&R\q>!k@;DZYJ\gRBD-@a>k/FSBen,j)"^TA5%EL;cD'`1?u3'$8@`OW`T
kKcp10-#TR#DqJ:_;>H>%Z%BMG9!`(2epC^f#to]A/B<"2rf`Z(1DMIgrH[X=M%+')Ea3[KdT
]A12adM"EL^l1Na(;`n&:4A42<NB)OR4_kcQ`3H\=bcmDY3h,S:!A,T\ceZM5C%BCW:&kodk+
`+;9f9F<jXq/!n]A9N"5-sNE0=WeV!1k37)p$6H??O$D*@f3\F3S^I]AHEL_63"J"Z%T0nJ)h^
:CM'I*\RMbT$8^X:m.IV)79[%sKWJ2>MR$+da7gq9$l1a'bR$<_.a8,s.tV_H\<;gRi"GMP3
hdi8lV]AMRJE8p@["$o:=!i:S#$o<!^96e@*j43LeQ%eBu6+[a`hJ'#oZK'i0T9o_Ho-khS2R
oJlL_3NNVq&b8pR<%asUh#HV!,'f,EZlMWN):RD#S'Oj^YUZ'BU?+PB>0M0oL1d.7QPH-21@
rk,S8qFJmT386c?[K&=Sp@Bi\f@_k;:Ms]A%7WE3apHMF#mI3o)b)O0/O9nT[l!\MWXrVg@@(
ri8$GfhKK3)FLrDGdUhHXEq;SJZFEA%oq]Aqj!]AKJ<fd]Ar'!hRZ!cJ=F.D>hsKb!9/`/l[74\
?p1ZESXWD_K@W-s!be7qAN'E'`F/b:ODY@184k*d.gTjf.NjB5=icDpH(t$FQ`NA:o>kD!L9
(N*MDTGK/:*[34f:?Y,q!@pGo^_H\:nrj-nM;iSCh]A&FC46Oduo?8-ms!%i><9MP#;\8Im(Z
7!k@"brC3%f/ek`b.Whtpqe?DFW%UsdM*'IqE]A9QfT1D5W*^-Ujf!KEPb2*cR$E)KEaEj*MH
ser8Z*OQ_^.]Ai9LCFqPOcf#(*W-<psIE;Y!Bdpfu1,-!Z%>D1/4#6aBs9MV7$(b:gL-i3OZk
dJ(mi[]AcgfKS>#29RG!;C\,H)9M(`tX,'TMjikI^hB\h,!F?2e5pWtH0ZWi,M]Ap&*Pi2nY!\
W&[(6d@bClC8^9F`-h;U-1N?<'g'8j>.B/"(0SjMDVHTOoOn\hg,hoGN4Wa[oV5"GDlu\',O
pfdE+fcn_N[U/RF&cUoKeO]Ac\L+=#@@d9?=C7(J]ADIR)f-``B5CJqZ<PNCr"4)077fn^rba`
csL^B'P1uPjA[.U]A7:qt:KBWaV6++.M1Z2._Pp)jm<'W?!pgB1ZQ(bARX+_`%klSL-$7^;0S
eC9+@F@*Vn5%5o=/GF.!O/)V$6'N?e[2q_B`eL[KI\r3IU5^[u7)l7`GI&D)CZBF,CD[$dc^
5#E^r3I88*\;`6?a@N9l,CY\TPM+)9X,<^,Q0$TAQ@P=[pcKOV5/.?CNg?a(8;7'!W5Q6,/F
q^cRi(qDAaR]A>nNR5H\6(c\ss*AZAmfX#e8`Ll5TH0R`_D(kEN%+LVCB5jZQ!"L'ekL9VIag
7H8nrpUo&c''lWWqp4:m-Qd64r("HX>pp8DH)P70Hr3Sc8[+0/fsC-A2E*8a(HAN$37]AtYb6
@Q@u`3<.CXCC7iYb78(=hX7cXZ=bfAnOHg;mtQ=MXt:2e%2E-g@KrGkc_bf`o!OI6^O;mG.P
J3_($<9u]ACX]A^IcVGo1E02YBNh8"rl$Zd-efN9m_Drg&]AU-?lS7e%Q60#U0cZ>,!/EI,>iiM
JXE>PT`f$k*cd+>:[a.1Bm^G.U@4F4gAU.m1j(Me^fR>_AY%ipOn7qU^.bq90'sRGN%!"G3X
LGJnkBJ7(4gCRCnF%LQ\>4McgNFa=meG\a[rddh<1cl(N$M#Of+'%RfEq+2O82C)b2GpCQ`:
_Y9nsOK8k2cKCFp<c(A\dZ3h*dRc1Rh9="7EGp=>Of^!0ceT7P>OACQ@ci?R&d-6j9.cBu^]A
RZ[YGrWWVS]A<?k@!uCM32\@2p]A)*"iT>^8OpT:df?&(RmIT,$pXe6`j78CQ^1^6oiec7bs7=
T35;c&ru-esJBLiErS$#CsSYVd#9JLoGSbR<:+m0bfOq;<G/%M0B*OE#/6)q(LlETNE@?07A
(qX:8XO^Gr%QGe0RaLlgfQX*3,1fBJX6<KkDp>^^("7$EL_&moKUH`<m,WjAs7K[EXW:smAW
(#P\Z.s+24kd\_5=r^oA#Oko2;?+YA_D*67`@CKCV]ANHKK"js^';g5T@2*#=r3AKKn0t1Y0Z
+<5Ujf1Nta_1m%#-kSC`ah[o@!D,Wa9V?K>`D+nj!ufl+p@'gW=SRq]AaE4OC7SU"8&6q^ejd
U[\qsg_N-0!*pL;J/lM(e"]As62WK5h[>T'bZj?]A$ATNrpUr9mFa#?_J!HlW(mql/!q?ZtK_R
><&;5Tq:ka,0YG%2FTBU.L@_dGZK2t:P0e`GHXAraf\TbhiUZb:_QU9@qcIt"2&2;Dk_6qS*
Y?!6V-&U(1M55ct1?=NN:l6O?@H[?g&?S!DRL#cTN]AX>sRG/\DBDJOijl;X$h.?>WDTnt-?q
%'Xf;:`>'69kuhTni<d3d`IZ@Y43DDja?'!M]A@<bRVPe#VDV)ZWb)Gg&qOYf6^Hkk0jgURN[
MJ<#1@g-\L84M^m]AV%oqXllXkrOKACNfX0/acaFad8J%D.FT*%6_D\0_iEM<2WM'![Q0X`S4
oFE<i3alBfW5IbWe&7_M87D0/L>M/h0okG:$.`)[U3g>RrX)eIi^F$rcke_Z`b>t*MY(<W/@
:ib"&s-<jY)r&kkhJRb2[,b"g/Bed^bdr'(s!XT@#7_Z!STUlYthM@:ooC*a\[K<qTC8n*L$
BeH<;Jq'u^c=rZeX:%=dL0]A'9u+i><6^6o`$/1#i7a5Gu>53tiW>]A5#D0G+nd4G=!.TI,j4\
;^BuprN8B]A@GEjZeb:tX/k'rHcO$*W[WFHQ2fpN6M8C4,L3;t7uku3ebIl0qVS6i-h$M)I9c
6(o.SYhb9'leiK02b&$#.]ArFP)%j^mObj^mObj^mObj^mObj^mObj^mObjo;CPY6o0%c=a6_
`S2sK.h'r\k^WS<mcV^<Slud(3%n"7/6irC$^ZRj_I_]A3E*9\%>S\q"Q\EW"A`9q6=h$"f(+
ou]AL&Xrc9bH=C^YE--do;s0O1HFLrGplNrr<~
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
<BoundsAttr x="0" y="0" width="680" height="105"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="155" width="680" height="105"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_01"/>
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
<WidgetName name="REP_01"/>
<WidgetID widgetID="f52a02a5-f8ea-44e5-820d-dd22b9c6cc6f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_01"/>
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
<HC F="1" T="3"/>
<FC/>
<UPFCR COLUMN="true" ROW="true"/>
<USE REPEAT="true" PAGE="true" WRITE="false"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,1065600,2362200,1600200,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,3619500,10668000,2286000,4762500,2095500,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="571500"/>
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
<C c="0" r="1" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2857500"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="609600"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("ranking")]]></Attributes>
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
<C c="2" r="1" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("alert_indicator_name")]]></Attributes>
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
<C c="3" r="1" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("occurr")]]></Attributes>
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
<C c="4" r="1" s="3">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="ENTITY_NAME"/>
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
<![CDATA[ISNULL width = 0]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL($$$)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[width = 125]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL($$$) = false]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="4762500"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="1">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="E2"/>
</cellSortAttr>
</Expand>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="2" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SEQ()]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=SEQ(1)]]></Content>
</Present>
<Expand dir="0" leftParentDefault="false" upParentDefault="false">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="B3"/>
</cellSortAttr>
</Expand>
</C>
<C c="2" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="REP_CATEGORY" columnName="TYPE"/>
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
<CellGUIAttr adjustmode="1"/>
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
<Expand dir="0" leftParentDefault="false" upParentDefault="false">
<cellSortAttr>
<sortExpressions>
<cellSortExpression sortRule="2" sortArea="D3"/>
</sortExpressions>
<sortHeader sortArea="C3"/>
</cellSortAttr>
</Expand>
</C>
<C c="3" r="2" s="6">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=COUNT(E3)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[ISNULL($$$) = 0]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL($$$)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="I">
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="D3"/>
</cellSortAttr>
</Expand>
</C>
<C c="4" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="REP_WARNING" columnName="TYPE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE]]></CNAME>
<Compare op="10">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=C3]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[1 = V]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ != ""]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ForegroundHighlightAction">
<Foreground>
<color>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</color>
</Foreground>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[="V"]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[NULL OR 0  = X]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = '0']]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[ISNULL($$$)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ForegroundHighlightAction">
<Foreground>
<color>
<FineColor color="-15246292" hor="-1" ver="-1"/>
</color>
</Foreground>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[="X"]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" leftParentDefault="false" left="C3">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="E3"/>
</cellSortAttr>
</Expand>
</C>
<C c="1" r="3" s="7">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="3" s="8">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[="Total"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="3" s="8">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(D3)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="D4"/>
</cellSortAttr>
</Expand>
</C>
<C c="4" r="3" s="8">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=COUNT(E3)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="E4"/>
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
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
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
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
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
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="6" paddingRight="6" spacingBefore="2">
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="1" size="128"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style imageLayout="1" paddingLeft="0" paddingRight="0">
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="0" size="96"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="Microsoft JhengHei UI" style="1" size="144"/>
<Background name="NullBackground"/>
<Border>
<Top style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Top>
<Bottom style="1">
<color>
<FineColor color="-2171170" hor="-1" ver="-1"/>
</color>
</Bottom>
</Border>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<a%Ve+pFjB#Y^YYokeG-tSVT:mup_+u#aC+9IEWBd6WhZqurG.\]AfrFK#jK6!>O!!eb#++>
k>hKTJUdP(WfY#tYE8"Qu:2pY:,q]ABe:^hNG9OXMt0eq_"MehV3gof&h=.3qO'c!8(e$nbcA
ei;7#YIli,krafuDC^pGaqpj^(fkW<r1t%FZE^!lp>OU;?+b0OR)cNflk?mV'prgt$4'=FU=
*GWKH=uDnj$s33>ci<)*HkJcoE!I<F3g-;C)?/3fCh4rGiX-Y#cXP=4lAcHZ^Tgu>W?;f5:S
dCYh9PGC\'?B/]AMAAqiRGkS0D>OQQ/.YRbHl.DYcNS8Tc<n[0$F(0]A>$%1@7DLnMgq^L%AU]A
Z%))\U2O@,nOdfY!.MC?P`ucmoFAG\Akr8!E#$@,6s*,@('E>Uqa/+3oMT\pKn=-Fpt@%2P,
;$?-;PBWpq_`"MgR%q[1Rf!)?7XM(Bcnh!Zmd8!)BO.gs9r7rE"&[UJqN*BcH/q>7F'j217/
!=Z,RS&HI?'Q?jMY*qiqlE^@ZPa1m'"F32Y?p]A%]A!HPu!qqmWsY/GFVbs1i/b;O3do`Cq%n+
Re!ef!#!g:732b`?3d?'*k$Ig<DGD!W[&]A%\$[We:iL,Be!=F!ZZ<Gq3/SnQb/O9;c1*u6`i
i`U`OhY$k-:>'@)((l1V/X"=^j(9E)=^XKAq@'(]A0!qfstW?b"F?Pn4\Ila1!ll_lUh^%m-.
^tj4dmi(N^nFLi_ERFhPf$IZYG7sBJ;%13[ri`)`V.\R@f%e#P!!)pWo";p<i-uHiJ]AG^E`k
TrTkPjRs7oG)r5IP!`J/\/U^2hgb2l(T]A!2?2Ps)ce+Hj;%5#M-m5F3tAAHaXc@hG-%a<gN)
Uo:Jb3#LU5W@5L/iT(d6AqI9Z#NcoMO^2retF/qE??S6_97QDFD3iek>B1-mfY!GbbS5574o
5s:PZ-@0P9:k$Z]A`)*):#"=[+gtR]A]At.*f/+'B4L`<JLc3bE8XTaf]A>L_lU4AIu9XfTh^gl%
?5q$n/Y>YWoYYZ&=sWu/KZk20/7d,kQ3r*6UuL3je8A'e@YNu+oKWM.j!%&:KYd4LX.SQ=BX
6;es(?jG_EI,5DC14g=WjqH0+&Y:PM?Fd>2A3sMU@%uF[@ob4RjKT7mYW&91A92=<?Ahs$8b
Z*?O*@)T@X/N,YR-U'NuE)bp?BbWC=?-E2V\jPEqsE3LA0X^r&Xnos2SX*:'rq_WI?YqrB]A'
0-SP0.5rZ>^_/K$gTPDNDA"'Y<Nq3VGlYd91<C;U2Z>L%%a!F-.Znr3K>^M62#C8p<q'=Hq)
ZF0En::(1=eOc4*;0h0BNb8_g?2np90$`?A>'qmfd?WCPJDFWDo\hL1o*nf/^*6>)Octb6(%
ljfbi^Pl!HAiH)t5O<YPE,P'WkTar_ug,K=XIfs_@QToSNARS`lj:@!;-#3A=;*09haANtTj
i@`ShF4LGXYdlM!U3Y#WAnML\<aOA/Yq`9c$TZ:SjQ!L"FjPO53p=?JUIt8`ZFeDkTZ,s-/p
e)\QjD8hE=d;A)EK^d5WUB'i&#n,/%C9c;E4=^miiN"VG$(T,@MX,:@T11N7k+B^T&k_3nlS
f9o*Z2I0iuRkabDb8t6Pn86B3V?tdVSZ_*BpQ52Ad`k7#t-q5a??IsJ/LlpU3M-2d]A+[t=J$
Il&(`4\\Pje#/X6`ls"o3^M)UUF@/+G,YZ.&BGcY2!3@459dg=A^1t@DIZsQL'Kg&'lk*mpF
&J4CL.i@X_s^8(@+VoDe<eQQdPLm!Wlm7P1uE"=/ja+2MXN3%3Go]AB0-h6Y=fljU'd]AXW228
7XIZn[>Om?1S=),ScCB#H21,jpa[g@K.(,&DkI>bU0#.(:d?X8Q&7%ZHV=/2ZXWWL34R*0SX
o/B.tk>%_lLUZ.N_-\*+=Q2M8hg?:FG/=;FbJcUD)H.LG!,`p>s-um91%'770)_H9[]ACQ[4`
Pk4BY6Wh&PJFSl=rrmF9<`M>Bd>?r4Gb6iRX%c*Y1\oWcXgnJme._&[j6:F8A_PoD+ctEZtJ
QW152Z/*S$A]Ai0UZF\c2^uQH1d>(mK(XndquRt\rUPhF2s%9ncF-`BXYh'2An]AdkQ33"!o6>
t7J?_0FN_fFHZ-NPm2l%umjA.F8;B_:,Y'a-rN0m0q:HJZA:",_\0Jj0nk_;k3AS#6[#^<^"
jl8^CCD$03=6F=q[G_KCkg=<%S9Hl;@NQ%-c2*&Z,gIK.n3\2jK2um6HL[LOR)$2+/8juN&%
:;A;W>Bb=\SP?DkuX#oB.NL1.R\(C\l]A0R$kDga"kHL%UM7XDP89Gl/o\O<43b8.[m^^gfRN
6aAR>/ifQ\);;&qaJ"3[2(V<!)1BFp$^NfoJ$dXNd%rR)G]Aal1[@_e>"Cr<<mf4oIK([N-5.
_=qI*:$7TGT`T2I<_$t&t+PS-jBL+N`ckc6)ar]A)?+X$N=k?@&]Ai6e,l%#V4&e9kg;HbqT:g
";EXjbQle[hb<08VN/s+!7?NRbf8f3.("M-4UNHp_J)F5UQUP=LP1@0>]A6)a7]A>Y,u/a;%cK
*CO4R@h@P".5sP-ch&uN.7V+U]A_VGqh\Gm"Nd47cPdHjSa]A]AX)B6l"2!X_F?;WKlZHO$1]A8@
o\S?/9R([irS4A\h"Kee8Z42ULQ>F``\8I91uXU$9bPV4#phVn4[P/d?!/nA;`A^1f1)oWt/
m.77Jk;\*V5#ji1jiB&r#LsRL(::7>F(VOea``nXd[gVqhMUhjP_="H2bJY-*;Tp$-$)PVnG
+iZ5bg>laHqHm>W`qBUs!#R#LO]A?5)pe32r%kN=nWLdHD=FJ0MDrYE:X_V0eRE]A>)@N*V>,u
B_EDs"iGfo51\)hVVESl_8kqo%N7(8^GMFbA2AG=kO7\+6'>r-]AbfIK]A94B6M9^*Y!Ln>(g@
kK]AF'j9W>Ur;Zb^g/p(gF`04RFc$;n2/V+4G4`8_H*KtYZr\+^]A)G`]Ar9FFnIgP.E#iC^Q:c
Q+05%UKrRGW'oRCrZS-EO>Q%)-^`N*-+E"Ohm@UrVOr9q)g3B6_@aE39'JNe.Repd%"XW#ga
Zpg$Y=cPZDoZI+kE;6Y:k,9HK`A_6)0XOba`2OP7JBc7?4*Dg]AmYCUnn>Q7W'7+srY>A)j%0
0OZl[]AB>b2+e-O`C$XVJC-]Acm8_g:Ul[L6^gs]Ath_%'7lOI=BT`*W)brC&S;Hl?bj\!L=c2Z
!R^kUV]AnJ&^*I*j!D\?tuZ#Y)qGGlTWF1q05r!?JLq1Yh9LLL/dOq-GFm@*dqTcRbE05=i_$
irNJ%0(gTa%':lE3f&ri3<+$Y-610KKT=VNkRG%4l;B-RE+&%*q<nR8PRn8Z/9eHD;X(ir?/
b1V;<B*`j'5q/N]A5\NeTcB$HK_?6YguJ$RQ@/'emd6Of$7d]A0F-SW#J.kTP2!=BVbB+hcjoP
=mZ6-]Am5=%j@tJ'oFoZEp(.O?4)t*7gdk/ROk+f=)9.a+!4JR29(sEd"bod]AFVAcS?)LQ-13
2XkNX(t]A43,tV0f.+h$s4YDXSMkQt]A3LcKqcSImG=f5Za>d"Am.59/+ItOC1;O"KGB*uNHg^
esF*iS*5h?]A3L/D]A/HmiHZ<oH1kjRVl)c.PeX0J\K%Y:047CeS?\;>lI8$#0/tOY$V^]AY=q/
DQH$^IAu]Ae9*D35md3't,.Ke1G3sA#@tt3UV+j.+&d28$_rCtLM1+.HY)Ws'%d:`P>c9G:]A0
VISJ.#PU?_THu>XFF3B-pFYm08MMVAZK'pXaW;3M,WElCfu<k+CLfRnSE5o&,PNK!>;h,8!e
[<0]AU0U2!bC&+l,PT\WLX(4Y.A.!5:nX"hA`49RnS_)*TlgS,#9p-lgY(chPCSNA2cpm((oZ
6-Afg:[WkN2GjH4m(c!&5&5>r>>%)2@^V7bl3Rt$Q0)jf9:JY?DT2.POm-J_(u_Z-?CJ^gVo
0H2AZ^?9::jK_/*0@&r&]Ad<KO?JR&7;\ljs_DH-b+8DcoB/\oQ5-#uBdc/RJfh/il1lk['"p
+[c?lUR7<U&\@7[F`'t2r$]A;TUs'5*>jiWR^#[$,d)+C*F/:`"NF@9KltVb,*"4#G+.,PR[?
K\3DE8+oqIB5JmWG0r:lh);Rd7R#8up&A[^u+bLH_s,ni@";5!DYi-NXPAW_P4E7M]A@DQQ[V
-dZPMOZu.Tl872,Z2D/q2nL;n=+aL1W%%GKZ)r4UNpV3?&ZRh5C4e["r7NW9U9^mWOJ\5L?%
"PqZ?J0YRDQi"Ln/.3H'JY7H;K:Pf/57DuQD.eLp.5Bp(LF5a6Fq_YXfFEsI\8COQd'jE:EG
R7V:=Jo(X#H`<8CUs?%.ti"=;GOJk'7g/("Y1FCQJs5f)Nsf3C>1qbo$RRPmi2Dc,0^-t_m/
Yp=>uo4T9e/#/EQCZS^ns!dEsH%.\SUZH*bQNrm8$K`;C06Z-n^W<.E;?QF@h/k4*X3Dj'A^
<(c[k.kUUma<P8?l<]A[1`#LNO+B#jDi,H1-4?R.IDDJpLj4rqRSuQ-]Ao>mFuK!8e>'2KXsN<
@lBfn8[7q63$`tQ#!XI^Zm%XYP]ADg_[=Ea)'`gS]A^&(=lpbt0NWTThO%5.PS,9:5Cs/o,oX2
(6_^"29rXf._foJX7SUL0$%/(dLhr6!&(a51)`knLhcDnGX@sraFb##q6b*'PAd4.p!$H54s
g9#0r"u*6V'=\^egZi>$_%-Q*qWkQs$scWYN;c`*WU0pf2%S"L>ff#E+3DC)KYDjCW@M':Vs
rfJ9rl"rYTh9;Gre<BEHqAD3GI1pC5g=+2PG&r=`Xrsu:<U$f]A!`uP/i]APQ!p01I7E9>'Z:^
&a1NMRl1<BP2?0MF_D^/8i'V+3'#&)7%L@X(Y%n9,O@!YO>'CD!<<e<I+A/$*8);!XsQ.:g`
tFb0gYaTnD?Ie@"@UlqT#/3S=3>/YI*c0DRLn[X2Pa4O*5gnS!h:^W(?:@hBAbnb\2Lj'YTV
o$jH<.Xka"0c_6"]A*92FWXnG?<P%.16TjQ0]ANN]A_Osb]A=j)lHhTA8_C9;6X>tC8R9lZft0/#
?uLp*)EM(^OP?5H),1]A&?O(ca75Tc^9S&b7[Z`+0J,n`lVfP1cdU88:q6.9o^RQIdGb8Y?0H
d/ca/`2'j8RZ7;A*7TE)YudBD'3L#B+&OM%q(:OTmoe@IZFU_:-6Z*Um\bt=X^(L9j4']Ad&^
jD@@Ofdr2sD:/@AQb.OL;ABoKgY3niQpAgNCu:,>[P$q$2dkdbL#tliG/_)m6sE'@C)*/,8`
i_UAKbl[9!J*CgLi6q@'?O+.S2r]A+)c`*;iWqT$2JJE5XP/Y*s`!1sj8HH$BpO(C^USrf;A7
]A%5d0N!TMh55m\mCoH`e^(500KWs9n7Qc3ndfV*2kJLuJB/#g4HmU]A;5naaBT?JAiKb%DM'@
&6Z08BS-g'(f'lV3=CFu?q+&6ChMTt0i]AX]A!<FNRtg=nJO_=YVHX76K(m`9GX%r'KiMOr8[r
1h7"8@j3kP4"=.bZ_%>"$l4/q'2`5OB-A`/HO$T"X=+a)nWI5[JDFfOno9;98(eE,;P/9iE7
mRi8mVlfkO,cFQ"cQ.4AiN<'hs,0ZmY4+nKL3E-)g7KZa$DDRDmcbrr.5t>X!<8?g4=_Rm5[
9C@!ui&j4S"U$dl0.A)A_2[;g[2.\"<et-c#m5TC7N+10uJiL;-]A\r8`.o]ARGAcUd,4TlkDh
5/f9XBFdd^8L)`rAIL_j71E)8[n`m^#:nK1R2'hj]A^9ueNXZLp\,Xcf'3=ajo%H>3gF7S^p.
Y9>u^`O2d5MV<j9_UcJu?RF]A!]A0ID:%WLE+WJm/:k;IhU#e8Ipbu06*a-dZl#_A[%gX_\OOq
DB-oarDn"n80Qp)$LZc]A$hk,AO.FIH#C9fDYkh]Ai3c9@lj0AL=-U5T`4Nk1;TD3E%.ioZpjH
/S8=.*RU(,FL6[j=>2)_C!@BCYpuleF2Ma'2;bFG,`ZD#V$[q3KB]Ae=-hGL*s&,O+s]A1&8L%
QSc$!]APsu/jUHR>2aH4rW$Pn=R'NqY%?AKt9Sbu\Q8b,=I^`BM<fC@-tVq-Ws)r9drOm1NZK
3PJ0QX]AE<^pHNJR,*r*8hFbT0=j[q2$5[24]A8Cf^Y->`#$d%BhF26S.%D"96bZkT=]A<7Y&_H
N.WdMJ`Pffj&@b&sefYaDb.tY\fo7e%>3G#!3?i9kEf^jF<NgZidOH4mIOl`N%l7VF-/:R*]A
a]Ad-bm_jl*U.h30^J\Wkk:7Fu2a15j*\Q>jXR92>ZYQTuPs/V5GY]Atu`&6sIZjkpg=/%D;+t
NGE>&/iZ>jJg.85>[^']AmZ*[f+#aOQ/`[cd>U3ilbQ,@GPsoB.>rK>q'".OH,VR[jkMSY%'d
ML@"dJVbt4$M!6QNi`!uH(ItMe49Q4[D>4hBhlcC>=h4Fp=bX"U4J>s^;;WYeJnbSoC\`%P]A
N(/4bnL4!5,Q-0SLNUekNK@XRipL@6BQ0T"@>`*BmKZbR)2=-[fSDF>SO/:C,"poTg?UDrNc
rtB9T+L`lhV*BaH85DZC$c$/,;I#E[drCfB(NQS7217WmT;Q]Ag6I!GF*Qep>$NF0m#k3:!gp
BGQ?;2PK@l8!@.e4&U1VlTDFrogk4_USC\7h;dkVDdlEpR69:tkWtbXERf%3*fCs5+>0UP27
@'5[5bJRhJdPWUc@pt"kjRWG)b&A"48#!a#05;A.jo.b1Sa3i@+p%gj(&*g_a:$e[m^N)EFd
$Ri"5O'JVfX0("M/=+2;g*tgEsklJ*M9M`(UN&["R'D-Tdl>R8loHm1'#DJ?p0kq=W;<UTnN
5p=Va`kAa<16=<QPZfF6/S!q4kE&Hn-bDP]A2IVA34Z)_.!14Z@1uhYG]A,a*51'Z9I"@)4i&$
3,92l.)kbtV!K",'li1UYtl=1.Gp:/]ALicqcQOl^N"A=%'I3Q0!Y=FG&0@\pS[9[<B]A@Xe5F
^PDTC#')%8E;Y*p(TA\frlE[[%Ak8TSI;T_a(4Kg/8KAK<-N7dT,35W7WbI3go`ANbkK2L"g
=$Mfpo'Z/M7BR7#64lKait*kc!>si>FQM@RuC'EmEbT`>AOYH\FTgA8Fr/75\"Z1$!.sW8!j
Y>fo5N?6,+"BJ6QjN#*?A7`W"BeL,<;(!PRG^L6?j]A;OL#?AeD/DAu+cTt1-QZhq%#/>J3bS
ceq)Yjg^k]A<`I?GG"+)>s$$-K64:@;l=>mMFF*?C6)l-N:+(q5&o619.i:TeO@!q/c-$Ag=H
lAYkS'JHqiNkVe!i?7=A6.-u`d'O^t(jd.m1LOGQkJJoYkTe3MhffAY'ZW0fiB\PNLbm&bH6
0<U%[@ktr-oUO<[.7*KB&!N@Yl4@]A\r6aF\_`$DICQAN]A]AdPPJmQo4G5Wa$7,[g/5'lSu(a^
"H(Y-OOGfUHfUA"<`b]Aa9*Z*<$CALg2k:L<FGB&A;Amoq6nLFW+kCW"751`f+(s%'JAM*3p'
>A"/so50r^bVH`[m->),,',SUS$J*e\bp1hhacBYuPI0[SI$+4$8"$=4IWG*2rHg%VcYM.=T
R7qpF(LJDG;pPS2IrtY)G[fp@*hFR1p`S8ZftPqUSI#V,D"Zh@\Y9H]AX$<<W1K-S(fo*4O)"
55SV&M7(Xpg`-?_0bg3!/'2>NB7bWoOE/F[D8ZKC<t)OXoo2g//]A+ujUS1q&(LDqQ2FfS698
JY0762HK]A3\")Zn>'E^TnIroeE2PF_`oI\3fUkf2->IC^n^0V7&=Bu1$rtabMGTWkn$]A"+;u
l=s^V?,Oh:Y5D]A6Pde"NC=>A9\k]Aa8mDYK_;]AQ?QWj5n97BsIJCf&^*KNHnH28_=OcAfZZaf
?bA-e2iq.gO:Yk>"A(g:;1nnUi;TI6\f<D-nf_#5-I,p/F\1sEJd9fGn2INtF\>m\]AFgu.Qa
_#QtMu:N<EhB$k;.b?"U+#\#r)q_KWFX9I]A'Rt4blM"K4*e:),T,tc%9>Le)<4g(SXN)(mnl
5arWB'IklsMiA#Bro#"*6soj$719UKge]A3BoIp4#2l<i)8[%oZPqKI8SQo@E);\aJs'6(8SV
o<TseAf&J:9Ro,I7\NXMRd3sBCg7+>e@55EPun\h3Jd!\MdiIdXL+$u<sqajN]AR.FR?+g""h
#IbYOM$%RlI9@[sU:i[pDm(_m8,(!0(%:.>A$_is;2BFoZPM#qXRn,.t6UKQu(86uTI"W?hj
B`\`;3;b%-L.;*(To$X_kMD04^d/j`a-p#M6QTub<D\cNAXD@(rSc`G-&-]AaOLS@GS2a9UXU
/4>@9q0]A+K=i[,6$JM6cp;gRJ7@X54_S]AVGqKOG<S"(8da*pR'a;4m;is;U)i!k,==oJT5$=
V`?KM\N,h^d^g+AoC&j^p8(;ct>gS!>VN<;=lqr_3o,(UdHLg"glZlK39o\U:#[Qk<GB^<W`
@L.\k&#LmY&CS2Vl6VnSgihB*H"M=B3<cKD)%bAk%OR/Q\I/-?]AUq?oG%FU0?WON#>n1("+M
3KIjd5go_.D5EV8iO</%b?#0kF6&[>&Z`kFkQmU.r^9.]AFQEN"Zu+<<bci5I7SpoYnlFlR9I
4@Fm^ce5_0%Mm.8EoIr@Act&52Hb=]AKq5nm3rDgV\a.S9T_:9B(aHgq)P;Gl*7?M"CggnS1#
nCD4*L'1Pd?81'B$M%$]Aik\,5_1Y'dTXW*!JoP4,Tpmnl%jG6Lq*s2Pe[Uqe%:1rkdIF/F`6
S9oVjNNJcgK754)g@)a]AhaoW/I!L^+Ojk[W_B<6RV?^%@@t?J<`-M(73"mreY5;OgG)0O!<U
78j<rO%Ol-qXuB^Ec&+_(G0'0?(ai7/@p&>O[4&&M>XGGJ1M0mD`ou?,FK3*a\H-+P[(p<TO
dnNo__k_F5IIabq9at2Ng3HB:O//Lbi_>NpPt_H^_1RFK1;Pr4'h0aOt_7Kd5<lo\Nm:k3$j
76GBI8BG;BDAbP@LA+BCWi[NbG>bBn4^6\si_5).S*iE:?k;7Hq7GI:KA7dmGc3!V2SS/Fi%
!D3p7VV*GFrrftT)tTgSaD%F-@J\BTq)m<Q)f8p?35qf#^<n0-7QVI*N2f+R[ucpkSEN!%B+
<q'-UtH5<h@BlYVGNPAhjNp#0ZFO$j?N/eWr65ko:?^?aiq2GUSt\0l$mj65-/Ckj*p(!sIT
\/]A:X*.31tm.H5/J0Yk`58)=fe(7Y6kq7;j0K&AM)hk3Nng<N<a01((S(iMS^;$78>Ac'^hY
fnco+,X*I!IrO\]A-Efq96s<U;Z2g?Tt#M`"$$q-H%Y,<6nXH5SmdlD[)!9hY>d79d2O=g^ut
cmo_cTkK?YLV:&,9R7c@7&L)*WL^%j*M]APc(F%AA_m;[r((/$a4'cfUj^FiGQ\Ci%$T)pN$p
_(fn&c"+KULRdK()="o8]A1uG+CukY_[;`aKOH3UB39Kee/p#@aEE?^s'`l.oTi0t*8Wg,2;&
7hLIs<c=%-1`E?_Pu%4H?l;^J=>\Nq<-9q\qtH<ji1'Jm'cXODnkLjC`D@<EMUCu/EB"bRjS
Dd-W)8KURPqC]A4,81uCV1Do=5im))sHI%aE0"4PSn/5i_3u8<XL?kgq.B/Mn_j;D6]A=nG,9?
"R\DR)t;(<S(Y@0jTP=g2+)"/sDNamja6S3K#0`qU&)a%mY>Bq:'u4ushCeTclbqJouG1:Ol
)Y"?9!QP`[d@,_D9G*E+pd,:)tbu0Ie;\\hfY0a3mS2YS`i+j5<6ZBksVrWadIeX?rLZYi)a
PW9Wr@Y'*OI:338Bph<.EeH!cC!tj4mRr/e[$M>V@34pWTp3'_Vqc.:[_=sj*h-jJHneJ'Qb
6<C46eIjPNbi5FrU3l:1N"fK2-O\5X9r*O%<pHqn=fCNjQ;QXmF&qks=H2a+I0`@\Ffdpj[*
I(N\?r.ogSQCXq,)X5F#'LLE5eE@cdSRHKCEFO[JoNUcb(F4>_hmih5fL'oX+]A]AG?;6r88Ri
YJbNm]AZQ@LegTEqc-^hmt3OCoI-k;7.!?g5B<[oG4Ok`ei1;(=D++CJPM/)SVDlZ5fC/s3i\
4CmEj\'k(n1KZ4>7?BqcHIdAoJQ2,`g,N]AhZ8!)<*Xc<d,r=1[jWcG1`jh;?.p+$4$W-oaCp
h0j#1ob1^mQ.--a)aE/S8g3LJeYi2oPCkjcb6I%Z[$F^m7'N^KH;Fjaa^\:`c>f`&:*#Xf5d
PE16t?71d@4*\tkQZMkoFI&4&tI1hCLl-L?.fT[5_8rWkT!#s,nP;I@&'Q^u8I8^;s/N4&a)
oO>-4J%W.U-#P:Zc&M%U\&h6\Q['^b-:l^\\RP*.FE9Kq;j&CJk<_,Y'qmP>j)R7j9;ZUk_^
3R9p&^IFR<uT7e"9'*oAH<_>A`&AASt![=$Qn(9!bRK\CcqsN(Y'oDcON.?u:-]A$-5q"XDoe
IK#XXgpQ6n!*b'LWJ!aD9_Y#\6".<e.TQSF%!$X5'`#MIV-^EB7qinEnRWR5^E$nU!'Rp8B,
X.c47H7:?F*nj-UK3<8$'1j'M6]A\a3He`FIaR:^.:;F?HY;*8_aWpuR\i6>[S?ndUH"mZB9l
n5R+a'FpOD*?U0kbX8#mgl6`i<=+0E#%QuT0a>!1G7n_eUdB+oTO3__&_,<"tFJ0Z^4/W<;O
0%EN]AW&o^[Ln1l.Co\*=^[BJIG,^1!)i^tE0872Gf7j;+:X&8XA]AY.:FDeFchQA"hp!DZYGD
DKo.^d!umCYl-HX1EpWu-DfQQQY(`_gWLH9-]ATR6oD#B,iq8BV:ghb-1;@`ht2Ff9H%P"h[I
UM8L$-kp$ch$h8g@q^TZNT26]Aq:p"BqUTe.9m&X9an9PkB/7#R4s)\e8l"r47O/puj)]AAZP=
m"8B4RP.[).[s4^m'7?i`gDb8O5c/fem<!XDY]A-9SB*j&/^l<M<7S>^Q-[40?n^El?BbE]A46
:PAn*NaL%CdfL!8l?I6Z@r"BihdV.,'g]Au!_AiloE.J7\qq@]AM"/M"!;aT0T]AoT4+r!N['Cq
<Q+1oFLtTpekXTIUK`gp/5Ga33L[pRUXJ;VSD^A*ND[0Nb+kLgrfKI6TR2]A<Sc+FJNen@&:P
ue[\WH(Cb[:#<`s.W/4MU0'VOY[`!:Upp84AuV2Yk_pPprd@9\amSPO=u+G=G7tN%X[A*>_r
!ODf!D45XU]AC1(^GW[DP-rDd/VN)OVD.&F82Q4A&;$0"t3B4;eOJTFJ[#4O7!6$0DWY?"+e7
]AKBP\K"Dro)?pA4=&*BVpbAKI63LJ")0DMie;qnbY^=DdVU)>fI4Y5&M()?V8j6I\p#0<'-C
TmI:DU$$T!!-ZqX!*r]AFZdL\0]Apmm3BWdAajV0TATGRdqN!l(2>"n:]A=5[!f*4XafQUaCEVo
G?6Ws.]AQu.pc?kuKF3;K_GXPCo9/Xrd\\,OD(@g!VP_Z\k-45!FKt:*\hL8bbAIV:=?Y/6A$
]AFt@,@n@YK"4cAn*u-M(Qh_XWD3,/]AgPsQhk#]A6-ECBiH.*+,&HRB<9f.*Jm@0oa1B;7"qhW
`\.MCYDkIX0=6?SSd+GbLZ*VC`0YU3u"Q`$11Q9K1lJ[$7K&&TD>._KLgm10hD]AA]A4e(ZtCc
X,L;\)HVFHhrDkg*s)]AmS9Rbo5f3aEji,TSj,l;T6YVrIS"T"dIf%[XZXE_4&A<<&Cnuu"rF
$SJ:*a)OuKXZA4fp#B)iuINeM7^fZ76N`%I9"6/#Whg6/F"iKl/kbB9sU[I1'd<PY.2g6s_^
G&ha]A=adM,(Ho=7oEL^82o8*W&ENX%F.8GND3`:r__+DjaaHQtZo`o+HhBIZB\VVHQL$mBmW
j4I8i?/2nbB0WUc7Uor*S*#5d20<bZ2n%pqmB-&LSsmQ:;fkc-4%+dEW8GQRQEG`Q8k!M2Yo
44?E_b<lhB8-D$6Q"V%;60ogbWH=:rlA>TcI*9Vgh"//oc;@"4/"=:Rk5+["1%1@'%r_i5o6
9pC)J/Jll#[[.6jK-uRZ'-P(4c#2=QC=0.30bJk@bkV;lkrckAU"q/K6bg@[XW1O2j'_U-(B
G/;*Gqd"?e+>HM92K)Gb1_cS]Aa`08*&'XP=6!d4k/eV2#gEGop($h2,%&er>4p17qi.H^hYR
0C*r/N=:d37ho;N$%JkV&'nsGK0D+&XDcE,*o-CV>7\U3WJB]Aen%5!f@3]AFL+ICDN<>molk&
ImAl'TuB+Wa<50RRPD"d/0Cm.;_.gEbh.7q@QPNdj]AGP,G;a\**Z=?S]A,o6jW']A2P_SD0FDL
!8uI^`QW?t"\K_-RTIL0rEU^>an^a<#!OltQ,>h\DWq_:5EVI]AH^?M?s6Bgb_gR"rIrO$%rN
Fl/<jck`kmkPaM-VRUXRpSqqMLdYK2d)XIDZi+CR!#4;:c1o;,mN[-=FI)GRa;C[BM&8hbbT
(9g(FI<AqMFKhG$8V,+A@1*N8>!H[=&W"]A[Y:mU</W@jY,U]A=/9J<ej:MqF\IAD;RZ@@p2N4
DA6jYU+i^Ui.JH%"*Xf8.;LHc^N+Jr_Nf6nr,00>!jU^gNN/Yg/+)$+TEhN$4\fFj^_1SZ`C
NMM*\C=OXiYWa;Oq,^_G_USSFn]Aj=0[,-n$hro"N2s5$6obc6,pu,,e&**,;8]AYm,BGQrEb?
<C7D(AW>ar8_DjTf!P*4B>eF*g[r5A3P-,B877dp[c?8&*Wr*,&8Da:q^NdGoj(ECQ]AG6Nh;
t-gC1hao6Rjka%$]A2TSK<'@CmT.2W56!.IYO?iLMftfd\")+`:TNe.?gU_5Gk`s<TXRIlDgn
@0e$k.BX!7#-FSAR#Z($5s'B7Q4Rp%?a'32@7PUD0@isM[>i\B/)F+$cIMQ;8p1cq"J=7J.Q
?09U*Pt`h1JB.M9V+3al$%-@%-<1Y[X,=aae$QV0?AdLJ4dN`bg-b<rWFs`#O8!g,N8e\'bH
s&eJ4iVcm1#e[Zd699Y^i9Ql3-t>f^pJ.Se]A6,5'Qe1kKP@Lg17gLMOospHREnH!L]Aa0=S\/
q%qZ^TL,U)"D2E"90KkuQr88_S9e-$9S!j0Cm#j\rd]A1&hcA]Auii;4XU;3qX00',A+iN_Z^L
7-c/Cs>5@+M"k/)J7E(,0&?#.Ac"7SilGMd3]A!ZRs(I<I0"cN"b7^neNrloCG5fr23<Hfema
SfVY^!N?@e.mk&p?`p1>f/Cf44BcDmmKR:\K%OPGEKD:>d\e?5F2K;'@Gif6nQ'G;`gM[++=
h53cF4/]ABFM/"@Jci)C'),0bVqnU).kj>Be@"bOK]A1M6*f*po4b=.CMem#e1^cQb1+O<!'nq
W5YF=p"@2Vd,(\59EXFN]AH]A3<cuh;4k"\p3\FA?/`;X+'?_b]Al$`hXSG;>ZYAmtU#Rdj8IhQ
,ls;i;fNm[GF&q<hQ2r1p%XQJrk"AgNOGq>'X$'TVcGQgVVHV(r.>=p";)\`1`ocJC@8s)Ei
s-9,B3*(.73(gqiP,f]Ao>f*pgQ[4P10b`pb]A"[qb?hE<<`JVQ#T0[C(a1HpH0tB;%A^1=0&l
gLl*dMEO=Na12-iUq?`j;"4B=ka/:TDZ2g$B;2VaE`I='tX?P(G>!F>(iVW`mcA!MfNELPM9
Was(uqnqdY:%igraq'3ZFd.GZ:NtW>L$<f^;W#4R=fI4jEGBAg$GB)Ra\Kf_Y$D:qdMfHD.k
hkmG)It;J56)<HOQrAPSZ2(]A`7CA]A3jFMs3461[Gg;H6o6V$e*X]A`le[=@3RBb)Lc&X3XeJF
Y*nN*PFoT"jq93/*`Ta-4.DOE@Ctu;>liuid[g@I`D)+V\9*b`^3[3>_!gh7lQ;R@Gd.oQ+"
7c-`0mY>5lK>>BZGg+u$!qKYc9B_OoEWfpl;6(gW2^tCp$i#Idj=gP$cHg$E71HsNZ51>he/
o]AMB6GA/_X>HbVFsT_brQrqLh_"V`HjH[;C9m.S+gL]Ag4+]A($4G(qd41\m^id;9U9!pC"3/_
If*Etkd%2,C[^:doL$L7<_WNNF-)XJ:J+4H";)W>f)4:B8@DSq)N=<?;MA@8k/b;0?AIr]Ah!
$8m7u<U*=)tl(nt:BInl`cq+8t&7aa=?'Xf[$ET1,)rG%^iUaRUnG$b_#[\%NqT%taNW!-eH
D=R1,)P21@nq`cc;f3'e4e-P:K>(/%-ob%:'\7*l2'N^sJa;#>a"[&#LjWV,H,q)b;>$&]A9&
1O)bQm`KRFY\8W;Ydj4I+)T;U*;Fc#+$g>7eO]A@_?tVE1YFOZ3[32WeYM.*2(dumOW7@3aa1
epFSn&/rt(BTM.TTkdhT`4HBRs1B*(mahP/GON+ro$LqpG;?aJ!GATX,'Jc))8<BbY56Pq('
j&1mUf0>/IC<abbfnR8up7E"l>^]AH[Q-/@+($D1XQI%RG8tiVe\)M$hjgY<P#)oL>@*`fR*O
*2k?#qNj+V'g^fK6[L4p>qSrs8Hs0AZq9`/#lgnS7($gLVg(f.a:O<?LSHF]AZHV78V.KKV`N
L'oXKEi;k>?V"@(bVjAK,(6Nq:7TBK?U]A$Hq<UP"(oV73&A<C*/Z!d;\oON4(<`L`U,#]A%aL
C/RtZcV_G!D+-m]A$?30g^]ARmfY2!&GmE6aorE^Am1sudiP!:j35h*g6Ok[l"^U0&+eP_4(a4
/da(=i[*F%a-51!"LS]A2WP158SS1T(Af`\G[eeFMmV(5I%S5`;9UENDT`,9D%b)G8.e>G"Lt
mI+o`4sNt)Qg#]AZig8H+r:D!k=iaVSj:l1ddYIUm?)^HfK^aTf-:5'6[?g>$]A3NMm/F&t'@I
4,%@Ls23b(pP=;.+p6[W0r7D/!b*Q[#E%<C8g7U0=(u#J3p_VR;g;Lq3X3p1,Xk0fHPcX_0c
I>1e1!o737MkQJ?jQ-8(S(P2orM*C(.5%:g`nkn4`dB,Z@2LX)bT[9kqfQ9d]AW#<["dFHok=
d'56Y^oP,@Nmp+%ol-'@aYM-0`,hpn>tjhH4YYCj_0puYk[p6)Bp&uRB.uTOYlMf-bA(C-'8
d)<6h.jCYfOFI$<cH)sH%WSRp?/b9>`s["sFYLb%=/^'I0R+(j`;<>3cU#k`@0,gR"!M]As$9
1jkpM>Up%2;L2PjBf(7fAGU[&qY)FYVT1>LH@T-i88UTBG/#q\gP)'n$rTfE75f0PRGT-?%%
nHb[_oW>;Zo>*@+3Jna8"'L/(WNp>+4]Ape1m:d!@!ZoLT[C6E'`6D*j_eqnkJd\@]Ab)d$k$.
U$_ru9-[oZQWOgus:#l;H6uVClGTo%CHsHGk7(fi.rm1HZDN-lhM>j,70<`R"5EX[41o!'=-
-G'OVf/Z3pEs@;,Nauh\Dl[g[Ek4ba><C?cXqr_\M]A18p"hl1Bh9NK%CuDuN?10bh_qM'6+0
JRhDLk\EtGD'8dt(ui/UDo[.jgXI9a*6IlM+74U&X)knDLsQH*$`AiBo^V-m/m?p*M.2^+.a
(WMAnrT-%8Qi5iu_?_oW?%Q<'LVS"/DL%q9I)u(,HqT_?&Wd=-lKQ3Xf5@B"O>;esdpX3pm3
*Z,iU9\F@XDXBFc;ats8?)YFcH8UcYTa[GDrU$hJ`6=4-`N;b=[%Xn(`:OE,<rk>n?H`_@Id
]AS/0BaOl?![#&Z<H6_M*<j]Ae'in<8^hm#;.l--`kUhGd.^q3ute\Mb2IgjtHn*hF.CG.q.5[
GLE>Y)be#'#=',)8DC<06@+.63JB/%nrd6+^^OZLL(FpeCrmM.pQ`c7cT4jbo!/\'Jkqj:7c
^dXRchq3!%?IK-QP_oOTPhV"L&F'DU!Qc2n8K$C+[GJoK?6bD2:\ds`=KC-`rn>?tI\Fj@p(
j-t@dpO#/!U*"P;a3.TqMEJ=ghY7%9)9>V1Ak?tF)6HqP8n4btp"DK2BR/:1P2=_D;\,/8Ks
26(Ch>j:-J?G-#XgB54,h>aOt&]ANpE;RUH/^Wu)YZ-2?`jt8h9dblQ+J<$d!pgPJ?46XG3FN
;#)#-FBq=fQfS4fSI40Rj?-!rnk3HNf5(,F\6I2T?G[8G)m8&DWa4oLZgLH3.HSkE)$buLsQ
ckc$U>"TlT<"o4eeokX-YGH;;s:_[)bo/n%-H<,\0g/n'5#">8T&G;kN<#V[>o;Yh$TB2Et(
O1Ht4ZWUl@7O\Y]AbBde5h3I"DtTl:3!K2='H64k8"bL7O<$A,Ej_5+&=+.(=RuG>LoW"Lu>H
=n*;Q[#d8VlBo</#8c)i6A1pWTqR1[;*F8I%cc%K%^nak_sVegGa>eb\5@mNS#/*+r)ZCo;\
dKhTK%)b,p\ud%ce$oiE-Nq+IYJV5<;=o)"#*u9Z85;Ni4]Ah<^$e;gFKVtR-['7*=kOHjuAW
.Q!%c\8A.a,:9u2/o2_W,?,M#RVZg5ULH:@0W`cVA;8:Y"@-(c.$mqf-V)TNU4;kqng,%s%q
G=_I4jefo_4Ai)<g+[?lcis/aH`GX'd'M;>EpZMUaWmK7pjcYnO+5SJ!qd/0ReU<PAc+7g[#
oLpUCem0Q#@Fg8et/orpnur3WB2rBPLPE"VTBSM8(>?3IuE'_`Otj=5C#hHie>r.,s]AH+P#*
N(q*dHK]AQmK+>aR@#]AtQc1^f_bId9["X\K4P*\eI>&U=9:Sii+N4B4$4B(*[XilIIcUQ:1H7
/%l33GHodtOm[RWj0pU2BtBm/2#B[QT9\N#%Y9-[bh%muRqOBWMKLD]AA+iJgg,6`?Nhb:2L*
V'kqiDs"NM!g!3h32r;O)>tF&!]AK[[*N_\%=;N)pp]A$!B)&Hn.1j\9MqcqAPW;4<==dAc8'Y
A$^D%#F>\)Y"AtXX4SphC7Rl;s&&#VaAX9L%9`%%*<!eGk4_K`eBIbqkXHk/G//>N,Ag_`^-
K1#Ii<ip82[4fNm`:W`E<:78r$H2,Nf7AOu.fWr'/sH-+:A__tV>fq3p4bW`SLQfmZj?#`S\
'@XG"1"u<Vm(pD"X8Gng?NaZZ-`J/9M_1qQ9:(qA`/hSu2h%Ro^#PDo<\W[f1$g_W0hQ6&XF
J!dc8Y5[Y`tc?.6l_0Hk^,?a#gmk[5$KkgO2?ogC6)"afif8?oDGbi?H_q,O'BRc_d#XSUW\
>.JVD-"JUn#F"\2g&srb08P<j"051.u;T4tY8FC3;'VXjEP2#RJISKeAk)_R<JT#l\Xn=oT"
Z2R<*oF?>/8oFS88a7rF,M699R@hpfS5N%D`4]A[hHo78O.k0S6GQ#Er1rs$4kCQ)\AF,i0^b
CWdo)1n[lUVNm?e9*n3;1N=NSdapn4@9f8&G-(VN9gm7gQ[:!T+dGH&:00$%l#^?hM.).,5Y
Ifg/[cV8"6ku$dY2.WCc'Zh0ErV4GA]A<-<9NNgqc.Sahn^8n1mplKg'PfpIR07$,#o&1d3*u
8tiq.hn'g'tsN@Eo>OBD_:B[_.7nI<-jd`]A2NnME>O@7hCltoa:'mAl7=$gaF>X\,4:m/,lr
`4N55:jmTDAF;H3K9A#8Y-t`^/#iY/'7?q%HctmX/pbb1O8Hk;3=D4pm''1UC4E(Xi7DRAeU
(^'->Z;m5&iX.s"n:fKcGEW)2h9drK!c@>!MZ4C$_l\l!:[$;,9Zp+fPgSfkdSNla1`/b]A)>
UXZn2E&=%,+Z!8s4(U?!!gn7S&cEtSJ_B_cfGfAU(lIi\N2pt+J3LOU?DFnkuriO?:8Bl_tc
mGr+Y*)uc8);o&14jWT;^.b0tAXLBcmB=52^C%^_^C%^_^C%^_^C%^_^C%^_^C%^_^C%^_^C
%^_^C%^_^C%^_s*k[dFRS&2,OZ1/l+85@OF3J$ST]AHnq'DT5H@/q#rH(-sr)NOlVsqY$@NDJ
a_Q%[hJoJR&I')Z%GQ&*~
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
<BoundsAttr x="0" y="0" width="1148" height="895"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="725" y="155" width="1148" height="895"/>
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
<WidgetID widgetID="b2abeb22-6996-43a4-9df6-7a1cb81226dd"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_05"/>
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
<![CDATA[lO<9(kN.ld@UNU%p%320@UNSD"^qm!TZFI#Mk;^XW/5l43/1DVH#r"R-F8=)MkfD6,u\F<a>
A9#hK!"0o.Tpaqs/(\T,3"WGE4pa'19WH`Edi>j[%*06E9t@(kIVMh7uemK2H=LI>sH@oBh2
rU46/>rTc`XL*,q<Sfh3&eVa`%CBfA*G]AZ[^;%?o2=?puT+r(YH5tD`,e.`?e&9l6pekrQE>
">u\C)thcWc_;,W7FhJUKU0qNbTTb3i[=%l_rB3XeT&i[>o!uZdtT4amEJRe%bk=>!!761.6
A=2(,=hN1:5P*>Sc9@oRJJE`@'YE`@'YE`@'YE`@'YE`@'YE`@'YE`A3q+Z0)_]A*6o+EIo<!
:KKcIF\W6;!!~
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
<BoundsAttr x="0" y="0" width="680" height="105"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="155" width="680" height="105"/>
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
<FRFont name="Arial" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="REP_BG_03"/>
<WidgetID widgetID="c32316c0-ec1d-4c42-87f8-699375b8a175"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_BG_03"/>
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
<BoundsAttr x="0" y="0" width="1165" height="895"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="725" y="155" width="1165" height="895"/>
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
<WidgetID widgetID="b2abeb22-6996-43a4-9df6-7a1cb81226dd"/>
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
<BoundsAttr x="0" y="0" width="680" height="775"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="275" width="680" height="775"/>
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
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="REP_BG_01"/>
<Widget widgetName="REP_BG_02"/>
<Widget widgetName="CHT_MAP"/>
<Widget widgetName="BTN_MAP_LEVEL"/>
<Widget widgetName="BTN_RETURN"/>
<Widget widgetName="REP_MAP"/>
<Widget widgetName="P_COMPANY"/>
<Widget widgetName="P_COUNTRY"/>
<Widget widgetName="LABEL_TITLE"/>
<Widget widgetName="LABEL_ENTITY_NAME"/>
<Widget widgetName="LABEL_COUNTRY"/>
<Widget widgetName="LABEL_PERIOD"/>
<Widget widgetName="LABEL_CATEGORY"/>
<Widget widgetName="P_COUNTRY_"/>
<Widget widgetName="P_COMPANY_"/>
<Widget widgetName="P_CATEGORY"/>
<Widget widgetName="BTN_SUBMIT"/>
<Widget widgetName="REP_BG_03"/>
<Widget widgetName="REP_BG_04"/>
<Widget widgetName="P_PERIOD_"/>
<Widget widgetName="P_PERIOD"/>
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
<I18N key="country_id" description="">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country]]></en_US>
</I18N>
<I18N key="entity_id" description="">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity]]></en_US>
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
<I18N key="country" description="國家地區">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
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
<I18N key="entity_name" description="">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity Name]]></en_US>
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
<I18N key="col_lowtax_income_non_rel" description="">
<zh_TW>
<![CDATA[低稅地區有非關係人收入]]></zh_TW>
<en_US>
<![CDATA[There is 'Revenues-Unrelated Party' amount in low-tax jurisdictions.]]></en_US>
</I18N>
<I18N key="col_lowtax_tangible_asset" description="">
<zh_TW>
<![CDATA[低稅地區有有形資產]]></zh_TW>
<en_US>
<![CDATA[There is 'Tangible Assets' amount in low-tax jurisdictions.]]></en_US>
</I18N>
<I18N key="col_lowtax_hold" description="">
<zh_TW>
<![CDATA[低稅地區具有『控股』以外功能]]></zh_TW>
<en_US>
<![CDATA[There are functions other than 'Holding' in low-tax jurisdictions.]]></en_US>
</I18N>
<I18N key="col_emp_manufacture" description="">
<zh_TW>
<![CDATA[有『製造功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Manufacturing or Production' function but no number of employees.]]></en_US>
</I18N>
<I18N key="col_emp_sales_mkt_distrbn" description="">
<zh_TW>
<![CDATA[有『行銷、銷售或配銷功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Sales, Marketing or Distribution' function but no number of employees.]]></en_US>
</I18N>
<I18N key="col_emp_provide_serv_to_nrp" description="">
<zh_TW>
<![CDATA[有『對外提供服務功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Provision of Services to Unrelated Parties' function but no number of employees.]]></en_US>
</I18N>
<I18N key="col_emp_admin_mgnt_sup" description="">
<zh_TW>
<![CDATA[有『行政、管理或支援功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Administrative, Management or Support Services' function but no number of employees.]]></en_US>
</I18N>
<I18N key="col_emp_res_and_dev" description="">
<zh_TW>
<![CDATA[有『研發功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Research and Development' function but no number of employees.]]></en_US>
</I18N>
<I18N key="col_emp_income_non_rel" description="">
<zh_TW>
<![CDATA[有『收入-非關係人』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Revenues-Unrelated Party' amount but no number of employees.]]></en_US>
</I18N>
<I18N key="col_unmatch" description="">
<zh_TW>
<![CDATA[稅前損益和所得稅應計情形不匹配]]></zh_TW>
<en_US>
<![CDATA[Profit before tax and income tax accrued do not match.]]></en_US>
</I18N>
<I18N key="col_low_etr" description="">
<zh_TW>
<![CDATA[CbCR有效稅率低於法定稅率]]></zh_TW>
<en_US>
<![CDATA[CbCR effective tax rate is lower than the statutory tax rate.]]></en_US>
</I18N>
<I18N key="col_de_minimis" description="">
<zh_TW>
<![CDATA[可能不符合Pillar 2過渡性避風港小型微利測試之豁免條件]]></zh_TW>
<en_US>
<![CDATA[May not qualify for exemption of De Minimis Test in Pillar 2 Transitional CbCR Safe Harbour.]]></en_US>
</I18N>
<I18N key="col_simplified_etr" description="">
<zh_TW>
<![CDATA[可能不符合Pillar 2過渡性避風港簡易版有效稅率測試之豁免條件]]></zh_TW>
<en_US>
<![CDATA[May not qualify for exemption of Simplified ETR Test in Pillar 2 Transitional CbCR Safe Harbour.]]></en_US>
</I18N>
<I18N key="col_routine_profits" description="">
<zh_TW>
<![CDATA[可能不符合Pillar 2過渡性避風港例行利潤測試之豁免條件]]></zh_TW>
<en_US>
<![CDATA[May not qualify for exemption of Routine Profits Test in Pillar 2 Transitional CbCR Safe Harbour.]]></en_US>
</I18N>
<I18N key="cbcr_alert" description="">
<zh_TW>
<![CDATA[國別報告風險預警]]></zh_TW>
<en_US>
<![CDATA[CbCR Alert]]></en_US>
</I18N>
<I18N key="alert_indicator_name" description="">
<zh_TW>
<![CDATA[預警指標名稱]]></zh_TW>
<en_US>
<![CDATA[Alert Indicator Name]]></en_US>
</I18N>
<I18N key="ranking" description="">
<zh_TW>
<![CDATA[排名]]></zh_TW>
<en_US>
<![CDATA[Ranking]]></en_US>
</I18N>
<I18N key="occurr" description="">
<zh_TW>
<![CDATA[發生次數]]></zh_TW>
<en_US>
<![CDATA[Occurrences]]></en_US>
</I18N>
<I18N key="occurr_ttl" description="">
<zh_TW>
<![CDATA[預警指標發生總次數]]></zh_TW>
<en_US>
<![CDATA[Total occurrences of Alert Indicator]]></en_US>
</I18N>
<I18N key="alert_indicator" description="">
<zh_TW>
<![CDATA[預警指標]]></zh_TW>
<en_US>
<![CDATA[Alert Indicator]]></en_US>
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
<StrategyConfig dsName="DIC_CATEGORY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_DATE" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_COUNTRY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_WARNING" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_CATEGORY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_DATE_MAX" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
</StrategyConfigs>
</StrategyConfigsAttr>
<NewFormMarkAttr class="com.fr.form.fit.NewFormMarkAttr">
<NewFormMarkAttr type="0" tabPreload="true" fontScaleFrontAdjust="true" supportColRowAutoAdjust="true" supportExportTransparency="false" supportFrontEndDataCache="false"/>
</NewFormMarkAttr>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.27.0.20240627">
<TemplateCloudInfoAttrMark createTime="1711940947019"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="1908a42a-88b8-4b70-b318-d51ee713106d"/>
</TemplateIdAttMark>
</Form>
