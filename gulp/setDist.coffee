gulp   = require 'gulp'

# set dist
gulp.task 'setDist',[],()->
  global.pkg.distMode = 'dist'
  global.pkg.distPath = global.pkg.approot+'/'+global.pkg.distMode
