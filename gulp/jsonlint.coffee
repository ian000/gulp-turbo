gulp       = require 'gulp'
jsonlint   = require "gulp-jsonlint"

gulp.task 'jsonlint',()->
	{approot} = global.pkg
	
	gulp.src [approot+'/mock/**/*.json',approot+'/src/**/*.json']
		.pipe jsonlint()
		.pipe jsonlint.reporter()
