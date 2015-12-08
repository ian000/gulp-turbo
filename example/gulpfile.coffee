gulp       = require 'gulp'
requireDir = require 'require-dir'

#your require should be  " turbo = require'gulp-turbo' "
turbo       = require '../index'
porjectConf = require './porject-conf.json'

#register into global
global.globalGulp = gulp
global.pkg        = porjectConf

requireDir turbo.dir

# tasks
gulp.task 'compile'      , ['jade','jadeToJs','stylus','coffee','cpVender','cpImg']
gulp.task 'dev'          , ['jsonlint','compile','proxy','server','watch']
gulp.task 'dist'         , ['setDist','rMin','server','watch']

gulp.task 'default',['dev'];
