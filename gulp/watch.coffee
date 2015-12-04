gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
util   = require 'gulp-util'
define = require './define'
{approot,wwwroot} = pkg

# watcher
gulp.task 'watch',[],()->

  # jade
  jade_watcher = gulp.watch approot + '/src/**/*.jade', ['jadeToJs','jade']
  jade_watcher.on 'change', (event)->
    util.log 'File ' + event.path + ' was ' + event.type + ', running jade tasks...'

  # stylus
  stylus_watcher = gulp.watch approot + '/src/**/*.styl', ['stylus']
  stylus_watcher.on 'change', (event)->
    util.log 'File ' + event.path + ' was ' + event.type + ', running stylus tasks...'

  #coffee
  coffee_watcher = gulp.watch [approot + '/src/**/*.coffee',approot + '/src/**/*.js'], ['coffee']
  coffee_watcher.on 'change', (event)->
    util.log 'File ' + event.path + ' was ' + event.type + ', running coffee tasks...'

  #cpImg
  cpImg_watcher = gulp.watch [approot + '/src/img/**/*.*'], ['cpImg']
  cpImg_watcher.on 'change', (event)->
    util.log 'File ' + event.path + ' was ' + event.type + ', running cpImg tasks...'

  #cpVender
  cpVender_watcher = gulp.watch [approot + '/src/vender/**/*.*'], ['cpVender']
  cpVender_watcher.on 'change', (event)->
    util.log 'File ' + event.path + ' was ' + event.type + ', running cpVender tasks...'
  #cpVender
  jsonLint_watcher = gulp.watch [approot + '/src/vender/**/*.*'], ['cpVender']
  cpVender_watcher.on 'change', (event)->
    util.log 'File ' + event.path + ' was ' + event.type + ', running cpVender tasks...'
