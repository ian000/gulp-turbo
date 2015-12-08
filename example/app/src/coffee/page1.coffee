require.config
    paths:
        jade: '../vender/runtime'
        mainTpl:'tpl/page1_body'

require ['jade','mainTpl'], (jade, tpl)->
  o = document.createElement "div"
  o.innerHTML = tpl
  					"arr1":["ccc","dddd"]
  document.body.appendChild o
