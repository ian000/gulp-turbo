gulp   = global.globalGulp or require 'gulp'
pkg    = global.pkg
nproxy = require 'gulp-nproxy'
define = require './define'

# proxy
gulp.task 'proxy', ()->
  nproxy
    timeout: 10
    port: pkg.proxyProt
    rule: pkg.proxyRule
