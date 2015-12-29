gulp       = require 'gulp'
del        = require 'del'

#clean dev
gulp.task 'clean:dev-js-entry', (cb)->
	{approot}  = global.pkg

	del [approot + '/dev/js/entry/**/*'], cb

# 
gulp.task 'clean:dev-loderAndConf', (cb)->
	{approot}  = global.pkg

	del [approot + '/dev/js/loder.js', approot + '/dev/js/require-conf.js'], cb