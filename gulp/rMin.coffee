gulp       = require 'gulp'
chalk      = require 'chalk'
util       = require 'gulp-util'
requirejs  = require 'gulp-requirejs'
sourcemaps = require 'gulp-sourcemaps'
through    = require 'through2'
uglify     = require 'gulp-uglify'
path       = require 'path'
md5        = require 'md5'

#requirejs min
gulp.task 'rMin',()->
    pkg = global.pkg
    {approot,distPath} = pkg
    gulp.src approot+'/dev/js/*.js',
        read: false
      .pipe rjs
        base: approot+'/dev/js/'
        dest: approot+'/dist/js/'
rjs_cache = {}
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
    .pipe through.obj (file, enc, cb)->
      fileMd5 = md5 file.contents
      if rjs_cache[file.path] isnt fileMd5
        rjs_cache[file.path] = fileMd5
        this.push file
        cb()
    .pipe sourcemaps.init()
    .pipe uglify
      output:
        beautify: false
        indent_level: 1
    .pipe through.obj (file, enc, cb)->
      util.log chalk.magenta 'compress ', fname, ' --> ', file.contents.length, 'bytes'
      this.push file
      cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest opts.dest
    cb()
    return
