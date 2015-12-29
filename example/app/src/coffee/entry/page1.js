require([
	'mod1',
	'module/page/page1'
	],
	function (){
		var mods = Array.prototype.slice.call(arguments);
		for(var i = 0; i < mods.length; i++){
			var mod = mods[i];
			if(mod && typeof mod.init === 'function'){
				mod.init();
			}
		}
	});