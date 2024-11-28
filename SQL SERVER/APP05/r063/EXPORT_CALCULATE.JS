const P_COMPANY1 = _g().getParameterContainer().getWidgetByName("P_COMPANY").getValue();
const P_DATE = _g().getParameterContainer().getWidgetByName("P_DATE").getValue();
const P_VERSION = _g().getParameterContainer().getWidgetByName("P_VERSION").getValue();

var url = servletURL + 
    "?viewlet=App05/r074.cpt" +  // 设置报表路径
    "&op=export" +
    "&sessionID=" + session_id +
    "&format=excel" +
    "&extype=simple" +
    "&P_COMPANY=" + P_COMPANY1 +  // 添加公司参数
    "&P_DATE=" + P_DATE +        // 添加日期参数
    "&P_VERSION=" + P_VERSION +  // 添加版本参数
    "&__filename__=" + filename + '_' + P_DATE + P_VERSION + P_COMPANY  + '_'  + today;

window.open(url);