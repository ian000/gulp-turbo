gulp            = require 'gulp'
pkg             = global.pkg
util            = require 'gulp-util'
fs              = require 'fs'
url             = require 'url'
request         = require 'request'
path            = require 'path'
webserver       = require 'gulp-webserver'
forceLivereload = if typeof(pkg.forceLivereload != 'undefined') then !!pkg.forceLivereload else distMode=='dev'

# webserver
gulp.task 'server', ()->
    util.log 'approot',pkg.approot
    {base,approot,vhost,routerPath,distPath,wwwroot} = pkg
    util.log 'current webroot:',distPath
    gulp.src distPath
        .pipe webserver
            livereload       : forceLivereload
            host             : '0.0.0.0'
            path             : path.normalize '/'+routerPath
            port             : pkg.httpPort
            proxies          : pkg.serverProxies
            directoryListing :
              enable:true
              path:distPath

            middleware: (req, res, next)->
              urlObj = url.parse(req.url, true)
              method = req.method
              filenameOrign = urlObj.pathname

              util.log 'request-->:'+req.url

              #skip favicon.ico
              if req.url.search /favicon\.ico$/ >-1
                next()
                
              #replace to file path
              disk_path = base + req.url.replace routerPath, '/'+distPath+'/'
              stats = fs.statSync disk_path

              # mock
              mockfile = approot+'/mock'+urlObj.pathname+'.json'
              if fs.existsSync mockfile
                res.setHeader('Content-Type', 'application/json')
                res.end fs.readFileSync mockfile
                return

              # if is a file
              if stats.isFile disk_path
                res.end fs.readFileSync disk_path
                return

              #if local not found
              try
                fs.readdirSync disk_path
                next()
                return
              catch err

                # vhost
                request vhost+req.url, (error, response, body)->
                  if (!error && response.statusCode == 200)
                    next(_data)
                  else
                    next()

            fallback : ()->
              util.log 'fallback', arguments
              request vhost+req.url, (error, response, body)->
                  if (!error && response.statusCode == 200)
                    next(body)
