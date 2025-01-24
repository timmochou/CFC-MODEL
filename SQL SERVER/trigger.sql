if (fr_submitinfo.success) {
    alert("Submit Successed!")
    
    // 創建第一個 iframe 執行
    function executeFirstProcedure() {
        return new Promise((resolve) => {
            var iframe = $("<iframe id='inp1' name='inp1' width='100%' height='100%' scrolling='yes' frameborder='0'>");
            let url = '${servletURL}?viewlet=/App05/procedure/P_TRIGGER_ENTITY_CUR.cpt';
            iframe.attr("src", url);
            var o = {
                title: "exec P_TRIGGER_ENTITY_CUR.cpt",
                width: 700,
                height: 500
            };
            FR.showDialog(o.title, o.width, o.height, iframe);
            setTimeout(() => {
                window.FR.closeDialog();
                resolve();
            }, 5000);  // 改為5000毫秒（5秒）
        });
    }

    function executeSecondProcedure() {
        return new Promise((resolve) => {
            var iframe = $("<iframe id='inp2' name='inp2' width='100%' height='100%' scrolling='yes' frameborder='0'>");
            let url2 = '${servletURL}?viewlet=/App05/procedure/P_TEMP_TRS_FACT_CFC_RECOGNIZED_AMOUNT.cpt';
            iframe.attr("src", url2);
            var o = {
                title: "exec P_TEMP_TRS_FACT_CFC_RECOGNIZED_AMOUNT.cpt",
                width: 700,
                height: 500
            };
            FR.showDialog(o.title, o.width, o.height, iframe);
            setTimeout(() => {
                window.FR.closeDialog();
                resolve();
            }, 5000);  // 改為5000毫秒（5秒）
        });
    }
    // 依序執行兩個程序
    executeFirstProcedure()
        .then(() => executeSecondProcedure())
        .then(() => {
            window.parent.FR.closeDialog();
            if (_g().parameterEl) {
                window.parent._g().parameterCommit();
            }
        });

} else {
    alert("Submit Failed!")
}
return false;