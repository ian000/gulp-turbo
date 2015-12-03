gulp       = global.globalGulp or require 'gulp'
jsonlint   = require "gulp-jsonlint"
{approot} = global.feScaffoldConf
gulp.task 'jsonlint',()->
    gulp.src [approot+'/mock/**/*.json',approot+'/src/**/*.json']
        .pipe jsonlint()
        .pipe jsonlint.reporter()