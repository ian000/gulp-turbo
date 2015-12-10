gulp   = require 'gulp'
nproxy = require 'gulp-nproxy'

# proxy
gulp.task 'proxy', ()->
  pkg = global.pkg
  nproxy
    timeout: 10
    port: pkg.proxyPort
    rule: pkg.proxyRule
