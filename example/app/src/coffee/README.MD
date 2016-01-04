# 目录说明
> coffescript源码目录（支持直接写.js文件，将会直接copy到app/dev/js目录下）

## 开发约定
loder版：
> 根目录用于存放一些通用文件或配置类文件
> ./entry目录存放入口文件，与html文件名对应
> ./module目录存放模块文件
> loder.js 公用页面主文件装载器主体文件，将以此生成各个页面入口文件的伴生loder文件
> require-conf.coffee/js 项目require.config配置文件，将自动写入到各个页面入口文件的头部
> entry/page.js 范例：
```javascript
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
      var o   = document.createElement("div");
          o.innerHTML = tpl(data)
          document.body.appendChild(o)  
    }

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
```

原始版：
> 根目录用于存放requirejs 入口文件、模块文件以及其他相关js文件，以文件名对应，
> 例：page1.coffee 将服务于 app/src/jade/page1.jade
> page1.coffee 范例
```coffeescript
  require.config
      paths:
          # 浏览器端jade引擎
          jade: '../vender/runtime'

          # 页面主要模板，以 app/dev/js/tpl下的pageName_body.js识别
          mainTpl:'tpl/page1_body'

          # 也可以引入相关模块
          mod1:'module/mod1'

  require ['jade','mainTpl'], (jade, tpl)->
    o = document.createElement "div"

    # 将$CONFIG传给主模板
    o.innerHTML = tpl $CONFIG

    #将节点追加到body（已经生成了html片段了，此处行为你可以自由定制）
    document.body.appendChild o
