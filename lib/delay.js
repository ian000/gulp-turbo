/**
* @lock 延迟触发的函数
* @example
* var delay = require('delay');
* var comp = {
* 	countWords : function(){
* 		console.info(this.length);
* 	}
* };
* $('#input').keydown($delay(function(){
* 	this.length = $('#input').val().length;
* 	this.countWords();
* }, 200, comp));
**/

/**
包装为延迟触发的函数
@param {function} fn 要延迟触发的函数
@param {number} delay 延迟时间[ms]
@param {object} [bind] 函数的this指向
**/
function delay(fn, delay, bind){
	var timer = null;
	return function(){
		bind = bind || this;
		if(timer){clearTimeout(timer);}
		var args = arguments;
		timer = setTimeout(function(){
			fn.apply(bind, args);
		}, delay);
	};
}

module.exports = delay;