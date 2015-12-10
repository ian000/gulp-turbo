gulp   = require 'gulp'
util   = require 'gulp-util'
# watcher
gulp.task 'watch',[],()->
  pkg = global.pkg
  {approot,wwwroot,distMode} = pkg

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

  # if distMode=='dist'
  #   dist_watcher = gulp.watch [approot + '/dev/**/*.js'], ['rMin']
  #   dist_watcher.on 'change', (event)->
  #     util.log 'File ' + event.path + ' was ' + event.type + ', running rMin tasks...'