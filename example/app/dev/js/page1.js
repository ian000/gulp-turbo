require.config({
  paths: {
    jade: '../vender/runtime',
    mainTpl: 'tpl/page1_body'
  }
});

require(['jade', 'mainTpl'], function(jade, tpl) {
  var o;
  o = document.createElement("div");
  o.innerHTML = tpl({
    "arr1": ["ccc", "dddd"]
  });
  return document.body.appendChild(o);
});

//# sourceMappingURL=.maps/page1.js.map
