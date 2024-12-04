
_g().getWidgetByName("BTN_RETURN").setVisible(true);
if(TYPE == "0"){
	_g().getWidgetByName("BTN_MAP_LEVEL").setValue(BTN_MAP_LEVEL);
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else if(TYPE == "") {
	_g().getWidgetByName("BTN_MAP_LEVEL").setValue(BTN_MAP_LEVEL);
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else {
	}


const TYPE = _g().getWidgetByName("BTN_MAP_LEVEL").getValue();
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
	}




