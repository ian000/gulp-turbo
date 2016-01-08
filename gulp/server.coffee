gulp            = require 'gulp'
pkg             = global.pkg
util            = require 'gulp-util'
fs              = require 'fs'
url             = require 'url'
path            = require 'path'
webserver       = require 'gulp-webserver'
chalk           = require 'chalk'
through         = require 'through2'
forceLivereload = if typeof(pkg.forceLivereload != 'undefined') then !!pkg.forceLivereload else distMode=='dev'
request         = require('http').request



# webserver
gulp.task 'server', ()->
    util.log 'approot',pkg.approot
    {base,approot,vhost,routerPath,distPath,wwwroot} = pkg

    # dist
    if pkg.distMode is 'dist'
      forceLivereload = false

    util.log 'current webroot:',distPath
    gulp.src distPath
        .pipe webserver
            livereload       : forceLivereload
            host             : '0.0.0.0'
            path             : routerPath
            port             : pkg.httpPort
            proxies          : pkg.serverProxies
            directoryListing :
              enable:true
              path:distPath

            middleware: (req, res, next)->

              util.log 'request1-->'+req.url

              #replace to file path
              disk_path     = url.parse( path.normalize(base+req.url.replace(routerPath, '/'+distPath+'/')) ).pathname
              urlObj        = url.parse(req.url, true)
              method        = req.method

              # mock
              mockfile = approot+'/mock'+urlObj.pathname+'.json'
              if fs.existsSync mockfile
                res.setHeader('Content-Type', 'application/json')
                res.end fs.readFileSync mockfile
                return

              try
                stats         = fs.statSync disk_path
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

                proxyURL = vhost+req.url
                util.log chalk.magenta '本地不存在'+req.url+'，请求远程透明代理替换请求 : '+proxyURL
                # vhost
                myReq = request proxyURL, (myRes)->
                  {statusCode,headers} = myRes
                  res.writeHead(myRes.statusCode, myRes.headers)
                  myRes.on 'error', (err)->
                    next(err)
                  myRes.pipe(res)

                myReq.on 'error', (err)->
                  next err
                
                if !req.readable

                  myReq.end()
                  return
                else
                  req.pipe myReq
                  return

              #skip favicon.ico
              if req.url.search /favicon\.ico$/ >-1
                next()

            fallback : ()->
              util.log 'fallback', arguments
              request vhost+req.url, (error, response, body)->
                  if (!error && response.statusCode == 200)
                    next(body)
        .pipe through.obj (file, enc, cb)->
          util.log chalk.magenta 'running at '+wwwroot
          cb()
