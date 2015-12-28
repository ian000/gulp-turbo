_    = require 'lodash'
path = require 'path'
util = require 'gulp-util'
requireDir = require 'require-dir'
defaultConf = require path.join(process.cwd(), './project-conf.json')

{approot,distMode,domain,routerPath,httpPort} = defaultConf

defaultConf.routerPath = routerPath = '/'+routerPath.replace(/^\//,'')

domain     = domain.replace /^https?:\/\/|^\/\//, '//'
domain     = domain+':'+httpPort if httpPort*1 != 80
wwwroot    = path.join(domain,routerPath)
			 
			 #replace tail /
			 .replace /\/$|\\$/,''

			 #replace first / 
			 .replace /^\/*||''/,'//'

#extends project config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : wwwroot

global.pkg = _.assign defaultConf, extconf

requireDir './gulp'
