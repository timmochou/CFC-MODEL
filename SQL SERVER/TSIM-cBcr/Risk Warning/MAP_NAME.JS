function(){ 
    var name_array = []; 
    var hint_array = [];
    var hint2_array = [];
    var hint;
    var text;
    if($("td[id^=A1-]","div#REP_MAP").text() == "zh_TW"){ 
        text = "發生次數： ";
    }
    else if($("td[id^=A1-]","div#REP_MAP").text() == "en_US"){ 
        text = "Occurrences: ";
    }
    for (var i = 1; i < 100; i++){
     if($("td[id^=B"+i+"-]","div#REP_MAP").text().length==0){
      break;
     }
     name_array.push($("td[id^=B"+i+"-]","div#REP_MAP").text());
     hint_array.push($("td[id^=C"+i+"-]","div#REP_MAP").text());
     hint2_array.push($("td[id^=D"+i+"-]","div#REP_MAP").text());
    }
    
    

    for (var j = 0; j < 100; j++){
     if(this.name == name_array[j]){
      hint = "<span style='color: #d04a02;'>●</span>" +text + hint_array[j] + " " + hint2_array[j];
      break;
     }
    }
    return  hint;}

    