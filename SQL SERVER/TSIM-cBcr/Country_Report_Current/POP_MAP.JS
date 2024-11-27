const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "" 為初始化，BTN_TYPE 還沒有賦任何值，此時Series為國家列表，點擊 返回按鈕顯示
if(TYPE == ""){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COUNTRY_").setValue(P_COUNTRY);
	}

else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("BTN_TYPE").setValue("2");
	_g().getWidgetByName("P_COMPANY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue(P_COUNTRY);
	}
else if(TYPE == "2"){
	}


//RETURN 按鈕

const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
// TYPE = "2" 代表現在顯示個別公司，退回公司列表的顯示
if(TYPE == "2"){
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(true);
	_g().getWidgetByName("BTN_RETURN02").setVisible(true);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(true);
	// 賦值 BTN_TYPE 要drill down 去各個公司列表 此時賦值為"1""
	_g().getWidgetByName("BTN_TYPE").setValue("1");
	// 賦值 P_COUNTRY （真正有用的參數）跟 P_COUNTRY（這個是為了顯示在下拉匡而已） 為國家列表
	_g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
// TYPE = "1" 代表現在顯示公司列表
else if(TYPE == "1") {
	//返回按鈕顯示
	_g().getWidgetByName("BTN_RETURN01").setVisible(false);
	_g().getWidgetByName("BTN_RETURN02").setVisible(false);	
	_g().getWidgetByName("BTN_RETURN03").setVisible(false);
    _g().getWidgetByName("BTN_TYPE").setValue("");
	// 此時Series 要為公司列表，所以一樣取P_COUNTRY（因為這個為Series）的值
	_g().getWidgetByName("P_COUNTRY").setValue("");
	_g().getWidgetByName("P_COUNTRY_").setValue("");
    _g().getWidgetByName("P_COMPANY").setValue("");
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else{

	}