gulp       = require 'gulp'
fs         = require 'fs'
path       = require 'path'
sequence   = require 'gulp-sequence'

# tasks
gulp.task 'compile', ['jade','jadeToJs','stylus','coffee','cpVender','cpImg']
gulp.task 'dev', ['jsonlint','compile','proxy','server','watch']
gulp.task 'dist', 
	sequence ['setDist','compile'], 'rMin', 'loderMin', ['server','watch']
gulp.task 'tasks', [], ()->
	taskslistFile = path.join __dirname, './TASKSLIST'
	console.log fs.readFileSync taskslistFile, {encoding: 'utf8'}

gulp.task 'default', ['dev']