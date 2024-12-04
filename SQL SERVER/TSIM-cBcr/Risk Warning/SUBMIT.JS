var P_COMPANY= _g().getWidgetByName("P_COMPANY_").getValue();
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
else {}