util   = require 'gulp-util'
pkg    = global.pkg
_      = require 'lodash'
define = require './define'
path   = require 'path'

#log
util.log "pkg.routerPath",pkg.routerPath

# define
{approot,distMode,domain,routerPath} = pkg

#extends feScaffold config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : domain+routerPath
global.pkg = _.assign pkg, extconf
