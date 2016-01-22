gulp     = require 'gulp'
fs       = require 'fs'
util     = require 'gulp-util'
argv     = require('yargs').argv
execSync = require('child_process').execSync

# task svnChanges
# e.g:  gulp svnChanges --svn /Users/kings/didi/svn_static --ver 150518
# 参数说明：

# --svn 需要读取的svn本地文件所在目录 必须
# --ver 指定需要比较的svn版本号 默认比较最后一个提交记录
# --append 需要再每个文件名后追加的字符
# --separate 分隔符，默认一个空格
gulp.task 'svnChanges', ()->
  pkg = global.pkg
  svnDir = argv.svn
  lastVersion = argv.ver
  append = argv.append
  separate = argv.separate || ' '

  svnUpdate = execSync('svn update', {cwd: svnDir, encoding: 'utf8'})
  svnInfo = execSync('svn info', {cwd: svnDir, encoding: 'utf8'})
  svnRoot = svnInfo.match(/Repository\sRoot:\s([^\s]+)/)[1]
  revision = svnInfo.match(/Revision:\s(\d+)/)[1]
  resultFileName = 'svn_changelist_'+revision+ '.txt'
  append = append || revision
  if lastVersion
    result = execSync('svn log -r ' + lastVersion + ' -v', {cwd: svnDir, encoding: 'utf8'})
  else
    result = execSync('svn log -l 1 -v', {cwd: svnDir, encoding: 'utf8'})

  str = ''
  dataArr = result.split('\n').slice(3,-4).forEach (item)->
    if /[^\/]+\.\w+\s?$/.test(item) && !/\s+D\s+/.test(item)
      str += svnRoot + item.replace(/^[^\/]+(\/.*)\s?$/,'$1')+separate+append+'\n'
  fs.writeFileSync './'+resultFileName, str, {encoding: 'utf8'}
  util.log('*****created change file list: ' + resultFileName + '*****');
