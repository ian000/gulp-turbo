gulp            = global.globalGulp or require 'gulp'
pkg             = global.pkg
util            = require 'gulp-util'
fs              = require 'fs'
url             = require 'url'
request         = require 'request'
path            = require 'path'
webserver       = require 'gulp-webserver'
define          = require './define'
forceLivereload = if typeof(pkg.forceLivereload != 'undefined') then !!pkg.forceLivereload else distMode=='dev'
console.log 'approot',pkg.approot
{base,approot,vhost,routerPath,distPath,wwwroot} = pkg

util.log 'current webroot:',distPath

# webserver-with-mocks
gulp.task 'server', ()->
    console.log 'current webroot:',distPath
    gulp.src distPath
        .pipe webserver
            livereload       : forceLivereload
            host             : '0.0.0.0'
            path             : routerPath
            port             : pkg.httpProt
            proxies          : pkg.serverProxies
            directoryListing :
              enable:true
              path:distPath

            middleware: (req, res, next)->
              urlObj = url.parse(req.url, true)
              method = req.method
              filenameOrign = urlObj.pathname
              # mock
              filename = approot+'/mock'+urlObj.pathname+'.json'
              if(fs.existsSync(filename))
                _data = fs.readFileSync(filename)
                res.setHeader('Content-Type', 'application/json')
                res.end(_data)
                return

              #replace to file path
              req_url = req.url.replace(routerPath, '/'+distPath+'/')

              # if is a file
              if(fs.existsSync(base+req_url))
                next()
                return

              # if is a dir
              try
                req_url = (approot+req.url).replace(routerPath, '/'+distPath+'/')
                fs.readdirSync req_url
                next()
                return
              catch err
                request vhost+req.url, (error, response, body)->
                  if (!error && response.statusCode == 200)
                    next(_data)
                  else
                    next()

            fallback : ()->
              console.log 'fallback', arguments
              request vhost+req.url, (error, response, body)->
                  if (!error && response.statusCode == 200)
                    next(body)
