var fs = require('fs');
var path = require('path');
var MD5 = require('md5');
var delay = require('./delay');
var mkdirSync = require('./mkdirSync');

function TurboCache(cpath){
	this.cpath = path.join(cpath, '.turboCache');
	this.init();
}

TurboCache.prototype = {
	constructor: TurboCache,
	init: function (){
		var that = this;
		var confPath = that.confPath = path.join(that.cpath, '.turboCache-conf.json');
		var conf = {};
		
		mkdirSync(that.cpath);
		if(that.isExists(confPath)){
			conf = that.readFileForJson(confPath);
		}

		that.conf = conf;
		that.saveConf = delay(that.saveConf, 1000);
	},
	readFileForJson: function (file){
		var json = {};
		try{
			json = JSON.parse(fs.readFileSync(file, {encoding: 'utf8'}));
		}catch(e){}
		return json;
	},
	isExists: function (path){
		try{
			fs.accessSync(path);
			return true;
		}catch(e){
			return false;
		}
	},
	setFile: function (content, md5, key){
		var that = this;
		// 以指定的filepath的MD5值为缓存文件名
		var cacheFilepath = path.join(that.cpath, MD5(key));
		fs.writeFileSync(cacheFilepath, content);
		that.conf[key] = md5;
		that.saveConf();
	},
	getFile: function (md5, key){
		var that = this;
		var cacheFilepath = path.join(that.cpath, MD5(key));
		var ret = '';
		if(md5 === that.conf[key]){
			if(that.isExists(cacheFilepath)){
				ret = fs.readFileSync(cacheFilepath);
			}
		}

		return ret;
	},
	saveConf: function (){
		fs.writeFileSync(this.confPath, JSON.stringify(this.conf), {encoding: 'utf8'});
	}
};

turboCache = null;
module.exports = function (cachePath){
	turboCache = turboCache || new TurboCache(cachePath);
	return turboCache;
};