_    = require 'lodash'
path = require 'path'
util = require 'gulp-util'
requireDir = require 'require-dir'
defaultConf = require path.join(process.cwd(), './project-conf.json')

{approot,distMode,domain,routerPath} = defaultConf

defaultConf.routerPath = routerPath = routerPath.replace(/^\//,'')

#extends project config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : domain+'/'+path.normalize routerPath
global.pkg = _.assign defaultConf, extconf

requireDir './gulp'
