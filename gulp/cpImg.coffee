gulp       = require 'gulp'
pkg        = global.pkg
define     = require './define'

# copy images
gulp.task 'cpImg', ()->
  {approot,distPath} = pkg
  gulp.src approot+'/src/img/**/*.*'
    .pipe gulp.dest distPath+'/img'
