require.config({
  paths: {
    jade: '../vender/runtime',
    mainTpl: 'tpl/table'
  }
});

require(['jade', 'mainTpl'], function(jade, tpl) {
  return document.body.innerHTML = tpl({
    "arr1": ["asdasd", "dddd"]
  });
});

//# sourceMappingURL=.maps/page2.js.map
