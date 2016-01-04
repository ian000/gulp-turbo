# 目录说明
> 样式目录，将被编译到 app/dev/css下
> 例：main.styl 将会被编译到 app/dev/css/main.css

# 开发约定
> 请在次目录务必使用.styl扩展名,由于stylus对css格式支持比较好，
> 因此你甚至可以将原有的.css文件直接改名为.styl文件
> 如需合并文件，请将css模块化拆分，然后在主文件里面import,例： @import 'module/mod'
> 将会合并到主文件的css里面
