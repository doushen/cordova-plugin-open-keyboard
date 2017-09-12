var options = {
	"debug":"true",//true、false
}
var _result = function(data){
	alert(JSON.stringify(data));
}
//键盘初始化
window.plugins.openKeyboard.init(options,_result);


window.addEventListener('keyboardWillShow',function(e){
	//e.keyboardHeight
});
window.addEventListener('keyboardDidShow',function(e){
	//e.keyboardHeight
});

window.addEventListener('keyboardWillHide', function(){});
window.addEventListener('keyboardDidHide', function(){});
