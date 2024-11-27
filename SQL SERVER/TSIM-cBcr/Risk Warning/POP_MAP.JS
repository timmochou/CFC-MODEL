const TYPE = _g().getWidgetByName("BTN_TYPE").getValue();
if(TYPE == "0"){
	_g().getWidgetByName("BTN_TYPE").setValue(BTN_TYPE);
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else if(TYPE == "") {
	_g().getWidgetByName("BTN_TYPE").setValue(BTN_TYPE);
	_g().getWidgetByName("P_COUNTRY").setValue(P_COUNTRY);
	_g().getWidgetByName("P_COMPANY_").setValue("");
	}
else {
	}
