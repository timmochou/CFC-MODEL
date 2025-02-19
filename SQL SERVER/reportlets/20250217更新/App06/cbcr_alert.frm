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
<![CDATA[2023-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COUNTRY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[SZYC_tax_cbcr1]]></O>
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
AND (PERIOD = '${P_PERIOD}' OR PERIOD = CAST(CAST(SUBSTRING('${P_PERIOD}', 1, 4) AS INT) - 1 AS VARCHAR) + SUBSTRING('${P_PERIOD}', 5, 3))
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
),GroupExchangeRate AS (
    SELECT 
        Period,
        VALUE AS GroupExchangeRate
    FROM TRS_FACT_COUNTRY_REPORT
    WHERE Period = '${P_PERIOD}'
    AND ENTITY_ID = 'group'
    AND DATA_NAME = 'col_p2_eur_to_twd_exch'
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
GE.GroupExchangeRate,
STUFF((
    SELECT ',' + x.risk_type
    FROM (
        SELECT 'col_lowtax_income_non_rel' as risk_type WHERE IS_LOWTAX = 'true' AND T1.col_income_non_rel != 0
        UNION ALL SELECT 'col_lowtax_tangible_asset' WHERE IS_LOWTAX = 'true' AND T1.col_tangible_asset != 0
        UNION ALL SELECT 'col_lowtax_hold' WHERE IS_LOWTAX = 'true' AND (
            T1.col_res_and_dev = '1' OR 
            T1.col_hold_int_property = '1' OR 
            T1.col_purchase = '1' OR 
            T1.col_manufacture = '1' OR 
            T1.col_sales_mkt_distrbn = '1' OR 
            T1.col_admin_mgnt_sup = '1' OR 
            T1.col_provide_serv_to_nrp = '1' OR 
            T1.col_int_grp_fin = '1' OR 
            T1.col_regu_fin_serv = '1' OR 
            T1.col_insurance = '1' OR 
            T1.col_others = '1'
        )
        UNION ALL SELECT 'col_emp_manufacture' WHERE T1.col_manufacture != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_sales_mkt_distrbn' WHERE T1.col_sales_mkt_distrbn != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_provide_serv_to_nrp' WHERE T1.col_provide_serv_to_nrp != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_admin_mgnt_sup' WHERE T1.col_admin_mgnt_sup != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_res_and_dev' WHERE T1.col_res_and_dev != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_emp_income_non_rel' WHERE T1.col_income_non_rel != 0 AND T1.col_num_of_emp = 0
        UNION ALL SELECT 'col_unmatch' WHERE (T1.col_pre_tax_income > 0 AND T1.col_curr_tax_payable < 0) OR (T1.col_pre_tax_income < 0 AND T1.col_curr_tax_payable > 0)
        UNION ALL SELECT 'col_low_etr' WHERE ISNULL(T1.col_curr_tax_payable / NULLIF(T1.col_pre_tax_income, 0), 0) < T5.TAX_RATE
        --可能不符合Pillar 2過渡性避風港小型微利測試之豁免條件
        UNION ALL SELECT 'col_de_minimis' WHERE T1.col_p2_income > (10000000 * GE.GroupExchangeRate) OR T1.col_p2_pre_tax_income > (1000000 * GE.GroupExchangeRate)
        UNION ALL SELECT 'col_simplified_etr' WHERE 
            (LEFT(T1.Period,4)='2023' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)='2024' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.15) OR
            (LEFT(T1.Period,4)='2025' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.16) OR
            (LEFT(T1.Period,4)='2026' AND ISNULL(T1.col_p2_tax_exp / NULLIF(T1.col_p2_pre_tax_income, 0), 0)< 0.17)
        --可能不符合Pillar 2過渡性避風港例行利潤測試之豁免條件
        UNION ALL SELECT 'col_routine_profits' WHERE (ISNULL(T1.col_p2_pre_tax_income,0) - (((ISNULL(T6.col_p2_payroll,0) + ISNULL(T1.col_p2_payroll,0)) * 0.05)+ ((ISNULL(T6.col_p2_tangible_asset,0) + ISNULL(T1.col_p2_tangible_asset,0)) * 0.04)) >=0)
     ) x
        WHERE 1=1 
        ${if(len(P_CATEGORY) == 0,"","and risk_type IN ('" + P_CATEGORY + "')")}
    FOR XML PATH('')
), 1, 1, '') AS TYPE
FROM PivotData T1
-- T6 為上期資料 
LEFT JOIN PivotData T6 ON T1.ENTITY_ID = T6.ENTITY_ID 
    AND T6.Period = CAST(CAST(SUBSTRING('${P_PERIOD}', 1, 4) AS INT) - 1 AS VARCHAR) + SUBSTRING('${P_PERIOD}', 5, 3)
LEFT JOIN
        TRSDB.dbo.V_TRS_DIM_ENTITY_CUR T2 ON T1.ENTITY_ID = T2.ENTITY_CODE 
    LEFT JOIN 
        V_TRS_DIM_ENTITY T3 ON T1.ENTITY_ID = T3.ENTITY_ID AND T3.FR_LOCALE='${fr_locale}'
	LEFT JOIN 
        V_TRS_DIM_COUNTRY T4 ON T3.COUNTRY_ID = T4.COUNTRY_CODE AND T4.FR_LOCALE='${fr_locale}'
    LEFT JOIN
        TRS_FACT_COUNTRY_TAX T5 ON T4.COUNTRY_ID = T5.COUNTRY_CODE
LEFT JOIN GroupExchangeRate GE ON T1.Period = GE.Period
WHERE 
1=1 
AND T1.Period = '${P_PERIOD}'
${if(len(P_COUNTRY) == 0,"","and T3.COUNTRY_ID IN ('" + P_COUNTRY + "')")}
),COUNT_TYPE AS(
SELECT 
    TYPE,
    LEN(TYPE) - LEN(REPLACE(TYPE, ',', '')) + 1 AS TypeCount  -- 計算逗號數量來+1 獲得COL 數量
FROM RiskWarning
WHERE TYPE IS NOT NULL  -- 確保TYPE不為空
GROUP BY TYPE
)
SELECT 
    T1.*,
    ISNULL(T2.TypeCount, 0) as TypeCount  -- 如果TYPE為空,則返回0
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
<params>
<![CDATA[{}]]></params>
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
<params>
<![CDATA[{}]]></params>
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
<UUID uuid="a48c5300-c88c-4de6-916c-84ab2dc1defd"/>
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
<Attributes dsName="REP_WARNING" columnName="ENTITY_ID"/>
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
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
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
<![CDATA[e@]AErPA/W,MIRZ(&Z&&>$b_JjVBReD/bCAXRPZIe-a=g=c(Q@V5X;<s!e_2O&g9LC,QU5f&4
1o/?jI;dK^@X@o0'Fpp\hRNm2m;QE.n*<CTVZKk?@U(_:m>ujDj/=>[1M]ADuFtA%N!`*ao/D
Q7l\7dTTq-KEV]AXEFlV2haSZbmGKp:dO>L)'a:Y-CX[?>0]A-$R7cF=X7rT\+WRtn0&36h>%Q
0GQaa3HV]ASA#G/3TAuTSFQ=$TjA=4Poai"Z[AULB-_3Cs7koV6N^5cSa85E41U!CgZd(gYUZ
Y0YSd]A5ggbRFP3D%q[dale%M3I0C"9O4#Xii6jPn<ZSmnH*F57A1)2eP]ALS#.$QYpq^hZ\)+
*oZ^4S^$$H/3(T0o7C..J&NNr'/IAp<e;5')Xhlcm!Uo2f9!DMW?j\jP$YE:[56R6):=mq-!
BDTY&>]A9NV^siSdF,oOLT$bbucrZ8LqP-I=UXC]A8)?ROk&5`dFuFUGim6BXQ/N0j\&i[eZ)D
;HN3p#Q3Js3!Z(dukDr3'4C1+Z+N!>YlY_17qu%;^A$=@Y.9sfdK:;hsi?&r3#6oEnK)WH?C
GOVYAOrcX>??TuC*bH(/Uuflo#s/UOGr/sY2Ff3IAD,eQo4Y;/E,J6]AACm2G5(NM+"2sA8C:
KUG_YPO\`[ZCYAPGT-ia3]AKAY"Bm]AC^Qk0Z^[aT$TA,O(0b>I6R80!7,S;#K@+>h/n]AI`Q[j
`;SscHVN11mat[Fnn,jIQ.]ALZ:ctq&1b5b7RPl+jV28piS`0^*E4.g]ACqcoo+m/t[<5G\Gj3
shod-tGYp&3'9jS03.II!$hDB<N?i94[A2U2MY(%7`;i$0==qekriYsaW4)(+i`GJg0_.A:#
8dlAcmW@<2PW;QKti312^Lmeg'qS+,YD;F,gId>*%i)s"(BtAYm6XCK#`$8pbHDjPTY4)=Z]A
D3A;k5!nWr&FZoHU^=N*^\JrP.7Tis"W:"1ldDl"AFT#VJfbRr8/eOi/h4I`#ff%g0)3lL@;
:==8/YoiE:-*bN_H]Ai*QCd8brh\IpK`VqJ(uDp4/^/GCFL<jSNc0-[9Psjs8Y_d,hmbcVFe:
MRIi,UW(>F%C`L&JTW\"A8P;1V-dO/e<eU8#M1Xj=$\\LnJM9ZiGP`.4'bh8Cn)U^bTaZ1Mp
$V7SLACcg1%qP9_9BI'gF-)&7,?)qbfK=_ZdhD605m#ptebd=4Ye(WH4g]A-ib&AAl2U\im6t
!;VUNSg)Elnm2OE<cC,2G.\pRfe^L:AJha3Yb&9UP9\$``?7B@PP0u;^=$,W+Jo7j09>Q/7T
aBgh:DgAG++;J$'OR%f$]AncMPFKQCrAoEJ<qZi5_1gL&%,'AmG+Hf7"b)MoMCjHE"o/kW+'`
'@i-<BNN]A\aQ"3b@Bi+JB<[sF;I5ORA[g:8RoSI"S;m&%)Sah^q9HOoM/(SDq#R`a;oc!bL@
0Q@clFSt82\PC"\!Jka#Ms`P?k.rh.m5?f1hqK?N7U.UpC5Epbm#`Dirt^Q/$kR8""R?eA]A!
CA+i!(&ZV7Z;8LN?5R.-;aj5`8&McIOFPI"uU\VON`P6AP`]A#&ZMtfhr/rqQMRr2$+p:@;aE
4k.#mAOn8PD4+dI_O(U=igk+MKeQ,"oM\4`mTWIA/21.rmmA/sJIAO2*nZd1/T<9nA?&M7DR
Y.t+o;!-<fCf-Xp4K]AaT@"NY4>-utl:(T\dbg_X%<lI4ghp>'A<$F??(9(B!OWq`"#NgO<hH
66\[FXtqW_r%A>b#Kgue/FZd9+g%H2Mdh@Y:nO)*Jch@-U`>g(DjFDQ76r-%HU&3T!@mG`p2
JqH\]A4JQ'%d3FK/MPj(I99E)lT31>rHlo3S(i9/TN8cY%G1*./o,(7"[L(P>/mM!o`f#TL=[
l14V,EO>f11<\QM.o+!_8tBi)JJ]A35Ra,hhW%.dV0ht!iC\fje5&->/W#f9fGG?O4j,<rHLH
;k)%:`3XUrcgV(bf&RS*7"lrQuH6_a3.+dK-!Rn`-Bu?dE@isi^G4QDbd"d(h[F!keI94H9R
9,(+BQ?i-hUM+"PoHcE,:0(ZoWD7?885c_%[S['Q>3Y1=Bu'6Z05?pE_FhR\<lY!cd0P2i[,
K>gmD$dM'LXN4#bN3Vs!lGHApr)k@at4]Akq&ro5D/#fDCH?@-=^E'DYGW?0c&*7<UPKj%BS4
o7"6QCbs\N1sS\70jWhr_9?EM,MLXa;A%cZlTp#h.7k(PG5'W.2t:?1Ql#3S&uM"`AA;1q_=
IE-G)T=^$)i%4MN&gbcWY(o477mA'cWQ4<5$-%?`@I:`fG:,*TS*Fn'%i>*8VBT`6%ug1?WD
4brt[VpHr$FrjmYaqK>cFL/]A8^'gXZgV7t@Mkc:lRTqLn+3M*o+4QRNa,F@Ltksn/>Xc[_Uc
KK86O.mcb)4S4K(PkO<0)Oa.65R=CfDE>#P[LP?K"ohdJ2%.5CA>;"GDXHTX)fCMZDQ_O\H:
A5;QAnp/4ips?N_L\2t"\k+d)JJ/l6_@'<Bb,(IVb<b!P#Z)^n3P9!T73pO)V?W^=K4Ad_!C
]AP9VLZs,?J;k!(*:5/Lh]ABgH#P==;[Rr!(p<.-2MnlX:GQoB'oe@E8SVe_*=H4mW5g=DfmUZ
9d)idQ+`K;&q+/Ma(&!7mV<K*-acefje-?,1l#,%L5q+m$U!:,8%)%JOXCJa@PB/!'nGq8_g
!InBI<iKKUg9+o&<MR5I-lQ`CeVWJ>p;Zr`Al`ul_Z*^o&c)uA=W&$><4PD/@Y9@M,`'a[i+
FoA.flkSs$f]Atk6^RNsT8>c]ABk>@h+188p`e@o<)Qf/TSkEAV@T%sf5+SG4XZ\'kp'sQY*!g
1o%MNjub9QWG3p-2FJ.as$icXO<3>f3!#@<D+lNRnjKCkKjNZV2JO&UGBX79QZ,oChY=Th`2
o'4Gsr7AYh;U8NVW,39CQ;r*Ni]A_1N=[#90Z$?2pW+&6q#?"mqgA\>dPCk]AQj65>]A?(-D,`5
hXI?Pr2C$k%P'>FD\Nen?isi-KOKi%ANZY%oVQJBbl8/Bs,s&=gGicG=Z;41Yu/Fg"i,3JjI
[`6?R91##B'-tjN%6B65;%e$6!pmtT;K$XZ=]Ad969QKn(XIR=gR8XU\aj]A5R79C^4'D77uX(
><jp$)i`?cr3Q9&DFY,B5fYrffEBQd_bMV>qECC<&eKj`'Tf>\DCSLGa1/Z_&pss"JHn9f;=
mCG/e-bE[@-GrJQ:$L-c8ERRMX:M,Y[0di3nq=gEYCpu:]AV5<-"\Bb3cT9=M-@WG&gQ`f@YD
M@\hhD^'sbJ8\gZIGr.?/K:%'#n]Ao6mN/th-JYgj`6KnEAE*>O!'[X^_.5^BA;)/%>4-e_rL
9&Sj/tB/JF7?.=sQ+;RPMd/!,AOI=_[#T8?r[2[ZV"4_*%p74`r&F<)GS(RDC!I,D[!OKmZk
E+`fd+`OTCWN;=?DKn80JVF8_eCK`Q)^jT`6:.WbC=R5>`H5if*JV7s-Y))7%<hU9Q9@U>:i
N_,q)Xg@s$lk,;ffi9f!n"aL>7Cpd8nE[FG%<9h5H3Q!:(''[e?,FBF$1JVlUd]A=X.rY[E\`
n4fct9H94+AHk4u(7g*,?)l=gHM8L>BM*oUAL2upm:1_IA727N*?l%?.#+_jq*CoRO&B\N:g
q0q'$kf#<D8=Af;BtDtN;<fEJN`cr2m>De?<Z>4eK@b4)Bi6\+N>l^.><uoq2I!K'00:RYXI
NMZ/e+6!CL0@YeeHSU*9M;t21@*P\2:3/'%f7WF`]A5If0Vt6QC.VmNu-7F&#FsiCKH0KfZC#
!^)/R_I/9qdi(Ju`fTH^:=U*t/E?`Kc'qikoLl+Y\p-!bN0h&/(Cj7&T_F<qQ]A2qW#gM]A.qi
pn-kJ#]AN&<Aq"Oe=<roK?Dt#p=`Nc(gi>(g=85[[\77c,sF)'K_BuAZBYd2H#s=3`J(./_DF
NEBG6u+Uj<[3E!T8YX#NRD76_e1<<\hf,!>1+n5O5.@04/[nV(Z$3P*E"W`R?0k$3VufsE\k
]AlY(oOW@'CUU<b)d#hV=M)r:="[+Q3D$`]A&,oco.&i:N6O&;1gdqhqW)).\HU<'L0EQT/%J0
\,L:Ed3VK+It)=h_OuO_,c6X9eZepd:osjV>lGi!J70\eT[9;9_YkR""G1*IMM4i-36G]ApFt
koM=p@!/6J<YD$WZZ5*21^<M6B4XJA84-,)$=P"#.>%A=,3=:/B4iBuTY?Q?T#G,G#)^+-Xd
\N%"<95.Z:r1JDa>\K.2WsL7:>p>h!29rlW$:IG@&0OoV2M4G;)'kNgSudb;NDh8UYg;LLhP
P3915E]A%F<q6$X%?:YK?j\J[,LK9dXeAH]AJJJE%&itg+f?8/F[p.Xk5ln29V#6mekFQ_m\E:
XF1)V%LU@HeLN#'T2V9M!!Olp0@%4Ug:o01eFS35e#)rKnF-"(Qj5]AoZO"H3g7N9(\VZ!t_=
]A7/0G"WkVCHkUT?u.Zo+:<P;sIRK7_!LsheNnLB&X9UnQTY_X`2&>Li&i+W"Ok?Wb5:d<3I6
Fm<6XnGDE"%5FBLp0@0O5%ij]AB.\hFSLo_bn$n-p.%eiUa5K*M$)gba"n8Q4jkJ_X@7Dm'!;
jnR>%pg3nhR*0#D>?YlojuKMM`TC^$d<=J5t!94EEK-=;*c]A(X+]AUO>U9Vf!4&e0d%9V8*>i
grpD/"k(U?bUc64ii1.)r5Zn^u8D$K:qY`&TGTEV@W9JXr?&&!Ljh.0=G_FP2"0M!fUkU#Eo
Qe8q&ji_-Fc$c,/U&O`$-H$cX#7Eub7uY;'\7BJrA+.BtAfoojGqb3_3!9U8F$SE"G.)(n^F
0C`eYT^?L,!++rE&[mdmaJK(8?Z^g?;N(:WCF,U3!/7nEMNK5u]AQ8Q4&\6+0W`dJ_T59%0Q9
EM')*g<Xf:?n=SiVR6_.>]AMnWIqj_\d+mlp78pX?(Ku-J=`Nd*oa;.PPk&a1[_f=kOmkZkA6
#`,h=H/$djc$"UEc0k]A?^.i-D&&Y`CunZN7+Kb."N>_Oo"@<-n^o9<FQ^G.K@W6=SGg@s5gP
[c4(Zl7=fgD->jp2#GA;R3Gg:8q=TOYq$>2RNb&SdmDT'FL1QU>r'FCH7F7?`Nk]As\Z=E&"Q
(?#AC.6&)cX:*t7AJ<_5-,Xo?[21j?YFWZ$6qj1e?4d`%Ik4AQg!8;bj>SZ7BJqn.V&Eq0-j
]A>^K5Fn[L:\a;'OfpI/9::/X%@'DM^pNS%NIXjZCc0QfD@e.n@Mu9=g_uT*`PRqn(am?aOo<
Y_"#/3U+js_kb*DoX%YK:E$s)CBQ(RNf>WXj3i6)0>dC`mHdBbkpS^LHa"Vm4mKq!'e2`@Ml
0aSXn+`LL3qln)`i),Q_0fK.B'KpNTA#1rAN'JcTS,D&g8sF1"e]AeIP,Ms[@X@!1.T&3<&h0
YbV3l@+B$q$QB,YqJR6l]A8rH>a".%M@qeo&ok+7gW_h.^"QQ8f]A9oG2-U``K'sj14BD\oX`Q
VFPb[>B=$,8*=f/(Y?U::LkHZ>-Cm52")>O4`IcAcbb*E3VIMnW+Pr)n"Z@/VJr<6?uM*0B8
Z-S/JeeFe4i$i0'rI6eK/ee2K0p?3t%`+N(XaU:FK_XkEP^'hX=D7%2%&`*SZq'NMG'V_1b0
_HCf#`oo5<tN.);*g`Xs(!7B6U?T7Z`dCZ01lL?]ARh0ie.%K[j%I[A>]AnU/TJT(5Wfoq97S<
H!-('sq8X;1InoV/DWGA'8lXb6&Q289lU_oNa>02?HKWg,!3rN0qfid'j3JH%c(cSNH*S.hu
"kaet&#QI"GQbIT;!AiJ`/Qh1J/<aouJ@e2u[U'kb/6q$ZU'a#[?'#rq)`?$DQ\,(+7h*E6e
X1;5EpCuOb)#<<k@l^F-.gqW@Ht:aQMGR;JBhu5r?EQYD>=&`5<U7h*bVFbRh=Oq,L#qAdAT
;B2:-Z/XiHXI'GYf+&l%RoAA2t>pPZtkH:Dd5Pe@P%GQbpBCrgL-.XjS/uq@)1E#sNTkl`kT
RV%\&4bZ%o1H'=b?)M]A;:gNmZ`q<'7Le,#?L,*kHNoKh,/_#&N8_]A8!c4m(CC"YV+^/?;J1b
LQ=Z-&i7lckF.qbAj0cej.3sAlrM7LTNoj@!n4mdTGBe\>q5*Fh/&#]A@0O8W;F04J&GV!h$J
FN<G'o6#qkRVg7!0G<pVgI7bP&%V*n/HmqQ>\fo1F'5!lq^m!^GT$;7'tbV19s1!UhB"H+De
kq=h&hi`E[WqJ=;=s]AJPcC\RirP;eAi,LP^$=#O\Z1pVKAV-iF_(\@[7G`rMe\\3Fk8mm@1)
SE^1Lea2e3LDRru_@L0$+bfog]AcaJb#Md]A:aEJ,>`R^XJp&2bhWEVZJ^,Fg,?,VJFB*jXILA
!/gWt=6WY7EcOpGn8G]ABtGG]AYuR*Hd)Ac=,KIESi);+etH^e&/h3/hTV-8G9e@V=T2"!EbQh
"K=)Fg5))Dp]A$p8Hf]A*L"+:!-dt_V0nVF'OCQP#B2U,tH;8^*0>kY'm3RgLl%7C=S#<%47nb
*2,Wh]A?`=JL!^H5c)[0ksEB<F)V&qsUD11eS17,AjO=R_$:M6r2`XZrE*BHhPb46.'<nMOpt
7FhnYEF_YF8Vu=;#LtMqf1-eSO!:M>?)h6!kMQt7S&W0@SL5'"&WB1j0)mC&mFUTQfm%-9AO
XXr17E$YfiE+*ps]Ad2!fm6X0+Wj$J9m_pbOfIIluXqu@`$Ksf,-k>7NL%I2=KR"lE`/1g`/r
!YL4sqBlOKMUp]AN8$QECFEZ\1SXoJ@f7mYoG!uHNteF"Is-ONsla"C*U^,Q%[l"Y6PGiVjl;
+"cg?:g+5TQ:/#B8+,?$0D@WY/&e27i(&Y*gJY=mN5cIdcHYSoeT`NNEHp)")\,Fi,`<<F$Y
WE6H\\u/Db[GcZmA*4(9fk\H^[c/k-=8hKfmAg;sWXKC>rd&`-#U5#GY.f*X)>dJ`%cmT2@n
;lae[AS`VW$S5-]ADG?ji,$e![$jWi,]AH5)Jjc_^f1gQ(Fk8a*Rg>+q$ZT6J5*3;1Je"g\;W?
1R64V0FN]ACH\-DP7t)Fuacq0_VkJleV6?aZCUd9\R@OrS!c=WDS.N/5a,H5[X4H16I>PP."V
YW3k@0QPfM/1M,U7`9u@h(oFW_,G1c5d6+4UD;)o4_1s8-pS'tRXb;D75"a%FptqXn]AV33#]A
*QK9`/Vj[_JK*W]Anq=Q0O^Q\Kd\AKP:"R>-!S85aedeMqp)PT@E'pLqYc2!9!>o-fhW_UjCW
T80uf[*drpZ#1DbFFrdNtS<?W0`de8I4-)n*F1fhW8["&tsW(-D3%H4*&q3bHB,_.pWP<0[#
>&WobPFN&sCJ@bQlNikr&0:!seiVhN&2",i:b,_,eQ0SNDJ/rIM>^ulTml=87(6G4Ds(`+GR
jP.S]ArRSh_/XOCT(!s3c68L`KmMEEBa#844g*24C=ZrW8hYTqb8diC!n(7"\.O*ns'$QPDT>
`Y828f^ZLY<!/;Ck$dW\Z<+L*rXpZ1Rl<@%RGLmISem=o6nRCc8PetLle%]AXmJ%eI3Wf%q%.
R,)uR#+rdf&3WfO]A&t",K+]AML<Xr:`l^8SN80NRQ6`!UONR/:btZcPnF*@E;$JV?ko/,52HP
oi@XjrWpqU*,C.ri[>Ka+q*-]Al+l8Or(7qn>7i4&!j_n>ht*qlR;H"*iP1Rl`,TN$JI@$*je
Uj.U*1TZS2_57&aW(4uM$ueW98A0UtoiAmaH/MZY3aH^V;L'<7CN?'B%Vt^n>)\a^nYiBm))
bm*T\l^FkpVQ7]A,#29%E`h#YsFulE90V,c[VlAe1mUplG+?=_[SqUMHODn5<kco=qj1<I$"Y
l'Pn<'MG'`3euodh`fcnu&A$-C9G;R=gV[(nkj:m<p5AS!9Brd3RS31O[B?sAFqGj08RIoH%
lpZUG,\`7+0a=@9I+)i[fZLSNa!;[L]A"`!d-GT4iBTd(QXBpM"%L1FiaWV>Kkt(k*M`!nD9@
#./i//?=FfBg2`\p>U="nOZ/2S9G,h<tD7HJ+l:AHjqkF'-651mAD?S$#)"Oa"Y$uOeJ*UtM
KDr7:E)kS"'>p@Q1tjAaa4lDQBX%hh:U&Id_/JuUUM/8X*(3ue3Iam?Zp%CG3RSlt25>r#8V
t-GSS#OMphd_<dEgZ:&&n@8;rmsYXRgLdqE&q/kh+^2gRT!/YYE;aNF$p+o^&`/a#H=7o@to
oIeAI7gr6M0o1%Q:h0MftXrZBXKQ>-^I<R7^^9Vc<<r)Wml33fUq\mh7ih//l+M!TAiZ3RSc
#UEJ<Xm'eV0uI6RmMK9$J)\gF4GJWmA7R9r3rLDC_7*M#f#EI-<1?]AJYq2QCO_b.qbfV$T.3
+m,==Qfl`h$jh(7-OM;ar=1f;&K>=X*J_,b&j%!NeU$Y-,.LLffWL_tj=[.^F>R70F8kZuPg
X7B'Do(`rGf6h1O`(drP+RbEX\(G4Mp.j\EH#jeakBYUZO=&rN84'V(EiRtHbh>LBm6=0.O.
%7-^loEI/adeWbf>=+MoPT%M6PRt%O#%*['C(@M+fkcE.'sDC-YFr$A0\T2jG.Z&:$dPih"o
++.$fiF9t$E7GK:i#5Qt*""O=LpcN'?=$8O;-u2Z8,=5XbU#fr;n>niTk$0C/DlO,nnR6S3r
5BhZrn1r/glbIAbA3NK-`VE2&JqKd0m8T)#J</s"3]A`D_C)e+M>(eLo']A'0q:0USl!$Lp9(s
<5nsCY6oZWF%HaM:%*f^JBQ3jdRG3>^`CPj0N^&Fk>=WGtoZA,mug["Hhl5#emN[bD&Y$L5[
6euH4=-qnO>3k()FKriBU\F+IeH<ZT;2c_A*ko(sr,hn[0LHQuW[>KS3rV&sqP8=oK*FOF1?
EYNbYq^71CflrX?`%\ablVqW/*@B(MW&rDm`H8f^P<4=eMr35,H@^a?'u6945?f=O=MZDr.<
E?(:bo#^#*fN+*jTHQ]AFl0Z"FPgTZ#qS/-)f5fCV^+@Z"W!3Yuf\'32,)>@a=p6<*69B-"(e
sBg`Ru@1s+0Do,)8f8i[$@GO>QUtUM=TL4anN1_::CNC#qs2#2rJ=Sf9T3''$M\CVNj6V:#/
:T5G(N'^)oK6]A-JDGE$QQ,j1cp=psnn4L0Zm^FnP+ZY?Kf#LU+IPPcD<tke<dag=tO]AZ$-e)
WF^>*hM[L`<9:kV6a`W^gO,dF,#a#P4CLBCe(-m-.)-'/?5dQ`41LACqf_uF>N7WRH0'<TX^
n4&01pmRlM$;"qupFfO^1?e1mHa5^P/5C'R:D&%T0khUclmbOtT-ts4'=Pi-ZB3pAN9JKBJR
>=^Oj?7FS;]A+)dKNamf<EV7P3iY*i8g2j2KkLE%bU+ep'ih9-kta\e@]A909+QU&C&Qm3K1/n
!OR2*,oVa5e]Ac;Sj/ou/(gA%cB6OqXn$c;,+_TmGoTF1(n)Pd_;N!66AdBq3IJ\,*b)ANZQ&
IK80&AUPJC&65r#luQVD>>6=*L?#"QLIkIF"=2Fc3pd'9r_n%saj[F)@3<#ChQ*otXZmjK?R
JPZH*A)_mW_W^(lN$aAH2c$qd"&#;R&2,*<#`Ed_Na\r-,GoX?b)l"H\X[NbC-A'C5X>X_cg
@(7`/]A^=qNP_rlb#Bs6&+dPc%a.cNCBLL,MYFg0GT8hB>i*E&/#P`(u0q*/)qYkF?$3K&BdX
WSXL'Cb<6<..gnub7GrtN3%M;`"8#TcERUaBW.iGjRI5sid#'ItO96;bL_ia2_X4G9BksjpC
_jpJ?*;kk<#)`;O6CKE\FN)6dH=[7>A%;N)g8fE`r.OiW7Q8#69BE.]ASAHeQeZLs#KURCZV%
jT\^gQ)JNWDu?+HSq1Mbc<XZt$S/YCW[Vj?:#<E_qI0matJ?fK_ta:!n]A.uil,F;-fIb59eu
+-XRO6!.rc<4cml>1KL)ZJl5)em@jYf4:-&cVFchY7G!'T$Jn//1bA7%XBhKJpV_cR5Oaiil
V`?o,jDtpC)L7iRtn5[3plP[LR$KHpg@5\$rKq92ZfEp@B!6"ph,9S:WfTb/5J7`%oG"N!k9
ogMe]A9hAN<L=\-[9UpRs"LL,NjqhKg0jfj:f\8ZUpb`G#n/r#2fDZa^X:pOks>6K`W5]AiR.b
3)uObLV]A#(BDkZqSVai)[;TEZ>e!r%j=*(`iT(SKK+jE6_#5#H5m%^!AM5@9SVQDZ0Z1D7kq
o9'1*cm`I\<omec/]A1M<:#$bh^@h\Eb/LJ:L.WHK3i^OmQa-;*Gcq?!\+3g<?)`":;sZ/h@>
R5<n3DuD7_^g8"I]A]Aeg&E@R%0n,\B*7HoE;4.aMEQCiNRKM"Wi2k[k<F7D94E9U[)?H30GCW
GI-rlNE[:2/@:3khJ'2FXgY=d5gYWGOgnq1^!VR+gB"H")H75j!]A7e"2_*HnG35N4WBMoBB;
Y,3ReV[WjZGX47=tIW*h/[+8oaN_[JC7RR!<bn0dCg2HBVeC2=jKtb]AIPJlj5\Z/0$%1N,W9
D%s$R7S##mF3#eER5MNlk@4?.3%,0fa^8(\VO[`fFT;M`]AXQ'O=sru#5`k-Mp(G.599c/cF*
GiIe0NFYgLZgpF,#T>'A^K$C_bA\hS)X5DQoa0fm!KI(_c6Zbn@4LF,QoqY_1';e4pM##f!l
E2U9:q)mj8XS"<X`h2!E"fX$$Y,]A1[cKX*j1Ds>MRhL<Pj[6"Y9YTC&0,(QK)<C%iWmS5n"u
dH^;RDiWh.\*7d4rfR80qka+DsT^p2dSnV.iU@^j7.:\/")JY4dc?@4qTE5hm?r1ii:uOM]A(
R!c9^5X99suf2A)<C4RlI*$iR7pKoOLiVo`$5%Hk%\78Ric63qaQ-=GTR<K1P=,".g4B0gZ,
]Ac_#Y%5Ef$N?4[I#QCYn;S99&kD;;SgJK!/%p3U#0hp;\Di^.Gn\+\&Q!TKH9^W'ipEb+g,K
QjD*q2ecj>b$2L<.n;8>bI!Qk7e<+>U9Jp^\/<Jon%#P-Xj7ONZbp.!AdprtVd!A5mlT02\Q
pd$68?YcrS6^=.T;R!&23X0b8Aa976)**KPH)neTMAkLhfLAPYcjCiT@Wk^\_EY!R1@\?RSd
4<).$3fd>M<4P/j!s2P-\2<0<HlhDKm@9/3dJ?;s%?]Ab_ffQNV5^C2FdWa@p2HfCQ1#?\qNm
(pt??;c?a?<8Il$4"!r#-@)agP2""R!=@9cs9gSqj2%gncBfI5AFB9!tDs'f`[#`!'0t8*?`
ubr@B"")Og9+<8ph^\L%GX"8R-h?6k+TPkRB]A)7'IgYtYD[@.^;"H2:dVnL@sCqJkk+pSm[!
oA?\BSK:K1=S!XK??_j`9D@uVUNQLJA%l^a$deUU-?-J$POpRHFkc+At#[I>JnA?2'.CCmg9
V'1QZLUJ]AmC#"o?K\dW3'2>UpgmkZ"$RicWO`[b2&YN4uZ'N+n.%n([37=m4f1F5S$\hE&j[
gP<+$%AK7u[?Q*7cJ(qO6a?iVLS5`[l6]AABDDDdW8t,6oQnE0,(71d2Zks1q%3C+.d6`_?>/
kiAkEXP2:T!oA-0-caJ/m#WYcN]AP77bjo2>V2%##(Ba68_Dr\dk-CiT7[NJoKVTskf+q5e9e
?SNlWH3(tcpp=<\HSsVY?2jtX(7PMEH*kmYC2OV'JX$mqJ=hBL9f3oW!$>+23@m@7pqHJ"k\
O<3Q^r>RldE>;+B$cj)[L0"=$E"'9,rJ8&\%/^f^I62WPW3:3?T^LUFDgV[r*V#M*<[@nEO<
W8K3`0h]AN;48j!-BM2nt[=^ZejuZ*m0e;MNE7^j%kKoo[`__:G"?6ZI]A\:i=TfN4R_q7@(H_
1WdE]AZpWB`-_rNAt+NR$O:'<7RQ^A%;&HD'Olo3(sSB%o>mro5$\;V-l5KA-%shF(.eP&j7L
qM0Orn[YuB2p+>&XXSOF>j\I3LNVcIqFelN"C"$M=%suo#Im^$g-&asNF]A-/bO-%%OaPO5S&
1`46S21%4oNO_W+\^J*lq<+N'R@'C&0^K\F!t-9TP9'"Qu$cQiVk@B8bMsP=jLmK'>e(LeD6
%'AG,70=gX)+6H.g(dgl/YrLNfr&kL>Dkq%;?7%qiGq`VjH-4.0d3(;c5,\$"7cK#?*6P@o6
m(riiJ\\:>;5T=[[Fpkp(r9i($f8!L^Y`5E]AbHPlT%FU+ium"A+f&$a7/Ej5m<@QC1,I72\G
$roe`6lERI.!BVWStP7ACZW%F(O<[mZ_/=H>)\[8'*6!+2<S.J87!I?JH-Hmt^_$#k"q;'Hs
/9*]All);H%"/0HaZo%I%%;ItS%L7VkT?IOC)ocC'IV'Rk7ImYn8N]A9pW;=($PCesuXS5'Lq^
'0.Z9WHQpf<sO!+eEEWGlX7+*_33A'uCd^;/gH%LO,$<3n*1pL6tI,POL:79ib+F=H^0SB+I
KM0R$g&*+/#[oujhI38/]AD=iZFm@,o%WfRC%6IDR@Mh!GLqp1<?6q;R?d)FXme\39Q(()/7\
V-&N2YX*4DTT+d>(umJ*cO-aFBFIWnA3U9c;@CRhi*AN?Lu/%[F>^2ecfbk7;Yr)^Dm"C5I<
3Nb]AK]A?Oc6.Ke5oM9b1\6&^UE8cP`\"`5a$%T56TH-%q]Ai7r#2\NhXkM\IFs:CY_j]A3^3;f<
C,n@/_bb-E0-goX<e=R5bQ>t/(S7BYYesmk1Mb0[.hFGfNQHR18o$@CR7YN"$BpFKt)_Kn-R
*#9V=_,E1UA#SH:7o$3S7Tu;9K-XNXnpP;'[uQ2$,@=b"eZ&\Dr[:4[N<ot:@A50eb@O>8j+
c!"h.(0cYi_'BfR-5PQ]AdM4ZDr.lAN_Z=(4)b>AFq]A3$>hbB:*iBq@PKCaYfl?e^S4PWCqId
QUUJJWP3lLNMsnk)A+$(BMe9I^u.\uGB<h,7/j^7<S';A6ZZVUOgk;Dr?iO,MG_JgcQ^@JhM
:HW4T4NM:$c-Qk>7(MZg'sL^%]Ar+B9[E*MER>:92N_TbJ_f'1Rmn%MBu\hkiA1]A+:M%Hq<I_
2;,c<TIgpetK3Kg1,`d2S^st1-Z1N8gH:eKlG@8'*:T_Z_nV2C#`UXbc9i?gN4.aZ?1"Vigj
ls0W`=K0\^)[:hhE'9cSKBr]A8>>!"#$'Ssk4$?1!7RFm4\[Gs1tu1i^GVlL1A#:?@!Ya"V]A_
kRN6,M"5V'M^JQ1/%k"of6*2)=:-<mLBPJW^E_Qn"U./;p+!qP^urM5OSXc=pU`1,F_**EPn
Sp!rIO2Gqi[hOqU=`Op:NmbIi\_bZiVHK3t<?Ep?j!NRu:()mJ><CQ-EohFcXA?U*Rjc+g'+
c.Fn'lKlaT.`\Tbr(+Xc`3"biN0kV;b*;mJoFZ*29>I2oUo=%OP2YnREV/e`o+?ODFT!?d\"
fn>W7#)FWW`VgD+,ggK>5L\r^kdmYmqD;D[;aL@%jR%8p7\Mm.2+#-?=o2uZcSi@56(TidP2
n"Fpa-XSa7e""KLUcV_&9CY6*E[eEcsI?gD8TT,ZGnH)NHa=#2@+Q(^WXl87(9'U#'fG^OrA
0$+3`<t!=h\GH`0qC1igp.kX<[S9:Kd(Dc,#+Sc)OcJD/">Xqm/CLgC!V0lrXp&j_ebophOR
e2>6>:Tn3DYhg;MqnnT]A;f(1njP"$R'K#m$`\^8WjETi9f^JNR2=Ae[h`Ss:BU(?I`e7#;UH
4')C5T!0;GFjq9*D9Bm'Vr7I)K*9h>)Bh&EARB1?aAe39r9MA)X+nl]ABEV'CW7fG@&;Lp-F+
i:ZCX$E9EC<KSn<A\CI(%-H_iCDWtP`S+"n4bq+3]AJEEggSJY5DKQEs6P"nf#m0'DS6_A`Jq
mG^*%e[)K3AF3=:l8HI4lF'0P%35XC1n4.B:P_>XDEa:rLn#&mt_EMM0>^^2(,>0`bg^elio
J5mT2XQNS6+QF$/+"BH/pEol_%UqSu'30jFj,QX&j+-GKSR?%]AOQlH``)qNM%rW)#t^4Fd>4
^RZHXX4\NP*'s2c>NNU?<,0FX??-=W4YD`Lp[`(R<W=/l%@K2b.JC!OJqR*XZf/neR@0i@0@
JWc8$c9%5Ct3k7Qd-h"c`m;ap.,X(XI0+&W;/CQ=O24`Y2ab^q_B!0*]AuA'S)dp^<c*2ns-=
DpMceH4@tP(iHp@t>O]AhcCAu1(_:pS<HS1=9fMpP0_S-*2)FKWLMgmOl:rSCkT7'e:meJ2^4
t0m5U[`KU64V0!Af%9WPb^(mUh;U,+=>[RJ+G&i-57BrGYOda8"bg,J,HD94`GsF8pfKi`;8
:A67P'Eh!_Xu@m^<9oW(QI7M%$M_iK0"L_)DH?YtZno=_mH*ele;?E;l3h?_^$Y.ULOM=D+`
BN'PERo_Sb?Xh+_(#&b[Zlsc64u%245PlLDKH6F5<ms[n6$tc\?q4$(Yj5jlJ"^0J_<5"Kk<
AZmqrP;Z*C?2E@e._[[IYKbJQEh\p%K>N:i]Af,G+VgJ"%`6PqhTQQ^QYmr?A33MZZ*1q-5#o
mNfN<A;/CZaNil?9lDjXPZA,%QljW@YgFFI*+0_^V"`o^_gf"8c[DXscnSg,eepl=RNRq-D0
]A$;HJP$L$MZ'L>H`U3QgF*PbcX1j)OuD#_g"Mtg5)9RKEG--.'WT]A9n<EN6r?"o?/T3fB56H
J\"Zc%Y4/cbIcJ,r9n&/a0>e]Aa/k[AI/Z6^[`Oj/LsQSkYg!7.>_+@WJO?<]Apob<tp^@`fY6
5[VAqiXrdF2RX<pNAu$/>I/[p;`R=npZc?9W*ZH!:?:fF%S<bL^82A&mul5!Q[$]AnZ&O&;e1
jXl2#O:K>6)S_)sZ4"<V%IJOXk9"=2rhGI*d44fT<(j[$bDIT?SfVB'Y$X$M$5=`*k<KVmT>
pG3.$tIqgh:[+(D$Kd<#"s$'B=cs4b%l2Jfqg'Sb!/5=MpDVtF\<gt>Mfhh@M_sS1Qf/p^!F
:nXZ-p[6WW5;kIlS:)F"G$u:.V/*iCluW'b5$Xr.RmasU_hgS$f-2^g:l:[j,Jj%V/<\_Uo%
;Hl[Xel%hHF3q"a_6qn:6XR;m^tX</20;?&B?H;unMWa63#7@sLq"52tZ.gIg7ePLY>n5"A&
/%*cI1uV'M(4j!YatXq\+70GAkd?4GAc!$l(1<kF!;;bP;9pK1.;;N5l/s>&6WMINPoY+]AZe
sS"9)!;OkkU`&#plMZ8$j-h6EB;$SBl>l2_-l+F^O'aHH*>Kb_5@SRA>J$)R,3J;@C"*HP9s
o9U)[#?Q88q:\!r=P%MGZXoO5AkW[e\b4$>@Y7YhS#eF<$lt[fSm$`5.FV1sMp-*X(5"fBcm
@._5aCOaI(tt`a9>j?2I=AsR@8P#:XEQ0QUPZGl3o;-m16)-A#<Z>A=5+*)1k%J#U7Ycc@Db
L.Irn-hoY9)?iUN*Qrng":!4>;7b*9Qob#p[;T',iATEF&S=.uPpPOoo>Am]A&^Heumu5mLr2
k^;)'R8`N(9hpKsM2Q1B;;eT@FS4(!_siH'/?3A9bLt:TI+t6><3(%[iZn3mITshTTo?Dfe3
#naq>OS/44>lD(Oa,?LY#9$$2\lJ]A0M?1]A0=++nN(gC@i"9-i8b=^<gF]A(UG;(;`B0pY8O<M
n\V_7G`mZ[:9&:[DF54m"+!EEGLJDVJ<2K`TLJ]A1/-q'TiWMWmaF!Is2?<m#Lb_i)%Y(]AW&6
tQ[oHM'fpb3WA)@D9R=%FOMYE\DPDHIOHhKI\PP"k=#R(Pd5LI=!IUe,/u89f&r'1tJ1mCko
b!Oa0:NE5V4*@gSA?0_nH+G:o02I02"lWE#8:'_CAZ7EC\6Mo*eh[\1N`CA@53X)6iYTYqP@
$']AhY`[YO3^Jm&Nk-Uoa7nc'+YaA>?@OtdS&U?s^gG3TH7@u;/(S(,M=/W?/8#r.b^IF<M<!
*,t$cD<D-#?]A@`PGMZ]AB6sLQoY3?BCu/H1DjV'CI<K-H,'(Q#/fF*qd=+!A"Arh;ia\I;]AGl
Ka78sU@)gKSI/,LI]A11[eq8o(I/hX`s?))k+7s1Ama(+sc"BM.7!'p+!.-%nk4?ii#%23G\9
q1XP-j\`#FNf=WDe;r')H_*3$bE2A^Q7\0Q8g7nTnLYnI+.qt<6Chj=@`@6g%&BD$''HW:Sk
YYIcOj/ror@(U)Hijs,2V,..o"lA4G2cnkGA!.p'BMcH[&>_38pt+3A3r$e.2h\[fQHc0%S`
9oS@":ScFQ*/@[-+ccBoE+1=Fif12,WJ>So^0+L!`.8k_S1$gXT#f&!6?s=/hDS\E:4+g?hK
NO='-8m#"da>:eStQ:2@8D-.K^c@//;e]A3I_2-$B$oW$<9crmEJ'phRMP/nqljP`cm:#F%lr
7bfSuC+9u;AI9JG,#glI>2CT__h*>s^g>/Ar5^@7g_81?`A"^i,7rc_]AP&OPV%(5l]A_C1o23
XZo.2$nN^8?leJIBGh;&c(1]A?VZ2q6QJZe8mf^9mjLr#J>r>.CIWrA;g[8ad)Nl(m00CcClj
8>i0PkHj&R4!p_%\0.b$>^DbPA%5(,<(YcEW/_3#LdKe&i]Ahl-Ep9t\mM\hbhsXlAFY?ub2>
5`\7@WiK?(K]AYZF&Yo-PTn,D/bJ%3:ro5GOf9K.mr*ep7q#pju:Rce)-\Y!HaHc==*G]AC73.
8V6Q[@n:VPGqFbmKT@U8G@>$`&"=e;tiW$d%SKnS*EWMMK&]Aa7#%dqpi,,N5b13>MU-t3jU6
#/`2.A:>Q!tj-IU@Qsr2?S"5MUm*6sDDq"ZWYoFJg+kHBYC0fVB,B<E#;R%OV6!^8/h;D)r7
Z>ohD!-n/_;bgjb\Xr1hQsb=,DDf7k9BdDr:iaH`M#2a2kn-$>P%hPE1"aErCk[hBN=8Imus
EI@98-7pW?u!9CkEU-m$'oTATaAMH#Wufdll[.L`F)+4-#ZO',m_Or;>QKpD-QE8>]A6:Tf<k
4&U/fiO@>o&h!:XHg"7[@ftAWe2QMN'aD)&1R[o8Zr9e6)8Zo#9GKlC[GPM;oI9/8'TOn.!i
=$ShZ_]ARM>R;n$<hD5amF?rU[4``%4JO<cA?l@.^2qg5RS&-9!EH"m7BRte^Q*DUWc9AT.Rr
?bB5WF<%T.ECc9'eI3r^g1]AjqNnr5X5dDcEH5=gSelbh7iM`->q;>6IWk\qX1?NE]A[T>K]A#F
TM'EIo-@Ha:=!7L]A6Mcbd=?P@U[%+dsj=e+3(b]Am2;QTUV:+8gW+tAdBZQ3X%&<LB?TlJGA[
Ph>jH1UdD5F2L'6O'_l#mgM*fG"O"glp1NPA<`Yq-8Ii#39kIWS"Pm1T#([?F%k;^F5%=o=s
WN1?T)JY,"CdZ"YL_El'oG44!3t]AlcR#).GqVo23]At-Z7$AO0_C1l-lST8Ur1^e51_]AM.+%B
&F/QG7DcrDl%qmP#5j*in:1&a0O<#QS>YYi2<$CY17$b_3=\/4T5dF)I5T'*&jY7?tG)A=^:
6Ikf4;)Qd$<N*.4*P42%TZ#V8b@)_omd2)J,^&3&Ycq\uJ.)A+SCXYr?e*<n;U\#G9`_>*Ea
Yib:P_.sBB"f89$do[HlbpE/)P]Afck/u`Cf^(fZ0hIS07K^e]AK^%KoE\;VBU*"gf"l7[@XcK
Ro?[o,9dg7^I7\]A:p&BM5'$1QM3fla3I#Q8kUJ[orP@,F'=dt`=[!TLZFVq_WM%)f=`L()/_
A(URRlh'q[#]AR&TJ!CU;7?G4L6u:c3B1W_S<`@(oC<@AQpAVmZHi#clpeUE\YAH.iM;tU^*K
d]Ahp@t+p5^nS0ngHPc#BRj-pWKIAJkmJG%IQEZ\_H,V[C,A9?*[8PY@P1s:O3d*YGd:b\bS;
,$#JX(Gd:Z+*ICaJncqt$(+Hf4fZRX_]A_B6n7t$$S9Q%#6K\ueNVTXl)_maE$QWaTAC)^Dl:
9kA_4-XVme.75ZoC1&i:`K_E`I3r$@pOE?5om<r\8Ur[m(`$):,6Ze`P@2j!V4RcAs:sjY=J
+M-#V*HpO;0!k4>4fXuMG]A.YV[..C[aVSV+hO??Mj[,tTF5%b_n?h%;sn5`BUK(L8V;DgHj2
_(UY)i0LG`k+oZ*]A]A?"dn24S"#qJ/B:Q1*PMON#.n?D`?K:rTV5-(654m%lSjIe"Y<^rSKX<
2i's3\aBhqiHm:6E4=`'dP&(m"0i12=,uSGp5ZAS8d6c=ED:'p,gn/=:\*3'^:e\i2DAU^SG
k58t*TrA+GPQ:d-.]AYHDOQ^LVUc(4KJ3$Cj#=.'J[C&:8t7/"ucWciln]A$E&((3J'+Q*!LNe
`#g=GCR"lr*t%t9m1@`%Kq-@pFDu8s%FLEQ83)rGe!l>IQh5[EH86Wa/leX:sGLFc&<<l16?
@D/*gq"V=.REi[/?R^dR>O[U$YOgqO?RM1tLF17U4uq@b8>g@MN,^/q^t?Uf`8%WM5#=itE=
M+>h^EcLn;s8,g.XL*o;rpTBq,`[Tn[1@X`fTTr=4Sk'#hfG$3Nt2.BA#Fg;$i\I4<>Fn[r$
Tq""fq"mleVR^N0JXNVRCqfAlmRQ1&0W.OPNjd+\.FhQ_j(";Dc)dkNDl[:M5^+-Y$q?FHp?
FIBg_S>'6+hW+!,/kkp1X+,nL^3JPSSE)D]A+ecQR@o4D]A,iuUkgq0sKrfI]A@kDR:[uEB#8%5
hcN=6d:JbcRK3r?TltIbWp%Q>GQ+*Jp?@_a6hYIUjI7SD#j^=0h:OL)Aa$92*,4qbnuZXCpB
dA*4.n]A%oA"6#Nh:0i6sCmg3lt\)r#k(hG17`DWqs(f[Je-AI%u7dVWo>[>>?B(HK/nMUa`A
04!)$TaRd*l_/J'loJ05X6kS\#>]A3a"u>9dFP"65KO\9)De"jH"XjnU'ufJ:[&a3ZNJC45,?
VXWFB<pcp9BNgJ$@2?OOeJr25!^R%;AXiMkprlLkg@@%r(*LRXm/3.G)29%;%MDdQ-uMoTmh
,ZL4Gk^?hPng;-.9qs:fOf19d.&)$#T`.WJ"$`GudAl9o0?su]AiKVE8dLUDKZ<HABk[QYE8N
c#4Cp"/V=:_kpcc@lr,Cq&kM!RSrB"="udp%\J7$$\+3'7MhBgF8b+]AQGkirtg-PDJIA$^r@
%O'[^+ZhN"9Y[[CE/D\&J>7u/t-*E:\eF2>qhm?X%dZi8;O@IgU.m-;cP.9feV@V0cZf3?!T
gQ`bJ(>76@SNBV*;;<MiNi)m3LBX5uQJHoH'[SrP8\Q:VT.kT+`,W-VZ]A'<;-G5\R8O[H)'5
CWnFk;N&I",k=VKeY[rLD\mfmCU5IJ!7s`^0cC0%u5bR>`hgAhn.S-kO>,$iGhGe,A'2H"MO
efu3BsF04-YB;p_V(O%5hZX*9(SHNp8NM3<*YudKirf_;PXS@uL,H68XTtU!NkD/"_VOQ!0K
C4`8pr"70gpT!`NZoqOURP1YrD;i0IOS'uX*)<pH(pu&St#`PIVqCbqG,D(?n7eEGD8C'm1h
Se28\p%hl$Cpp9XJ"SWlC;1af6XnWYJGpi$dkIEW&$lNFq%26X/SEBN@^q%pg55SK:5Cn6.R
Ns5^WN\K&d2fZk7$0e?Y)8n?_3N.!$mH!5H.&3YbG37P6ba6%<!e2lh<Ug1+T.uGO*SVpmWe
DJdQb6<<F9p.f'tcW@MB/5Ql_s,8NSmcD_naB5p=AJ/>WA$\edDaM$Zk23QZ3S$\D`amr!8L
sMsbtGJ0(54auO.XAulP%<8n.tJ:``F:/&^B$A^nmajH&oA@##/daQJL7fC#G*9UbF<;KiuY
IZ)-b2AeIm?epJ.21)PBPDO&,Zt5]AaWCa%0d_B2B&Vh&?!H`SFO(c%1\;>r2<tEK^&g/K9LA
^L=t=nVJtg<V\o\9;A/r8d)"PF7-<<ktO4FFkA*U3Cg$^<Q`kN+^6>0',q>+W]A\jhq[A2kr4
i_$`:*mUY!TMVVPB:HfEYdKp$p"Le2gQ$lq*V%dST6UPHrU.a#,092MEoWNCdAhclD1a=pR/
?kZOhLa&H561e[Sj[bG--u&"Xh(^\gdY3Bf2.*g%dGtDVP\=fA/GQL`s-BG7A8bfh7o7)7]A_
Bl![O)"Dli-PLp_PeN&No\N^_)j\"0dW4V)_432tRW]Ano]AZX(*]ASTYQCC8TK=cQ-9;Y]A7,??
%0>,aL<2E(m]A-%be>3<1]AN`-eD:WS*V1nYIJ%h'^I\_((k(@a/KGO>hWQ++ITH5LrHE8&/r^
HuT&RRZhu"]AXmPX6`I/Oee,85R@N?lh%R2bT`k[KJcmB&244N\LRe?o,=50DhPa(EWn7HQM5
D+"<^<pGa<;grkjH`@r(.h,%%,":>QT<U<+9@W9_3$?7N\=aH&/htO525tB+1d.,0_)aHJ@L
D@S:59sg)_YuP4U/HkrS!eY=dA3C)iLJnWI:^:X`id(`YboD.0odg)Rj?GAc&-brJTCjAO@,
K\Q!;UP194'5EU!;T(s]AN@>IDFfm5f\a$)AFjde7*n,_4"fZ&2`<@.S7F*8N+Qu6j'Gn3\p;
Ta4hGfcIQJa4Y/5`'mNJb?\Xm$_OG8<eq#\`p3)q87;%LbX!)e$Jhc$)cC4nkbUO1M=YsaD#
tgJ&_;#j?$+`+q.-3-7sKF/K)g-hqnM(qppW?3ml[4Qn'D1fGk'//@ApN]Ah(KG$5=GHg-^+g
k*ri%9X:BJ86+1aN&'a$Vcsq)YHs2`USI7ds.hjTk^k;Y6[gP<mJ5ms#)EZoF+R95k-^;uGG
7cGql8$hlq47,STRIAhd@*9I$Nmk/Y*]A[WtpNAiS9P9Ku:3b1Q_fSVmFfVk;:D\F>]A,h+5/!
l3]A8Wm9_M^*abWUeea#_:.4XSmAQh$kc1j.Z;K@TGi2A=@iBp&m:9r3$[ZR%'XB"nG5L,J^=
_XNO64=N:r=&YC-"M0SKtk]Ai1i4?W'-Q9`MIeAQ_V;`[/Do"\qbjn%;a!.,ZF%GTpm;s%Ein
U,/gYMS/(3hSIo:10q7@aag_GQj`9=f`^0Z'V<7Z]A6EG8DmJNA>X<He40lP!]A"7JI[+9#'ql
X2X[)rZsb-noHkS"3ib;Bj<d(MY:C-j[$[#X=po7S"sAT&eG3_1A!Dsg++8WpS)#'3[/>#f4
^=X%'$j<[*6j)I"tp&BpZ*1!H4Mbi,1bfXP3]ATBDj,(J[=+b(ac'_U6*p;6DGZnbY;WT++UA
[_'_C;EsU<oI&['o1_Je0V-rfHG%>2@J7B2WiWk)tDeaAOS^?pFH5H6/@M.)*ThO/QL(g2Dl
aL9bk.3Bbi4;%*]A0D@24L'3ggHaL$UhaR?6MFj&8K4Rd[h3seQ7+Sl^<+<p#EphW^r8SdQb2
K^UTW.X1M->n+U5.`_u,5Id,_Z9%p8%AV(VZ>99,nkrm:JNs!h!iI+S,)@@G*'gD!^%T1`T;
j]A#Yq1nTL;_5>Od5@!X9QYYEKrTlTE+0%/.L@*N3[cnZ_rU!T$?S8$<]A!+:MEluubi:[(k9:
[@C2`=K7dB*GO/3gT:92Y_1*#r4mSb-Lj$MU\c+h/t+!@utR3s\9KptSW?LVKWcX)e7=>0DB
>cY=0:#oRIf;m7sSo!JuQ1?H^E6bE9tqA9b0@\?Z;hDX]A<Lrr;L:E@A9q7`rYGMV0'oaYurj
0uT+mip-@G.VTjbPWSls0G09:$D)"_Na6mdHkH%moAdFrTBN<-l[W5BC$-+LHg*5jd]ArLk^"
.)Y!@-?_81!T."g%$+I$!1Y(;!\"[0Kq!0C$#.p1`,*S#VBkH%[=AkS,+>0<X;r5Se:)NdEk
hC.od9PFn$;O7!2?\$Q$W]A)=pRKJF9Hr:-1Es[(OOhS:3)?)@&d$<E?s3ElYjm(p=$a/NnV/
Peo%qU+$>[M2D=Nf*qcdSI%,T^:le6lJZY*[?2)oneEELtoA.5r^BgZ>1/m2j@_m!cWM]A`7[
V)':l4a\Ab6j_9!)[p3(;EpSJ*f?>07RnP&AB2:ss@FI?9nh7V'["W@,CeMh'j82(@Ghg&@h
u)>jfq32pB<RBKQZdP<r\jTN.o"9G?aF=dC]Al]A)0!9M?J=6G`m4S\rB4m\,*`W<.G%0p?fj4
#L^KRmehehjbPYt<Wai(!I`oh2r9C%%ZQP>9mF'j@q>(fE192NOtFIi4g4dl705#oE[h."oM
n)taPFZR'40M&YCai+)0^-$bgH0mh6I]A)+Cm_^oOcg=UpFQ,oU*k0:8]AfG6p5Q8Cen,M1uj4
j8Wqo2A'mF[r"pm]Ag<\n'!e*8bt,DJoP6@5fi7/Y@(Ue'le=F%]A6fKYK"MCVI=#o[NRDk>u#
nrV0p/s$$&1kFNbI&:GF9ZZLpeKO:sce9^57LPf_)SNQRFGQ$BJCJ-tdG64`BSd\BVL<e\hj
``;kOZ,G`i`)eh4$TarCYnutURC$-L\jjGUFUQ'3.8mm]Al;8cfD!j-l>2BhIPq'#`Dt`[3Pa
"@4q^`dZV!tA+MW,9P0UMIkWe!^S<_bR6FunM>q;'Rh.CU'HgVB/m5`GGhVR+43aXr$54/&"
Fc/e3[6pBIN?4Vco6GV62Uau!mnJ0/9oY-Zca\"1>hks$gTJ_SD>JU#UYW3R16'tQZ=0mGZA
jPWHQIH.^%Ojq-1O+<a0*jLgUZ)=Se%o\SX46e.e'%lcJS*@@^iHjH+uQ.r[72%]A.9Otk9<a
7o:-r5h<F:3HM6stX0s?tL)FYp:Mua;)^QJpj(eRBmk(lY"0WM&VL@5Imc`9/:hoCcDjbBPs
0&&Cp(h"i[GLBNQRl=/k=)^.^F6\Rn)m?3(-ksTmPZqlGj9BMo)A$[Vrhg1\gd=E5LXH%)f*
4.$Enq_dSYF<hp&@<@Wt+Z#GmJ6CfA&2/\G\eea($'YA:%eP3mQlZ>G6gl<\,*T96[*laGJ,
Z?>H=(HhZ,mcg<NpKHf]AFhCJJID+s5:L/m']Am85BpIfS0G>7s^mF8O"f=!=8er57M#bVg.P;
BtE;!qt(E);9?H&d3acM4h/!skFEGObma$c5Bt;0nHJV+9cIHB]AJpFMn.SZIUKJT"p]Am>P3D
Hr'9U+9>Ek5-;=P=#J@^:5d[sHkG[I?jJ_.<jJ_.<jJ_.<jJ_.<jJ_.<jJ_.<jJ_.<jJ_.<j
J_.<jJ_.DPJ#<k.g0=&r;(n9>`B%HjW!.b*_/t%<Fl;2%9'1/J@K#R@!/6-UQVC8UQWPgZ5Q
Kti9B87h$N(d]A)&t=F%U*I!!~
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
<I18N description="" key="country_id">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
<en_US>
<![CDATA[Country]]></en_US>
</I18N>
<I18N description="" key="entity_id">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity]]></en_US>
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
<I18N description="國家地區" key="country">
<zh_TW>
<![CDATA[國家地區]]></zh_TW>
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
<I18N description="" key="entity_name">
<zh_TW>
<![CDATA[報告成員]]></zh_TW>
<en_US>
<![CDATA[Entity Name]]></en_US>
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
<I18N description="" key="col_lowtax_income_non_rel">
<zh_TW>
<![CDATA[低稅地區有非關係人收入]]></zh_TW>
<en_US>
<![CDATA[There is 'Revenues-Unrelated Party' amount in low-tax jurisdictions.]]></en_US>
</I18N>
<I18N description="" key="col_lowtax_tangible_asset">
<zh_TW>
<![CDATA[低稅地區有有形資產]]></zh_TW>
<en_US>
<![CDATA[There is 'Tangible Assets' amount in low-tax jurisdictions.]]></en_US>
</I18N>
<I18N description="" key="col_lowtax_hold">
<zh_TW>
<![CDATA[低稅地區具有『控股』以外功能]]></zh_TW>
<en_US>
<![CDATA[There are functions other than 'Holding' in low-tax jurisdictions.]]></en_US>
</I18N>
<I18N description="" key="col_emp_manufacture">
<zh_TW>
<![CDATA[有『製造功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Manufacturing or Production' function but no number of employees.]]></en_US>
</I18N>
<I18N description="" key="col_emp_sales_mkt_distrbn">
<zh_TW>
<![CDATA[有『行銷、銷售或配銷功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Sales, Marketing or Distribution' function but no number of employees.]]></en_US>
</I18N>
<I18N description="" key="col_emp_provide_serv_to_nrp">
<zh_TW>
<![CDATA[有『對外提供服務功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Provision of Services to Unrelated Parties' function but no number of employees.]]></en_US>
</I18N>
<I18N description="" key="col_emp_admin_mgnt_sup">
<zh_TW>
<![CDATA[有『行政、管理或支援功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Administrative, Management or Support Services' function but no number of employees.]]></en_US>
</I18N>
<I18N description="" key="col_emp_res_and_dev">
<zh_TW>
<![CDATA[有『研發功能』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Research and Development' function but no number of employees.]]></en_US>
</I18N>
<I18N description="" key="col_emp_income_non_rel">
<zh_TW>
<![CDATA[有『收入-非關係人』但無員工人數]]></zh_TW>
<en_US>
<![CDATA[There is 'Revenues-Unrelated Party' amount but no number of employees.]]></en_US>
</I18N>
<I18N description="" key="col_unmatch">
<zh_TW>
<![CDATA[稅前損益和所得稅應計情形不匹配]]></zh_TW>
<en_US>
<![CDATA[Profit before tax and income tax accrued do not match.]]></en_US>
</I18N>
<I18N description="" key="col_low_etr">
<zh_TW>
<![CDATA[CbCR有效稅率低於法定稅率]]></zh_TW>
<en_US>
<![CDATA[CbCR effective tax rate is lower than the statutory tax rate.]]></en_US>
</I18N>
<I18N description="" key="col_de_minimis">
<zh_TW>
<![CDATA[可能不符合Pillar 2過渡性避風港小型微利測試之豁免條件]]></zh_TW>
<en_US>
<![CDATA[May not qualify for exemption of De Minimis Test in Pillar 2 Transitional CbCR Safe Harbour.]]></en_US>
</I18N>
<I18N description="" key="col_simplified_etr">
<zh_TW>
<![CDATA[可能不符合Pillar 2過渡性避風港簡易版有效稅率測試之豁免條件]]></zh_TW>
<en_US>
<![CDATA[May not qualify for exemption of Simplified ETR Test in Pillar 2 Transitional CbCR Safe Harbour.]]></en_US>
</I18N>
<I18N description="" key="col_routine_profits">
<zh_TW>
<![CDATA[可能不符合Pillar 2過渡性避風港例行利潤測試之豁免條件]]></zh_TW>
<en_US>
<![CDATA[May not qualify for exemption of Routine Profits Test in Pillar 2 Transitional CbCR Safe Harbour.]]></en_US>
</I18N>
<I18N description="" key="cbcr_alert">
<zh_TW>
<![CDATA[國別報告風險預警]]></zh_TW>
<en_US>
<![CDATA[CbCR Alert]]></en_US>
</I18N>
<I18N description="" key="alert_indicator_name">
<zh_TW>
<![CDATA[預警指標名稱]]></zh_TW>
<en_US>
<![CDATA[Alert Indicator Name]]></en_US>
</I18N>
<I18N description="" key="ranking">
<zh_TW>
<![CDATA[排名]]></zh_TW>
<en_US>
<![CDATA[Ranking]]></en_US>
</I18N>
<I18N description="" key="occurr">
<zh_TW>
<![CDATA[發生次數]]></zh_TW>
<en_US>
<![CDATA[Occurrences]]></en_US>
</I18N>
<I18N description="" key="occurr_ttl">
<zh_TW>
<![CDATA[預警指標發生總次數]]></zh_TW>
<en_US>
<![CDATA[Total occurrences of Alert Indicator]]></en_US>
</I18N>
<I18N description="" key="alert_indicator">
<zh_TW>
<![CDATA[預警指標]]></zh_TW>
<en_US>
<![CDATA[Alert Indicator]]></en_US>
</I18N>
<I18N description="註解" key="annotation">
<zh_TW>
<![CDATA[註：預警圖示紅勾為本期有風險，灰叉為本期無風險。]]></zh_TW>
<en_US>
<![CDATA[Note: A red checkmark in the table indicates the risk happens in this period, while a grey cross indicates there is no risk in this period.]]></en_US>
</I18N>
</FileAttrErrorMarker-I18NMap>
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
<ForkIdAttrMark class="com.fr.base.iofile.attr.ForkIdAttrMark">
<ForkIdAttrMark forkId="a4998779-4261-41e6-966d-b12f05091390"/>
</ForkIdAttrMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.32.0.20241202">
<TemplateCloudInfoAttrMark createTime="1711940947019"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="a4998779-4261-41e6-966d-b12f05091390"/>
</TemplateIdAttMark>
</Form>
