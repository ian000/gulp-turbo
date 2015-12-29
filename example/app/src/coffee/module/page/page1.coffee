define ['module/mod2', 'mainTpl'], (mod2, tpl)->
	ret = 
		init: ()->
			o = document.createElement "div"
			o.innerHTML = tpl()
			document.body.appendChild o
	return ret