gulp   = require 'gulp'

# copy vender
gulp.task 'cpVender', ()->
  {approot,distMode} = global.pkg
  
  gulp.src approot+'/src/vender/**/*.*'
    .pipe gulp.dest approot+'/dev/vender'

  if distMode=='dist'
    gulp.src approot+'/src/vender/**/*.*'
      .pipe gulp.dest approot+'/'+distMode+'/vender'
