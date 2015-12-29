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

# 兼容老版本 合并压缩js根目录下的main JS
gulp.task '_oldverMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg

  gulp.src approot+'/dev/js/*.js',
      read: false
    .pipe rjs
      base: approot+'/dev/js/'
      dest: approot+'/dist/js/'

# 合并压缩entry目录下的main JS
gulp.task '_entryMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg

  gulp.src [approot+'/dev/js/entry/**/*.js', '!'+approot+'/dev/js/entry/**/*-loder.js'],
      read: false
    .pipe rjs2
      base: approot+'/dev/js/'
      dest: approot+'/dist/js/entry/'

# 
gulp.task '_loderMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg

  gulp.src [approot+'/dev/js/entry/**/*-loder.js']
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
      util.log chalk.magenta 'compress ', path.relative(approot+'/dev/js/', file.path), ' --> ', file.contents.length, 'bytes'
      this.push file
      cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest approot+'/dist/js/entry/'

gulp.task '_loderAddVer', ()->
  pkg = global.pkg
  {approot,distPath} = pkg
  gulp.src [approot+'/dist/js/entry/**/*-loder.js']
    .pipe through.obj (file, enc, cb)->
        mainFilePath = path.relative approot + '/dist/js/', file.path
        mainFilePath = mainFilePath.replace(/(\-loder)\.js$/, '.js')
        contsMD5 = rjs_cache[mainFilePath]
        loderCon = file.contents.toString()
        loderCon = loderCon.replace /\[mainJsVersion\]/g, contsMD5
        util.log chalk.yellow mainFilePath, ' is version: ', contsMD5
        file.contents = new Buffer loderCon
        this.push file
        cb()
    .pipe gulp.dest approot+'/dist/js/entry/'

#requirejs min
gulp.task 'rMin', (cb)->
  sequence '_oldverMin', '_entryMin', '_loderMin', '_loderAddVer', cb

rjs_cache = {}
rjs = ( opts ) ->
  through.obj ( file, enc, cb ) ->
    fname = path.basename file.path
    filename = path.basename file.path, '.js'
    filepath = path.relative opts.base, file.path

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
    .pipe gulp.dest opts.dest
    cb()
    return

rjs2 = ( opts ) ->
  through.obj ( file, enc, cb ) ->
    fname = path.basename file.path
    filename = path.basename file.path, '.js'
    filedir = path.dirname file.path
    relativePath = path.relative opts.base, filedir
    filepath = path.relative opts.base, file.path

    # console.log filepath, relativePath,filename, fname, filedir
    requirejs
      baseUrl: opts.base
      mainConfigFile: "#{filedir}/#{fname}"
      name: "#{relativePath}/#{filename}"
      out: fname
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
    .pipe gulp.dest opts.dest
    cb()
    return
