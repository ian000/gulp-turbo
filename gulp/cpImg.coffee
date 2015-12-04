gulp       = global.globalGulp or require 'gulp'
pkg        = global.pkg
define = require './define'
{approot,distPath} = pkg
# copy images
gulp.task 'cpImg', ()->
  gulp.src approot+'/src/img/**/*.*'
    .pipe gulp.dest distPath+'/img'
