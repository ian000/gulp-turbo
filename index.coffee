_    = require 'lodash'
path = require 'path'
util = require 'gulp-util'
requireDir = require 'require-dir'
defaultConf = require path.join(process.cwd(), './project-conf.json')

{approot,distMode,domain,routerPath} = defaultConf

defaultConf.routerPath = routerPath = routerPath.replace(/^\//,'')

domain     = '//'+domain if domain.search(/^https?:\/\/|^\/\//) is -1
routerPath = path.normalize '/'+routerPath
wwwroot    = (domain+routerPath).replace /\/$/,''

#extends project config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : wwwroot
global.pkg = _.assign defaultConf, extconf

requireDir './gulp'
