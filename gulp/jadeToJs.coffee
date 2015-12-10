gulp       = require 'gulp'
jade    = require 'gulp-jade'
wrapAmd = require 'gulp-wrap-amd'
# jade to js
gulp.task 'jadeToJs', ()->
  {approot,wwwroot} = global.pkg
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
