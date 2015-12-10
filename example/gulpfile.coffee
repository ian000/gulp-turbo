gulp       = require 'gulp'
requireDir = require 'require-dir'

#your require should be  " turbo = require'gulp-turbo' "
turbo       = require '../index'
porjectConf = require './porject-conf.json'

global.pkg        = porjectConf

requireDir turbo.dir

gulp.task 'default',['dev'];
