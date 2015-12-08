gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
define = require './define'

# copy vender
gulp.task 'cpVender', ()->
  {approot,distPath} = pkg
  gulp.src approot+'/src/vender/**/*.*'
    .pipe gulp.dest distPath+'/vender'
