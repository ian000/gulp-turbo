require.config
    paths:
        jade: '../vender/runtime'
        mainTpl:'tpl/demo_body'
        mod1:'module/mod1'

require ['jade','mainTpl'], (jade, tpl)->
  o = document.createElement "div"
  o.innerHTML = tpl $CONFIG
  document.body.appendChild o
