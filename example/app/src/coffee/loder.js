(function (window, undefined){
	var entryPath = '[entryPath]';
	var conf = {
		js: {
			version: "[mainJsVersion]"
		},
		css: {
			// to do
			version: "[mainCssVersion]"
		},
		image: {
			// to do
			version: "[mainImageVersion]"
		}
	};

	// 加载css
	loadCss(function (){
		// 加载js
		if(entryPath){
			var requirejs = wwwroot + "/vender/require.js";
			var pagejsUrl = wwwroot + '/js/entry/' + entryPath + '.js?_v=' + conf.js.version;
			loadScript(requirejs, {'data-main': pagejsUrl});
		}
	});
	loadImages();
	
	// 加载图片
	function loadImages(){
		var imgs = document.getElementsByTagName('img');
		for(var i = 0; i < imgs.length; i++){
			var img = imgs[i];
			var src = img.getAttribute('loder-src');
			if(src){
				img.src = src + '?_v=' + conf.image.version;
			}
		}
	}
	// 加载管理css资源
	function loadCss(cb){
		var links = document.getElementsByTagName('link');
		var flag = {};
		var checkFn = function (){
			for(var k in flag){
				if(!flag[k]){
					setTimeout(arguments.caller, 2);
				}
			}
			cb();
		};
		for(var i = 0; i < links.length; i++){
			var link = links[i];
			var src = link.getAttribute('loder-src');
			if(src){
				flag.loaded = 0;
				link.onload = function (){
					flag.loaded = 1;
				};
				link.href = src + '?_v=' + conf.css.version;	
			}
		}

		checkFn();
	}
	// 加载js
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