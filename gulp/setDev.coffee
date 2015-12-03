gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
define = require './define'
{approot,distMode,distMode,distPath} = global.feScaffoldConf
# set dev
gulp.task 'setDev',[],()->
  distMode = 'dev'
  distPath   = approot+'/'+distMode
