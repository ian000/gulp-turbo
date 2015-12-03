gulp       = global.globalGulp or require 'gulp'
pkg    = global.pkg
util       = require 'gulp-util'
requirejs  = require 'gulp-requirejs'
sourcemaps = require 'gulp-sourcemaps'
through    = require 'through2'
uglify     = require 'gulp-uglify'
path       = require 'path'
define     = require './define'
{approot,distPath} = global.feScaffoldConf
#requirejs min
gulp.task 'rMin',['setDev','compile'],()->
    gulp.src approot+'/dev/js/*.js',
        read: false
      .pipe rjs
        base: approot+'/dev/js/'
        dest: approot+'/dist/js/'

rjs = ( opts ) ->
  through.obj ( file, enc, cb ) ->
    fname = path.basename file.path
    filename = path.basename file.path, '.js'
    requirejs
      baseUrl: opts.base
      mainConfigFile: "#{opts.base}/#{fname}"
      name: filename
      out: fname
      optimize: 'uglify2'
      paths: opts.paths or {}
      excludeShallow: opts.excludeShallow or []
      inlineText: true
      removeCombined: true
      findNestedDependencies: true
    .pipe sourcemaps.init()
    .pipe uglify
      output:
        beautify: false
        indent_level: 1
    .pipe sourcemaps.write '.maps'
    # .pipe rename
    #   extname: '_min.js'
    .pipe pipeHandle (file, enc)->
      util.log 'compress ', fname, ' --> ', file.contents.length, 'bytes'
    .pipe gulp.dest opts.dest
    cb()
    return

pipeHandle = (fn)->
  through.obj (file, enc, cb)->
    try
      fn(file, enc)
    catch e
      console.log '[ERROR] pipeHandle(fn) ', e.toString()
    cb()
