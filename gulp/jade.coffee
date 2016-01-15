gulp   = require 'gulp'
path   = require 'path'
fs     = require 'fs'
chalk = require 'chalk'
data   = require 'gulp-data'
_      = require 'lodash'
util   = require 'gulp-util'
jade   = require 'gulp-jade'


#jade
gulp.task 'jade', ()->
  {approot,distPath,wwwroot} = global.pkg
  LOCALS =
    wwwroot : wwwroot
  gulp.src [approot+'/src/jade/**/*.jade','!'+approot+'/src/jade/layout/*.*','!'+approot+'/src/jade/module/**/*.jade']

    .pipe data (file)->
      util.log  chalk.blue('[jade compress]', path.relative(approot + '/src/jade/', file.path))
      currFile = file
      $CONFIG= file.path.replace(/\.jade/,'\_$config\.json')
      if fs.existsSync($CONFIG)
        _$CONFIG =
        	$CONFIG : JSON.parse(fs.readFileSync($CONFIG))
        _data = _.assign({}, _$CONFIG, LOCALS)
        return _data;
      else
        _data = _.assign({}, {}, LOCALS);
        return _data;
    .on 'error',(e)->
      util.log chalk.red('jade-error->',e.toString()+'    ========>'+ currFile.patutil.log)
    .pipe jade
          pretty: true
    .pipe gulp.dest distPath+'/html/'
