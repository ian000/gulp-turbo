gulp   = require 'gulp'
pkg    = global.pkg
define = require './define'

# copy vender
gulp.task 'cpVender', ()->
  {approot,distMode} = pkg
  gulp.src approot+'/src/vender/**/*.*'
    .pipe gulp.dest approot+'/dev/vender'

  if distMode=='dist'
    gulp.src approot+'/src/vender/**/*.*'
      .pipe gulp.dest approot+'/'+distMode+'/vender'
