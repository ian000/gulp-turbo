gulp       = require 'gulp'
del        = require 'del'
chalk      = require 'chalk'
util       = require 'gulp-util'

#clean dev/js/entry
gulp.task 'clean:dev-js-entry', (cb)->
	{approot}  = global.pkg
	util.log chalk.yellow '清除dev/js/entry'
	del [approot + '/dev/js/entry'], cb

# 清除dev/js 下loder和require-conf文件
gulp.task 'clean:dev-loderAndConf', (cb)->
	{approot}  = global.pkg
	util.log chalk.yellow '清除dev/js 下loder和require-conf文件'
	del [approot + '/dev/js/loder.js', approot + '/dev/js/require-conf.js'], cb

# 清除turboCache
gulp.task 'clean:turboCache', (cb)->
	{approot}  = global.pkg
	util.log chalk.yellow '清除turboCache'
	del [global.pkg.base + '/.turboCache'], cb

# 清除dev和dist文件夹
gulp.task 'clean', (cb)->
	{approot}  = global.pkg
	util.log chalk.yellow '清除dev和dist文件夹'
	del [approot + '/dev', approot + '/dist'], cb