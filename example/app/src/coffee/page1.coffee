require.config
    paths:
        jade: '../vender/runtime'
        mainTpl:'tpl/page1_body'
        mod1:'module/mod1'

require ['jade','mainTpl'], (jade, tpl)->
  o = document.createElement "div"
  o.innerHTML = tpl()
  document.body.appendChild o
