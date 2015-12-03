gulp       = global.globalGulp or require 'gulp'
pkg        = global.pkg
util       = require 'gulp-util'
coffee     = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
define     = require './define'
{approot,distPath} = global.feScaffoldConf

# coffee
gulp.task 'coffee', ()->
  gulp.src [approot+'/src/coffee/**/*.coffee','!'+approot+'/src/coffee/module/**/*.coffee']
    .pipe sourcemaps.init()
    .pipe coffee
            bare: true
          .on 'error', util.log
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest distPath+'/js/'

  #支持不熟悉coffee的同学直接写js
  gulp.src approot+'/src/coffee/**/*.js'
    .pipe gulp.dest distPath+'/js'
