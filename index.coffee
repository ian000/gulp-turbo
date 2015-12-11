_    = require 'lodash'
path = require 'path'
util = require 'gulp-util'
requireDir = require 'require-dir'
defaultConf = require path.join(process.cwd(), './project-conf.json')

{approot,distMode,domain,routerPath} = defaultConf
#extends feScaffold config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : domain+routerPath
global.pkg = _.assign defaultConf, extconf

requireDir './gulp'