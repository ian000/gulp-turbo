(function (window, undefined){
	// var wwwroot = 'http://xxx.bbb.com/tech-bs/';
	var entryPath = '[entryPath]';
	var conf = {
		js: {
			version: "[mainJsVersion]"
		},
		css: {
			// to do
		},
		image: {
			// to do
		}
	};

	// js
	if(entryPath){
		var requirejs = wwwroot + "/vender/require.js";
		var pagejsUrl = wwwroot + '/js/entry/' + entryPath + '.js?_v=' + conf.js.version;
		loadScript(requirejs, {'data-main': pagejsUrl});
	}

	function loadScript(url, attrs){
		var header = document.getElementsByTagName('head')[0]; 
		var node = document.createElement('script');
		if(attrs){
			for(var k in attrs){
				node.setAttribute(k, attrs[k]);
			}
		}
		node.src = url;
		header.appendChild(node);
	}
})(window);