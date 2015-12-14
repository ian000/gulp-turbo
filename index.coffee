_    = require 'lodash'
path = require 'path'
util = require 'gulp-util'
requireDir = require 'require-dir'
defaultConf = require path.join(process.cwd(), './project-conf.json')

{approot,distMode,domain,routerPath,httpPort} = defaultConf

defaultConf.routerPath = routerPath = routerPath.replace(/^\//,'')

domain     = '//'+domain if domain.search(/^https?:\/\/|^\/\//) is -1
domain     = domain+':'+httpPort if httpPort*1 != 80
wwwroot    = (domain+'/'+routerPath).replace /\/$|\\$/,''
routerPath = path.normalize '/'+routerPath

#extends project config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : wwwroot

global.pkg = _.assign defaultConf, extconf

requireDir './gulp'
