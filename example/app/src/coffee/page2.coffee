require.config
    paths:
        jade: '../vender/runtime'
        mainTpl:'tpl/table'

require ['jade','mainTpl'], (jade, tpl)->
	document.body.innerHTML = tpl({"arr1":["asdasd","dddd"]})