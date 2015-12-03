gulp       = global.globalGulp or require 'gulp'
pkg    = global.pkg
jade    = require 'gulp-jade'
wrapAmd = require 'gulp-wrap-amd'
define  = require './define'
{approot,wwwroot} = global.feScaffoldConf
# jade to js
gulp.task 'jadeToJs', ()->
  YOUR_LOCALS = {
    wwwroot : wwwroot
  }
  gulp.src [approot+'/src/jade/module/**/*.jade']
    .pipe jade
          client: true
          locals: YOUR_LOCALS
    .pipe wrapAmd
        deps: ['jade'],
        params: ['jade']
    .pipe gulp.dest approot+'/dev/js/tpl/'
