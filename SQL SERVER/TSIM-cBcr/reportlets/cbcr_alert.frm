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
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABLE_ANNOTATION1_c"/>
<WidgetID widgetID="09c9774d-1ca0-4106-bd11-1f80523b2640"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABLE_ANNOTATION1"/>
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
<![CDATA[=I18N("annotation")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微軟正黑體" style="0" size="72"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="1222" y="85" width="520" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD"/>
<WidgetID widgetID="6aa16fcf-3220-4f92-a6c2-ad6514f3b3e6"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_PERIOD__c"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<BoundsAttr x="430" y="0" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_PERIOD_"/>
<WidgetID widgetID="6aa16fcf-3220-4f92-a6c2-ad6514f3b3e6"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<WidgetName name="LABEL_COUNTRY"/>
<WidgetID widgetID="d506761c-b875-4982-a6b0-53670ce8d233"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label3" frozen="false" index="-1" oldWidgetName="LABEL_COUNTRY"/>
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
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABEL_TITLE_c"/>
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
<![CDATA[=i18n("cbcr_alert")]]></Attributes>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<BoundsAttr x="626" y="0" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COUNTRY"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COUNTRY"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
<fontColor>
<FineColor color="-16179648" hor="-1" ver="-1"/>
</fontColor>
</FontStyle>
</WidgetTheme>
</WidgetAttr>
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
<BoundsAttr x="1020" y="85" width="180" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_CATEGORY"/>
<WidgetID widgetID="60c85dce-6bdf-4cd4-bfb3-16c895813fad"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName="LABEL_ENTITY_NAME_c"/>
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
<![CDATA[=I18N("alert_indicator")]]></Attributes>
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
<BoundsAttr x="1020" y="45" width="180" height="35"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<BoundsAttr x="810" y="85" width="180" height="40"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<FRFont name="simhei" style="0" size="72"/>
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
<FontStyle fontSize="12" name="宋体" bold="false" italic="false">
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
<FRFont name="simhei" style="1" size="128"/>
<Position pos="2"/>
<Background name="ColorBackground">
<color>
<FineColor color="-10243346" hor="-1" ver="-1"/>
</color>
</Background>
<BackgroundOpacity opacity="0.04"/>
<InsetImage padding="4" insetRelativeTextLeft="true" insetRelativeTextRight="false" name="ImageBackground" layout="3"/>
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
<FRFont name="simhei" style="0" size="72"/>
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
<UUID uuid="a6523dff-d63b-4702-86cb-371a2cd12349"/>
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
<![CDATA[1104900,3352800,16383000,4991100,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<FRFont name="WenQuanYi Micro Hei" style="0" size="144">
<foreground>
<FineColor color="-3126782" hor="-1" ver="-1"/>
</foreground>
</FRFont>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="13" paddingRight="0" spacingBefore="3">
<FRFont name="微軟正黑體" style="0" size="112"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="0" paddingRight="0" spacingBefore="3">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="0" size="112">
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
<![CDATA[m<NtVP3Lj_ems\M=d)UK=un7t<gIGLd$/+2g+m8t8m,ok6LK^^2;2N*:/gQfc'ZnQ;PFdROI
B@IP*.#,A1g9#W!EY74P6iLjue.,mm$8$n+4U\gml:FHXGD'q-M\G>s<Jt$$Xu9bLS<K!!"O
0*-O=G!%]A+Yq_$:Ir0'Q!)Zp(V4-$iKnnUPmIphNAT1.gtaOWH=P&k!E3>W6mC=dlFkoZsre
hEl#P#n%u#[SRP?'>o`r5\98/FL2t'm5(l3Z>A;Bj#WQS$i!:>f2"FI7$Rd4<TtS2$P8ddp.
LQ4^Qnp6=:Y?B@YNPoTtc3UhA5E0nupdSI5I"j*k(ag[*+#gU1?^&:r.;lMs$nOC)/e=!KWS
++$)Ui;F6OnO^8+?sm>6p@"3'*o?@:SIC/OWin"Zfefe:DsL'i?S,9.R"]AkcqjS"s\d)%BAq
k)Lei'X)\RP^iI"P&GhRDGA$C?FBl_"6u<2I<AeY7hR[jG/1;?/GP'irYtFS=Ck)VTQNU%S6
Es">``<PtsLXc\nG`7'3689QSn'ZJ"1$n,4=Pb94WBhVh]A8J1.WnZI;O2_n,P?`C?K;J.XoB
T\.0Y*Q9jp&K;2CP,UZ,_<]At9OkDj*VbI=)d_2,,1]AJjYWEeD3?i.iXD<pj<.J^Q=Tm6F1"-
'&qi0ealk4^&a]At*U*O4ATA:KK'^c*&e1i@e5ip\]A%Vh\%))#p:JL5="Dhlm/T]AKXIEO!Gb4
S6d3(4]A0m@]AQdJ$@Ed_LCcVYr4H;-IYUf7ST]ALKaQorn)kVUj]A&G]AM>@pf.XIp!e\q(n5HZ2
f/<0R`rOK_fenWq@K]Ah1)b/]A$--*K2r=FUW"fjXb8C<+<!SPKdVf-c+B`@p]AFa""`6G<bj=E
Us3?I4eM?hfPja=NVINE$ql^kj`E*:':Vq^lQ6eg__?^&:Mh'O1KDL+aUYjX9pYOGn4[cejf
W<<A[9h@QhZ]A&?ak[\UGAc4)S)Vh<H:gXGV36Qk0F3?]A`aP1c(f21N=m1`ro2XS)<o9$/^AJ
'3=eTt$X\hI,rZBi#;($Mo-hOaMnIK=STY:U,]AMlT@=3G0PQ;sFX7C1fmC@?`PCPkV*IQ$/-
s1X!Am0QFAlHb#5jAWcD6sU@DgN1,g-,ScBRp,iIg\R&)"JRI6*KQ>AZh+9RrqO5j$OWLXnV
8E]AJa=-di_:_WSmK)V8_,'uKj\-@lmRAhfDe#]A&jejRib>iLc*l2S>tpPMTQ3:W7W[I`U$DF
Ii=Q3Q.;OqgaI1?\>;F2iT64\l<LR?*D#^aWrd8=fVHX=H*#HblV/tSgJ&(Y8Fp*'6,WU!VA
C,#UX;/*fbM;,bUiu,GX7h_R600!^h?0\]A@+Eqd:KL0@?R^TfqWKV\,K;"qWYZO:dZQ?%b<(
L;rZGt3jcO[UU&ag4/'i0T/F!OM@1d5OFrLRo7WCr.U0/Q:Fk3:,0<!:[X'VQ9,DQ)7T>r7Y
!iJ["2g]AQW<m8=FjaEtC&_&nTZHKb3$3p$&>^Jm'-ZRN(.A0PF`i@D3H*I!YKW)Z?0#JFg97
'c2rt@W]AIqe\\]Auj%a45,7[^OAi8;Ti6*f:Ah/Ph3*YbCUE3To&Z)!]ArgZG^5L(otZbG)/i^
FGh;eH]AN'mPm'j@H&jfu#H/D\L[+SWn)7I[@[pg'YE=J,iitnHP2UpgbM#72?gm,&J]AHnZOH
..buC5WCbVt(c*o$_EHT8o9_@dYQdKT0`e0Kmq8%;I;/;IGg+XI5WRdBU;N3fdE\=95dGUX"
6ZZ[$=q'?)DZa*:d^US.D++('Ur!22DgpiB::A\6[dnI/#$5cTbYiY.lt%/7?B3sf]AMON>GL
-:XVC[D=eSL<4R@OGLh#./<F%OX=36,=^*U-b:t]Ap(O\*V=]AK-/Obnig0MXbfEMi?QIcb161
^Ia\BTn,H^#NW2$UX@PER_b+(cl:)d6Zc'DVu\^O#^AqSh!LH9#dD6-eZWqF]AVh:7`_&0*6c
1gfd=Vo>TOJTqEGb'n'lfU)R*5'm4khmeF\2k&YIbWs,msbs^HX40YH?IdmNF_KTrtGc&Ut+
WJZqfB,n>G(s@iUTUd`P>K[>HIpMm]APSd_Xit[AG/#R4N]Ao(tkWF`O96G`Q>BTk?YG9F%YdW
MS-HrtpI^$`U7(6bsk:moeS4`^R6R?#G<n%4%o]A8$0_^^["UJ["dqb=:X_5WsqV"X)23nrd=
l0>M67#PES0>bIT*`n3,5#u^7at3<'hHlh'?>NrjaISW24T/8+8sU1#5ogZkd0eF%LV?Zi4.
NT3%S9jgWB0QUA8Dfl4*Ft86&>A__n")3P)blX0L\*b>K9d4ekfpn[N&'ckC?,aHd%W1aA6`
enk2=<r]A&,m(74s)gE,2eh7f6IBpMg:967Sd3bFK:rF0U68OfZ-\u$c?=KRp>CmSdRn-[NZ5
R\rh>3R(6NdHPT?@(!+p)GT[)kfX*eR\p(rm]AN,$?\qdaup6.gi!$n;,ABAr=PLLlsp@1EAR
Ph.Y1UDXuFC'i/mXqlK-KMB/XqfDcT=;GpmKn*)06ge*PH36V5,a"`^UaiAsCA[fpu)ecSnW
h;+EL0(E_7J"fGIcunXJD.VaKW_d_8?T=0Qaf>&)MS&)kbr@7H/qkRX"l_YKWogN9OkJHpp\
S>tV%n2X4uqClIG+!$3fr_>`_t).O#E&rZd'l#(jAKB4.A3uC!oaf7r4tQhZ==:N2I*?0N?$
)Ct)61b=jIX%HE<4nQf7mfrj9,j4#($Y5UWV*V*j#d[6?qaQAHI*<39!_Ve<%'C=iI:CbNA2
,B!ZpqR<MZg%ds)@mNrVIZQoZsl+fWp4lDSt*J_%qOdV="esW:GWQJE^[gf186g?Tb"crPCg
MR(47Tsb@FFAQmUHBAe%!krf4TQH'TgrW3cUgaB`97f6h4<MU8n`\BjJB]A<m`-NgMf9"]A%>N
pr.0(CiGaG<D?&'O!Ya,T0SbmZ/+9,_,#qHH"*6\Shu`<dgbe`C<a*Fh%&r7IV<UE@*BlTmh
e&V9&&^cZX0_^C@.S*r"ffRDR?s\Nsc*MQF_^ZO7&?OG\_XKFWpg!&SU?R33UTrD:Qo5;4^.
2K[55g^S*<m'J8AZ;,IoYD>IQCW=[i\!F0hIDgH@df[hn4V9QGeqKU8piJMM0!cQ(+FAm0V/
b-qtNa:qg!=OX=KAqqD1lo-6E&G1'R]Ag.qs1"4Y6%Mga2_mDtc*us%G]A.`4%'B4lJB:Z&jVS
4!k,9.#jnaTV&XrJ@Bj:`*Yo\'lY(m=10i>,Ap%=Mf^hO`#ilc-NBgNHB)i@\9]AW@,]A=qT:7
KmGZg\\!1T@[sqNBq/_\7B[;&ohg+fE4WQ;MaMFe;(\QJ1ln7cS=N`V540@o+V&[%TLV$%a?
-ju\E4FJ:/Qnj6&E=3/ru]AufEuZJ.&RYb9%7_"MIuNL@A&Kfd0R>#X,bFak/p@j<-02eQfUc
0b,(XJmk@G\8eVl6ju13Nia?ijHlHh]Ak`[9<j/HWPn$9)-X&<@2ciEn)%&G3CCiUh$Bg.j)b
c+!1;eUIuJsm9bH-C-u%b.[XrXS!iKlJCJCHm9M6P+shI=[3DS*HhqNj2r7EA)CscD">L>?h
pSbcdAFK&n!uQBToq@C0AI.A6F,`Z%Y<6_/]AsqZT/_=2e.!#655-jA=\(]AOnPmg0,6ZLK[T:
5^?dh\XO)RPV:7gs+$YFi\E;96jf,Of!QuVk_6C;64p[3]AQBiCa4ckKVl.H+#5>:MSNTkVF8
3t0_8s_<9X^>Z`sd\qil4[<:@>T$ABu`J7F]APuWcro$@5/cB-(R2KmO4;h#9qod5io)G;YSO
',^7SR7d6@^I?e$Bdb>G!`+m:>$/TuO/onS'PhZpG3A#`/GkFmqTGFXr2oP[Ym.]AN0h59sOH
5&mkZ#*:oXI<K%/]A_u,o!6)fd#bTX7krW7#PGc[0!'8qm"jX6qH4c\<p*]A5Sgb!6ckbR]A-0e
UHGTBtE5A`tdpr58ohq,V)ru:/"NJjTfOF>hAR(eI+:M0`>ki\^8O*0ln`AWq]AH[UEo'S;K`
O,m%jDhW@f%Ko9qnlfeEr`@D*':D>2fU(iunTFg8:UtXToXS/ji!AZX'a+:_mZc`5BYf.:-%
=>k@m\/Y<a@_BTHXXpNA%0e:BO>iS`@8QG(&`#pfmt^EQStM*PQ`MQ9Rrg1lDe>\LDtdBFVu
XG^&bmZ&D1XZ)^NH$*PaFIbhehVXP/!f]A$U!ZN'ITg_d`)!8r:C<c#TSQhCT-@=[^U_C*uf[
X;`diX3i90Z/XYps`8\5\r1g^JFC$%jlh&%!I_)iPo\%gd#tjH.LhHdW_<16*W8bX((QYk.n
.RN5J,HBMV2Ej=EiF.1dQ2?Fe4[<\82f2)R9a9g\Sr-f:@p_(Ym`iAG1,oJj4tiPPDq,nW1g
ih,Q6l828i3E#LsNr#u32P[mp4uC.:N1*ah]AlX%j]A$`>A^WjR2-4G.g*(;cO<"hbOcLTYkgl
1An"tr5'T8keG]A0gd=UE&6TO]A<tJ?!^?=?%B"S5"Fj7&J)Fg$JW6bO)d@'Zf37BlIq=IOmQ(
/F`Z&Aj\1IUqj@&b^Ouu)l+-Sg`0#pX!RBSPFq]A7.&HG8k4YomC'>iUWr8T:X`oTcNlr-,f1
Gb+uI\,V^%th1R63FDVp;c]AG(YH_..8hAOmWLLSi9-J4UA?WK>"U(Vh?L3V87ZlfYBKZS)'Y
F=+a!Ei0EeUsZeh@[r_`#:_jILgGiJ.HdAUiIZ6tWlVD):"PkQNO7iD"&0aoGs$(o\*;IWYp
jl_'<$kf2ApVeod?uN"VG.5h7*!:(QRJEZMKqgAF$T>fhj9uNF3)@7C?rTB88>DmYM-0T4<@
iN$//,W<iU%qXKJrF9El8,Nf\f544F&5f+urt26=(dZc:%27$R=FOBDL-rf^5?-IRTtXnTrB
,B;-2H.kWk(os7.)s7g]A=k'tSaKtcKU*W3=9`&e+9#QNB'aPVN.3G0SSqt`?6SMrJ9.8+Jj&
^IoE?3j:ML.1I1B*8T)&euj\S[#*=4@>kJb(g<$lO40j9a!Oj`@!Hk2bcfSHM*BX_Rl2B%'@
JTNlt29s-]AX]A>;i1`+I[=o?;P&Sm'=RD:FqLtf]AU?8D?VfdkZ#pG`7"WsKgVr!+D%=ul]APnV
GM/[7Eg]AYu$X?U*@l",:+JYXZWhiWZ.js!eg[@R?J8N>?(P0't)g)&,Xg@2ndeNWjlFbKL7!
*YFO.\gF.`CibBY>Ial!]A/Nj#ta4$PI0sWc(4$Z;JoiYO8DXnRgb_-<YHTA8Uo!hkj_B3,PJ
K=ma@8M1=[Ojn&hXiR@.5,dM`QO"*GWPsq$kUTl(9HgNI=#n1f]A-N/XLf52Z;4r`QW8!s\oY
d4FKY\-@M<>\I3Q-m$@=E8sL%C9l^GYcV<9at\t/]A`mKPuoGT^cgX[%qAiWP&c&5_aqfgL1&
.nklGr&M<]A>B\T`)ODjgd8B3D2LWbb`#C)$Q=98Jb^@#mpHGmnu1oGfHb4[V\2#Gfo(1c!@M
1!u?'O_cL8?Jut]A%$0qA2sc00E1_,]A(!5Q3\-:Gd&MLKg@4E-b%>h0@.l6'M]AZ33:G5LbWe*
El?)J9?CN]A]A5YUn\N`Ge*ZRP$El;qcN(ggOY.P=-mr[NNT[=3(L)5l?6#;bN>o9c$DuG.fG:
++4M\]AaD8ea;mo;>j^A3u"6A%R;%)AlVoSnX<3o>"bXGZ[#1WX4hB5=;\Kmde_]Aj7J.45"EF
j*U\k*Sap8]AB<e?%[I@rC.C0(A0@]A.lta(3,7h:`S9BIiO1dAA'NQrTG7K1^k=$gLb)Dddh,
pHCZJD;10_a=iIli\gTtUh)VarmP99*pJZ*CVAD]AQ\JUKO>nI_p["2nZr6SWus?GG)#6ep96
?$#HHP75/UI$'V(I65VIet?;*Shf]A8fTT_6HHD(p[En@jWd5==Ks2>bf`SCf@d1RARkPQ':T
'Un0AMPDI&I3c2#b/chg1E&Du3R/6@dk>Q[(C'akSq7fR/Oeo%_=d41XX7"N&u9mr\2C:0"o
'6(gBLYct"@MPVb-Y#MVWrmWpVr4>QeP!HI=eUu*Z+23]A$%M@7]AJ+J<;a]AG%@#GQL6VE9s:b
uZalc2>0n'Lqb;8\g,:h48fb_KK!M^2lDe\)-M$<-'1/5gY1J6GDO+[5)6!FYCjP<qZg:.jS
84^IfjbX*tSK_HRSP20J?[DdHOi4G@HQqSG*bq9gc)\`"Z)oXV&$Hs0r1bPnN&WFi=,:\W1u
MCmI_q6c[*O$JQ[V+<2ZD"*$X7*)c=?<%]A4g6&-"h*]AA(c?ct\cqFU!h03t;N+q/"c.:=<#e
gWUXNa<ddpoPq)qm!5doGis%U_.3`dt9$eZ?qPSaZ.*!3?g)QU'"%.1?Z;1NdHNb$LiC6YR[
#oFkCgf><rNCX3pM@Xe]AhD7;3<Pr<i%P$[(4DnaQX'."FeiVNf-qIU#af9VM+3\KlCh-c4?>
H`UX)6.1]A;?ho:"l37oVcli&5*HW4#4Hrn[8f62#\F$+0$:IrrNq1s@Dn_.0e6o';2+mLqq\
MX9^4@Q(u7t2j+Kn3a81k#*cFL$qK]A)q#&ps\r6=A!><-%a+(Z:BSR7u?r]AD!-:)eE<>sI8$
E(1mHMEOQX=$V?bo$KSL(ko:a]Agis;8_9HG4h831Au1qh(=.HnRhLD'.,S/,1d0>WM$/e`:m
p@Up8J_jXuB)`eiUc/QpgFM+qq\=PB+T,'LLhj]AgZgW%%1@JD0+DZLGnQC.,PJ%,7[6!l\BP
":E8`;"$)Y6]Ai/6sMR,0_MU/XLIarlE2N3m.4,``k>D]A(4bef6Ia"k(qS@%+lg2^&Z<d9R_r
bKNfUi9'C%$9RSh2T^i?d9b!Z"N;'NZS*No_$*+B"00(=YuX.V%6ADZfZTM1/F`3'46(tR^<
9DM9%VCnk?3n+?&:rW@%VE?\/0J9&Z4T-ET1,S>+X+-mt'+0%-RS"o^p(VC>"`]A0a4]A=H*YY
!oO.Xb37[jK]AoU*&PCiDk9,F0pY!.sjZ?9hfZp-j$,WgmUW\^WJgQT<3e5Ieh]A05!:XhO^$f
O@[r]A%:JnZ=G\3bQd+c3i-E_`*;[<Va07:KTm7Winb7)!*PhFf&<&h4MDLN2L)UB\.-1Q^JZ
T;>";s/!H;'g$RpQe\\rM`&B><5Mt3bY2"jB<dq13!sd^$Wld)@?J8B)o,s^>nl0[ERlTRAb
aRgC3U*pKmiZX]A!#<X4rO?.VDb\17kH;dce;<G'T1_/.?8lO,etF1P6hG&m-qXlh(Vdo0$ql
0So"5<++CT;Mjc#7S_8Bb"nAX]AtD[Wm=A"=Ja]A!j\c^#r?*G2&*sSnWLqI0g[]AadM#9Y-Sng
T?tfnpA:q..%]A,.X"_emI*$c^_l^',gNG(RLd/2]ArNLCF]ArX^E*;t,b<FBD,;.-fSJpm3qh5
rfl\?nbLW?\2>ENsgoec<F"ZG]As1U+P)V9C2L+&<_mNL9,nblst!oFc$u4'2c'L7?h$Y]A3;#
JVGkN235Jqbq=f)fE`N)WIKfFo(JCMY`\D2R8g0LXQWn^kj`U'm-`p-W>eVPt]AGa9uQCD,?O
4[BGWK=5]ADL"utn2n;u2H(9^jOrY!UE/=c7b2b&1Y4>_7d!d<[?K.LqJ:4g?V^Mp%kYN=l9U
<U\jHdD6f[kVm9Dm:QVnJqJnb(-Wi).?ZMt25-$=Ns4Rn0/:ntS8@Ae&ROE"L&ZHG2.lm[]A>
'js#d:H\)V#$%SL+@6YR.&6W.r?<5@!7`@I#lDH\<\'ElnNKQum(a'gH:IMCgEC>@SV,&^1_
U4IqX5hWcErnVH(oq..pl!M/?FN[RRe^n1<A5Kpa$F#Wn\_'U8UQhHm%j<ZS_6k3,X/01p."
.Hkt6e(O.5[U5::nKVN!trJ.p*VQJ!p!g-$CLBZ#g_\P?e#q)]AeSDn-o=Tia=a4V@*coM^2>
7W.C!D9G=2\oqU5!,bd81[.KCeHf5ET=T&pX%m`(`]A:urqW4,\:^b:)&pq\nJ7RQho)4^kW.
o*]A+=T.Y/USOc.sThi61,@l!XW:SflX9k`s"S\MnqoC]A'=,N5HsG\.k71@[Jk59$]A[Ph<?*<
l)1BURMT:ua</#'2E.o90]A1R?Hd?=`+`C=M796k<KoQpNiphS?XuP5HHesBuAl(4K5d55U\n
<Y;laXQ<e)'Z!7806*9+<^o@WW/j\n:I(=*EZkY<jOLC]AO->e3!4ZQ$rY(N-f5B4iaSh1$\.
dg?(u"f,F<D;VPT`c;"mPRXXa%a18F(,oGCo'Vus,,N;f\Qa_iD&:P'Y@L?GQ_%cFrr@ms;a
rYsrmu?cBE_+l3L:*sln,^+>a'2;.Bu-&)XhE!@We)ND&"^YB0=hsG[s@P0\dSNj-!%cgp[5
/Gm8E,MY^F@P&2c3Y2/L;ggWPNHXDI/<s2eCTRIgST#>jL\rADVLMT8nV",hO(dt#f0:Jj`D
*Nd<gYh]A5-_HXYdWE0(M98e^m[%4B2k6G(m!LcfCNh3E9k8+p>c1M=T+jG.p9?KR$@,Iu0?l
k[?k(.ec*gd2pJU(WEQj;c)H!h\\#NgS_i*X8N9G)Vr:/KX==WIjo=`O`IfWohKEm<%O!5R.
7\U.\qe8#'bk=k&Vg2ZS=k*g@9DOBHKDZJ"Nc^W7Ms"?&jJllD7&:>lH3Ys?-*-?BRgOJY#r
rN~
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
<![CDATA[723900,1065600,1065600,1065600,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2324100,9144000,3314700,4762500,2095500,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<RowHeight i="1905000"/>
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
<Expand/>
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
<C c="4" r="2" s="7">
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
<FineColor color="-13816531" hor="-1" ver="-1"/>
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
<Expand/>
</C>
<C c="1" r="3" s="8">
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="3" s="4">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[="Total"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="3" r="3" s="4">
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
<C c="4" r="3" s="4">
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
<FRFont name="simhei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<FRFont name="微軟正黑體" style="1" size="84"/>
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
<FRFont name="微軟正黑體" style="0" size="84"/>
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
<![CDATA[m@&<&dWt`YFa>BM.]Ak-UF()):[)FWA*NdO:F3WK\+Z2&S,Z7%GV5@-(Q0-K$>VIt?<883WO\
3U7"`n#^84Z;a8.e]A23S6IG3Tp-!k?R2]AIcoVa_gal,hs5W=5PO_o^HOT;?(C8)rH.NV3B=W
UQS+lE+t*+Pn`J`;Xg452Z)=M\jG]A[:3e-j<9HKP/^%']A^K\i84p[>/_h]A.94jmUCk:pXI,m
#ue.Dn,0mq;L\D9c(;'=si[_f[Kk]A]AtQ++DP&"3i*(6=Fe>dOWcl<"f?@Tc%k=J_EbK`GWT>
iU637W%j^[I'jp'jX\<1QG/6`elGDG:`[8rTr0gIe<IP%USa8=uTBhp"Q[:pT+Q![M>E!7Vi
3jO2i9++LBoO59]AU4:0+CSNTKci7+;F"p2ba.gpmp1/tVg5.IP=fV@KU/hnCEt,g$-4]ACQq<
s73HgL.jqMctr%!pb%dLIYLm0?R-N8O1h1%9*sHgIB)^A]AM3PP2<Vq8m\r:UOK1Od,^lR:Y#
c]AAJ!JhZ/8%NC.Hh'mK%eqtQKoq[9Sk%lc`o5HHZ'p[N4bEC5N=rq4]Ap=+V+Ch@R<ZDab^9]A
9N$Q5Q-)F,WNGU$*l8f+eL5d]AlC9'kDi(41<Oeq=0+U[KA>B>Mbj1I*;:<;C[u>3Si=pW2SL
J?LHD4t:E#h[f>)("UopYCfA>j_(?g^$GH*ThV7oLIf!p'8Yjk![q,H+Z!-,`?^l?C+fB4Ij
c3FTN;q3P2B\8(W'ST;rG7Jp?:fo$;J8*CADH4jYbF>a6r]AYj\Lfr+XiWI3&U9kN?jc@^W28
XLE25snM7oc#Ip_u?p2&5"1B>_Ym49XFrSV>OuSD'"(N1E-E1qp(-^@g<kE)Iqe:BVGoGB[l
:'m\_cO,Nghe>%dSGpMVYY,npoE-H?2Uk"IN)e/]Arjuc3Kj"XYEGt<@pg!$efn;$$>>HZ"os
1X:rHMo^\YNN?2q^\V[4rcQ*dTiqIWn34*HllBl`/[1M1`Y_nn;M$/Q^HSS8Jb`Uma5fY"8S
W`,l5r)PBnV"L%^X(X6"*=M?Ua@Ot;+nF0!qhU:^.Vd#jh11NqUt6+S3T41U>Q`:q$R`R3TP
U0@pk9GagJo]Aa?>?H*G@H$Z>HMg<P_Jl;3grVX^1X<\uSNmD]A9kgY-\?>V[Eob&I@_1$*\9)
+MGW.@UOV^FSGN2bdD,CAe,q[)$^l@gqF5)f$fbZ-4.`EQ:GOF`=>@)@bPI(ldtm;sYkOgDp
A!4pY<(#>c*<omQOH[SW?^U73H$pmI\VJHWFkt'4E-RtVuk9HFSFIoOQ]AV_ecIBi6`DSuZuW
<baF?i9LdQul:qP"J29h92r9XS.=7(EOrJ#-B(3BNa#dZWQ=sPhZ#]A';>(QcdPq0h^XDnl?W
4m45PhDn%=k)<Q9$r34ktTen[]ALZrS=[P&IS]A.ct_S9&OJ8%ZdIUWCJG&ddX]AV+?h0'Y3*L(
R#PIEN9hMJ2.92(<isZ7ON,lTel'=T@?RM`Q/":bf1.X]AnR?D8Y&>>,nPDuZ1[:E0ppq"^'j
g70.QfX//$:qsWD*c$,T_&\Is\BGG=c"k*Lh/Pn([mGM!VLApRBLB.CtZO*]AQ+U!Xc8$14at
@G7)sO+>!u#H44uu8s%5`6r($E7hH\F84'YVQ"G5Im9BbKS$\7]AM/!JY_)7Q3^hGLK&<cQb?
lst5Bb'tQPpBXi8>ES%QP1b'['?`$9nnM5r3+<SZk$R;:HNV?L9X@%hfNd]A/IO(;(<+u>3-=
C.LOQ8,61X4H3T.,9-uJ606,RQL0hE&S7]A8d[:r=`Sn;(8?/_HHhZb*2Ue(otJJC>5cKL1nV
HS+2gVAAiYnE[\<8pS:j&("t7Klt%dc6Ao;EZi7>\Gfl*PZ_Hu/C[9oeCs5J-[)[Nou0q\[j
bJt<QI@SYr73KFuelal3c*8WB`3\dW]A*6GaKY>0_jqPaE8963bU9.gM^WiZ\#T!OI(:`>^Sb
VW(:usYWu4snWTg4(a#%e_T"0gj#gP5b)lc^qC.JL(>"QkL==Kfh:8'beEpWlp6.%0UWAL_r
D."$l.>cX"$@\\D//32e9F]A,IN&ieo)?UMm!-#>a@']A5^,]AjGG5[=7>Z(<2M=a`0e^3ZZ<6[
g;<BTL)gtZiI$-T^[gq4<Cno;4uL<t;^Y6d^^:eCHe1`uR'('V5fhuttqZat_SF6#kWS%3/4
jB^'^"V[5[oe]A:39"P4Z;.;tBT9VAC=U-#Zc5nu/l<ETCNTAl:!?)u2e*^NBT'*`H"mlQEJC
^,<4qJEnC0lKPh\7oe[[+(Z\Q!3K\\16_CGJ*$T\s''m11`YohrbV6C?jJ0l'&VXVHHuFsDk
g?1G:0aa9lZ:M,0)mG\0bZoVMB\MJSPN4bFSAZg+LC0"5&oZm]A`rIY>8d>1BEOM$$\16:H82
s6JKl.'$X9J:R(a(Y(.k[ucN6Ta<YF'D>L"OhZ'#cA"%$O3L:UL[(C&$"hLT,BItCAadgDK)
+ILSCW>]A^8=s#,g>g5_HNu=L27Ajr94,bbtbRlZJa!^cg4:\cAY_'=D0>Om,lgKn`,+/'4kK
4H&)@T_Om6re"maKXYo"^Pg[Pf$5NcR]A7eg@N(jd>L1<Ek$RN;qsff?m']A9=_4<":iQ$rS8$
$lSk$E[j6Vj1);/IJ4F]A)e&KTe'^++A4'chZP`/^hf$h6(667M1T(X7[nf:M_r'Y\2VR"RDf
R.Zbp[+:XchH"+*LdA&KopNp6VJKaitcG:B6\5K\JX=!UTm.35TIJM]AY<AqQkk"5eLUVm16c
tQ'ZkE/-&M!S*H9"!p"@:7-\<qQh:e**D*\ju$B'SmJPrmBNj)L;Y0d6`;"F4:+:N7*]AWK0H
W_Wc!q@(0[T/3h'EVb7D?!@SaOJ!e=_.<GLkN>QUh?n29@baK$(H=iujP>Y'F^aUu?up630b
VM27_>p__\Nb1R_[,^;$!*#bI"![8CX'<^sS4[En!ijbrf_E$C`r_EY7iY+A2^dN$%Hr023"
=jtK9I#P3_JVAUtc01oq%Ui_>'oG2s8F">!sB+mE!T7FdP2gn56UtE,V%Qcd.,qA@j6YP-!L
/<d#;E[oS>0fTPr/_q&k6i+m6=O2/:dPb>1CbQ^VPg4b4?5q=$Vb[C`B4^A,rT's&%.7qS#c
U&6.-_d)BT5KWdClU1ZNBGR-5&h\fg>B0aQLCR)PmV6.2BWB.U+NrO3Lk.#,q$7L<u%tN7>1
XK]AX?q"_P<uF;W:hPh/1lk+BTjNdq(l55`tO-m*"`V4PQOpoG_p&)"4AFVt]AlHkMIp/>s;3T
[Ql2OAj)Dedh)]A0dtfEt/'F-tPV2si0LgF4[[N?p.97b8r_tFa^.?9#_V#_9'MHtV^iTjD;F
+Ti+fk+HY%#aRE^os^(*r9J7MQ@L2Y8*3OW2Ork3e3Lrni1&#Y\65@l4qL%;&,.WWX"DGaAH
=B%QEF_WV*5)CV"R.Y`rt\9+.1I,e]A87ci.g[s[)A`i^pl5#*ajSrQ!9FL"ValDH+sNG\,H6
oSgc8B]A%3^.C@):_D))l*@\J`oZJ0'i7lqF5e![gJM7,$Z/7tL=]Ael?V[<q0A1QmE"*$YME+
h<Z%fJ]Ai=1RLIR':VKA7*`IZ'DDZW)&G>;BB9<HT)iP@s7f"8#oG6`&['?PsZ_26@+?<499X
;q&MnmIWV:B7oE(=CE)'(u[>$r7)*2\$`E:nHEHE;b,TdWAVPscD-o1,gccZeG#7FXNjT<\&
"A9`>R9W<b-m%HJ)?`JLgs4R"X,X<KGtE7M'0=(Nq54Y*MO1_t]A=c.EkR$"d8D-h?*b$[,Q)
;LT?>3$]ABm1=fur8<P]A$/4keqF:rk;oDua5#"_ciVln$nM&L.C?>J</ZFq+GNA.H-=j6;\Gf
m+Q1rjEI71]A)lI+O/s2&P@SV8=L6nc)'k^NTJ-=QMCn]A.7"6TDU3Um'OW/9Z0DQ5G3A)'a8q
@*eH]AYVr(/+'SgRhZNE`;MHm%4s6Q"eP&%<-O#-G5iKniaNB=0VRs14G?1Y/T/EGa2I"YS4!
Ki4<OWMArmY,RSX@Z[AfZu4'4Y5jr.@1Tn/j)cJns03*-#UA3*h-R`:?V?AlY,BGW<clnI?2
kU5bh;5kNTa'/,1j9g"R+'0:G)>*a"HXo9\sr+Z5&(^$@7*$^rDo-@NJ9-Xm.Xp.V\?g[KA_
)\M%I-]Aq*il?mW9B.BC't@o6$JQeXEgE>@q+SP9(4MaRQQE`shF5MNM.]AJBHQ\F'u"6`%`(U
QLnH'o66mc?cb7]Am:@GaNI#8S1IpDKe\SU:,H[7$\VQm`u:aW4DA`aN]A/Oj-R>h:mjZJ6m^B
UZ<%b@b*F-X;JDZb-l,A8%P!5Q;QX3R30Sd,[U/7-OQ#"sGTS0h<;%q*ZqJ/^K_qM<7P'<!o
;OGiAcp,f-*>j+FJgZB4(>X>Lh-9?]AXDh?iW^UnsXgA,mhMI6L$@29^[L*CO>KC3ZA)aZGN-
OK@]AAr54'8)9mF"(+95j^p"XGFq"O'KmBe+?LLjNn8"nmB[PXtF#I'=r[BE3c$mJ'51sirO1
CIj!"glqpBiXK*Db9Fj,2j.?h+i@'tN0*]Ap*boK,W')P7h$Y9jaYIpRS*m$O@G]A*5*nV?pS\
\o$sc(pMK"8;]Af<Wn16U\/5.qG;8mZO44oUmr;5^KcbT.lXipFaM/5nRS5HaR/>XOd0[59J+
QBC8[b!Xk*>'&K6HYIrNgq]A8@Dn-d+VkF-Go?QU,Cg6=MOQ$8AD'4`j]A7[TXP;OVontK@j[`
`.@:-apL/M)MK:qT7T-$6HB^;VdO'qk5YK<c">B'_NNMI1!UaV,qE)"I,G>I`UgeG;^;6^59
>=Zi0",?aWR^M`N55*9lDlC0j^dMUMFq`?rgg5r8;_7kPGVKV"SIc;,e^EAn?J[,&M[Q8NU&
1]AJ)sKfpX5]A/uhRlW$`aEIr&3=8@`KEV&&G[P6*>c?:Stb8fhpn6bV"9:!?s>lo(A,Uo%E2e
HK^T_ZZ&#R(qZCP`E[&!jlfP2IP&%`H0GqeN=RG#'&OGcCc:HT+fhOqo/=*-Is'uB0*_1lj]A
Z-"drq&lmUOk(#.c9)ksf1!.nqJGGGjHgmF-GlpmN,DHce(aK00'iU5\5Yi_tQ`Mm]AiKi)!-
V3BXSccEEt2P!P+E\WpLY2?q!)0->mDZ+f:G?s9jiX3FV?,D+=^?'N5:$KNlm$:N]Am/2Mu]AI
#Ob>SB;B:J)%:+E_Fn@S6bMmh\Wt;$^M6cq['DdJB&XV52UVjCLgBEipFBo9ujA5#"Q;M*0H
'Z:5l`^+9^3F>T,AHltg##%P4=BB;mg/=OlmUE6EBZ(U9/<P&;jWON%5)"g6sBV?5,D]Ai[.o
jM7Cou7'1o'rZ[_B_<\%W3V\hnTR&1>u-(S*3B*a4ULQQEjFUQZ\Q+^(r'k?cujgg9[)D!]An
jVH\g.W&<^RL1oc5I9"49pg8h[(Raeof\]ARdC-g8-"G]ADaGlgR'^]A71k7eJAqtgca(^_sKII
DT]A%SP1A<6]AlUO%L;t%ok0JUd^Ba/g_h%2]AfLIm?#e4`<IE3C5_o*O.l_[U)hVH(u8hZ8tA3
F3Zr"<I-p@4<lZD:^db#i*N97s;N()l^:!nRc;Q:a9G'6V`TJMQ"pD<WpTY"(Zl3FJA(l@Rm
"Xbu"6@GjQJf&!,]ATfsRXUG7c%V_/?r-g!bBKefCSDt#d=47uNN,M.UFs.LdL48tnl@ujcb0
\W5u%g/<2TJn%37Y"RbNK8M8ZK11)A2,(CO2S*D9+jQp(S=a2]A.E;Pf]A1WO]A>:/_p;_JD,9H
m?FaTO=[Ec1kYO$"nE$_l/U8*=#%7YjK/s#6c['%\FRq158[T9\7B/QXH"%s.&Zn!f/S:>0C
L*G#Ro.P\,:=bRSdVU<#1cG!&$*.j"P3'04>M8FU*c[qO$CZq`_mN"WhbnT]A9L%EM<;FU6m]A
ME^c4)-T9'PBUIUkf/imN?jFNC^8pe;Sm?3$_WLq@(61`8%WL8U"<ih]A)h]A?OMD7dXq-V3kJ
8"VukSVo.Lp(T4,,WD6orDT=\9cIXP5cU's?qImo=/&MW>f[_),2'fm`Q$+,=\pO8[/*I#>_
c#Ek<=lbZdZmd;feenF=-9fg**@7$"NW!cDmUO-*9ile_`GXKkUnsV#1s^sYlh3*$#C!h.Y0
&HZ)u;M=`uJ]A>B)r$,pLe8@^fYF8A&[@cGaQAAPtMHL7eCpq,]AeSFW3RFY,#OsafYY,ZCF#]A
c+ERUHU/KDo'WPWo;./X)GfWEG$ZGj1H2?``%8KFGp83pE3hJ.:3eXf'<ICPH#`SB%(hh_0!
bOIDbEcZU6q"LiYs0/#.T!!-W0IB'5d,ZReoXp56fZe4La()<b)&^J&aEI%M.d89s(C%c?nj
m`:h7B\kZ5E_Y^YRPdrZs6WCOH[386B8A&^$27ta8b<IXa\Q#X(T`qVPG``fo>W`bd]A3Rm1:
W%RKX\RtDkA,.UiO-CJ+kdbi[`Su<?"qobT>!`Rg?&Lu`6af-JjZXjDH"fH!Pi)-I!YViHdB
eN<Z35PE/rYM2fInNZQpr.!b=\UWNpYPg0qg5A6JAbY8GdU%s@9u]AFsh)q%snD7Mo6cr:67q
]A7=Pi;?o@Sn<VfM,:aFC8^W[%L"1mCY@l^`%-lqJLpAID1rQ`^d_iASCG3IED50Q8m:=03aj
8WK+J9O/-&n8dNQba2(rpi''X_K87,K*g6_4K`Gbp$U.stDK%?EFm[(46s$hmpiSMA0HF'5f
h>660g<:p+?Xgt!>.J_j*'"\D6=on%=,9aUYJrA=KrG5-rLgfaF2eSeF\'2-p)Zh\6K6Y_UY
+4j;3-(1YlMeL4UbSZTj!Plc#1M0&]AL/je]A3RcsX20*_7!8in;U.Z7P%JcY6A4I%>n-_Disc
ZQBUoU,ASZ?J`AfYW=Y.\Il8[F$%VuM0_k[WU9rR$YdbE=ZP:r^3q<Agr'KC<NDU?LO-a(0K
/S#r]Aq4WnuiOm9R&7&`HjqdfoNh/JrB,,>rDJa$2f3#b.<*m2=/!hi2:T[%\M)SIaGAH^jJ=
,FV'[!el6`d^+V0<miOhYb'o.l0u2ND&#+0-LFc\NK]AKS3S,q]A;!12"Oqj:E@&pX4:)=1@e>
s<ElWM_J;ZVftu-;e>`cG6*:neP=qmcY"SYnEDn_aa4j@><kGHNXK?4^ba<Z%bH+=0C4\s>b
*u$\Z?_E\ed7U.[#M]A?;XBsF`)L<.NM"3chaG=:pm\qq*EfW`nM\k`8-N5B1Q>m5P$o(')Eh
M1NZDhkaB?nToErf#rN.op.mub"\n#NOnV;6)g*7m;6J!VUcMs'-8(3BA^On_K$,?'S39I@E
T+S(3bV.NmK7i0cANI_Y+?giT5Vo0lZ7)&q0.l<:RX%HuSL4d&k1upla+/>U[ps+lJuFkR[X
]AXgn]Ar4S4_g6R<ie!_oRO@GF.J7<B>^i%G_YbV9qC'XD+`72@GF3Z]AToqKN-L&XVE/k``K3^
SVr!qoXST_Tf-H@>Z-g+m2quV8%loY.5bJ?S;2aES80rmsSM3:Y*8PL$Mtq9[b:IHL\WR2&,
um@?iEM!qCVj&F)I7bf);HLfme3Zh)B*o$@^@M$"itNu[7`?HZRYj.2!Pjr!o47M^nWPU(;C
Cl95=+]AFH`8NW\o%k_I65<;>is_E]Au$h-TeZoR"'\doc+$BB9;LJ]ASsu-klYOOS94Z%Vm?aq
*d7Ah4aSd)H1`m+bu1/`oq-?JF)HuZ4@L%RVI:j\e^u,Wgui1;EgaeR73a+aoQc]A]A&?g8d0.
N<)#-8U(kULnhRU?n4QnGW%JGH4V8N6C?Xt2`6M:QP:os3"=4Fo&_oGJP)R(eH%J>1N)YWXk
fDa"+GbhBDr@3fEupVS-sZ:&2:b4s6,Ngd$@`)i74"2F*0>7=[F0H)0Z.%qkm0eGsjb:dL^m
`i&UBmW?pla*!=<B<3i!NMA#E?6!;DAh5c0k'FH`MM`[Od#V-/(E?J59tu%:;<sjCZ="(4c6
go<L,[(g4$1-kF3_5:D6E1qlGY@Lnn0t'T/:@g0lPDKEmk7^V3@L=Ta8i,b3]Asko3sZJ7cOd
_Ra#4ah##:IG/DYis&6<9LWInp%\[*<-[`Zg-0l6UrWCC3bJ4']A@.nA>dcupM)2g]AC8\Cc2@
>aQD;nNV++<hI_l(7D/#AdGf%'$Wi5b@bOOW(Apr#WgK8%j$Q]Ao!&&/R)-O+!+4,I1Lc77a`
U:@Vu7g0">&+Pp5.YoFO\NPsi":_3^I18'c0g[XJLBq0o2QTCEdW\Du/%q-@<?h$3d>jD"5s
-Y4]A->6g=Zm,pKU5*aOHlNCp/3cgZeoNragS4`;]A^tJpj-W$6GMKEs2Eh"8Atl\VU7^QA<+-
q`Lj_j9h(5XCN\n&PN>;+5E"&`t5fKUpVKRJj<._J[IoIp.4o,l.!*I@':/]A9`DaEgiXdn5]A
:<Kn.^K1n#]Afb=%laE%3:4RF$p>_Y4mE068X1*L-=tn$mT2YY0J1n7u`rQ*R=(ebd?L"-/cD
CuT%XhA>h_BVQ77s\6j'K_AZ#Cq/ZXb]A;:@2-!jL^?6[=)'ka"'H%h_GK(1T,6B-80CsYRkO
mj9-I(Q7,^?G(pFI14gJ89\?YQah?aPpBp@cV3`ula4hOgmR@3*U>k<HFVR'fDt%GuWBhj%p
EF/cEAV?5YrHe/HD[mn]AbjAbSVO-h/Y]A/dekT4PMOi:XYcF\d#FAe57EOVpnr\\0?)$[JA`1
2cPEIqijlUX),/I=FXaK&)I8-g*XU"ZoSp!fdCk6FQ.eeXr]AIKcnC)R9-FR_6[nX2t:2D+Zt
J@@ShqT&9YC_ZZH'/&h`lQU"IY<32RHBtbTdR`61%I\os=b\@Qm[u%hH#\4!FINLIp]AiAhdA
7A[:tb1D7M-qY58F25m4#;q,[0;;-+i3XjLtsSm#E\0[VR4AM&oO]AQo.MU`R/*Gn'/Q02kuR
6<h`QBH-m..9DpZGD=+(ArM$p'HWO>k5\areATX@?kl)Cg=p3$+h)\;:(fW]AP#tAZ?pd6J=_
M`(;%c>uZ>/:-;Rj-5*c"st.`p=VSMkR1!%QLc8Hs=Op?<>@Qab%uP'fOOur3O<tqKquY"T.
U#Qj\3KXiK$SLh\K-<C8%SP4blC\PXqZmVYUp]A5/&X=ZVV=&n[']A;fZ"frdTX0f2Z%M;5Qek
k%hFq^`S\!#\n$C2@]Ak`(=k.n!O1j*dfog7XgbWG$@ST;8b$Y91!YP&P:,L!o6)ZsKa%qD)b
`24%+3.7^GkWk]AsZGT0po7a\56;JXkr*R)SO#3ek=-b9L.b_jP>\_s$?l-\`RJ)jGg5Q<B?c
;*RqMQ>1:EUm3i0Clq\hcDqC3qiV`i1YO\nbq)u+TNG0FrI%AS_Z-bE-9KXKiJNK2u*"ZaQo
\Ta5$9dHud]AJ!qY_&FjlJPlj/p<a_&^C1_c8FkH0%!-.!D3+\Kls`"-shGBd$!q;J[7$Pr8u
%?CY-Akl-P&Bp7k1@SBsoe`M>38K9\p_R)@N)bjI,\U5Jng3.p%\nK[X#,ddH6.Q\P4l7*mg
Ft8^q@.eI=g>(,4V\cqNd#g8T(V3K@8.(QT&1b3ToB4'pCJTa6lT%JhW[/CXafnm9H"fYQ`]A
-Bb[6\D6D$n@Gn0W,&$E?'dSF(ffFS?-Z^u<.O%A\ES1Xt[\$g`h?kL,c(S#t;*)U_hp?-\m
n?)9O^^_B_&0Puf!N@b+Q5daaDDHYF@o(=4F)=RQ?8.+60"FbUWIFRdAliDfiNET'%d%YC6?
71+As"A.j2R?b>*;&8'7<B#\s*\RtkR-\L!2Nu_,[S$_g[o'87+[ZmK'Lbf[B;;4"tOs)Bh`
*4EJ.^Z^(n'`>^2pGd)o>?9poo/H.RW57K[JH,Cc)m,;DsIo=t3=OKl-UI[ojk51q?QI;'^i
!7dg_\;G6`g6JRIMfj4?n@^hYq!V8Q1TS@pd<#M\eo/(dD6TUL_2EkeTX*l?@_7Yc`"EPJYM
NK;95\rET;DP=(ECbk;&C9:iDI=0$0jX34$h.efR:HA.,B9RS(m`=<PmF9:aJ>\q7&[;dCRQ
=&d_I`\[Ebc(>/#5iQE0nb@#.?E\DOq=;IfL^;7Ri2rGdIdpj]A)Q!`VEMefcf&enaR\&!1\K
F=K'cZ%mMJ"MbI!pl-M@q>R>Z+0Kl/A8/A.@V"5F&%50O8g,0hpg3_q"MaAQ,9KnIim_>a$7
3lo8)S`Z0RCtEGN@Qg\j[;"&N0CGP1/-qYh6dHFsSkEc]AYWDS.=KRMOQ]A,gkTtF]AP"g%,m>)
7SRZfn^9l0l6@"FU:4!]A1)8f0S1Wmp.CETl]AuK'SmqA,0U10sG\T.*A*PNr*T`32H+nE1&8B
5`*dH5jofd`f]AV;s:_I,+aYA?cLMh=dG0ZXo8jGKlHc=$%;+^8o:;2]A79B7Me]A]A/i^QTX3rL
-n$<qN9I@40Hnl2Jm]Ah8!.&>kB]A_N4m=IN+7f)>o[!-$X3(]ArshCeU$Y2O,p-0r-\_HDL3nR
09\qe"a[\Z4!IXr:OLg(s1ARbf2n3S;rCMbsIkrZUR%Lp'Gpu?>]A:(\Z_3K47;qWOMX!jBlt
a=Eh"EONc8I+4*>)-p6c79G!Y(BbLp-TO&fA$I-ncu)^V4UI-=cP*.fhBQT<)K9."N+3jM!B
^.b^Q/l1DV_RIf'Y:sj;C*Aiiis>2%hL_$dk,jZ=2e!b('d;jMe+-.?OY^1HJl<fqG::IWpB
b5[W<_gSiY!AHhY:3tOF8?E52c9G;B5b`=)CA?^g?N^>aPHS?VQHU9&.;!/p$h-?Q2s,Q85_
JMMJZW0T<tuP*F>o8AO%>U]A(XGf!-c/Z0^ClJgdHpmhghVK+3?I;&H/R'!7KpKXJHqTo%0Ri
+D,OX0!:`$mGeuUg&8toi"j\bBokJ4M2;c7@pqi.8c-I$NQmT&06i_dV(g:XDVTXJS\l*IK#
Dg]A\su3%(i;8[6HTUhRma#@`6H)ei0VKN>7pnFNi!J0[4BVj0*CXadY*eoHG'IJZU(!EQ_O$
WDj!F:)*FHA5'dS(%XP+%We[#2K&n4cN/uN^Yd=qoN_-Op1V<5rn0PBOc^5*Ceo9mQ,NH@L`
1PZF!klrcKNAnZ@m[&@t"5$7YrHG>4j,`2<qRn3iZ-#ZG92A;-#uMoAb#J.J%s3^Yc5CQ<)3
':+rXK<]A[+FZnc[Zd4sOGWCM2q"0+NIF;Wj21oX3kHG'_Gd.HibB6)\60*3m%dVHCpZ?8log
URDXf$IsbgiPLZ*0YeoE5&>HdJC:/D`hQYm]AL(J2&b8_+8AfN[(#6`4D!,3IERBgCPOQP#7]A
:oQfQui.`lNNh$E_fUYid"/lt]A(=0%/$V8F0j$0hPp)SL%Bnh%?EP*i9Sd!do.'[LRmhLrG1
SaO1V?f0:<J!>]A`r62VCG\TM6"I&&Q6IrZr"KAAX9XfPQ2fB\p@9d#l34>;DD-c$kEQ?4HKA
R"j6RLQmRjd;]AN.m*m>cDq[XHZ[CO+@pnP1&fM,t,efD`G+%nl\.G1Sr#C5pCuL9g.9IV)#!
V;K_cpeqnXJ<1A0sDfG6H4HT/pR51h;4;CG@'n=b""Y?a'HD"sN<R#s]AdGa]AT#tQUZ\7;eq/
,auFYStiD(Pa0U3ldEKg'Q\=NSD=*?\E`AhAC2nJSW/OZE.>/.]AW*8%PY<&pMR+"+fS0<gM>
f/=2rT\&*Vg';pN=+M\YB,gL]A$:'54c%>,ub`#8.8r\pi;t'DC?[O)qX7`nsYhOm1F9.t)Au
b1X7FT/Leh29W8/Bm`P6():D.,b_%fMMA5<MpqG/PA1\h;n[0]AXr$_26>fE2F-qXhe;?Egi:
ShIgUM#&$dQdAAfAYD&*#M!odjLUj1gAVaYFVGq^d6LE.)D>[BQlt&FJ(nBq_cF`i/XGbaIX
q2A%\.GL-5\]AB5AlT1-rc^^ZPW^?rE51l^/.53dXJ11E4rOG668C(<L<5K[2LlNWWQ(sL*--
U@E1gEN)sb7_C"Lpe&r:IU!Y&.mN)+DMauIcqSF'LE!.q\7NZr4k.[k`:el8d:?fc<F,PQW9
YQ^HH7Q*gMc?Pr((;Z7,nfF1]AHK(O2m>Uf*]A9J%TU<Q\?Vl1u>ObdLUZFf!kV,m)S0l#Tb,]A
%--@<("6$1T8GEkFRb;ZlejJ"q&[hnALM&=H2JV?j0@c>!YLsPJ>6RXA<\Tm+c12h'BlZ7*=
/BDNB+m(MY?)mE"F2m;HiL8^f#$#ADYnGO.ObDf?m<@]A]A2;".N;-8NKta"i;I@:oTe%iK`"?
#cC=Qsa*DE7nFt&nU;-]A+iqmS-^^(rkTbCj&!ZCWJ5Y6BT?ASC1gW^hcpA5DqAd>,MY)UAX'
6BIfqb1Q]AZ?KiVa6e56jCkV6ZCZaGDS)(`jp=]ACYCde6B+!"S,r'C@Q[6rtBHoh-5MKuHWC'
4D[-IrWB@_.ZpAF!Vj:LS:/$FLoV-s0/q^_mgg]A5b;m-?o$Z^(^@0tgGT6@Z1)jnmao.Uj'(
5AB-9*An!MSjf2c^6<[GAA*W<LVTO[^29K!Yr\k"M:R"T7H'[2CXp5:PN'h)V.6'oKA0p^]AO
TS&d+U+Z3ITYg2U,:<&2k#dC_tJ7i-7E::hfg(O9mLlO?.!]A0PZ2Ad9'KsZ$#i1<*s`iQtm#
m]A)X`P.?f;>"]A+>X%?.e2lrm:j(tMa0LQ<8ioYLtSJ@Q+f<HVoT?iL(S:%s/9a^19s[RQD]A+
Ek6LZRb)1'3?>Go0:C>aVF6-]A,,VXR%2su_^fbJ"5AaqjBh5]AQ^>=_Q2-'f'.</hjaP<qq+:
"5q;6pV)ua^L\)H5!IiJB(pp]A5>L4:0AD><!H'M7D'+UTkY"i%1^<4L^0>Gq'-kH=ja56(~
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
<FRFont name="simhei" style="0" size="72"/>
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
<FRFont name="simhei" style="0" size="72"/>
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
<FRFont name="simhei" style="0" size="72"/>
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
<FRFont name="simhei" style="0" size="72"/>
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
<Widget widgetName="LABLE_ANNOTATION1_c"/>
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
<I18N key="annotation" description="註解">
<zh_TW>
<![CDATA[註：預警圖示紅勾為本期有風險，灰叉為本期無風險。]]></zh_TW>
<en_US>
<![CDATA[Note: A red checkmark in the table indicates the risk happens in this period, while a grey cross indicates there is no risk in this period.]]></en_US>
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
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.32.0.20241202">
<TemplateCloudInfoAttrMark createTime="1711940947019"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="a4998779-4261-41e6-966d-b12f05091390"/>
</TemplateIdAttMark>
</Form>
