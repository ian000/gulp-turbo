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
              urlObj    = url.parse(req.url, true)
              urlObj.protocol or= 'http'
              orginUrl = urlObj.protocol+wwwroot+req.url

              util.log 'Received request-->'+orginUrl

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

              #skip favicon.ico
              if req.url.search(/favicon\.ico$/)>-1
                console.log 'req.url',req.url
                console.log 'favicon'
                next()
                return
              
              #if local not found
              try
                fs.readdirSync disk_path
                next()
                return
              catch err
                if !vhost
                  next()
                  return
                proxyURL  = vhost+req.url
                oProxyURL = url.parse proxyURL, true
                oProxyURL.protocol or= 'http'
                httpLib  = oProxyURL.protocol.replace(/\:/,'')
                request  = require(httpLib).request

                #make proxy url
                proxyURL = httpLib+'://'+proxyURL.replace(/^.*\/\/(.*)$/, '$1') 
                util.log chalk.magenta '本地资源不存在，触发透明代理 : '+proxyURL
                
                # vhost
                myReq = request proxyURL, (myRes)->
                  {statusCode,headers,host} = myRes
                  res.writeHead statusCode, headers, host
                  util.log chalk.magenta 'http code : '+statusCode
                  myRes.on 'error', (err)->
                    console.log 'err',err
                    next err
                  myRes.pipe res

                myReq.on 'error', (err)->
                  console.log 'myReq error',err
                  if err.code is 'ETIMEDOUT'
                    util.log chalk.magenta '访问超时'
                  else
                    console.log 'myReq error',err
                  next()
                
                if !req.readable
                  console.log '!req.readable'
                  myReq.end()
                  next()
                
                req.pipe myReq

            fallback : ()->
              util.log 'fallback', arguments
              # request proxyURL, (error, response, body)->
              #     if (!error && response.statusCode == 200)
              #       next(body)
        .pipe through.obj (file, enc, cb)->
          util.log chalk.magenta 'running at '+wwwroot
          cb()
