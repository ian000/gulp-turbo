gulp   = global.globalGulp or require 'gulp'

# set dist
gulp.task 'setDist',[],()->
  global.pkg.distMode = 'dist'
  global.pkg.distPath = global.pkg.approot+'/'+global.pkg.distMode
  console.log 'setDist->',global.pkg.distMode
