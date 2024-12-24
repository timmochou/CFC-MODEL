var toast = FR.Msg.toast;
FR.Msg.toast = function(msg) {
if (1 == 1) {
return;
} else {
toast.call(FR.Msg, msg);
}
}