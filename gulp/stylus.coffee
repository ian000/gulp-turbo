gulp       = require 'gulp'
util       = require 'gulp-util'
chalk      = require 'chalk'
stylus     = require 'gulp-stylus'
sourcemaps = require 'gulp-sourcemaps'
through    = require 'through2'
_          = require 'lodash'
path       = require 'path'

# stylus - with sourcemaps
gulp.task 'stylus', ()->
    pkg = global.pkg
    {base,approot,distMode,distPath} = pkg
    if(distMode is 'dist')
      isCompress = true

    gulp.src [base+'/'+approot+'/src/stylus/**/*.styl','!'+base+'/'+approot+'/src/stylus/module/**/*.styl']
    .pipe sourcemaps.init()
    .pipe stylus
            compress: isCompress
    .pipe through.obj (file, enc, cb)->
        util.log chalk.cyan('[stylus compress] ', path.relative(approot + '/src/stylus/', file.path), ' --> ', file.contents.length, 'bytes')
        this.push file
        cb()
    .pipe sourcemaps.write '.maps'
    .pipe gulp.dest base+'/'+distPath+'/css/'
