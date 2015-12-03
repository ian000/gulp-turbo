util   = require 'gulp-util'
pkg    = global.pkg
_      = require 'lodash'
define = require './define'
path   = require 'path'

#log
util.log "pkg.routerPath",pkg.routerPath

# define
{approot,distMode,domain,routerPath} = global.feScaffoldConf =
  approot    : 'app'
  distMode   : 'dev'
  routerPath : pkg.routerPath
  domain     : '//static.xiaojukeji.com'
  vhost      : 'http://static.diditaxi.com.cn'

#extends feScaffold config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : domain+routerPath
global.feScaffoldConf = _.assign global.feScaffoldConf, extconf
