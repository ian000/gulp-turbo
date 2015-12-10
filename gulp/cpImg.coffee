gulp       = require 'gulp'

# copy images
gulp.task 'cpImg', ()->
  {approot,distPath} = global.pkg
  gulp.src approot+'/src/img/**/*.*'
    .pipe gulp.dest distPath+'/img'
