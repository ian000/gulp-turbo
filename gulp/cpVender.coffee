gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
define = require './define'
{approot,distPath} = global.feScaffoldConf
# copy vender
gulp.task 'cpVender', ()->
  gulp.src approot+'/src/vender/**/*.*'
    .pipe gulp.dest distPath+'/vender'
