gulp       = require 'gulp'
chalk      = require 'chalk'
util       = require 'gulp-util'
requirejs  = require 'gulp-requirejs'
sourcemaps = require 'gulp-sourcemaps'
through    = require 'through2'
uglify     = require 'gulp-uglify'
path       = require 'path'
md5        = require 'md5'
sequence   = require 'gulp-sequence'

# 兼容老版本 合并压缩entry目录下的main JS
gulp.task '_rMainMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg

  gulp.src [approot+'/dev/js/*.js', approot+'/dev/js/entry/**/*.js', '!'+approot+'/dev/js/entry/**/*_loder.js'],
      read: false
    .pipe rjs
      base: approot+'/dev/js/'
      dest: approot+'/dist/js/'

# 压缩page loder
gulp.task '_loderMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg

  gulp.src [approot+'/dev/js/entry/**/*_loder.js']
    .pipe through.obj (file, enc, cb)->
      # 获取main文件js位置相对路径，然后从cache中得到最新的MD5值，替换loder中的js version
      mainFilePath = path.relative approot + '/dev/js/', file.path
      mainFilePath = mainFilePath.replace(/(\_loder)\.js$/, '.js')
      contsMD5 = rjs_cache[mainFilePath]
      loderCon = file.contents.toString()
      loderCon = loderCon.replace /\[mainJsVersion\]/g, contsMD5
      file.contents = new Buffer loderCon

      # 判断loder文件是否变更，变更则进行压缩
      fileMd5 = md5 file.contents
      if rjs_cache[file.path] isnt fileMd5
        util.log chalk.yellow mainFilePath, ' is version: ', contsMD5
        rjs_cache[file.path] = fileMd5
        this.push file
      cb()
    .pipe sourcemaps.init()
    .pipe uglify
      output:
        beautify: false
        indent_level: 1
    .pipe through.obj (file, enc, cb)->
      util.log chalk.magenta 'compress ', path.relative(approot+'/dev/js/', file.path), ' --> ', file.contents.length, 'bytes'
      this.push file
      cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest approot+'/dist/js/entry/'

#requirejs min
gulp.task 'rMin', (cb)->
  sequence '_rMainMin', '_loderMin', cb

rjs_cache = {}

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
      if rjs_cache[filepath] isnt fileMd5
        rjs_cache[filepath] = fileMd5
        this.push file
        cb()
    .pipe sourcemaps.init()
    .pipe uglify
      output:
        beautify: false
        indent_level: 1
    .pipe through.obj (file, enc, cb)->
      util.log chalk.magenta 'compress ', filepath, ' --> ', file.contents.length, 'bytes'
      this.push file
      cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest dist
    cb()
    return
