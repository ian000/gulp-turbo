gulp       = require 'gulp'
fs         = require 'fs'
util       = require 'gulp-util'
coffee     = require 'gulp-coffee'
through    = require 'through2'
sequence   = require 'gulp-sequence'
rename     = require 'gulp-rename'
path       = require 'path'

#支持不熟悉coffee的同学直接写js
gulp.task '_cpJs', ()->
  {approot}  = global.pkg

  gulp.src approot+'/src/coffee/**/*.js'
    .pipe gulp.dest approot+'/dev/js'

# coffee编译
gulp.task '_coffee', ()->
  {approot}  = global.pkg
  
  gulp.src [approot+'/src/coffee/**/*.coffee']
    .pipe coffee
            bare: true
          .on 'error', util.log
    .pipe gulp.dest approot+'/dev/js'

# 拼装config
gulp.task '_addRequireConf', ()->
  {approot}  = global.pkg

  requireConfPath = approot + '/dev/js/require-conf.js'

  if fs.existsSync requireConfPath
    gulp.src [approot + '/dev/js/entry/**/*.js', '!'+approot+'/dev/js/entry/**/*_loder.js']
      .pipe through.obj (file, enc, cb)->
          requireConf = fs.readFileSync requireConfPath, 'utf8'
          contents = requireConf + '\n' + file.contents.toString()
          file.contents = new Buffer contents
          this.push file
          cb()
      .pipe gulp.dest approot+'/dev/js/entry/'

# 生成loder
gulp.task '_buildLoder', ()->
  {approot}  = global.pkg

  loderPath = approot + '/dev/js/loder.js'
  
  if fs.existsSync loderPath
    gulp.src [approot + '/dev/js/entry/**/*.js', '!'+approot+'/dev/js/entry/**/*_loder.js']
      .pipe through.obj (file, enc, cb)->
          loderCon = fs.readFileSync loderPath, 'utf8'
          filename = path.basename file.path, '.js'
          loderCon = loderCon.replace /\[entryPath\]/g, filename
          file.contents = new Buffer loderCon
          this.push file
          cb()
      .pipe rename (path)->
        path.basename += '_loder'
      .pipe gulp.dest approot+'/dev/js/entry/'

# coffee
gulp.task 'coffee', (cb)->
  sequence '_cpJs', '_coffee', '_addRequireConf', '_buildLoder', 'clean:dev-loderAndConf', cb