var fs = require('fs');
var path = require('path');
var md5 = require('md5');

function folderMd5(folder){
	var files = fs.readdirSync(folder);
	var md5str = '';
	for(var i = 0; i < files.length; i++){
		var filename = files[i];
		var filepath = path.join(folder, filename);
		var stat = fs.statSync(filepath);
		if(stat.isDirectory()){
			md5str += folderMd5(filepath);
		}else if(stat.isFile()){
			md5str += md5(fs.readFileSync(filepath));
		}
	}

	return md5(md5str);
}

// console.log(folderMd5(__dirname));
module.exports = folderMd5;