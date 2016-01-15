gulp       = require 'gulp'
fs         = require 'fs'
chalk      = require 'chalk'
util       = require 'gulp-util'
requirejs  = require 'gulp-requirejs'
sourcemaps = require 'gulp-sourcemaps'
through    = require 'through2'
uglify     = require 'gulp-uglify'
path       = require 'path'
md5        = require 'md5'
turboCache = require '../lib/turboCache'
mkdirSync  = require '../lib/mkdirSync'

rjs_cache = {}
# 兼容老版本 合并压缩entry目录下的main JS
gulp.task 'rMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg
  
  rjs_cache = turboCache pkg.base

  gulp.src [approot+'/dev/js/*.js', approot+'/dev/js/entry/**/*.js', '!'+approot+'/dev/js/entry/**/*_loder.js'],
      read: false
    .pipe rjs
      base: approot+'/dev/js/'
      dest: approot+'/dist/js/'

rjs = ( opts ) ->
  through.obj ( file, enc, cb ) ->
    fname = path.basename file.path
    filename = path.basename file.path, '.js'
    filedir = path.dirname file.path
    relativePath = path.relative(opts.base, filedir).replace(/\\+/g, '\/')
    filepath = path.relative opts.base, file.path

    mainConfigFile = filedir + '/' + fname
    name = if relativePath then relativePath + '/' + filename else filename
    out = fname
    dist = opts.dest + relativePath
    fileMd5 = null
    # console.log mainConfigFile, name, out, dist
    requirejs
      baseUrl: opts.base
      mainConfigFile: mainConfigFile
      name: name
      out: out
      optimize: 'uglify2'
      paths: opts.paths or {}
      excludeShallow: opts.excludeShallow or []
      inlineText: true
      removeCombined: true
      findNestedDependencies: true
    .pipe through.obj (file, enc, cb)->
      fileMd5 = md5 file.contents
      result = rjs_cache.getFile fileMd5
      if result
        _filepath = path.join(opts.dest, filepath)
        mkdirSync path.dirname(_filepath)
        util.log '[js turboCache]: ', filepath, ' [', fileMd5, ']'
        fs.writeFileSync _filepath, result
      else
        this.push file
        cb()
    .pipe sourcemaps.init()
    .pipe uglify
      output:
        beautify: false
        indent_level: 1
    .pipe through.obj (file, enc, cb)->
      util.log chalk.magenta '[js compress] ', filepath, ' --> ', file.contents.length, 'bytes [', fileMd5, ']'
      rjs_cache.setFile file.contents, fileMd5, filepath
      this.push file
      cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest dist
    cb()
    return
