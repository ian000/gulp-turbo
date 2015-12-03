gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
fs     = require 'fs'
data   = require 'gulp-data'
_      = require 'lodash'
util   = require 'gulp-util'
jade   = require 'gulp-jade'
define = require './define'
{approot,distPath,wwwroot} = global.feScaffoldConf

#jade
gulp.task 'jade', ()->
  currFile = null
  LOCALS =
    wwwroot : wwwroot
  gulp.src [approot+'/src/jade/**/*.jade','!'+approot+'/src/jade/layout/*.*','!'+approot+'/src/jade/module/**/*.jade']
    .pipe data (file)->
      currFile = file
      util.log 'jade file.path-->',file.path
      $CONFIG= file.path.replace(/\.jade/,'\_$config\.json')
      if fs.existsSync($CONFIG)
        _data = _.assign({}, JSON.parse(fs.readFileSync($CONFIG)), LOCALS)
        return _data;
      else
        _data = _.assign({}, {}, LOCALS);
        return _data;
    .on 'error',(e)->
      util.log 'jade-error->',e.toString()+'    @========>'+ currFile.path
    .pipe jade
          pretty: true
    .pipe gulp.dest distPath+'/html/'
