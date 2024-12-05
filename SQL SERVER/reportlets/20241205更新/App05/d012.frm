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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT
	DISTINCT
--	PERIOD,
	t1.ENTITY_CODE,
	t2.COMPANY_NAME
FROM V_TRS_FACT_CFC_ENTITY_VERSION t1
JOIN V_TRS_DIM_COMPANY t2 ON t1.ENTITY_CODE = t2.COMPANY_CODE AND t2.COUNTRY_ID = 'TW' AND t2.LANGUAGE = '${fr_locale}']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_CFC" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT
	DISTINCT
	T1.INV_ENTITY_CODE,
	t2.ENTITY_NAME
FROM V_TRS_FACT_CFC_EXEMPTION t1
LEFT JOIN TRS_DIM_ENTITY_I18N t2 ON t1.INV_ENTITY_CODE = t2.ENTITY_ID AND LANGUAGE = '${fr_locale}']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_SCENARIO" class="com.fr.data.impl.DBTableData">
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
	SCENARIO
FROM TRS_FACT_CFC_ENTITY_VERSION]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_COMPANY_CODE" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT
	COMPANY_CODE,
	COMPANY_NAME
FROM V_TRS_DIM_COMPANY_CUR t1
LEFT JOIN TRS_DIM_COMPANY_I18N t2 ON t1.CURRENT_CODE = t2.COMPANY_ID
WHERE t2.LANGUAGE = '${fr_locale}' AND t1.SHOW = 'true'
UNION ALL 
SELECT
	ENTITY_CODE,
	ENTITY_NAME
FROM TRS_DIM_EQUITY_INV_LIST
ORDER BY COMPANY_CODE]]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="REP_INV_INCOME" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_VERSION"/>
<O>
<![CDATA[Per Audit]]></O>
</Parameter>
<Parameter>
<Attributes name="P_REC_YEAR"/>
<O>
<![CDATA[2024]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CFC"/>
<O>
<![CDATA[P00013_BVI]]></O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[P00001_TW]]></O>
</Parameter>
<Parameter>
<Attributes name="P_END_DATE"/>
<O>
<![CDATA[2024]]></O>
</Parameter>
<Parameter>
<Attributes name="P_START_DATE"/>
<O>
<![CDATA[2023]]></O>
</Parameter>
<Parameter>
<Attributes name="P_DUE_YEAR"/>
<O>
<![CDATA[5]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[TRSDB]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH CTE_DEDUCTABLE_TAX AS (
	SELECT
	PERIOD,
	CFC_ENTITY_CODE,
	SCENARIO,
	YEAR(DECLARATION_DATE) AS DECLARATION_YEAR,
	SUM(TAX_CREDIT_TOTAL) AS TOTAL_DEDUCTABLE_TAX
FROM V_TRS_FACT_CFC_INV_DIVIDEND
WHERE
	COUNTRY_ID = 'CN'
	AND SCENARIO = '${P_VERSION}'
	${IF(LEN(P_CFC) = 0, "", "AND CFC_ENTITY_CODE IN ('" + P_CFC + "')")}
GROUP BY PERIOD,CFC_ENTITY_CODE,SCENARIO,YEAR(DECLARATION_DATE)
),CTE_LATEST_PERIOD AS (
SELECT
	PERIOD,
	SCENARIO,
	ENTITY_CODE
FROM(
SELECT 
	ROW_NUMBER() OVER(PARTITION BY YEAR(PERIOD),SCENARIO,ENTITY_CODE ORDER BY PERIOD DESC) AS RW,
	PERIOD,
	SCENARIO,
	ENTITY_CODE
FROM V_TRS_FACT_CFC_ENTITY_VERSION
) t
WHERE RW = 1
), CTE AS (
SELECT
	t1.REC_YEAR,
	t1.ENTITY_CODE,
	t1.CFC_ENTITY_CODE,
--	t1.SCENARIO,
	t1.FISCAL_YEAR,
	t1.E3 + t1.E4 AS ACT_REA_DIV,
	t1.E7 + t1.E8 AS ACT_TAX_DIV,
	t1.E1,
	t1.E2,
	t1.E3,
	t1.E4,
	t1.E5,
	t1.E6,
	t1.E7,
	t1.E8,
	t1.E9,
	t1.E10,
	t1.E11,
	t1.E12,
	t2.TOTAL_DEDUCTABLE_TAX * t3.RATIO_HOLD AS CN_TAX_PAID,
	SUM(t1.E10) OVER(PARTITION BY t1.REC_YEAR, t1.ENTITY_CODE, t1.CFC_ENTITY_CODE,t1.SCENARIO, t1.FISCAL_YEAR ORDER BY t1.FISCAL_YEAR) AS CN_TAX_OFFSET,
	(t2.TOTAL_DEDUCTABLE_TAX * t3.RATIO_HOLD) - SUM(t1.E10) OVER(PARTITION BY t1.REC_YEAR, t1.ENTITY_CODE, t1.CFC_ENTITY_CODE,t1.SCENARIO, t1.FISCAL_YEAR ORDER BY t1.FISCAL_YEAR) AS CN_TAX_NOT_OFFSET,
	t1.FISCAL_YEAR + 5 AS EXP_YEAR
FROM V_TRS_FACT_CFC_INV_INCOME t1
LEFT JOIN CTE_DEDUCTABLE_TAX t2 ON t1.PERIOD = t2.PERIOD AND t1.CFC_ENTITY_CODE = t2.CFC_ENTITY_CODE AND t1.SCENARIO = t2.SCENARIO AND t1.FISCAL_YEAR = t2.DECLARATION_YEAR
LEFT JOIN TRS_FACT_GROUP_INV_REL t3 ON t1.ENTITY_CODE = t3.ENTITY_CODE AND t1.CFC_ENTITY_CODE = t3.INV_ENTITY_CODE AND CAST(CONCAT(t1.FISCAL_YEAR, '-12-31') AS DATE) BETWEEN t3.START_DATE AND END_DATE
WHERE --1 = 1
	YEAR(t1.PERIOD) = '${P_REC_YEAR}'
	${IF(LEN(P_COMPANY) = 0, "", "AND t1.ENTITY_CODE IN ('" + P_COMPANY + "')")}
	${IF(LEN(P_CFC) = 0, "", "AND t1.CFC_ENTITY_CODE IN ('" + P_CFC + "')")}
	AND t1.SCENARIO = '${P_VERSION}'
	AND (t1.FISCAL_YEAR BETWEEN '${P_START_DATE}' AND '${P_END_DATE}')
	AND t1.REC_YEAR + '${P_DUE_YEAR}' >= t1.FISCAL_YEAR + 5
)
SELECT 
	t1.REC_YEAR,
	t1.ENTITY_CODE,
	t1.CFC_ENTITY_CODE,
	t1.FISCAL_YEAR,
	t1.ACT_REA_DIV,
	t1.ACT_TAX_DIV,
	t1.E1,
	t1.E2,
	t1.E3,
	t1.E4,
	t1.E5,
	t1.E6,
	ISNULL(t1.E7, 0) AS E7,
	t1.E8,
	t1.E9,
	t1.E10,
	t1.E11,
	t1.E12,
	ISNULL(t1.CN_TAX_PAID, 0) AS CN_TAX_PAID,
	ISNULL(t1.CN_TAX_OFFSET, 0) AS CN_TAX_OFFSET,
	ISNULL(t1.CN_TAX_NOT_OFFSET, 0) AS CN_TAX_NOT_OFFSET,
	t1.EXP_YEAR--,
--	SUM(t1.E1) OVER() AS REC_INV_TOTAL,
--	SUM(t1.E6) OVER() AS BALANCE,
--	SUM(t1.CN_TAX_PAID) OVER() AS CN_TAX_TOTAL,
--	SUM(t1.CN_TAX_OFFSET) OVER() AS ESP_CN_TAX_TOTAL
FROM CTE t1]]></Query>
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
<WidgetID widgetID="f52a02a5-f8ea-44e5-820d-dd22b9c6cc6f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_05"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="6" bottom="11" right="6"/>
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
<![CDATA[723900,1257300,1257300,1257300,1257300,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,5328000,5328000,4320000,4320000,5472000,4320000,4320000,5760000,3314700,4320000,4320000,4320000,4320000,1008000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="1008000"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="1008000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="1" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("COMPANY")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="2" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CFC_COMPANY")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="3" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("REC_YEAR")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="4" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("REC_INV")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="5" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("AMOUNT_ALLOCATED_PRE")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="6" r="1" cs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("FISCAL_YEAR_ACTUAL_DIVIDEND")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="8" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("AMOUNT_DIS")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="9" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("BALANCE")]]></Attributes>
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
<C c="10" r="1" cs="3" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CN_PAID")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
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
<C c="13" r="1" rs="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("EXP_YEAR")]]></Attributes>
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
<C c="14" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("ACT_REA_DIV")]]></Attributes>
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
<C c="7" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("ACT_TAX_DIV")]]></Attributes>
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
<C c="10" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CN_TAX_PAID")]]></Attributes>
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
<C c="11" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CN_TAX_OFFSET")]]></Attributes>
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
<C c="12" r="2" s="1">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CN_TAX_NOT_OFFSET")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<CellOptionalAttrHolder>
<DesensitizationAttr class="com.fr.report.cell.cellattr.CellDesensitizationAttr">
<Desensitizations desensitizeScope="0"/>
</DesensitizationAttr>
</CellOptionalAttrHolder>
<Expand/>
</C>
<C c="1" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="ENTITY_CODE"/>
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
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COMPANY_CODE" viName="COMPANY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_COMPANY_CODE]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0">
<cellSortAttr/>
</Expand>
</C>
<C c="2" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="CFC_ENTITY_CODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="COMPANY_CODE" viName="COMPANY_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_COMPANY_CODE]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</Present>
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="3" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="FISCAL_YEAR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="4" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="E1"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="5" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="E2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="6" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="ACT_REA_DIV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="7" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="ACT_TAX_DIV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="8" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="E5"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="9" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="E6"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="10" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="CN_TAX_PAID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="11" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="CN_TAX_OFFSET"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="12" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="CN_TAX_NOT_OFFSET"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="13" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="EXP_YEAR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Expand dir="0" leftParentDefault="false" left="B4">
<cellSortAttr>
<sortExpressions/>
<sortHeader sortArea="C4"/>
</cellSortAttr>
</Expand>
</C>
<C c="1" r="4" s="2">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("TOTAL")]]></Attributes>
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
<C c="2" r="4" s="4">
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
<C c="3" r="4" s="4">
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
<C c="4" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(E4)]]></Attributes>
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
<C c="5" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(F4)]]></Attributes>
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
<C c="6" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(G4)]]></Attributes>
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
<C c="7" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(H4)]]></Attributes>
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
<C c="8" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(I4)]]></Attributes>
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
<C c="9" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(J4)]]></Attributes>
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
<C c="10" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(K4)]]></Attributes>
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
<C c="11" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(L4)]]></Attributes>
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
<C c="12" r="4" s="3">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=SUM(M4)]]></Attributes>
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
<C c="13" r="4" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
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
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="Microsoft JhengHei UI" style="0" size="128"/>
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
<FRFont name="Microsoft JhengHei UI" style="0" size="112"/>
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
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="0" size="112"/>
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
<![CDATA[e@]AKtPLnMHgtc"J7A3`nPc78d:^05J.CP%g15LgD9I^*A)%8kT9R/*VPYjje""?$XJ.P8=;e
-.F+N=B^!^R)'V@Xk884&L.^9N#Lqg#sF3;2t04-'&jr9u&glWVn^?KX@NSmSh13dgG8_6:T
LlEKsCMq>`?C0rFbn%8P6s#@iOhgb<!fF.#'^YB5fXpDbF;tkmEY'tF`3U>\nhgD=Oo7HIEs
7nHbdq?UKb!$V:HMGrrf;lkQ-27@YmU2g-K9Q0Ydsa?A=nZ[Hp4#YXr$6@"le4#l3;i1+V(Q
EW23GsKa=@U-/ZgYQL-6r#/W\*m/$7(@jZGghY'PqMimnT7`"@7sbP:?ho<-0`Z4&=m+VbnS
R?/D[0@eKQk8*E"!Y5hu$95h#-2O5X15l+o0'6#JoB$rJ]AO1O1>9,l&AX<c(O2!2J\l_-P'C
oE):4(8dWa5lVNIc@@LODkLQr)Y,E$)i+2qp;Pl^U<?'q/EN`tbSqrUjuOY]A'.2-eQGWZ(ME
nEJHY+nAh\0qjs9dF%cm:(KEQ&UKA`9BZnGK1tV8t`k#DRCn)J'(A=2js,sYc#nmFm6(&QHE
@cY\15q;I<JgQZ/Q8[fc(X_"5VY(l.^_4fV$Cc+cjCh5'HWq/Io^,j,%*bYn"4N3l_J,/p&a
hVdpIgmIhL**;gtmsG.+Z`XqKD$gt[gR_oBsb\eQ/Zrpl\Ip1>Z4^je0tJLk1#s4;jWLUn6'
UZf!B>#VqA(pFUYN>f,4no^NO?tV[:2ofN<hP@tZ#XYc=_YNO<+-]A1e:Khr89'3^3@AHt&8N
qNnog(#54f_P^#bQO5jS^'^_pS:D\R^moSfO*l'P2a%meKmnCQ_P]A;&2[bX+>XegDn3N2*:B
<J=R35lb9Gr]A1>-Nf#+9+_3)cj'7t@/?=.8J5dL'>Nn9C>hb09(oQ3=qi_%P?-9LZ[.ZZ9lF
ljtf%qpX"FQ6kQrUVLr$uM'*!kXUhqQdfj048S@q6oaJ9WroQ_;:K:IlnD]A4<-;&ZA)sA?UM
!q,[:&_gi<RV>IX(?IDC[F\D=3QY%')Ik1cM<-+m5S;*is?92/2PY';GYQuRK?#AH9U#2Tu)
Ri`#cj&9GG$]A>mbh8apbi8oQ-@)J""F$so\O#_NQZ%H0=ApD80Kt#T8mlAfrNUtgFnC;BgV0
kVVFI]A^^1TN)?1S=We]AAd,`(!Iq^lK+3KH>@l06c/(dMIVpYXZrCXGMmGc[[$[.90\qSRujf
3P$ZhId5NuC&t%u#e9a5208s%0n^`R?-.Zs24<TGF&kl00K,;_0ml/h*G)9\k9_AY2;#RXsj
pHoD4<7a!'@e[)g^]Ae^7<_9f9_gdXc?u"W)rQa"8%k2W["I)W:MO2A/e\s/"M^'Mp&2I;;7o
qVgi_C)O*Z:$mYU4&g[&XV?N&9`Z2#__`3p1#SQSV4K\thfIR'U)$<Wf?T8=kk5_M5rLb@%,
.5]An'?@*)J%EK.>&\IfZmaK\L(!j.taOMj+;ZSK9h7H,j%tn<m72N@19_i2:_<k+Ge.ntJE6
IM"mbP`mn<Fpi0lZe-fUo)*XV^SA=X#!s*Q`%RBGLpMB`"`rUKkP/7ZYu#?i1d6@L7cqp4;n
i1GF..KrlY%eM*2kd`,W?,W7_pdX4]A/O.!;FLhZSDD&0*qYp(U@[3hp`9)QN0[PV]Ab0OUeBE
0FPdPr7pf3N]ACHZ%!aT]A='Nlb5qFj>4a"Zh?0N<^_&/QLn9h#2YH4S3L"_%T;@Rl)osiq<pZ
U:'#^.(HFh9YqZ=,Reh9UEYO5tVk5UZT_b\5<,Y"2G*8L:eZMrEuTP-D`9F,,=)#-4nDV]Abn
X/u2?AaG5<ge3!K)%04+iH?;gC`bZ4:03sG@cW9g'=gb2\0`?"E$@GYOdfmQBZic=#J%Q?SJ
#fVGU7]Ar,")L>MY[*ipcf*R2*6C@@[&f`r3m#m*I`!_HaZ/Cf41&Rm<VEGiibP/k*f!P"fJV
sDjDtn:nb()2NR"&rNUCoKA0JCYcK;:YR_[H]A^W*L>oKc^dYp-CC%!UoP,02+860U\6HBlTD
@8HaL^-:-G?^DQHo\EK]AnkV/rP&Z6;o<>pKaNZ/$&.P+MQf)A9koe`2c*3V>7NkDIdJD+LnE
lL926q'<"tE.2+2$_J#ss5D-;4/'-h5XNP]AIQ7eHDAO2K*6"t5>l"UhJ(ZmHrBs1-/=N,c]A`
BUtW+b0t%$N-Z"`>lC05p$Z.k:63U.*U-9D(2j$]Ap\$_s'HKO+X0Nl"=j-d#3;lfW'3Ee&`g
KBhYO,=*UKNQOg7se_M4gp339uOcrg*M@Hn#0ho9nNnfrMZe)uo]A/9/q.8l"&PTd1ET83mGt
&QR#9^/(Cr@WB2E=WmioX!ZSfh^J[S1,7"HOU1eF`6I:cWlq[M&'aV;C$:Sdd6D3mf74YkD9
@4)HQ0]A4"/LSLV,KAq7:?]AMXc2@>OMDnL\cpQ4GI2=UlL7Jura8]Afri>,<Z<HZqcbU%>a33?
F$Jo-$/PQ$e3ZZ&o"L921CN/0rU;>c8!j&eW"/RhjT+eO)1MJS\&ns4QJ/qPn_6U#1j2dPnE
"2^.e&Noo'-:ku$b#U#l4r`O*5E#MUh`@7b^0S?K?QIDX,j0juGt+]A\E-'8V[(-FfL*-E5_.
IAI)QGdB2n[Bh<f?mifK(87VWp@Si*>#W<O6m,6Ei"q10N>@fTAF*7r7=O\eTp7n`\a^RM!r
IqLY-Hb5,ud!XZP(fCY!Cs,7`en6WI9XN5cUI/EH[G"-LqpNq;(Js>@Yg(>9Mb%ssnZ_:]AHf
\<3F?Rlb2_P'G<+!1q+i.8>=b!6Eq<EBjoP[bVUSqaZ"jgbk=XbF68W;*O,^l'->fnmt_\fV
`k?;`uj;eNRIYk0]A2^*-GJ2e5aWg)++He'R[7qX5%oG=_mOKl37B-a/Tlqf^QBd!sQ"[]AU&&
;uK8+QJM5W7>*BP`BA5o0#p!T]A@'U:L@S=EUVFHkrH#*toQ?EUf3`r5H"H8%;;B%DBNT9G^k
oVbQ_[7LQ4Cn>LS266#%Zo?Bno(+6'Hf@%j=-]A2dT&uli,n95k]At(WOmm\a)Ps'bXbcn=sl"
Sn9%KZ?/]AEQ@diQ\VOYh_=cn--dd#YoEaRENs)m.;$tegd($\"F]AEQgY.!U3V/,_:/GJ6r0W
i!tu%CG_-S`S!9h4jS`M/NJcQT_JC@?M[9j\A]As-3mJBZ-><43KmU$$OWaqnr/BD]ABpq;CXq
J*"d`doR#!=A`#FhX)iKX:P&A5OIO$8_'CW2)j[fjDoN*#B3?p<q$jg]A[!L7j&k,MkcA%[1k
J"Vl9WI@ZnI7G=14j,'^-/.>'=ZYV+D^/%Z2iO@bCqWKq^(-R^s6)n@#aa?=qLV8Y#+^)G()
]A=8p"Fa$PF$RTF^"Tq[_LXGo\23<c$\>R*LlDQ#%qTiq_Pk=/[*A/C>;tI??!_S;rqPZUtV!
PK)QO#RW#oh*/O>]AoWXNLoRc^6mA`f-7A<9*(X,a[@>AFNI"/b=i;nB):C\s3OJWdVEtm/g+
mMosFfd`)do,cm#]A)S>S=N3cO7jphD[m#^4`#kq,/$Te`&Y">)AH!<4;>Dh44c^3YRo,1)jl
<eiDgXYSc;a[.AO$5F5V@T<1[*jq8%`Q?fXn8@T0lkq+A@DW!E3J,sgoiQCefT1Ju*Z<KJlX
kf8NCL_q0Ne[E(]AD>/XCT_%%$7]AnXQ0GL92m0=>0MHVG(%GH1+)gT1_S4i?bqg>s2E!u48Y2
c&Bbtrjec?:3/%[9@N7d9I!qsV\d"$t<8^J.Fn?b670]AlE1r2("o@$X%'"Ti\K64c\mls'&m
*KU\h%8t]A%g:\D9\4a]A+#Z<?B+W%%%Pb]A::sD_$#1L?Q._3E9j*k56q8)3N-Git;sd&9>#bU
(@<u_\g;5OrNeWXdbrW@dCn6\Dp'/P3pm*M4/YRqY;Z^@_5RX*(kP3$:N_Iqt7k9E['qc/Y=
#\_(=8t#/)2Ak6UVejZ44+1-JaCTuN'H;eIQe9-GROlq"@;A`n?*)Udt@V"0`3KNP`N<:hNf
_%kfZk5Kh'<ef,dAQP(i<EijsE6sLWG&^-:nm).=;eeS(#"1s?_*h[_N[8Z!-">/FjJdTNGY
fjJq"cs9Ze<ZN3D<b#=do[aH8d1JA3SUP;C'_<E47P*R,qk<X3U5]AHFD0+28X?s0^/=Mg/\q
P/&[u`73p3FX$n7D_UO%4l.@iS)D?!3R0&f!W[MkYo#XKc8%b:+'*K#co_auc)77nE3kr\Fo
J&<M(]A2n,9@I5!)J[J@f4JhE&;?`JbC9lF$df=2GmBbeDlb/pM0$dB+(c-UXZ,qb`1NF"7@d
Dk\XW%Dh;oVN<n9'Tr&Q,\K97ld,)Ns>ATQZp-:mI2C!4M:C8BGu=cQ<=b>.=`1<>^]A3u\e!
<tkosZJqi';i22B<5rD0fjBL.cZZel=STSt4t[F_p%>RjF%tpsff&'=9;3jAPEkkmPH5VHkZ
i0!#d)`-Ti3O?OE"IDodKteic8CtL0gB$RnLntpnJ)di=;jo"Z:#"V2!g?Rm<iH]AOJLnY<U*
<)@cmQXV-U1aBe6n%dMAr\)`p^4t<$5<`rj'+7@!%_OXG/4t/s`gLIXboX+O>I(:?AJaC)bP
S^UsQ93WP]APkLi[TZ)W7.I_um&Ub^cqhl"\7DSb=BjuU`W"f]ANohVi]Ae*E]Af=-7BP,;rUjh$
e^mU2fgT(f,4Pk9%Kim.Lp0sZ5m;d_-MJ<b]Ae>[[XfAjL50I0=lHE*M:g&-S^ZM!&(Op&7#;
?cJ!;DTI@B[s+NIITuV84OUV(\I/DWO(ea/7VWg9gCL2:bW1Yf?Y/fn_i]A;;F_^m[WrcLrgb
\nkGW:[C,3%uXF`q+]A7_$a9LtZgM2Po1jo_cV_Q!$bC=c.6OW,U63>]ATU&"n,h<Rqh2\XBDR
:g1iLA]Al\>7n@j@ojV=Yq`1Y8oo,XiQgKIhkiHSU:_kG7o>r&8VL"B6`OS\Lm'pDk>:Mh34I
5=P0[%Km,oL<^KBdIn6*!h32>`MC(B+a6"Nu2WN,^Lb5m$ktjhA/LD[;AYE2+t0)?G'uN)YW
RjqbZLS^C,\7r:R6t\R-QU0f=O[s0]A6Tf7Tmqh"M/-T3)^ZW6/U.E;Y*>Dmf+I+^76d&2cde
KCs\"E8*%u52s+XQZ(>ko3I:K^01G_+EIDL7qLbt@oH7(&alOmiRs6BNO8ACYh@O..]Aa%EhT
G3p;_C6jgrj6.$9MC&C1Ec\k-]A-65*l&5:Bg7W7ZR54hVV$VB8QVioJ"#rQaCO/hF?3[KgH/
)Rmp;!o@e.KJFFE=HXTQ9e;d@"4%e+I?FfT`"BaEkJ4;8do=B/94^P\He7!/?,jM24a4&XXp
+q3td6O-sVmp;B#tfErls2c6'b\in-YRfd.fULpdBauTm.M_HIb3LPHB4t2IL-E`\AqbESE9
6Rf$,"5S:EW.llkB=(s,[Q*JXap".Q!c^fQFQn'S4'#FbD`_C%!'qHR`mr<@,I;#qa-.0$3j
\)Yj,Y7#@u0tr^A9imal@4J[RhMj+)/3^oKb+At21qur#-8W2IXYV'2N_ga&ACgQ()kgQ7'$
$L=4[U0CH5j#eg7f*`m2c0d6fitG154BH(,kuCF#M&\1\QLk?cbg=eKSAd:$)h%"AGf%4\Ul
5miF$DZJdeG<`T&R]AUL5e)0mQulXH:l5=)lt7Wn3eXrq)n6QgtLHXboU#>DAWaT#\5aWNYFg
[9t$+?.pH6`UisYJgKJAX,c.<W*D"@5US^+XM>m(CbI<C=Xoo-sLPuQ/Z`VBB68_Gm6;pD>;
/oB6N%tS/-`t,kldjeMu(U*jD[?&:+8a:P>Kuce?>sbX]A5oqZ&F</6lo]A<4lI4cc/uaKiFXl
@l13ZPX#JNgKcOk$tVn(O<LIo2i3XOp<F$7)?9:/8>\On!DY]A(NSV`rK8k<O8ib*RI!&U71X
h^,P1!do;O\UrTa"3[Eul/[AocDjHa_o##+isAA?o`P7gEqAVOCsuYC2Z+f<QW:\?5=%)INO
;=m,IR?#E3/Tj:_,iTVM,K7hJ\."m*<oRGA_'bqa6.`:RIG!h#GKW?Fh0]A/loPfP*;7&.m7G
6[YXccgVAKl$D7RJGOCfe;Ql0GPJpl0VcYa>(P$Ne1iA,k:[TDHAHChA!BC*,jd%mP5mr>Xs
lHc.UZ1W6*cN5a)HT&%LW'@m!F#\c&rn03b5\DXU$%a^^ukih!q,5(^cY/-Sa6HAfO48-_*R
B50qrRoJ1Li'AS&aO_?jN"9B$rE97NG:pd^!n3.aULO)s9XP-b1$>(.,g80M`@,/s;sR%dLC
ffZJgDB"8LQrmHkC.B?XORLejnm7%<q:'Q[)$/a`+QL7f0A4&^YMn(*(I7@1Sf+%n3@_OLh?
%W%0oY-O0X?FPrV4ip+E5@E@Pk!O:1S>2RV%2[jaX_S.HN?BskcYHZniq^Cm9)=Z%tNQG79I
=6[B@oJk4gq3Me0()isEeF6V;hK`FT\h-nNfR_F%9;'K:S!-.96r1f=drrK'L1fMr=YoY'0S
]A";8%M;Wh<^*D5VL#<Sd,A_PmHM7XFO[;"8($Z?3WBXRo)4W96mTh@4b1D'!u2+kcHBV/@=P
CKN_V]A#nRk6H&*4X+-h#;D?jZTs?.GV2Jut(;FIN8uXnl)mHsjY#?A"&KWRSWW8nOd5P`J7(
_[J36sTLB=u?Vns5"#Tq2NRp4\g<b2JPCPLK5-^Wdkuc)'8OAIHPZZBg4H2NZ(+Ig(b-JcV*
8;sD)<YT$@Da&HgN!4-b4TaS\ZXbrAH_mb-eI/d`a]AXhHP='JQrPk%6had0m1%DSeMC/->]AU
O)NV>BIV/IK*T7=,KRrj*8cC1etRAm$%=dCj3!+NelF2ItX,*?*NDDG0E?BXm\/qhlf]AB.$5
mELCFF#nP/VWZFt*(S,<PYpCJV]A)a.oPX<VXG3d#7h?Ic^BQ`f;!=]Ag`9%LmU)"sOp%:6X&S
?AAel%Ncqhs3,@b.^.L?dnb(oU8gN%"_8^`HgP<pQ<[)_A-H#cnhgQni=de9EEZ66KT-l^!K
PQ/ZPIC9N,jDK@0^=V^@6[YLi&jNi)QsmFDYAUQ^6b=s/$YQ[R^->3_Pc"\O*oO`@%>BQOP[
P=hYe\Gk93*a!+T"XC@4Pqj'KJfBK7GF6`]AlNK'J)M^4jDJfcG4<3H_>>,>3I+;.nZiU`8hD
X[UXo.ck7^/%d"AAS8lcO-0,n[h=d*t)?/l<U$O@Uc8+"MLa>CY6[7%S3"C]AbM[0(2_?,h@+
f3=4-pk$L9Sh5(6s=Q*"cs_(Z&'qGZaG08nBNlm_4'HunV6R`Wc0V%#PHS]A?#H4`VRO6<D.?
EH4"TID]Ac&Y&Xh5nbIJ43Q""s2s+?,*]A9-r8MW=T-1)I7g;$EHmPm=P8_3oRGfCXuD=3_9Bo
u?HmMS_8o&d68Z2RmXoQG:#G:[[367]AoYl<fJ8D4q`'brY#bJ,LJ]A6@8;FbM&d&9]AB1)fl$<
s8RHr!L5uEl#$;sjpK8/+iDiQ>]A53`p@2WCYO=F4`HlXq6B-BZjp=7W]A0rZs7=[%,VM]A3PJG
^/m]A\"AHqrL^$UrYWLX<"qLK^tV%b,>Hmn3^JRH[:j(JT9o*Y,R*8!O$Ra?JNsC&9&Hk<C7L
Bpq[iAfI)[o&>[T]A/Qb_08HKl`He\WB_bq<e&U46T%]AXWVUH4-Pd$mG(.Ii!$.0gu8Oo/Utf
O5cVJ"Eo+86aYsK'lN1_&/C>6*r);N8V:NV9)"uQZ#Mo'J)c1]A'lM&a4$\\/Z@:jE60l'K.$
SpZ$Z:q)K%t^12hFcETc0H!26[`TUeN?qi;pmN!Vl*o7d96J-Z6]A^7.-KrEVG%la_;[I\"QP
rDtPKZ?k:X;KJ7Gah!<a6%ZB]A"kLOsjN$8(fh*@#ZCA_lDDspII[jF$QlJ*]A?)@Y790,EZ=&
03,JGr\g8hD+@P@(rUfHt&W[DAo0/4Oi0P7%/Q<]Ain3OcN025X)GoY+_Y#Z!=<>!$^N\\JX%
<8(!Z7fd%g4P]AVEA1U,g4;lQ0!EW^q/\]Ai7k2E$p$if5q\Dm)-?kC0:ad"qBo2oP;Zpd(Z@@
Gf@=/_6SiO0O1YX%8qcFB7Grg?]A9M6gqj&aU[a&p>,\3?_kE>O#[SsSg`PO/0f08NQi8,;ZM
@4'cj>S"b&Va]AP%40ACmG/iEGeCiSD*`<7A`b93"/`?dFb`dVs/I5A8*'g_h>ecKJVIi2[hG
_Br/'ShDaq*S'SYPF[4MM>@!AE\1"qnGrt8[J$JSh\Seeqn-fC>Y7U5c</6NPgRel@5!Gj'Q
b+t%d3XYr.T3/'I!NhHf]Ar74K]A"SFTcXnM6sN.4qKXdPGDM=UQKDZ!6sA:8s.\9<M$mcp>/^
!SX/h]A&ME1G9j$9o?OZ`TJX8?++ot,5V$>/XYa4)$@e\U"C]A(Bh\-`^G[_pdk]Ab@jf\,'8&;
V81DQr'C\hA.<CMgp?Q3?A`Y9DH1I@"ZV6:`(]A]A8)=ijgqF;P$flE;2j7[n+^"F8dkS6#l@g
>>qCf:F5;je/Vjk@klQ>]AX+LLu=RZ8Y]AU<dOoJP*4]A3BP(^;_srV?..c3*TF]Ag(5t[[GKW3Y
;nk'req_GEEemCmi"KrC$2]AY>"3IJh[g/;<beB5s;*0\T5W,cC.!%`2BfAqR1:(ftkWPkWWC
fC"O0+),E.s^rp6k7H0&1W(iH2T4f0Bo9"P1o\B_+"V=)0d<Yi9PRms-,TQ0]AhR-22;)!e6`
EpFb*<t;!V<W0jAfB"0lI"]AIAr!)59#!/Wt[R5*LQ(0tGiuIV<&eXYZqQbQ'arB]APj1Hur?2
F"MfdGH-iggoE"25<:')WC9hMJ]A@q!LBR#?6[\RED;ME$"+Qh!+ZI1b:S!m(L3Gmr;/`SW\Z
/Tg+hQ48QYAV.Lu0EuoChDJDt`'Q^]AV^YYkc.WX^jMW\Prpk0Ct0A[?:CX[3WrHWJW!!L/+l
]AR#!]A-kU"t%?Ml'UF1rm:3JIBk\7'-0GGH@+@hN[I?_D"L!ne!Xnh=S13>rLt_dO9/\XVtH$
(FkjB2T-O.@gs_XXLb/>eSB;amRt_8r70;+WC!h,sOD(2k9=8#o[feh#H?XgADMWrDWH_@3e
K[NSj4,c4hOEjs[6<_.@<#D#@`?n1D#E/I?B]As(a"jX(p0n'5YJ!SMB`l7iI<!o<+l:fKl$(
Q/V5qZfK8\`U4.m)S[2G4,fQ,I[M9hl)\j:aYA?L;"3Z*&#9X/DZ6ru2(%J"p1.M7:50s!Gg
RP>>urLulu=2Tcm*O7bs^KOMHGd:lqdTG\X$X<@cA'l/JnFG!.sngLlS1MiAaISX"kno'.@S
`Jm)a^X]Ae-&SO?]Anj1Mr:aeR>DR/i@O?n2J[M6PPnJ`.uaN?OJqT-9i95->1XlPRriPK=qGk
<'K(.U?`UlOp+A`Th[-PTnfJ()><_n)Gf2XLUP#4ZhNR1f+)6nat6_B4@m`735)FI7aEE_:Q
@uE^m;lT6tJ-A(AT;+Ja4'3b-mBW`FA>1T"tXGOeIdTmU,!_U&*V:0WqDFDBoGK8IWRhrC5`
@!bSNEmCb6fWKfWCcslO&pTGPiMe.pjt;)9n$Sc6o7#&Nh-WNC,g4Z9A+rkI`0FO]A]AT;UFY=
0WAd@,`U6=OB2k?;V.8EJAYXP4Rcen]Al@d765fSes/bWg@-I$d;P+^Eo7>cb3\B3,VX'?@7a
ncirg,+F"/N)Wq0.aed-`BX[<P7")D%$m+ampm/&frBB,c;*3lD[5>2J)f>Nao^?,;1=,WEC
nP1g6SSEM:ObMU,hHU47uDpd67jnN.>prlj0^`-qpmbP9AgI[]ALIS$_+O]AdFJVkP[-g5<Z5k
I'&74AoGEG"_fV+COb')mID%X*"-_N,R2cQdp&Npm3l)p2;MSQ(Ze`3<Sam6TMajRM(Ap>u;
BlBen)V]AK6$mraIK%UJN=u[eWNkC[9J*NO=JifND/!]Ar$p/H^1q5n(fPBJSNn!$]A+ejolM?d
s8<+Bkqt))VX0:T8RdP,qM32ma#UX_!:GO\pa>a9*dbc4cJ_G)oO>4J#u?[Nh0#4C"=m4Bk!
dV;gHFF[I'dL>hC&KcJ5gbEZ3(Bp+UH_mP0QU39X:Z;@Fi5iPSXkga)7f"Khe<QiRX)DGg'!
VE0YS<s4@AcK^'.ef2b;ng^#&&8$_l8;h?4se*L9>hDKV\8B'-70P0hN:WJI&RdF2VS5oa1T
<rjQ,i>-P&"hT!fY=4brsQEfcMsiU-GrI)Fk"UVS`tF,!>Q@8'.&bY'*<28Z_S5KOhf>>OgX
om(s_]AKe?=#%np!H[6V3"'dQN9I7W#P*EbJO1a00DM,BZU$O*Uq4$urM"=XP\jHE_^RT0`]Al
YL%>)UW_hY_%1/T7\:,tf)J-Ko=RCMJ;aYD).nnF*mtQMOX@qQ_6OO4N7C:BT@]Ao5GAto2GJ
dhq/0<FK3&gRFeM-9taP4.meM#>7tN?!0h'n`[KdEP`@UnHb]AlqA4hAaD`R""1E+D]A7+H,^@
!jDKd'^B9;+h4h"q`\fR5]Asq!Q-eDdW*rpYKkgl<f:dOIR]A(Ya"@-6lGSE#Pmpg,pRM_[f3*
^/O+(,fDoEu`\*,\+K0iJI_]AL6qnj\MgrLGX+h8_N1GUYDPqg#<uj(EB.@m:Wc'>[pEjaZY\
&TQUKVpk>P0@9Isl>9#FAo[=UjNg;akFZ&goEs=p0BKg<ZKqtrc=5mUVqko_'qo)=8:L`h8T
O]Ak4P[HjB!6$`Op-C2Ai0DJY!j@3NK$#.Yeicu.N_m*+!p;Aq:AcomN%POc<ged#$s*lOi@<
kCt*$l`bs2er#M2YH0:ENFAKCe<n#/fFM)CmB"T`OS6Z'"0NNXH4)b>$ieKJ0rRNleco]Ad,(
)U<G9`oRu&5[V5M9?FAoJ3&-.9P9^eTNL31>g`n["\HJ#>\XgXIb6?SHt3u40dC9P8m\5'Dl
EarK#$K"2Z66X)lh'-2m1bR?4L%SWo2]A#\KVqLNh)4DuJIV#N$"$eWbGE$-u\WU3/J06cWLN
)OnV3cA6Y<fB-G97C<kp8S;/*U&2Ouc,H0XD"CTo`/HNo(qpj+E_SX.D,(5q(PSuW*m4jgXZ
TaY)kG0#rRbZG?_IhCo3#d?8h$<J?E_R9Z\^F:#"bW!:c_<fMK_BY!1$Hq*93RcMq[GJZN7[
F,jc3HqC#`C</ijg?=Go.Z5u[r$X98kSL.hmbekMlG(t$L6FM'IMtRG5L']AF8YWVPrbMW,Me
WotYU5A"Z\=5CXLV+e5D&,KOH)G(D8,j*aBU?Pci9R:?)K2ak$Snpjg&3'1q#ji6a8d%pq[e
T_F@h?W[Ghr\JWQL7b\Zkfqk(FXc-Kac$#s8AH1cuN5E2+Os4/]A>@]A8&]AmbVXsdetRYh3s\k
bE6_;+\I)r9M8YH.`t0Ep$tiGs(Q?4,H1/%A9mG!:\8H2E)\j@I(3/&s&kop:S-b[AL3;%E7
bC<470Z>h3Q!t6/sGscnV___u?VEq(>P.is*9$i/S6KK3d$>X7Yp3^ZIJ$"..`FO.T#V-9j9
AXu`1mN)O5uHHRgJh7FJUC5tj\W-5oQ*r<JFB3&uC!;Yq6-:?7)CPI$SY!)[7Y^.CZFae&*d
+h"#lA^qY]AiSS-[<GgQ2+=>X^o+Z,)/9%^4't=JkRp_P@"FJ!5b3^ORk7eU&,GZBa)#PH"5H
![*O!SQH5iYT>TB.^*^M3<jocdL'4\gt_DRJR(3$SHJ`BcqgI4Zi^[ZVJ`b_WUE8q6=8c,bl
Z>4Cj`4W^F`Bm$qnj*i@lu%3aNblMdR&JW?;N(fP>dAjZiPp.)UZ=[iX88pE\$"4>r`G_S1"
G$n\KJY+pG?d_1"<EQ>dHF:eO>DqYQ<gja("g;K69B+#?#m8UNi`r`[[qRM!;S78*lJkVmlr
c`mFTG;pA]A#bONtsi[-2EG8H",";BZUR)`,$d'W!8&sW93:ua%iBE3D(7Di@BBLLq9LV+Nkk
b&Mtf&0h+0!h8+>L%Q,5e=@>.#Q_tfWSY!d/"4Id@I742_`0DfMk%#&6:DR#]A:!'^YM5I):'
,Zk;u9D5\?rlWjK-U3L%JMSudml(>j@F+mp<`7_rUu=A*p]AYq,GhrF(^p]ArEF8+XG#'&/#=G
Ts8#k"3<DTQgm^caFWb7`B8<-o]AW&-hZPjh1A(mqP+S7bXL%Q*l#PF[SP-:h^HQ;gQ)EW#\#
R[!`eCGu)!VZ"K<sYpNa%`VN?o#@G)fFK81M!D5==g''#J)ep1M^WV0ppd%/<49WX^CG"tBU
i&Vpn54?P\P!^PE,B+iL90>Bm/#u<bs*V&>A;.Sp*^;Y2dGVj3TmeXu5i5*2u+oP&2kXNi?D
]A6#5De[.AA'1fC8A3(sCTf!u'anq>RY9IKe1DE.Aoqn9Z"HC`>/&KlD)r9`hicr@XILWtePK
"$m;G8GKrG[;X,M&IV]AjVDOL%dDLFX$B*lbtU;01uhH2)NjJun_!^UV6i-[FtQo8Nc?l&61K
O]A3LTGr>SegZFJY2:hk-TF6b\f\@eN_%i:tkZUu[o=M&`F`(^4Q,AgNO:$JHYWT*$PB,*24M
Um%?10$M8Rg4KW^J07\n"Ea-C&_4Sg4/sXh/dmBa@q@7h"beEhBRbSPM"9M'ckQ`B5-KK^@r
C+tgB?/U\cNqldUO?o;M<2&.jZF/GsL)oVu`0)-5_^3lP5:IY9Mm1g_!#qi*r'Pi:*Q>o#dk
24FpmKT&tB[lsX=gWAmM[E28heKTnq=\F_*kTgm?.AmPat'<"6,_)u<0d.&.8t_%/\KWCF5X
e3A-b2fEb*/bhpkis9@7%::2Zbc_I1u?*/?--jSI;`SOMm(#IS3H"&J7I/K+@,WT"m`9qMi1
g`Cs`cEXCd$$k<P:\t&I./H)dm_=R]AA:[WOUb[B*ZFKEX:!t3=(VuU3EJsI^Zl3,P6Hm_s<$
%:e2XrtqBZ<?(?'rj@P:S22>k:_l8%^/\*"f"VAhL'.AT57m"8`ga[k26Kj@&bc]ANVIo="Q2
i^s;q6LML%CU^DD]AUN(b>'c^kMhp]A$6_S!`4TN3d;HQ/j6^mT>skWc6=]A(Fkm#p1Gbdc-cZE
\Na;Q3#oOD^?+0^,fH8j\]AUf'eOTH(bH+>*3P;.jV$/WVV@or(gSUf:Zc?lQ:sZ3f>?//FJ!
XnL>IoS%;7^mI9;kAlOqhg9(J3#?2JC>7K&J91'J"4NGMOJ&YJ4Z#ajL^64OuRak9U"p7i)Y
br>5?k4UCW&ki^Tq(*N("[;\#b++U^'%![Dp)r`96-a5=M[m.3VZCR@XW*:i,fm7nRbM7AN_
[[aVM+PB"0#,C5u?@%$_Pc9/0.KHRG_e2@T;6XGJZ2]As->WnT)9e?UNJ.H*8CDX0T]Ana+JXT
5R,M7%;W]AHt-\KLK#'1"!7NbLi5(@LtGkkW<\./lklh>>005iQ%3G4eBP-$G1TAEOD5-nCXF
##&YhfW0Q+N+irO!HqCS=\[S\caj9_=h:)htV(^QXFRg>-[l=5dD'QJG8VnejFqNJ?XmSURi
Pk-O1pJ'e<bJ#f/Ma5]As+='bUEkkg9\qpnEN']AHfj+4ri,qrH!$iqqqut/*j?J\FV^E/3#BT
l/:6J:EXf^-`4B;nBAu(7MV9J!BgVr(<a@m*-bJ#IM:m-)+kbXL[;22p2G-+C>&#PNBa3G#e
4/,-OYhL-QN<CL]AqVM[oB-%d6!EoUmG#LAl9:d^6M(/!Hi?R_+%'T`O"Nq.*(I,25069&Jq'
slF)M9!SY5%O>>[#N9K667XVKlqD43/O=-b_PC$Vo;Ho1*jep1a)?@=[;Ntd;K'1Z]A#/*)J4
mBp95/VQ_bJfBR[@Eun+(1SPX6hu)#,D$-TT8s.PPcb2_Fr:j`gibtCun:$IJn+Ak`'LMEBr
5^;%Y5>Sa0JO2<?D(m\ssq!Ag*mDEoOR>2^OnD(9Q`dVX=6gST1:i45eT\a^7iE6pg:H.L&>
`o;Z'q,uT^o>lEK@a1*qU@1P**sL("GdLl?,DT=uq(,@0Y%lZj^PLHQ+_O1t"`5O<QGddT+V
VW[ipYiLa0bGaTWoM$VelI,]AjQf;CR8eL@t"02.Un!`,R[GCI3%&&1b-!#0kBj^5.:s*3NdX
W%H64LIY9m,:V6aV;YMH!.IQ)@m[kRRrSAqU)AFu72%MH#0$7u0&0eF87dY;tGZuUdLMR?##
i+-[?9A.P/%!JQbuVU2?*NDN!s&a7/X-B0(,!0"M&&Sq&4O4L?"G7:LeAF4Psul[V<-7`D9O
[\$?qkgL`B5B1Bp`gPtap5ggggAq:nL$NY,dLF/(X>a,[_*^"egr?BXu2Sbr3"pL=gjCU*[<
h(oXAl5ZlE.Hn6Q'!]AlKlAJq\hGWd"\s+nP`$n*br#gao_+9SNEJC+?j4F@MW)s6cd:;qMFs
c(qH\)2JEut9/dUPCK1RN*3H<k!p6q$JRiuf_(pKQGA.Ni&=)NQke3Q5JC[nI[c)?-)F5Vq4
T,E1[e'2['7Nd$Ql8OA:2'*C>i_HHb>TEV^(Xl$/p$j=SG9mI%qIR-LZRa92*.d@P'^+`dgl
Ph\%"JBXpJj%ZuS/t5555o,>P9po_HpH9U%bENM3oj[+7r4_hGH(6HDId_B5"M(0I%EtG/NM
ed5\7'3i;2isR&ObZQV(TZI1-cVo`bqVXYa<'?>J25I\fY&YUTRJPMK?-XA%8*=Qprhh2*Mg
D^&9CjGlO1I5*5Cc!Y1g;Lh!!%Vf4T%I>%Em@!m8je^Onm/CsLL9Vb;rcT86T%H4?U.*jVg7
<b8XDT;g//$(,%te.5SdJakAkQaICA9"mY"Vcp5Bt,uCj"D6EepJ,"f[p:/oa,@C-Bqo,bh&
g*oT)\/2,q0Wui2lO`%cc5`9qb;2Mgc'64u=jrD2&6jtrGq8;3`N!_[YFttF/]A;jQZ1Gt?GM
Y7VO-t7HlATq;eq($,8OHg$c+<Q5afLEH-!lda,N(VY!eOFG>j&IpcC$gH'T71Y.W&0aj*Z2
Q]Aa$^.)Y@L%S;0ka'^s7[AOJpj!l5d8g*A;8E&;02.V7cjd]A1Q"T3_K1o86WCtVY0FdnEir)
ZZ'VNdImc""`Z!&7ZfNZ;)fi:$6t=lZX;1rK3,n[PR?7tb&9ce3?k*HSl)hX8-Fm;e#;dUX3
FF7NF72[@JZ]A298g#>5up<VVl$tV@G]A2X\<uYM77#U1A'OJi"*t[SE$bjprD:nr=_">#j!am
0j-![nW4T*Fj"5\p#;f+=oinT;.PsZ7Os&]Ar@fDU@$osuBiN*QCGdg/r7)m_`o%R#28:TDlE
f/:b-%'E5`6o==-'G962<ob=j&[?&[YflA]Ad-T=<uiM.eTEIP03eP6(obiI4!Y*d@]ALT(=2j
6'r0pFFY/nFP(Kn!u<]A6LeNrpt4<)E?G:T@E%s!Bn,_?[q".o+KWf?Z<j4f/19hNM'WE0"*P
rk_K48,$>4IjKud`HDFM52P,<GAGifLkD]ATlpSG5"$^?4)-/N!LLK6BS#1l,lhZ\*@L=HhA1
V?=q;]AOVgK?^c=Y.IKX/@.6B;@DNn#FtujAuunBgk>iH,F>gq!b0IU$!L#kuDk1G8G3^kDAR
J&P`mH_$e6q_s$8,7/Ap<%[`pl/V]AJI+g]A5LhknOAIUhV.,GrP-gN>$KXQ[H6hqp#dA[hL7f
ZA5rC<a1HfdM!TX%?bO4>ua9OEGdA3+?C,RQbt?AE5)Zb/u@-NT7/$&_b*VXF?8?W$*#!GU8
NnX5H7[>p?$ACmoi<b;m_$BpUgpn&s%Re^:o;(RoS['%p3*&ae#43c'9kH$Ej0U;\Wd@Q7$#
G56//_@X:a473PVTAG*<`poNWP2W[]AV]A2c?ds*"KI[kU_"u!RcCh5!J_*\D3%I$Hrifg@=)a
+@LX&dk#)=015"2W5!]AB[60oDr=7Nga3rcOfKh)rQZ!WDo<M)'/bbft]A*B60$<U3[b=3J=if
"@Fj7Zla;mjSUqi4%K'hTe;q`C]A!#`-d3H0Rk]A-$)ch%;:(9iGbr'-4qo`SS^G!q"5)G7"mg
jM>nKfh,'%bNMe++,[a"dtD2D-Ph`D1%9m53m+k=>2X`L29VYZP[n5fREG;5:f+'+rLjAO<k
XF,YKB6a!km%-GTm!Df39gn)`eK[160u;q0\S.ViSt>G*6;'!tm3a\5k.c7rr&P[N$rEBHpG
Kr]A`^fTAZ4A.:d'f/EpPOZb)PB+8meFA!P8lS+APJK99CIala[CU\V4DU/bW\qK(a&14?ejp
lJ@[f]A(q>/l>'0^WFEfu65DB3:mMF5Z'6AWQ0`*WfYV3EYGcm3N$s]Ad!!c+WI:=n7/+A(e0s
e.uF=O(\84UG@.l!E9H52V"Ys078HDR^h/U)IC<j]A"`h5W4'c$B.H\9s/E6I`LSVd;?oQ_DX
a5g*+KV0V_On*t&4S*:i/81`;]A17`'Rp+>o;[!RX/"h&Z4!d[X9<bG&iI9kc/*TRYd4O%W'f
29WelZu_%Z3oi`8J>;N/r^[MniMlpu^99daT_=T-HBN.M%);Afb]A'53^OC*9sN;nX36!FICp
YZKhufEKTj1d1?/T_&OQj^=EndhuMkn]A\:o-mIemI`(b-VWJDE*YC#b*N%1^9WHZYBTmqn7?
[!_fai+Zh=WL!D<'U6bK(,3AGo&!K^;H,TIDJaH=NVT^hgV0FeCcJjHI!oSB65#Vf(,GGQ(>
]ATQJH')ekV!rg!D5?c.0m3eu""p;3@ZA:i076j6TPYd"H=8#Xk>/eSF#+LZe;!Xb:BCpgm*<
2M>?@iSjnc$(&HFs8K@(&/(PH'4!/@9b2oh)n2LfZX(O6]AIr&jFF$/DER&2!2\2/:*,]Ad]A`H
Ih!,GgR]A9-t!gI_M%"?tNj4>.1H?iI?HYon"[6r6cAa@85a#Hs-&XsV$Oh'h<KG-VPq`9::V
7<:r>7mi3u++\l;FX)s99n+Jr%gWrBpq`EZZ:#W<?#i!6PZR6VBEo&mPbL"hkXJj;-#Fb^^\
dR'hjV,3nn/DCZ2YR,qtlsfa61R$O"fM$dc.WlVPhhFJEHpV>OKQX994&+R$8@&'@QjRIBmq
0r,qf7hA61+CRn$V4!2hhSc=5\!U8X8$Ld^O[d,"_FmF45C<S;9d0Ch*+S,Hf\*kC@Au@I.B
]A*>,\<U5aXbDF2aGOj\c3$>&M=[N6GLA7]AoS.8L.=22YN&FgUn0CH1JTrFfYRUT.(Un;.?uZ
6tfP2YKRi7*@"pG)"eW%?_0"$tCp)Tm$rL2Pdfaq"7W$1\'7I8IU*&NEdklVD,:DfR'ccua*
,aYFC_3mU[-`"DpX84&brr[;t8$&@RS?()rH+H>Leb]AD3_i-"G42(>BYJ?oD!^a8-O2tqaOm
U0D_C"r-S0J*)qpWP"fRETc<K5.#-sdr(MM%jg3tA$Vg,@fHEH!,<-g'ejB4!it5e=s)RsC'
fIn#%HrC=In5?]A\)fMQ1DEc%OE^O2lP+Ri&m9=_LWj&T0e5:*Q[=s9%c/8SX,]A9n<"3pO/*]A
>4K//pZ%3C^lT:4X"YMTb2jD5CF/p@rVY@+J1r)1kX/rauOpS>'\$9K:HBl3+6>"'uW'4>d;
C?O-5kSJt,2T?!5X)6;2V3;eQO/Q/_)5!l]AtLr0:ne.CY#+=u#?"I\9(qA0-h<P6>W20E_1$
#G@N]A>P%+s:.eo+4Ig+=g!<Shn6s:TRc?7g[:[YP[Bq'.`g@Nn93>>6AdsV"#e?g92G(s-")
ujJRAB^D1ME#gO*3:M(c?daNh9!]ALF(&Q`'Odnr5BQHieK0u@:VA*Loh!p02R-$"#(lC[>W"
l%.f"o4BM%W&?1.`+[ne'_C-[@$U8tRnt%p&?nRQ'>cj`RC_Ujrs-\:-d:$l.!2B`!24%39\
ikgYkb-u>fRZleUGd9JlbVGBoKg(U*9*NKag(&6j2/e>"H!I,%,O6A=cTVNoP]AQ34/WYPmX:
OF6rn#fY?$Guc+_83hWW*EDof6(0XE^s/#cP';fiqkLq6#.8/-_/a]ASX3S#O_JbTo',Iuc,^
3bc1bHST=RUc'F;aa*-ub:Z_;f#GVp,]A!-riL-8dcKF7SI;_^/im*us#g&6f]AdEghi(rhu*.
sRA_dcbu0n)F7lTVYHir6Fn)Y.+uc<gh#hqtj4G1Bn'bj)n'ia9I+b9e\sX'\l5ZYEqF#85f
N?=g'nb`$<[]A,_I7pUca<hU<@K;_nK:#@$4>XJmIpnHhJhB<(`D6(qa#Ga:T[./;bDN+D2a?
1"2#)9Hf`Ttn<SoJ%Fe0!gtr(2!^!^5rSMHa34#JE?Ks]A+uCiSRnhfj,4LL9(tDhJfH^R7__
UYVEB@mH.hG2*n.>:5e%R?/DqhM9)\hOXP8d$70"8UEQ;UeK\KV9*l[e7Il.Ydr-@,043'CE
*43mB1WCM.+:i[ro?%M<0kI8+\j,11N9;MKNSM1G<RrRGqndcD)pI@A.jbd!WY\,S(o=lQFK
qLZi.Kj7c!_t[KdEI-$%u_Ek9;nX_e[IoqA$HZ%:`lJ%,eR+n@+iiFh`Y=7bqTjk_?J/Z!9@
ka?ViKp%)\rR\<9e8p09=U>]A-=^M[Rs.hFB4T^l`&gcK/j;S#LQaOuq7OMMl7oZJm'3q6M<r
0=YQeR4Um^I?0D@q\noM$1#N\:kDSHD1g;;nR_-rH:=%<<p1b,$)=5g"1g7Cg'r@W7Ho2!W$
pLL).&,O5PiM]A)-5SZRk8<c.CaH&2OYVS^%kNZCWO"8#;L?0<-Y9NGHiKR]AuWef+tq9?uimJ
6DfBr5^A9a5)<K,!\';=b3$Jl7VMONTD+&r8O4ac!X/\[PauOQZ1Y]AXe;KP+0;oc:p),_G&,
=aORe=*p*;^g>WL[_fj,'1?I_gf&;m1q!#'Dp7eS(KQD+l,NoC%.1>9bbIH[#b-WSI4Gf-%&
U*q1hjhKcH#4%&2mNXu*WHHUDkDpoG7;s_3*J:NF"^k:JS18!.KS?;P^<TDZDr^F*Ra=e5un
#m:43XAY192/sjZf[nZDaD>Ar@]AQ`f!PeUg&*_Y*f'?H\D^`AP[`-Gqb!2U$l$A?4?pa9E=m
&:!(Du'pC'!J1Me4!hAb[p5/P^r)6U/2;uGiQpY?Q+#f4fV46r63Ja'`,%\N>C9\/[=1S"GS
"[&J/QohI;q[@/U7O"1)%t1K\JtQ3r>)hfORTnOZg/P>s4nA?Yfn4+Fl)oON')Jj3kYL-MN`
u.L8KcWkKD4F7pZ1Uipi.<VU3:(^VZM0qeS8E#d-;0j91uU&mDE2/@'^Ok:HbpnH.qkq>G2n
_YaTgU/Voi$!f93_j+T^!el*/XHeL`Xab@Q]AQ6^$s<J+@Y9d'pG5Y@DXo910:am>(hC3X:<X
QP7NcDTr%/%6W;h<KltVDA3k&Cc;c9h_KW7!!3)<g.o3dqnN`n)ajKA2MpYbPe+s2G+Yenhn
J30oWb9n*4TK,;c@D*!=0C.m*B&iqE/BlFBkEX/O@Z+7Q0(Tl%8)`Sa&jcmLstj9.=8DL]A$T
R#?cih@W&,F@`kf]AfKc+_CsGU]A*DkFpR36,a(jYd*jmrWp=N\R+LFu#j[+_B`e*g7aH_Ir<)
#YW_-@pM0?JuDBS0QIdnVe`nE8tm(=_@,E/"tnaj-rn]AS;t&7;1irK&YJGBj&:8WohiJ:lZ;
]AN;i:K4u/stP2i?\?RZm-I&p%-UT\sue9O*NfCUeOc$MBk)LH"C?g,X/oJRUFJ@d7]AiqE9!:
52J3PB:kP1R_pn5L""Nk7tfnK$\.)fZ5B+;GF<Q*`74KXM>uh6@<`4(r^^T:@^,>ie-+FLWE
lm!YR.%o`_sE(_,[ugnV=+o"WsfPII()Zm'c^lS]A,Lc'rl:L0*<+o(-,P*rYG45?uAY64aMV
k%h_)W,$g>2k[A35,>fN3:mqKI=28n*8CbLotbM^AF/ZAk$DD-l-6lJ;Wu(g$b!=M>T=4V+3
!XPIZ5Hh\$A<HdY\rV0mM6ZREtf\ftqV-4Qch*O]A'Xs$6E&K"Y3@NGG@]ApdW7SqVRpUa@X6B
]Ah"9R@Sm-DdMt\AsXJ>QA$>I/#R-QZW6Gc=1<a3=,47p[#V_%a\1:W:WShY46T\u>C_nZf:i
LOj&dl(GejQu=Xh63Jn=`$-<#7eu7CjtTT@c@5e;+r]ATknR4.kS?:R2g-Eaj7S:kcgoHUJ60
!0QS4Yo;UeNWG(nA3a^oaZU[q8,(Fg[G4I40URsKm?8Hu#FgD#<kP3C14$u7rnJe2`i+8SPo
:*e_hg!'*5cu*o?i@S&cTb&6"%;)LjVe=\*/s`7&"RCphW/qH0S?DVl7_67/*)=HBRrN'gb*
"P@QX46lf=>I*L?0<"_We\i4Y=a&cs`T>RA&T&Sf=s,(>'61jOPGc+gp,GlA>rR^BR!B7L4h
m(b&+_]AE2KtWZoEuO;+<rc,OG$c_6#0b1Z#egq<4H/DdgIYO\$0#S#_-PDhhTnaGH5Pobj_9
sY[333lkVT*u&k$fHHLX]AWbFfB4(>\B'aF7t=<1"MZXc5ESWCPWBjC=@SG@64"H*R]A)>UpT<
usPg7`i"ofl--$RQk&3Z[^!1OQWnD6LY]A/JMDU)eI"En@D8`7`l^-et_65B?CHG"H[VU7G7\
VF8opa.Z[;$G;E<,JR.Ghg=:H8(`2!UjTu70aXdBS6iY0NEft`-^pX!HH_Tq,;mY)OQuQ23u
nSg,2ncBTTqSQ.JujmjSdaY@fiH*p..frrO5J<7,jK=+B]Adr.CThKc7PkKPionRCW//`V4t.
lnY7E'Obj#6rP$n.'1uN65[\-;VM:RX9.=m"n6Y#^oOA!sH-81,*uup(E\`L&-)<,B:<=S6\
o,DK8u3`+L^P(&WmpGhYO?!q$o*og@j`5.N/=<8G>OFF&?$L'0e5QJW<d]AC2rU!uhN+s3?7!
FG`>RP+i?+*2Jd7-\#go.X,0OIc8SGgP>'R%Sm]A7pbL1*O$)Zb:_As#Tufr>r:W"s7/Nc!WD
$eW"c.-4=e(:E#<AZ[1Z@a4;SLUWn"bY*6JG.g<M9VAXYq;F!741A%MH+U6+dF)QeNP6Gud1
*]AQo(m/"'uP:)TtdFO.;e;o:o9RK<nRhr9.s2tIJ"M0O>*9V<tKMSR(id=(k=\Kd42*j%dq%
ES;UCZ0b;3V\k+ZI;cjS7*cr[.gBBK/58=R9/Ru$bR8S'Qlb&Ns6OO?\>S7bam=ZVT3CJtN?
p;3m=2GAa\XHW;!CR%B2X[^)77D,:k;G=?M01#UU`Kg_^&0*8%d7>p]Atpk669)3A)oAqZg):
Tg'_g'B[Hj$oI6r"OJ;G?WCnEp*dB>I;1G0^MN9B:`iHW7M+=c3&OH!Eq1G@3<F514r_*7o1
8)0QZV2EhI6E@dhV<Pjs[jA=aJmH'$CWanMC!4?'"a3T6G\nN@pXunEB,(0:pj%Z]A/$Kb-#)
9Hod'fP4(OK9!7j;D654/gkQeE,Z<7ShCg^Rob';5e7QAm#13!"4uD3s)9D(21aG.8X%dK?N
5XYBgc2LMY.^]A.[MgU:+mQPqG[Q%9%sL7eM3"%+fAk9RON#&hZbM>cfjK]An%A.)d7N_!TG/Z
PB=0Sm<gXMq2mI_d5sd2@AK5[f(TqIUPu?kNO?VK88CZGH:dsq*Mo,pL0QYM.#=,p0s?h0G*
Z<W$;"=7#lcW>^@C[\]Ai4Dpaq[>R`0lJ(?24NOL-D77FP2fDKPo!X[6\So=,>%V&?1nW6q=[
`2X@8%o*N/Z9N8qSpiVsdC27*dPd,eIu]Af@KZKCT#d,:leZaX)`8"LV?3S^dSmdJjD%7Af\=
3XNe5JloC+_U+UXHK[hsh[+p5[(S9nR]AKS_-12R=.`.2N"`dHXi^XoO[^ej^5X.13g=H8V+m
DV170kPG#J"W^#I+^R7)j$U$3O?>OK7GZ3FZX%soB-fkc.F^Ir>n;I,OW:I-p2"M@rc@@3T,
>ab0^bkTN(\c6PT$M!7">,9)4nW\P-oqlDfq&5@%P\uL$O/Bp8VSUWlputD#C>3fqk<E;:o-
)Y,2,LIp/(D>?'M$?mek@`_uHc%YKqp)4RV(i4T+LD"CdR*Ka&il8,]ADSg;O#(V'eJ[\_V7-
:A_?ng"l,K4.@e6gFYAalAXZc21L-Vi`SM3[p(2JCM,`r^Ea<umg"p6s#^qom-Smg]AKc)Ddj
I5,=KVehYGXJ6rR<Ri4h0Hfgj*k5MOa;,@Xm2Jg#=fB2h?sZ\_TsJ6-[$$Q`]A04GV!GO<kbJ
u0hq8H7.[tU\BhM\GdLUYe]AS=N\E'Wl)_j#9EbDi(d=eS#H#r83/.fSOqg@[)[I*[G,350@!
magJ'9kU-6!9i;W;-84E]A[4H&q`p'Hr_0Z=1?g04Y?st=&7!5^HV74hsYbJO5'^3aEh1`NBC
mCj\J(E"oJ57F("."r5GtP^DBoS"YMIWOe05QnK'dZdZ_3o4]Adur.J!>d?N6f!jsf]AjF5G6I
""ioeg[UqNiT^4k2V1riLPd]AKr<6(Zq.>"]AF?J@n<)LD:[l^e]AJ[`it$_:E:+Do.NlXHpPDQ
R0B^[@h=`.D^L?Z"86QhA$B?i"O;lRD![QQ&NsCF_tQQ*&e`q/_l+=5rYWgJ6o4HUa:s?;!M
S;!rh=r!C^;H/E#s&=;n40qn1jf($N?G3`3\m@EhA`n'aZFLFb*WD#FLI9\K"<:Scic+!G-)
5aU-ci!OeLD?<T-U*#>Z"j!0\!?PWmk3o(Rh6'DXM-/5[!K)?rbp@G?or`35/SZ)8&3.;`s^
b+/mE'Tj:qdo*uCR'KO7^IHOUC\O2+5mEi=-6a3?nWbF3;?q^S4?/BY,#([Z;@?*8#6Zqlu(
f(\g=qB\uf-`ad`F8(@NOk4\nh<HpT":_0!'48IX,$&1!D(/lBSLE?*ct6`c'6X[=q-9=h.o
H61d'%_V?JVIdrT>_"^jGnPg(*Q-$1orcIQQ6C0S-4lTK2HR,kfHJ*kE,WlFqYV!gl1iJXt^
'/t_@Hd]A)tEh'LKR/+jdqi9k%^?LY7QU9;[I!L;cA!i#gl!i#gl!i#gl!i#fB$68iu05IZki
X1)/^K'0H`=L&F0H$VEbnKToTa]AM<@%@Q#r0S?kV+7@PV+7@PV+7@PV+7@PV+7@PV+7@PV+7
@PV+7@PV+7@PV+7@PV5Y_gV,(+t`9$des-C/5P<)'_qJspc0uK!7R:,,f78b8.@I>,^[:Q,]A
UXGpcUXGpcUXGpcUXGpcUXI%O3d,KXT>oD#8$7AeT!!Mpl^STV!!~
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
<BoundsAttr x="0" y="0" width="1860" height="779"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="258" width="1860" height="779"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_04"/>
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
<WidgetName name="REP_04"/>
<WidgetID widgetID="0471bf6e-345e-4144-9abc-764f5f544edb"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_04"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="8" left="11" bottom="4" right="11"/>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_DUE_YEAR_ + I18N("NY_CN_PAID_TAX")]]></Attributes>
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
<C c="0" r="1" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="190500"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand>
<cellSortAttr/>
</Expand>
</C>
<C c="0" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="CN_TAX_NOT_OFFSET"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
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
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="1" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="1" size="144"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?hZc;caONDo*_CNNlT:1.&4>k^\=VPuN<jK.RTANcks@!fiR;eJ\Q)9RpM=`pnVG5t?W%)6
-AI.j@:cOPF6BMT+?OWhPV$J:IoN8:Uj6.S0d1\$fZAE\__!^O*<%F8"tRqdiQ?MuF'uct+@
'6269*YjE!4_`'^dChMY$f.$P>aPS3d/G,FuZE[`Y)0(rms%W(uEID;lW,J;DfE'PFc:uU('
:>L5]A9fGc4"IGI4C7-TlqF;dC\dYZ,:EEe)aC`QI;thu\ofR4`5So74?P1%19=LH396&XQS+
&o?h>hjT<>8p6krmnWdVD9-lg0+l;T0PJ*:F^(<H-[pKa`)[nL_Kc]Ag[<L&]A`j^55c(()EpB
N(n`/rjG@U0tg:aO4AX+bU&]AF;X4rL]A!cBOQf'3uR%@*YPHlK[>)AtV_38gc\tUT*E5`3RFE
I:SVGc-jQFEfG'ZsD$*lM1ulqbq!8mTRu07#9'&?DMEmbF3]A>.qBl5!D.X6Vn?8@>ccD:jiV
e'L,"oQ>?ohP@^-n1=12Z8cH%e^6g6QCTC_')$B39Bu:I5!plcGZj,qt@<<#Q]Ajep<X-#J-f
gK:PmU5;)4PIs`(Qa8[jeER>]A[kff@8^R0EXYb*"eZn-bO:(HNTCcRl;WD6WF?]A4dHhp58;<
)[k"-<)_:nm<m(u:d)gU8(brpH9\]A.F7CNX;NP9@V<p;O:n=/2c*Dl/erOQUGFJg(7ol]AWSc
5KG+O@Zk2RhBW^Hr,1PunP[bV<CqE7"=I\=.8I"W3bgLS-+)/hH0EG3?ZoBr_:6j+Z6Y`9"A
ri1r^HoTS9Dqf\mm/bme4i%SOeLKY`7IdMTH&$4_i5,Z&ujpiSD4KE6+$B-H+mL5r5^EOKtP
?`'hVmCg$LZa[Y<TlYo&"RO8$nj_>7[OAmDM:\VBf=eKW]AeO;'&@k*\Qa!S2DU":8\%ge#OB
J3MXF.:UYQUpKo\=?r6kmpGLY'0m*iD,9sX_B,KRGO/18ZZ%"V/thY;OE>nasdS>138A=),,
LqPfp`.`)lPYkng!]A-Jpc9*ig+r_ccuF<j)6Pk"QfKHF=+L0NYgdp#K33,$L#inGg_qgS*]A<
\84V!,.A]A>PMW&IrI%I$]A:US2O:J2uB<V'LcX)q6<G,<k,i>Oj\;(;2Q3]AIh67rp)cJK%udr
MVR?o;S*\t!hF0V)DqQH76B91oAFl3M&dA1=GRa@0=pkf;0LlbjNj_QL&Ea*g!EC(eunh",`
#&5PKhB+YD3`lu@,ALh#L)r0k[5f[:d(>W$.Pr4@+IQ<.C!*#:JA@')"Bb;h1j^^ni%aXZ+[
?:#-4YLSup7$?sDV<6@Z'rs]AQ0C*o'BnJq)7'?(3Rb:W:@=E3o'!afjlMKf.Z<(o-9kC,F3r
pK0QH-8Z'k[@-HkAbYBVhopF0l^f`]An9'5/.R'TX,@%FEHO"\6dCKb>9G<_5g)gc<hO(e/&*
62[35YdmLm\UkQ8M3Mi?/$QmIj41`gGKVnH`9:g)_Eko2qD8U*J;V4Sl"&jr(%uLZrg_o^O"
&s?3DPe,8DkVCXUU1#[!\YF/oBkna)Na37l.;G/WPY6qX2q"4=qmX%'PrBG9sUmEc56k<p6r
+j8Q-]Aaa2JkCAa[).NQdt@*d`O[h(El=W`>TGF$hM#i/`b8E9]AX]AH25]AJH>u^'IZeN5_/t?$
5=mbTKn&0rBSNOn#>.'@^8>n#pM\32Jen9-,A9\4@4]AR>+8%<:__JCnRJ`?R)bs!+"\_YPR,
GDnWnrA@Ld@-"!$5!#<9L"%WHq#*8gf%35>P)E.A$1huNf8pa0.)+5R_.PMp^g+*f^JPS2pS
'jp/OM5uZ5\\BkE&R2!IDJi30r\j~
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
<BoundsAttr x="0" y="0" width="458" height="102"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="1432" y="149" width="458" height="102"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_03"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="report3" frozen="false" index="-1" oldWidgetName=""/>
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
<WidgetID widgetID="ec4bb1d7-7e57-4c4f-b935-12b40d04913c"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_03"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="8" left="11" bottom="4" right="11"/>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CN_PAID_TAX")]]></Attributes>
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
<C c="0" r="1" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="190500"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="CN_TAX_PAID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
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
<FRFont name="微軟正黑體" style="1" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="WenQuanYi Micro Hei" style="1" size="144"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?qZb;caZ`?NQ\+6kCj\"%EZU()K#4K0Vt53f"t>@Nd@?F^Zbh(mHV8PZY'J#]A2/L5Y0E;Vh
W0B;DCEXL5IB&$5PHL$)%JVO9@!XR&qX;dJD1WG/cc@8*2o%k'm&qS9Nh^PI!?'r,FM/c@d;
G(U/&*/dRmMRm5Qi;_(F>.N&A;WX.7_EHc0FE0'3fG`3$c(XNp/GgC6Kj6:EPo=r.OZe@;p0
tAe:pS,R)BZD:.D*9!"=(#+eFg)l1mQ;6L-8"1g8aYkG>]AJPK>?Z:ulKlh=hnS\tn+i=qX+U
7QMCon`GE7_EV)i@K2(&XZFZd9o1jh^F5]A1CCK!oIK<#Q<qCF-EtE%THW1V\*`rU]AD-bFd%@
]A!c"j@8qf[HEQ&C*.%$<CU%@tF-s]AN76`YDNhF2]Ah)8Gd8uZO\'4aB^iK^,#dF!C%Q3ZE#L9
#+T[5(W6gO#I&W\dW$R-P>bImW"4WA?1\Y?/q@;0?kgHqjGlahmTiTB\tgEnC5PZoQRU47pW
rZ`XOSN!&)"qe"%'EdX$W4Q^a/nW.@J4XT>%?f#iOZknn00HQB.hj`iPA>G-@af9/8btol^9
[8CT+K<gp?p#J`WC\+qjdb`Qbmm?fB2ZaAL.Ks.jC<['i1/BJH[2afnkR_M8,N,KE(\-gY__
B-Dp>0a-Y8iY\TUhEIbZ:g6LgJh4_+!NCSO1.Wd_849boRAIr1]AdX59p+h,=k[8WksnSo:/-
>DcIeJcHJ5?X+pYm*YcP]ARt\"KV@eep,2kBZ>6=ZhrMf>&Ui./`X/dr95A>b+8h-iV8Z*i"o
F;ureR,FQZ5imIcr9+p*fLY5/F24'Fft=.jDM2;:1+QZ21k7C;^\JlKb]A19n+=5$.JJ;!^e<
s/rujP]A5)'p]AaG%]A6:3!me]Af@gN:ih_(q"l/UT,1_Q?4d102=[$]AB8qt`^AUSd@Pn=')!a@A
lt90SVRF/Q&u^BDX#4tl^%DrqOE4l79HOc)qo4A66$c7&8s._+`ZeYYe]A(@>t8=\)K8"Ear+
nP,68jM*gZh6XiW-$9)cQ,GQIBI8%4-t!>%!>&';VHRH+,#3rIf@4bihUdjQHVGXogFpk).0
UMQOmY!Oqsb0DtAe`A^a='%+]A%qK@.T8tE?=;XtJD67,n+GW(qMB;TE`MLsd;n:0,T(*XTJP
BPi@g'au8N[1n743jj6l96Bj#/&b[akjPRH+O1aj:>c*5o$^%;4"qIcZ6HP4j*^WQmr?a[9p
+Wn)H?GZ5q8RC'IZI`f1"4S+\A.ige"P\isiQ4I9a(gGn/cP)sB`NqP_2`;L_qE/%2s)QeK@
5q$7I)2@NkK:)#>(9Vj;Po,[O/>qOECmo#$j<iFQW:Fg2_h&U]AlTKM/Ti4Bf'L]A0pVmMFF*q
=$<[in'bOLuYoX(tsTo7AKUbBHc%&%3+_Q/o`.B3GD(^F'e\ETK_DtQul"`ZktLo_J>]AD's$
'OB6nQY<;T-WfQ$d+WjhjdgjpTK"1XTKU_YT0M+^;3Q<)q\9/eYESn9AurAG?ZXb14Vm;*`J
:rILuM".3SJ[1pooY9PpC^TmVV53-_DhWeT]A)F1*?Od7>Cf*RNB_aM\52@"G&O&oj[GU0@ru
<Zr\ESLZi,[Ks'<nne*MdjG-1l%g;q7!WiE)!WiE)!WiE)!WiE)!e+hJ$XJ-PbTfjZVu5:[B
?X7%cPG3<*GlZ.17+^d6V$oAA>g@\JBYuN\fm86WWP!m?TH"Z)$E"IJIZdp"!-Sj#<L4_%Wn
?G*U#`n3m`EfFJ+,.rFr]A5]A/dgDP_^,eZQ)4ZJc=O&2#QhAU%=&ZQWX5\p`aBEq51*l^B"~
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
<BoundsAttr x="0" y="0" width="458" height="102"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="962" y="149" width="458" height="102"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_02"/>
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
<WidgetName name="REP_02"/>
<WidgetID widgetID="f4e5a8d2-6767-4656-bbf9-93f80881d776"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="REP_02"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="8" left="11" bottom="4" right="11"/>
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
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("REST_TOTAL")]]></Attributes>
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
<C c="0" r="1" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[條件屬性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="190500"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="E6"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
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
<FRFont name="微軟正黑體" style="1" size="160"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style style_name="預設" full="true" border_source="-1" imageLayout="1">
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat" roundingMode="6">
<![CDATA[#,##0]]></Format>
<FRFont name="微軟正黑體" style="1" size="144"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m?qff;HXie0:JT;7U*K-VW+be2WaX$R@/jg[\`D$;pCc)TfH[GKj&quE<F?<D/*jqEn*PqB=
FrSPYEWk"<=aDNEH]AIbs4)""VLtNiN>F^rS6X5J'JSe3JTW@3TkhZ486dBcgE&rGBJ(QL*4P
pHq2gA#]A^KGIu\S_s#F,Tl@kn='B*A(p11Et]A;+rWP!#-q`TN024'a2q0)#<X:W.PIr75_Ai
oJs7pGnQr*:j^9GH?+5gG*tBQ!N58Wfl[0@V]A0ldX?!dhn%p(@+Dt+NaIP2p2]AWkJ!.I#AN_
TYLSO90PDnGLrr$q!om+kQ6"/*?gjq5Ld[db0^'HTC$YXOR_^Xl5IXC[2%FK(YX%sT[\gjYu
C?:1N]Am1+4a9C0lE'clekCY;XC_'XsH7`%S7A.st.ALG(TX6J#2(L(b\>c-oTY7S6:`_-3fQ
>Du&^9LZNSTBP=ngEjLdfAVj):-;XMB$UVb_KHoIn-jK@1!'QBm\LOsFVg1\`@jL+CEa]AKVq
;+2CQQ`21`qMe`(c#q^WP<[;Gk&6uI,Qf]AaJ.D$%pHYETS9f&Y1`IlhL&hi7P2,@OOV:,&n&
hg?,&ia1q\<Qhn?h%ZQW3([,0cFR=B_KDr/JJK6>09^^,A>@\<<`p010tU\2e(.5(l:*pNXA
G?Dq7QXE3pe-;3;[A;6qm0E+39Qg/@%MZm=r7mJnRQ:XeSbBHgbMR3YDEcK[R)Z6X<LKXO"$
$;Up"(gPof'_96_>nl\3qVJr#g&hb=e>4,^o:cPg:aBUsQ&CIslGLRJm&.#_\[f8mj16)F05
eA_a[PN1FXD_JBrRRWEk,3-fM:%I]AmKr(C+dM_lIS42#A9+`g@%^,<)0k9%\mXC%D*]Afn2.f
R'a5[Apic42iG&FSK9ZtZgJ4fiMI1OI9g4m&iM@\EN&m<60`[3TWcWQZ"+E/HcH.S&gD#O#G
X0['T5/cdM!+-;]A`5'MNce3pWC&O-fTLd/;/aT,b4^75mC(JQ_$5n,=T)(#o4JqAkj/CC!\)
%=&n:!E"u@_P`#>fIV[`H,8BBhf;LInUB6Fk>@L8pjgb7IH6)00SU-sI?Zad!6M&IBT9bs[\
#.e^MfkMe?K6jo\^8'#]Ad$ECj'hnG]Adt3j&Gt-L2]AVl9p`d#`FGe3H*f2-6DGLYG:c(#'7__
Opq.q\g1H<LREZ5DtG9s3qe+LBc%s.Xtod-*u1AKAE0e=O0<.:^+E6_i=-?poCb*\$*1ldCP
PQG-j0;iffK0"RVg89fk*iFBqcN5!to^=\UM9?BCcjAJ`1LN>\U;'2RWcFP;qOUE$Y_2u(Q]A
S?tWW&9nhd9'KkNFU3S`\-8lO$3&EP\*;6cpCs#mA@><A\5i/Lrl%$+YaI.C:a%\c/1&?]Ar(
Xc@"Qqgl6J$[[>'.j^O\_;*C/Uq)H(:.:-Y$hWLmj`,]AjBl.aj,HK[W2-;U#T;J!DPr=,XG6
c('=l#;qh_EcO3"!?(q$mLbQ%TG/Ma7KlAQ#OWMj]ACP'i0:S0t%`@0GP'V9!;\>E275.KD&W
1"ChrET#(j>Z@(/5bABTAhDquZ.tbX7D[B(TUMRZMFBPe$>!i/Q*)=n3iha`=(Q;QUXCW<`b
kf=HRu$O@"D#RC\A#RC\A#RC\A#RC_2RAmu7NY\%tjFlqhAD1"D.hHb>b0l:a?a@*Hj27u.;
kC2#\[Zj7[6sBNA8+M"J'>1i3h]A)+lb5Uh3m`EfFJ&^VkWfA6d")[KTE?4u5R0?sJI_=uXmb
/;q4h*_^;2cq$_/"6JQ)^LJ*X%=#tHHY@jnR,(;>bF<jagaoY1~
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
<BoundsAttr x="0" y="0" width="458" height="102"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="496" y="149" width="458" height="102"/>
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
<Margin top="8" left="11" bottom="4" right="11"/>
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
<![CDATA[723900,762000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3403600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("REC_CFC_TOTAL_INV")]]></Attributes>
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
<C c="0" r="1" s="1">
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
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="190500"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="REP_INV_INCOME" columnName="E1"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
<cellSortAttr/>
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
<FRFont name="Microsoft JhengHei UI" style="1" size="160"/>
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
<![CDATA[#,##0]]></Format>
<FRFont name="Microsoft JhengHei UI" style="1" size="144"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m@&B$P%buXZ.@%=e8[OKl(XGUeoj]Ag0s)S')GAi5RRTY5-'hDt:^deOTTj^oF4=g1oes*62-
mkFW.>g1X-p>o0O;>a!Z!782jFL\JJGQ#rGV_hF(WaDhfCd?rP"o]Ao/seBo=XN6jIHVfYZgM
**WuOI*=ML(%0DrmN'E4rQCj+aGN("V[-QL%s$IrD'f#gS5r@GW1W(ID;W*Z=)i5(UQ-lJd:
>XIpUH'5+=P?[nJ)^gqdr.<c+"@X+gWI$G3Uj9/I"6k;9.M[-fC@fCVfk`JXd<$O6h\qHZM3
:1gr:$gs-7?Of8o7;G!jtR7k44jPj,:_U(Wlmi-%.oc+aQ<Y??ea)6]ANs'@/?RKQY<3Z&L00
DP>bSh8'9pJPR1_N=Sh$C`.(FYfZTL:;X16d^61,!p\h+1PF#l`)i7iV>hiS_-IZ\CI*"K?%
PkDoP73kGoP@2NRH*na\^D7Yi0EBgarsfaZ]A1TJc*u3CZ?ZREl6IO%qsDTZhk^PVl7Z;V[3\
;d]AjA_jQ+&E3$$gPds=Q)-g&NN.lN+)C/DisrS6HILul=b4ZF/Ln9f.3g/l%6nHR>/N&X2nU
AMW'Ap1)ql8c(F:#kpaV:#($YhT85,eTUk0a+ZhS%7E]ADe\Z+`9(/5rg@V@)1AZNR4)fE4N$
]Ajh+<U=W13*#e`_f+,(=6$2]ASK5XARMJWPWR3Qr7lWYoo\$X04;6I<'F;#g8GSQ`Cs[,5nRA
q9<;%GG$+VM`8QTn%1:%V5p^3-j34%>k2f'*1]AnP42Y]AhQEugDU`O*=\Q1tjj::QX??\ksqS
(<t#qfN&mb6]A!^U^=6H>gIbLK%,i[OJEJ"gP&/UtUR!dKMB/)079k1:91I?d`lG9lS4`F'jm
Db?h4G_6r6]Aj#4UD1&(hm%qd:+G/1)qC:%s2)3'"E;g`qDS-g$i`>f$$3Gmh4F0N`(IcO+4P
rSWdI&M&7Xeq9**0tm^_g]A!tg#.g,U),Os3h=p-ImAmN2<NZ5M0;Uu5,?1sCOtF8@ER7U:BM
(KIiI4WR@,8F8AfUpFEFI-l[.2\dAbh;$DL+!gEkNldIZcu1]A<1BfeU2u=JKe*D2>?=H44NA
@@^Fd\cYMi`Sb4D65ID7L\t(>"n<X%9h"a*)s`be5qm-,ChmCag7sCRq@r`J7tNE/JtZ=U"j
D$Jpf_]A`q4`&Bq<mbc=;2V2-"H&b<Z>0^Or-nXhcl/\+PBmYA[Mj`7qao1p(C\tkXV'_C%J\
YG]A)8MC3:R3AWZWp0bU.3-Nf'`E+7GUq5+3s@31b:h9)rnrXd(GScp=-4$CnB-OK;@j=cc5a
kSZ&S#]A;h8uAnZJ'Bu`U-mDMMlY'$s%uI,*\[Q(+/]A^H2X-FkloEnFQSXSfp4/627Cm;MQ\A
/6'&!QXl8I.E;&nO[PaUVdHYr//r-:N6h2\p^ghenRNroU;fQBsOXb>>A.&<:"]AWPV$\Fgfm
GVdOtUt(isI^Y2.:Nnh#cF!<VUY[;u[DkXJo4V10VKTXAg_PBNV%^:==q$s-Br1!1m67A]A'i
T-*D,:1OS`T=!TUU`7T<-WTcN-*fr?RFI&sq`na1;[2l)Jaa0ZfugUi`oW]A.(^G9m@Hn[rkh
VR@@C"=38e3K)QNXpNs9T0.^&iXS-s6[RZaR<cAKb^g^La`p5rkghLQCSS3+CdVRT^Y!0^6p
bPSh.q?l$7N?'9g+;1EY?!80-\5(6^npE;nW@rnmnfef7G_Y,gpqU!2)2e/2j"`D@r;XlC(g
rsorO(qOA_OQmWLbA=Q<M04/(5f1//#q"!a8=\o;M#?='5!7U/G(CFf2H3We@6mN_2irWDlP
")66[E\XtEECsB$`,b5!e!r,1\0Deo]A>05BmP`]Aj(<h]A#0CPegKfW7U--oXK/:pOQ)eM<T3P
mY&$niEhTggZIcL%f$#Jh9Hbg@MnB8(P8ESAk/&c$+OGtO5A+d*NHE#^R[@J"%W!X>[S3&e*
e]A5cnl5n73#-[P<o]Aa&VQBP6'N.@!=SIep^orQn!hpK5P"0N5ZH!aG?BOlk;fEkh(l=HL7P[
*7L<:\-(c@r59<_#o2KfHgf-(@75FZ*CQ`Io,>]AQ2Kg&;0&pF+X!<@OS78_9-3(D+&[t4&^J
91C`+tbBJH,/*_WIpc,XCH\B8,B[7;k"']AP@lJ!5GeXVqko`Rr4ppU$=[$W!)S>k^[UFGic^
IKr3Ja[4!ZeYH;E;K!sGP7<'LH#pfA\_]AL.O)a1)!(^a%e8flD[W>ANMFWt34AmcEcYU77bN
f)@HC]A4DR3,A%qk^s)JL[3`/mosFKlCg2,h\J)o0M).G6DET"TnRIGnTjp7`B132F5_A;4'p
U>lGI+5<<36jKldD1gGKY)a`@"R,^i2S=F]A%8[#1\[hUltR&o9ZpFG(go<N3$`B0_bm%)a1A
[$WlK,qVCH@('1<_1PcG2G@U=#jf:RX<fKS<O-]A6Q8H%X+s@-ldU*=RMN:#IAPT:-9[R<Z)?
&h91MKB]Aqg&j_Rj7[G2^*CqDmG9Gn3$jf"2NJ#YoS^@qgVMjt+XO"E1YI?\DZM9,>7QAke=M
1AuB)AnHc.<OO/K(lS#?$cWt,an^pZS+TLM/?S7Df7:h\_eI",djKaiM,7c%q?36FS1ndkON
$C[\3SaHVOk?*A``R=&dVkF!uSfR"u(Q.$t'&;(r-+U0Rs04?i^3k@sr8=pi@*S1^n9m=lZq
!ITWk!34<9$83d4hOFRHZ+9;d>5QVR[J-7,?!=;:^!qNfJc"4K!KPdn=VLK^13tgmU4a]A0b?
N~
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
<BoundsAttr x="0" y="0" width="458" height="102"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="149" width="458" height="102"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WAbsoluteLayout">
<WidgetName name="ABS01"/>
<WidgetID widgetID="4c636e32-bcb6-4d28-87fc-03bac2de8322"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName="absolute0"/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="true"/>
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
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("TITLE")]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_COMPANY = _g().getWidgetByName("P_COMPANY_").getValue();
var P_CFC = _g().getWidgetByName("P_CFC_").getValue();
var P_VERSION = _g().getWidgetByName("P_VERSION_").getValue();
var P_REC_YEAR = _g().getWidgetByName("P_REC_YEAR_").getValue();
var P_DUE_YEAR = _g().getWidgetByName("P_DUE_YEAR_").getValue();
var P_START_DATE = _g().getWidgetByName("P_START_DATE_").getValue();
var P_END_DATE = _g().getWidgetByName("P_END_DATE_").getValue();
//var TITLE = '${}'

url = "${servletURL}?viewlet=App05/r073.cpt&op=write&P_REC_YEAR=" + P_REC_YEAR + "&P_VERSION=" + P_VERSION + "&P_DUE_YEAR=" + P_DUE_YEAR + "&P_START_DATE=" + P_START_DATE + "&P_END_DATE=" + P_END_DATE + "&P_COMPANY=" + P_COMPANY + "&P_CFC=" + P_CFC + "&format=excel&__filename__=" + TITLE
window.open(url)]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_EXPORT"/>
<WidgetID widgetID="c38ed6c3-fcf3-46b2-845a-da4d065fe368"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName="I18N(&quot;TITLE&quot;\"/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("export_excel")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="1700" y="81" width="70" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_END_DATE"/>
<WidgetID widgetID="01367331-a661-47e1-a712-c4d82ef04180"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor1" frozen="false" index="-1" oldWidgetName="P_END_DATE_c"/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=YEAR(TODAY())]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1290" y="11" width="140" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_START_DATE"/>
<WidgetID widgetID="560b0323-c2c4-4ffc-a3bb-8aee9ba5a3a4"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_START_DATE_c"/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy"/>
<widgetValue>
<O t="Date">
<![CDATA[1672502400000]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1120" y="11" width="140" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_DUE_YEAR"/>
<WidgetID widgetID="9ee11104-7808-4d22-8a62-8d496c308c41"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox4" frozen="false" index="-1" oldWidgetName="P_DUE_YEAR_c"/>
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
<BoundsAttr x="1450" y="11" width="140" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="P_VERSION"/>
<WidgetID widgetID="9a009746-f9ee-4002-ae68-8a6241ce8bfa"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox6" frozen="false" index="-1" oldWidgetName="P_VERSION_c"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="SCENARIO" viName="SCENARIO"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_SCENARIO]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="750" y="11" width="140" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_REC_YEAR"/>
<WidgetID widgetID="d921d1a6-4689-48ab-9a5c-b2af3ec14a27"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_REC_YEAR_c"/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=YEAR(TODAY())-1]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="930" y="11" width="140" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_CFC"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_CFC_c"/>
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
<BoundsAttr x="539" y="2" width="180" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<WidgetName name="P_COMPANY"/>
<WidgetID widgetID="83d88d26-1320-4dcf-9131-79e4189cceda"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COMPANY_c"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ENTITY_CODE" viName="COMPANY_NAME"/>
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
<BoundsAttr x="360" y="2" width="162" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_CFC_"/>
<WidgetID widgetID="4ba99b19-6643-4d37-8c6c-6fe02a4b9a19"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_CFC"/>
<PrivilegeControl/>
</WidgetAttr>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="INV_ENTITY_CODE" viName="ENTITY_NAME"/>
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
<BoundsAttr x="570" y="81" width="160" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboCheckBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_COMPANY_"/>
<WidgetID widgetID="83d88d26-1320-4dcf-9131-79e4189cceda"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboCheckBox0" frozen="false" index="-1" oldWidgetName="P_COMPANY"/>
<PrivilegeControl/>
</WidgetAttr>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ENTITY_CODE" viName="COMPANY_NAME"/>
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
<BoundsAttr x="390" y="81" width="160" height="40"/>
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
<![CDATA[=i18n("TITLE")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="1" size="144">
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
<InnerWidget class="com.fr.form.ui.DateEditor">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_REC_YEAR_"/>
<WidgetID widgetID="d921d1a6-4689-48ab-9a5c-b2af3ec14a27"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_REC_YEAR"/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy"/>
<widgetValue>
<O t="Date">
<![CDATA[1672502400000]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="930" y="81" width="160" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_END_DATE_"/>
<WidgetID widgetID="01367331-a661-47e1-a712-c4d82ef04180"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor1" frozen="false" index="-1" oldWidgetName="P_END_DATE"/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=YEAR(TODAY())]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1290" y="81" width="160" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_START_DATE_"/>
<WidgetID widgetID="560b0323-c2c4-4ffc-a3bb-8aee9ba5a3a4"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName="P_START_DATE"/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=YEAR(TODAY())-1]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1100" y="81" width="160" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_01"/>
<WidgetID widgetID="100759aa-9415-4bad-ad29-c145d155ec9a"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label6" frozen="false" index="-1" oldWidgetName="label6"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[~]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微軟正黑體" style="0" size="96"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="1270" y="81" width="20" height="40"/>
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
var P_CFC= _g().getWidgetByName("P_CFC_").getValue();
var P_VERSION= _g().getWidgetByName("P_VERSION_").getValue();
var P_REC_YEAR= _g().getWidgetByName("P_REC_YEAR_").getValue();
var P_DUE_YEAR= _g().getWidgetByName("P_DUE_YEAR_").getValue();
var P_START_DATE= _g().getWidgetByName("P_START_DATE_").getValue();
var P_END_DATE= _g().getWidgetByName("P_END_DATE_").getValue();

_g().getWidgetByName("P_COMPANY").setValue(P_COMPANY);
_g().getWidgetByName("P_CFC").setValue(P_CFC);
_g().getWidgetByName("P_REC_YEAR").setValue(P_REC_YEAR);
_g().getWidgetByName("P_VERSION").setValue(P_VERSION);
_g().getWidgetByName("P_DUE_YEAR").setValue(P_DUE_YEAR);
_g().getWidgetByName("P_START_DATE").setValue(P_START_DATE);
_g().getWidgetByName("P_END_DATE").setValue(P_END_DATE);
//alert("Loading...")]]></Content>
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
<BoundsAttr x="1790" y="81" width="70" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_VERSION_"/>
<WidgetID widgetID="9a009746-f9ee-4002-ae68-8a6241ce8bfa"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox6" frozen="false" index="-1" oldWidgetName="P_VERSION"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="SCENARIO" viName="SCENARIO"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[DIC_SCENARIO]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[Per Audit]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="750" y="81" width="160" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_VERSION"/>
<WidgetID widgetID="3d060ddf-e368-4fbe-ba90-5ba2e082af63"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label7" frozen="false" index="-1" oldWidgetName="label7"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("SCENARIO")]]></Attributes>
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
<BoundsAttr x="750" y="46" width="160" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_DUE_YEAR"/>
<WidgetID widgetID="6f468344-7717-4fb4-8037-ba2f3310dd96"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label5" frozen="false" index="-1" oldWidgetName="LABEL_DUE_DATE"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("DUEDATE")]]></Attributes>
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
<BoundsAttr x="1470" y="46" width="160" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit" name="編輯後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[return false;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="P_DUE_YEAR_"/>
<WidgetID widgetID="9ee11104-7808-4d22-8a62-8d496c308c41"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="comboBox4" frozen="false" index="-1" oldWidgetName="P_DUE_YEAR"/>
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=RANGE(5)]]></FormulaDict>
<EFormulaDict>
<![CDATA[=$$$]]></EFormulaDict>
</Dictionary>
<widgetValue>
<O>
<![CDATA[5]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="1470" y="81" width="160" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_REC_DATE"/>
<WidgetID widgetID="f1870bcd-2d6c-41c0-8234-8cf22a5df7f3"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label4" frozen="false" index="-1" oldWidgetName="label4"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("REC_DATE")]]></Attributes>
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
<BoundsAttr x="1109" y="46" width="225" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_CFC"/>
<WidgetID widgetID="d506761c-b875-4982-a6b0-53670ce8d233"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label3" frozen="false" index="-1" oldWidgetName="LABEL_CFF"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CFC_COMPANY")]]></Attributes>
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
<BoundsAttr x="570" y="46" width="160" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_DATE"/>
<WidgetID widgetID="60c85dce-6bdf-4cd4-bfb3-16c895813fad"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label2" frozen="false" index="-1" oldWidgetName="LABEL_PERIOD"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("PERIOD")]]></Attributes>
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
<BoundsAttr x="930" y="46" width="160" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_COMPANY"/>
<WidgetID widgetID="8984286b-2315-40ef-bea1-895aa4755d9f"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName="label1"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("COMPANY")]]></Attributes>
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
<BoundsAttr x="390" y="46" width="160" height="35"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="P_COMPANY"/>
<Widget widgetName="P_CFC"/>
<Widget widgetName="P_VERSION"/>
<Widget widgetName="P_REC_YEAR"/>
<Widget widgetName="P_START_DATE"/>
<Widget widgetName="P_END_DATE"/>
<Widget widgetName="P_DUE_YEAR"/>
<Widget widgetName="LABEL_TITLE"/>
<Widget widgetName="LABEL_COMPANY"/>
<Widget widgetName="LABEL_CFC"/>
<Widget widgetName="LABEL_VERSION"/>
<Widget widgetName="LABEL_DATE"/>
<Widget widgetName="LABEL_REC_DATE"/>
<Widget widgetName="LABEL_DUE_YEAR"/>
<Widget widgetName="P_COMPANY_"/>
<Widget widgetName="P_CFC_"/>
<Widget widgetName="P_VERSION_"/>
<Widget widgetName="P_REC_YEAR_"/>
<Widget widgetName="P_START_DATE_"/>
<Widget widgetName="LABEL_01"/>
<Widget widgetName="P_END_DATE_"/>
<Widget widgetName="P_DUE_YEAR_"/>
<Widget widgetName="BTN_EXPORT"/>
<Widget widgetName="BTN_SUBMIT"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetScalingAttr compState="0"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1920" height="140"/>
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
<IM>
<![CDATA[mF]A0H!b!(hn`TPe'Ma]A.)GG+TBS`<-XPqY_nq[d4L7f]A`.<%gkE6(.X$4<LOMM)nBXY="t:0
RMsXr=US67WFAqJk'Wpc"#PkMUT7n&OaK)o&FNF\Hba*J=tiM1d5_C")>"dJeVCOahX!Uq]AP
/LSg6fZ;I.$#":^4oR!sY(\_U6J[O<Dk>V6"r2_NmZfeaj!hkD>-783P/ir8\gipt8-Z-^u0
?WYW56&3W@ah!`AG]Ah7>gcn"*7I*r>IMs/ViZF;UJkue/E`K%_$_l"P>a[-c0+@:H\(Bp;.g
u.819@i.#O`IMP;MVU*tnnBJWl&5+?WB+nRR3H^T[nG'H7+e;d`qCm!Js3SED8P;JT=MUko0
qAOfd.^@V&ljKoQi8EPOi8EPOi8EPOi8EPOi8EPO/a's-0d';=BV&2krOj2"AP5$b5Iaj$h\
]ADYPqo@o:Iel^56~
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
<BoundsAttr x="0" y="0" width="1860" height="110"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="30" width="1860" height="110"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="ABS01"/>
<Widget widgetName="REP_BG_01"/>
<Widget widgetName="REP_01"/>
<Widget widgetName="REP_03"/>
<Widget widgetName="REP_02"/>
<Widget widgetName="REP_04"/>
<Widget widgetName="REP_05"/>
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
<I18N key="PERIOD" description="">
<zh_TW>
<![CDATA[申報年度]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
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
<StrategyConfig dsName="DIC_SCENARIO" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_COMPANY_CODE" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="REP_INV_INCOME" enabled="true" useGlobal="false" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_CFC" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
</StrategyConfigs>
</StrategyConfigsAttr>
<NewFormMarkAttr class="com.fr.form.fit.NewFormMarkAttr">
<NewFormMarkAttr type="0" tabPreload="true" fontScaleFrontAdjust="true" supportColRowAutoAdjust="true" supportExportTransparency="false" supportFrontEndDataCache="false"/>
</NewFormMarkAttr>
<ForkIdAttrMark class="com.fr.base.iofile.attr.ForkIdAttrMark">
<ForkIdAttrMark forkId="85b9f92b-31b5-4c83-a129-082f41dd52d9"/>
</ForkIdAttrMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.31.0.20241014">
<TemplateCloudInfoAttrMark createTime="1711940947019"/>
</TemplateCloudInfoAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="85b9f92b-31b5-4c83-a129-082f41dd52d9"/>
</TemplateIdAttMark>
</Form>
