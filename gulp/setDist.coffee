gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
define = require './define'

{approot,distMode,distMode,distPath} = pkg
# set dist
gulp.task 'setDist',[],()->
  distMode = 'dist'
  distPath   = approot+'/'+distMode
