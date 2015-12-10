gulp       = require 'gulp'
path       = require 'path'
sequence   = require 'gulp-sequence'

# tasks
gulp.task 'compile', ['jade','jadeToJs','stylus','coffee','cpVender','cpImg']
gulp.task 'dev', ['jsonlint','compile','proxy','server','watch']
gulp.task 'dist', 
	sequence ['setDist','compile'], 'rMin', ['server','watch']