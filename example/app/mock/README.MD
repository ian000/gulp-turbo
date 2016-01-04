# 目录说明
> 此目录用于放置用于模拟假接口的数据json文件。
> 例：如果存在 app/mock/data1.json文件，你可以使用ajax访问 http://static.xxxx.com/data
> 推荐此接口地址放置于$CONFIG中配置，这样一来，当后端变动接口地址时，前端只需要改动$CONFIG相应字段即可。
> gulp任务将自动校验此json文件的有效性。debug时请注意观察命令行错误提示

```javascript

  // app/src/jade/page1_.$config.json
  {
    getInfo:'http://static.xxxx.com/getInfo'
  }

  // app/src/coffee/page1.js
  $.get($.CONFIG.data1,function(){
    // TODO
  });

  /*
  * 假数据开发约定
  * 1.按照业务线约定 10000 代表成功
  * 2. status如果不存在将视为后端返回的非法数据。
  * 3.请求回来的数据放在data里。  
  */

  // app/mock/getInfo.json

  {
  	"status":10000,
  	"data":[
  		{
  				"aa":1111
  		}
  	]
  }
、、
```
