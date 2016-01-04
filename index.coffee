_    = require 'lodash'
path = require 'path'
util = require 'gulp-util'
chalk = require 'chalk'
requireDir = require 'require-dir'
defaultConf = require path.join(process.cwd(), './project-conf.json')

{approot,distMode,domain,routerPath,httpPort} = defaultConf

defaultConf.routerPath = routerPath = '/'+routerPath.replace(/^\//,'')

domain     = domain.replace /^https?:\/\/|^\/\//, '//'
domain     = domain+':'+httpPort if httpPort*1 != 80
wwwroot    = (domain+routerPath.replace(/^\/\//,'/'))
			 
			 #replace tail /
			 .replace /\/$|\\$/,''

			 #replace first / 
			 .replace /^\/*||''/,'//'

util.log chalk.bgGreen 'wwwroot',wwwroot

#extends project config
extconf =
    base     : path.resolve approot,'../'
    distPath : approot+'/'+distMode
    wwwroot  : wwwroot

global.pkg = _.assign defaultConf, extconf

requireDir './gulp'
	

