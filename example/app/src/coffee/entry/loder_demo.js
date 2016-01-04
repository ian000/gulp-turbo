
/**
 * 只与本页面相关的js逻辑写在这里
 */
require([
		'tpl/loder_demo_body'
	],
	function (tpl){

		/**
		 * 用数据渲染body模板，并追加到document.body下
		 * @param  {object} data 模板数据
		 * @return {[type]}
		 */
		function appdBody(data){
			var o 	= document.createElement("div");
        	o.innerHTML = tpl(data)
        	document.body.appendChild(o)	
		}
		console.log(333)

		/**
		 * 按依赖顺序执行模块的init方法。
		 * @return {[type]} [description]
		 */
		function initMods(){
			var mods = Array.prototype.slice.call(arguments);
			for(var i = 0; i < mods.length; i++){
				var mod = mods[i];
				if(mod && typeof mod.init === 'function'){
					mod.init();
				}
			}	
		}

		//$CONFIG渲染页面模板
		appdBody($CONFIG);

		//init
		initMods();

	});
