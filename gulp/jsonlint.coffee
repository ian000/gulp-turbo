gulp       = require 'gulp'
jsonlint   = require "gulp-jsonlint"
{approot} = pkg
gulp.task 'jsonlint',()->
    gulp.src [approot+'/mock/**/*.json',approot+'/src/**/*.json']
        .pipe jsonlint()
        .pipe jsonlint.reporter()
