<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20211223" releaseVersion="11.0.0">
<TableDataMap>
<TableData name="DIC_COMPANY_NAME" class="com.fr.data.impl.DBTableData">
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
FROM V_TRS_DIM_COMPANY
WHERE LANGUAGE = '${fr_locale}' AND IS_ACTIVE = 'true']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
<TableData name="DIC_CURRENCY" class="com.fr.data.impl.DBTableData">
<Desensitizations desensitizeOpen="false"/>
<Parameters>
<Parameter>
<Attributes name="P_CFC"/>
<O>
<![CDATA[BE_3]]></O>
</Parameter>
<Parameter>
<Attributes name="P_DATE"/>
<O>
<![CDATA[2023-12]]></O>
</Parameter>
<Parameter>
<Attributes name="P_VERSION"/>
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
<![CDATA[SELECT DISTINCT
	T1.CURRENCY_CODE,
	TRIM(TO_CHAR(T2.AVG_EXCHANGE_RATIO, '9,999.99999')) AS AVG_EXCHANGE_RATIO
FROM TRS_FACT_TRIAL_BALANCE T1
LEFT JOIN V_TRS_FACT_EXCHANGE_BANKOFTW T2 ON T1.PERIOD|| '-'||lpad(t1.MONTH, 2,0) = T2.PERIOD AND T1.CURRENCY_CODE = T2.CURRENCY_ID  AND T2.TARGET_CURRENCY_ID = 'NTD' AND T1.SCENARIO = T2.SCENARIO 
LEFT JOIN V_TRS_DIM_ENTITY_CUR t3 ON t1.ENTITY_CODE = t3.ENTITY_CODE
WHERE 1 = 1
	AND t3.CURRENT_CODE = '${P_CFC}'
	AND T1.PERIOD|| '-'|| lpad(t1.MONTH, 2,0)= '${P_DATE}'
	AND t1.SCENARIO = '${P_VERSION}']]></Query>
<PageQuery>
<![CDATA[]]></PageQuery>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="1" fitFont="true" minFontSize="0"/>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false" appearRefresh="false" promptWhenLeaveWithoutSubmit="false" allowDoubleClickOrZoom="true"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="P_COMPANY"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_DATE"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CFC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="P_VERSION"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
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
<Listener event="afterinit" name="初始化後2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(() => {
	$("div[widgetname='REP_TITLE_BG']A").css({
		"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
	});
		$("div[widgetname='REP_BG01']A").css({
		"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
	});
		$("div[widgetname='REP_BG02']A").css({
		"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
	});
//		$("div[widgetname='REP_05']A").css({
//		"box-shadow": "0px 1px 1px 0px rgba(0, 0, 0, 0.25)"
//	});

}, 200)]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit" name="初始化後3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var submit = this.options.form.getWidgetByName("BTN_SUBMIT");
let reader = this.options.form.getWidgetByName("P_READER").getValue();
if (reader != '0') {
	submit.setEnable(false);
}]]></Content>
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
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_READER"/>
<WidgetID widgetID="54aad064-ef4e-46a7-9189-1b4200d8d6df"/>
<WidgetAttr invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="P_READER_c" frozen="false" index="-1" oldWidgetName="P_READER_c"/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=INARRAY('{"departments":"目錄,App05","jobTitle":"reader"}',SPLIT(REPLACE(CONCATENATE($fine_position),"},","},,"),",,"))]]></Attributes>
</O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="1002" y="40" width="218" height="26"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_DATE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_DATE]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_VERSION"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_VERSION]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_COMPANY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_CFC"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_FILENAME]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[url = "${servletURL}?viewlet=App05/r070.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC + "&format=excel&__filename__=" + TITLE 
window.open(url)]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_EXPORT"/>
<WidgetID widgetID="95994598-00a0-4997-a82f-a8b6cab6c718"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("export_excel")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="1370" y="32" width="82" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="afterinit" name="初始化後1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[if (P_LOCK == 'true') {
	this.setEnable(false)
	}]]></Content>
</JavaScript>
</Listener>
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.iframe_r70.verifyAndWriteReport();
location.reload();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_SUBMIT"/>
<WidgetID widgetID="c90c3247-6126-4eed-9a6d-56aca7c9813c"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("SUBMIT")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="1462" y="32" width="82" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe" pluginID="com.fr.solution.plugin.form.widget.rh.iframe.v10" plugin-version="8.27">
<WidgetName name="IFM_REP"/>
<WidgetID widgetID="6b8f7d52-43b8-4313-8c95-ee8b5c92bcbf"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="rHIframe0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true" method="GET" contentAdapt="true" customUrlEncode="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr" pluginID="com.fr.solution.plugin.form.widget.rh.iframe.v10" plugin-version="8.27">
<RHIframeSource class="com.fr.plugin.form.widget.core.TemplateSource" pluginID="com.fr.solution.plugin.form.widget.rh.iframe.v10" plugin-version="8.27">
<Attr path="/App05/r070.cpt"/>
</RHIframeSource>
<Parameters>
<Parameter>
<Attributes name="P_COMPANY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_COMPANY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_CFC"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_DATE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_DATE]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_VERSION"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_VERSION]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[write]]></O>
</Parameter>
<Parameter>
<Attributes name="__pi__"/>
<O>
<![CDATA[false]]></O>
</Parameter>
<Parameter>
<Attributes name="P_CURRENCY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_CURRENCY]]></Attributes>
</O>
</Parameter>
</Parameters>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="362" y="105" width="1201" height="762"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="P_DATE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_DATE]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_VERSION"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_VERSION]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_COMPANY"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=$P_COMPANY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_CFC"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="LOG_TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("LOG_TITLE")]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[
var iframe = $("<iframe id='inp' name='inp' width='100%' height='100%' scrolling-'yes' frameborder='0'>");
//var locale = this.options.form.getWidgetByName("fr_locale").getValue()
var url ="${servletURL}?viewlet=App05%252Fr070_1.cpt&P_VERSION="+P_VERSION+"&P_DATE="+P_DATE+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC;
/*var url ="${GP_RELATIVE_LINK}&op=write&ope=A1&fr_locale="+locale*/
iframe.attr("src", url);

var o = {
	title: LOG_TITLE,
	width: 660,
	height: 400
};
FR.showDialog(o.title, o.width, o.height, iframe, o);
$('.fr-core-window-header').css("background", "#D04A02");
$(".fr-core-panel-tool-close").css("top","5px");
//按鈕close，放css不生效
//$('.fr-core-panel-tool-close').css("background", "yellow");]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_LOG"/>
<WidgetID widgetID="c90c3247-6126-4eed-9a6d-56aca7c9813c"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("LOG")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="1278" y="32" width="82" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_TITLE"/>
<WidgetID widgetID="da1977c4-7e05-42d6-929f-f79aa5c42e66"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("TITLE")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="1" size="140"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="67" y="32" width="800" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WAbsoluteLayout">
<WidgetName name="ABS_01"/>
<WidgetID widgetID="fbaa8895-27b1-4a3e-bee1-497930e00fb5"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
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
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_CURRENCY"/>
<WidgetID widgetID="2c23a333-4cf9-4120-b9b5-44b0d3437dd7"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName="LABEL_VERSION_c_c"/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("EXECHANGE_RATE")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="120"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="20" y="320" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_CURRENCY"/>
<WidgetID widgetID="acf77c2e-cb2c-4776-8f03-1b5886fcfa77"/>
<WidgetAttr disabled="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="textEditor1" frozen="false" index="-1" oldWidgetName="P_CURRENCY_c"/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("DIC_CURRENCY", 2)]]></Attributes>
</O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="20" y="354" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("D") + P_DATE + P_VERSION + P_COMPANY + P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_CFC = _g().getWidgetByName("P_CFC").getValue()
var P_COMPANY = _g().getWidgetByName("P_COMPANY").getValue()
var P_DATE = _g().getWidgetByName("P_DATE").getValue()
var P_VERSION = _g().getWidgetByName("P_VERSION").getValue()

window.parent.FS.tabPane.addItem({title:TITLE, src:"${servletURL}?viewlet=App05/r072.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC+ "&P_FILENAME=" +TITLE+ "&P_LOCK=" + P_LOCK});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_D"/>
<WidgetID widgetID="2ad7a06b-36ec-4e1f-9d40-303514f17b88"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("D")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="20" y="584" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("C") + P_DATE + P_VERSION + P_COMPANY + P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_CFC = _g().getWidgetByName("P_CFC").getValue()
var P_COMPANY = _g().getWidgetByName("P_COMPANY").getValue()
var P_DATE = _g().getWidgetByName("P_DATE").getValue()
var P_VERSION = _g().getWidgetByName("P_VERSION").getValue()

window.parent.FS.tabPane.addItem({title:TITLE, src:"${servletURL}?viewlet=App05/r071.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC+ "&P_FILENAME=" +TITLE+ "&P_LOCK=" + P_LOCK});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_C"/>
<WidgetID widgetID="2ad7a06b-36ec-4e1f-9d40-303514f17b88"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("C")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="20" y="530" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_CFC1"/>
<WidgetID widgetID="4ae37957-3093-4182-b112-23a7748f26ed"/>
<WidgetAttr disabled="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="textEditor1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("DIC_COMPANY_NAME", 2, 1, P_CFC)]]></Attributes>
</O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="20" y="132" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_COMPANY1"/>
<WidgetID widgetID="b5bb932b-ab14-49ba-af2f-d89735adb816"/>
<WidgetAttr disabled="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="textEditor0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=VALUE("DIC_COMPANY_NAME", 2, 1, P_COMPANY)]]></Attributes>
</O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="20" y="61" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_CFC"/>
<WidgetID widgetID="23c0e502-91bb-4a20-b817-d4e9542ac02f"/>
<WidgetAttr disabled="true" invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="textEditor0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="0" y="134" width="272" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="P_DATE"/>
<WidgetID widgetID="72845920-2c96-4859-b1a9-3a47a0ccd01f"/>
<WidgetAttr disabled="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="dateEditor0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<DateAttr format="yyyy-MM"/>
<widgetValue>
<O t="Date">
<![CDATA[1700582400000]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="20" y="204" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("F") + P_DATE + P_VERSION + P_COMPANY + P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_CFC = _g().getWidgetByName("P_CFC").getValue()
var P_COMPANY = _g().getWidgetByName("P_COMPANY").getValue()
var P_DATE = _g().getWidgetByName("P_DATE").getValue()
var P_VERSION = _g().getWidgetByName("P_VERSION").getValue()

window.parent.FS.tabPane.addItem({title:TITLE, src:"${servletURL}?viewlet=App05/r067.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC+ "&P_FILENAME=" +TITLE+ "&P_LOCK=" + P_LOCK});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_F"/>
<WidgetID widgetID="2ad7a06b-36ec-4e1f-9d40-303514f17b88"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("F")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="20" y="692" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("E") + P_DATE + P_VERSION + P_COMPANY + P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_CFC = _g().getWidgetByName("P_CFC").getValue()
var P_COMPANY = _g().getWidgetByName("P_COMPANY").getValue()
var P_DATE = _g().getWidgetByName("P_DATE").getValue()
var P_VERSION = _g().getWidgetByName("P_VERSION").getValue()

window.parent.FS.tabPane.addItem({title:TITLE, src:"${servletURL}?viewlet=App05/r066.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC+ "&P_FILENAME=" +TITLE+ "&P_LOCK=" + P_LOCK});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_E"/>
<WidgetID widgetID="2ad7a06b-36ec-4e1f-9d40-303514f17b88"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("E")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="20" y="638" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("B") + P_DATE + P_VERSION + P_COMPANY + P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_CFC = _g().getWidgetByName("P_CFC").getValue()
var P_COMPANY = _g().getWidgetByName("P_COMPANY").getValue()
var P_DATE = _g().getWidgetByName("P_DATE").getValue()
var P_VERSION = _g().getWidgetByName("P_VERSION").getValue()

window.parent.FS.tabPane.addItem({title:TITLE, src:"${servletURL}?viewlet=App05/r065.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC+ "&P_FILENAME=" +TITLE+ "&P_LOCK=" + P_LOCK});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_B"/>
<WidgetID widgetID="2ad7a06b-36ec-4e1f-9d40-303514f17b88"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("B")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="20" y="475" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click" name="點擊1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="TITLE"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("A") + P_DATE + P_VERSION + P_COMPANY + P_CFC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="P_LOCK"/>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=P_LOCK]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var P_CFC = _g().getWidgetByName("P_CFC").getValue()
var P_COMPANY = _g().getWidgetByName("P_COMPANY").getValue()
var P_DATE = _g().getWidgetByName("P_DATE").getValue()
var P_VERSION = _g().getWidgetByName("P_VERSION").getValue()

window.parent.FS.tabPane.addItem({title:TITLE, src:"${servletURL}?viewlet=App05/r064.cpt&op=write&P_DATE="+P_DATE+"&P_VERSION="+P_VERSION+"&P_COMPANY="+P_COMPANY+"&P_CFC=" + P_CFC+ "&P_FILENAME=" +TITLE+ "&P_LOCK=" + P_LOCK});
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="BTN_A"/>
<WidgetID widgetID="2ad7a06b-36ec-4e1f-9d40-303514f17b88"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="button0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[=I18N("A")]]></Text>
<Hotkeys>
<![CDATA[]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="20" y="420" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_VERSION"/>
<WidgetID widgetID="acf77c2e-cb2c-4776-8f03-1b5886fcfa77"/>
<WidgetAttr disabled="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="textEditor1" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="20" y="277" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="P_COMPANY"/>
<WidgetID widgetID="ea4e0c88-a5ca-4004-910a-9dfaa9ecc191"/>
<WidgetAttr disabled="true" invisible="true" aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="textEditor0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<MobileScanCodeAttr scanCode="true" textInputMode="0" isSupportManual="true" isSupportScan="true" isSupportNFC="false" nfcContentType="0"/>
<MobileTextEditAttr allowOneClickClear="true"/>
</InnerWidget>
<BoundsAttr x="0" y="63" width="272" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_VERSION"/>
<WidgetID widgetID="2c23a333-4cf9-4120-b9b5-44b0d3437dd7"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("SCENARIO")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="120"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="20" y="243" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_CFC"/>
<WidgetID widgetID="2c23a333-4cf9-4120-b9b5-44b0d3437dd7"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("CFC_COMPANY_NAME")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="120"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="20" y="99" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_DATE"/>
<WidgetID widgetID="2c23a333-4cf9-4120-b9b5-44b0d3437dd7"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("PERIOD")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="120"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="20" y="171" width="290" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="LABEL_COMPANY"/>
<WidgetID widgetID="2c23a333-4cf9-4120-b9b5-44b0d3437dd7"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="label0" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="XMLable" class="com.fr.base.Formula">
<Attributes>
<![CDATA[=I18N("COMPANY_NAME")]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="Microsoft JhengHei UI" style="0" size="120"/>
<border style="0">
<color>
<FineColor color="-723724" hor="-1" ver="-1"/>
</color>
</border>
</InnerWidget>
<BoundsAttr x="20" y="27" width="290" height="42"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="LABEL_COMPANY"/>
<Widget widgetName="P_COMPANY1"/>
<Widget widgetName="P_COMPANY"/>
<Widget widgetName="LABEL_CFC"/>
<Widget widgetName="P_CFC1"/>
<Widget widgetName="P_CFC"/>
<Widget widgetName="LABEL_DATE"/>
<Widget widgetName="P_DATE"/>
<Widget widgetName="LABEL_VERSION"/>
<Widget widgetName="P_VERSION"/>
<Widget widgetName="LABEL_CURRENCY"/>
<Widget widgetName="P_CURRENCY"/>
<Widget widgetName="BTN_A"/>
<Widget widgetName="BTN_B"/>
<Widget widgetName="BTN_C"/>
<Widget widgetName="BTN_D"/>
<Widget widgetName="BTN_E"/>
<Widget widgetName="BTN_F"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetScalingAttr compState="0"/>
</InnerWidget>
<BoundsAttr x="30" y="105" width="321" height="790"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG01"/>
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
<WidgetName name="REP_BG01"/>
<WidgetID widgetID="282974be-8494-4ed3-88df-751195cfa344"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="11" bottom="11" right="11"/>
<Border>
<border style="0" borderRadius="1" type="0" borderStyle="0"/>
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
<InsetImage padding="4" insetRelativeTextLeft="true" insetRelativeTextRight="false" name="ImageBackground" layout="3">
<FineImage fm="png" imageId="__ImageCache__9BDAD1A694F2AE09931BEB5B979DA1F5">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n&&RXMhpZ,a0ckg]Ag[)Sh?$H'm#O$mX9@nDg03/<C4dC'hs7\:U
CrUFIA*cmN+n1!@hUKFS0]AXkEO<r!!~
]]></IM>
</FineImage>
</InsetImage>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="0.94"/>
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
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNSD"^qm!TZFI#Mk;^XW!R^[3/1DVH#r!g09`(0MrWmpT]AqUHC@
-1;[(X4l:TL[)pU]AY\O+$"Q*=OiM"]A%dVJM]A:kW[\Nb`_TZ3WH*8uOI,qeh"dEW`&P!3@hOT
@n=%2qU4X5\J>`c@Wf/&P;`$I"ga+SE+A+rMM[;de"q#o0O3UV)UKU0qNbTTb3i[=%l_rB3X
eT&i[>nuBeN0^Q<9pL6;6?Ts8%"@l*S!c!X`eW$."\iXpqOO$;5o)&Tj]AFhaKQekl3L1i)%!
;SP=Hoh,tB7O,tB7O,tB7O,tB7O,tB7O,tB7O,tB7!,$7Q"J"B7*Se"l^l0@H;c7,Fn!!~
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
<BoundsAttr x="0" y="0" width="327" height="784"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="96" width="327" height="784"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_BG02"/>
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
<WidgetName name="REP_BG02"/>
<WidgetID widgetID="2305a00d-50a4-4c97-bf74-a0e3e444d9fe"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="11" bottom="11" right="11"/>
<Border>
<border style="0" borderRadius="1" type="0" borderStyle="0"/>
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
<InsetImage padding="4" insetRelativeTextLeft="true" insetRelativeTextRight="false" name="ImageBackground" layout="3">
<FineImage fm="png" imageId="__ImageCache__9BDAD1A694F2AE09931BEB5B979DA1F5">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n&&RXMhpZ,a0ckg]Ag[)Sh?$H'm#O$mX9@nDg03/<C4dC'hs7\:U
CrUFIA*cmN+n1!@hUKFS0]AXkEO<r!!~
]]></IM>
</FineImage>
</InsetImage>
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
<BoundsAttr x="0" y="0" width="1212" height="784"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="361" y="96" width="1212" height="784"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="REP_TITLE_BG"/>
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
<WidgetName name="REP_TITLE_BG"/>
<WidgetID widgetID="d273755a-fcb2-4969-8c91-414eeccb9aba"/>
<WidgetAttr aspectRatioLocked="false" aspectRatioBackup="-1.0" description="">
<MobileBookMark useBookMark="false" bookMarkName="" frozen="false" index="-1" oldWidgetName=""/>
<PrivilegeControl/>
</WidgetAttr>
<FollowingTheme borderStyle="false"/>
<Margin top="0" left="11" bottom="11" right="11"/>
<Border>
<border style="0" borderRadius="1" type="0" borderStyle="0"/>
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
<InsetImage padding="4" insetRelativeTextLeft="true" insetRelativeTextRight="false" name="ImageBackground" layout="3">
<FineImage fm="png" imageId="__ImageCache__9BDAD1A694F2AE09931BEB5B979DA1F5">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n&&RXMhpZ,a0ckg]Ag[)Sh?$H'm#O$mX9@nDg03/<C4dC'hs7\:U
CrUFIA*cmN+n1!@hUKFS0]AXkEO<r!!~
]]></IM>
</FineImage>
</InsetImage>
</WidgetTitle>
<Background name="ColorBackground">
<color>
<FineColor color="-1" hor="-1" ver="-1"/>
</color>
</Background>
<Alpha alpha="0.98"/>
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
<FRFont name="WenQuanYi Micro Hei" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<DesensitizationList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[mF\[:!auqdnQ3?NPK[t[_1U#WW5bQ#]A.iN+Y)!:;"sH<bVPYL.;C<7mKpI\+BW//0h1HjMKS
*;G_LoY&#VGXrr#6o5hf*t8Hb%Hah"YD=Zt6_ik@0C\eWn3&@tRe\3/>'m\[grL`b(r[7+jU
P=f/GO.&2AkltC&%6JhDU0U1DP8,`"VhY9k2Dq8R<elAeV&$k]A<LQ@_j<'(lRe+&n*b6[WpS
I3V8Ju2\Uk%N/Ln#^n"8=OW`?k(IGWY@?3I#8XTP3)[MW2E8Xo8o;dkOne-5%'W^B8m*u6r=
Xe;%uGr'Lbk578Xafqq82bhU5k6dMo0dZ#%qE4.d,rW$fGEFZ&Qa]Al$XaU!F*EDtg<pHeVr=
9)E%9E,]Ac8E,]Ac8E,]Ac8E,]Ac8E,]Adc^ZQ+h:Nep7g=M@sS8?5!qT"!3f4mnorp=k-VClSFS&
JM+(B~
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
<BoundsAttr x="0" y="0" width="1543" height="75"/>
</Widget>
<ShowBookmarks showBookmarks="false"/>
</InnerWidget>
<BoundsAttr x="30" y="15" width="1543" height="75"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="BTN_LOG"/>
<Widget widgetName="REP_TITLE_BG"/>
<Widget widgetName="REP_BG01"/>
<Widget widgetName="ABS_01"/>
<Widget widgetName="LABEL_TITLE"/>
<Widget widgetName="REP_BG02"/>
<Widget widgetName="IFM_REP"/>
<Widget widgetName="BTN_SUBMIT"/>
<Widget widgetName="BTN_EXPORT"/>
<Widget widgetName="P_READER"/>
</MobileWidgetList>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetScalingAttr compState="0"/>
<AppRelayout appRelayout="true"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="1600" height="900"/>
</Widget>
<ShowBookmarks showBookmarks="true"/>
<Sorted sorted="false"/>
<MobileWidgetList/>
<FrozenWidgets/>
<MobileBookMarkStyle class="com.fr.form.ui.mobile.impl.DefaultMobileBookMarkStyle"/>
<WidgetZoomAttr compState="0" scaleAttr="2"/>
<AppRelayout appRelayout="true"/>
<Size width="1600" height="900"/>
<BodyLayoutType type="1"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="LAA"/>
<PreviewType PreviewType="5"/>
<I18NMap class="com.fr.plugin.i18n.bundle.configurator.data.I18NAttrMark" pluginID="com.fr.plugin.i18n.bundle.v11" plugin-version="2.1.6">
<Attributes languageType="0" default="" backup="en_US"/>
<I18N key="CFC_COMPANY_CODE" description="">
<zh_TW>
<![CDATA[CFC公司代碼]]></zh_TW>
</I18N>
<I18N key="EQUITY_METHOD_INV_INC" description="">
<zh_TW>
<![CDATA[採權益法投資收益]]></zh_TW>
</I18N>
<I18N key="HOLDING_RATIO" description="">
<zh_TW>
<![CDATA[直接被持有之比率按加權平均天數計算]]></zh_TW>
</I18N>
<I18N key="EARNING_DISTRI_CN" description="">
<zh_TW>
<![CDATA[盈餘分配數]]></zh_TW>
</I18N>
<I18N key="OCI_AND_OTHER_EQUITY_ TO_RE" description="">
<zh_TW>
<![CDATA[其他綜合損益(OCI)與其他權益轉入RE數]]></zh_TW>
</I18N>
<I18N key="LIMIT_ITEMS" description="">
<zh_TW>
<![CDATA[法定盈餘公積或限制分配項目(c)]]></zh_TW>
</I18N>
<I18N key="EARNING_DISTRI_NON_CN" description="">
<zh_TW>
<![CDATA[盈餘分配數扣除已繳納之股利或盈餘所得稅之淨額]]></zh_TW>
</I18N>
<I18N key="CFC_EARNINGS" description="">
<zh_TW>
<![CDATA[當年度盈餘]]></zh_TW>
</I18N>
<I18N key="TAX_INC" description="">
<zh_TW>
<![CDATA[CFC當年度歸課所得]]></zh_TW>
</I18N>
<I18N key="EQUITY_METHOD_Realized_LOSS" description="">
<zh_TW>
<![CDATA[採權益法投資損失已實現數]]></zh_TW>
</I18N>
<I18N key="EQUITY_METHOD_INV_LOSS" description="">
<zh_TW>
<![CDATA[採權益法投資損失]]></zh_TW>
</I18N>
<I18N key="LOSS_PREVIOUS_YEARS" description="">
<zh_TW>
<![CDATA[以前年度CFC虧損核定數(d)]]></zh_TW>
</I18N>
<I18N key="PERIOD" description="">
<zh_TW>
<![CDATA[年月]]></zh_TW>
<en_US>
<![CDATA[Period]]></en_US>
</I18N>
<I18N key="CFC_NET_INCOME" description="">
<zh_TW>
<![CDATA[CFC稅後淨利(財報)]]></zh_TW>
</I18N>
<I18N key="SCENARIO" description="">
<zh_TW>
<![CDATA[版本]]></zh_TW>
<en_US>
<![CDATA[Scenario]]></en_US>
</I18N>
<I18N key="CFC_COMPANY_NAME" description="">
<zh_TW>
<![CDATA[CFC公司]]></zh_TW>
<en_US>
<![CDATA[CFC Company Name]]></en_US>
</I18N>
<I18N key="TITLE" description="">
<zh_TW>
<![CDATA[CFC當年度歸課所得計算]]></zh_TW>
<en_US>
<![CDATA[Calculation of CFC’s remitted income for the current year]]></en_US>
</I18N>
<I18N key="LOG" description="">
<zh_TW>
<![CDATA[操作日誌]]></zh_TW>
<en_US>
<![CDATA[Log]]></en_US>
</I18N>
<I18N key="EXPORT" description="Export">
<zh_TW>
<![CDATA[匯出]]></zh_TW>
</I18N>
<I18N key="COMPANY_NAME" description="">
<zh_TW>
<![CDATA[申報公司]]></zh_TW>
<en_US>
<![CDATA[Entity Name]]></en_US>
</I18N>
<I18N key="EXECHANGE_RATE" description="">
<zh_TW>
<![CDATA[匯率]]></zh_TW>
</I18N>
<I18N key="SUBMIT" description="">
<zh_TW>
<![CDATA[提交]]></zh_TW>
<en_US>
<![CDATA[Submit]]></en_US>
</I18N>
<I18N key="A" description="">
<zh_TW>
<![CDATA[(a)投資損益(B3)]]></zh_TW>
<en_US>
<![CDATA[(a)Investment Gain/Loss(B3)]]></en_US>
</I18N>
<I18N key="B" description="">
<zh_TW>
<![CDATA[(b)決議盈餘分配數(B4~B5)]]></zh_TW>
<en_US>
<![CDATA[(b)Distribution of Earnings(B4~B5)]]></en_US>
</I18N>
<I18N key="E" description="">
<zh_TW>
<![CDATA[(e)法定盈餘公積或限制分配項目(D2)]]></zh_TW>
<en_US>
<![CDATA[(e)Restricted Distribution Items(D2)]]></en_US>
</I18N>
<I18N key="F" description="">
<zh_TW>
<![CDATA[(f)十年虧損扣除(D3)]]></zh_TW>
<en_US>
<![CDATA[(f)Loss deduction for past ten yrs(D3)]]></en_US>
</I18N>
<I18N key="LOG_TITLE" description="">
<zh_TW>
<![CDATA[操作日誌]]></zh_TW>
</I18N>
<I18N key="C" description="">
<zh_TW>
<![CDATA[(c)虧損已實現數(B6)]]></zh_TW>
<en_US>
<![CDATA[(c)Actual Losses(B6)]]></en_US>
</I18N>
<I18N key="D" description="">
<zh_TW>
<![CDATA[(d)處分股權之調整數(B7)]]></zh_TW>
<en_US>
<![CDATA[(d)ADJ for disposal of Investment(B7)]]></en_US>
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
<StrategyConfig dsName="DIC_CURRENCY" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
<StrategyConfig dsName="DIC_COMPANY_NAME" enabled="false" useGlobal="true" shouldMonitor="true" shouldEvolve="false" scheduleBySchema="false" timeToLive="1500000" timeToIdle="86400000" updateInterval="1500000" terminalTime="" updateSchema="0 0 8 * * ? *" activeInitiation="false"/>
</StrategyConfigs>
</StrategyConfigsAttr>
<NewFormMarkAttr class="com.fr.form.fit.NewFormMarkAttr">
<NewFormMarkAttr type="0" tabPreload="true" fontScaleFrontAdjust="true" supportColRowAutoAdjust="true" supportExportTransparency="false" supportFrontEndDataCache="false"/>
</NewFormMarkAttr>
<ForkIdAttrMark class="com.fr.base.iofile.attr.ForkIdAttrMark">
<ForkIdAttrMark forkId="baf14ddc-0c0c-4a97-86c0-ac5581dc7b1b"/>
</ForkIdAttrMark>
<TemplateIdAttMark class="com.fr.base.iofile.attr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="baf14ddc-0c0c-4a97-86c0-ac5581dc7b1b"/>
</TemplateIdAttMark>
<TemplateCloudInfoAttrMark class="com.fr.plugin.cloud.analytics.attr.TemplateInfoAttrMark" pluginID="com.fr.plugin.cloud.analytics.v11" plugin-version="3.31.0.20241014">
<TemplateCloudInfoAttrMark createTime="1726803633808"/>
</TemplateCloudInfoAttrMark>
</Form>
