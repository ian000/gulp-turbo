gulp       = require 'gulp'
util       = require 'gulp-util'
coffee     = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'

# coffee
gulp.task 'coffee', ()->
  {approot}  = global.pkg
  
  gulp.src [approot+'/src/coffee/**/*.coffee']
    .pipe sourcemaps.init()
    .pipe coffee
            bare: true
          .on 'error', util.log
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest approot+'/dev/js'

  #支持不熟悉coffee的同学直接写js
  gulp.src approot+'/src/coffee/**/*.js'
    .pipe gulp.dest approot+'/dev/js'
