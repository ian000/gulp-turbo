gulp   = require 'gulp'
mkdir  = require 'mkdirp'

# the empty project init
gulp.task 'init', ( cb ) ->
  {approot} = global.pkg
  jade   = approot+'/src/jade'
  stylus = approot+'/src/stylus'
  coffee = approot+'/src/coffee'
  vender = approot+'/src/vender'
  img    = approot+'/src/img'
  mock   = approot+'/mock/'

  doc = [
    "#{jade}/layout"
    "#{jade}/module"
    "#{stylus}/module"
    "#{stylus}/font"
    "#{coffee}/lib"
    "#{coffee}/module"
    "#{vender}"
    "#{img}"
    "#{mock}"
  ]
  for val in doc
    mkdir.sync val
  cb()
