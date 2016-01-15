var fs = require('fs');
var path = require('path');

//递归创建目录 同步
function mkdirSync(dirname, mode) {
	if (fs.existsSync(dirname)) {
		return true;
	} else {
		if (mkdirSync(path.dirname(dirname), mode)) {
			fs.mkdirSync(dirname, mode);
			return true;
		}
	}
}

module.exports = mkdirSync;