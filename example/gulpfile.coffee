gulp       = require 'gulp'
requireDir = require 'require-dir'

#your require should be  " turbo = require'gulp-turbo' "
turbo      = require '../index'
pkg        = require './package.json'

#register into global
global.globalGulp = gulp
global.pkg        = pkg

requireDir turbo.dir

# tasks
#gulp.task 'compile'      , ['jade','jadeToJs','stylus','coffee','cpVender','cpImg']
#gulp.task 'compile:dev'  , ['setDev','compile']
#gulp.task 'compile:dist' , ['setDist','compile']
#gulp.task 'lint'         , ['jsonlint']
gulp.task 'dev'          , ['lint','setDev','compile','proxy','server','watch']
gulp.task 'dist'         , ['setDist','jade','stylus','rMin','cpVender','cpImg','server','watch']

gulp.task 'default',['dev'];
