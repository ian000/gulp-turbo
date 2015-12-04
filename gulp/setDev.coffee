gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
define = require './define'
{approot,distMode,distMode,distPath} = pkg
# set dev
gulp.task 'setDev',[],()->
  distMode = 'dev'
  distPath   = approot+'/'+distMode
