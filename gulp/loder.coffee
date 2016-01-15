fs         = require 'fs'
gulp       = require 'gulp'
chalk      = require 'chalk'
util       = require 'gulp-util'
requirejs  = require 'gulp-requirejs'
sourcemaps = require 'gulp-sourcemaps'
through    = require 'through2'
uglify     = require 'gulp-uglify'
path       = require 'path'
md5        = require 'md5'
folderMd5  = require '../lib/folderMd5'
turboCache = require '../lib/turboCache'
mkdirSync  = require '../lib/mkdirSync'

# 压缩page loder
loder_cache = {}
gulp.task 'loderMin', ()->
  pkg = global.pkg
  {approot,distPath} = pkg

  loder_cache = turboCache pkg.base
  # 获取css和image文件夹md5值
  cssFolderMd5 = folderMd5(approot + '/dist/css/') || '0'
  imageFolderMd5 = folderMd5(approot + '/dist/img/') || '0'
  util.log chalk.yellow 'css folder version: ', cssFolderMd5
  util.log chalk.yellow 'images folder version: ', imageFolderMd5
  
  md5s = {}
  jsDist = path.join approot, '/dist/js/'
  jsDev = path.join approot, '/dev/js/'
  gulp.src [approot+'/dev/js/entry/**/*_loder.js']
    .pipe through.obj (file, enc, cb)->
      # 获取main文件js位置相对路径，然后从cache中得到最新的MD5值，替换loder中的js version
      mainFilePath = path.relative jsDev, file.path
      mainFilePath = mainFilePath.replace(/(\_loder)\.js$/, '.js')
      contsMD5 = loder_cache.getFile(mainFilePath) || '0'
      loderCon = file.contents.toString()
      loderCon = loderCon.replace(/\[mainJsVersion\]/g, contsMD5)
                         .replace(/\[mainCssVersion\]/g, cssFolderMd5)
                         .replace(/\[mainImageVersion\]/g, imageFolderMd5)
      file.contents = new Buffer loderCon

      # 判断loder文件是否变更，变更则进行压缩
      fileMd5 = md5 file.contents
      result = loder_cache.getFile fileMd5
      md5s[file.path] = fileMd5
      if result
        _filepath = path.join(jsDist, path.relative(jsDev, file.path))
        mkdirSync path.dirname(_filepath)
        util.log '[loder turboCache]: ', path.relative(jsDev, file.path), ' [', fileMd5, ']'
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
      util.log chalk.magenta '[loder compress] ', path.relative(jsDev, file.path), ' --> ', file.contents.length, 'bytes [', md5s[file.path], ']'
      loder_cache.setFile file.contents, md5s[file.path], file.path 
      this.push file
      cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest approot+'/dist/js/entry/'