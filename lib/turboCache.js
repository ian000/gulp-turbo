var fs = require('fs');
var path = require('path');
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
	setFile: function (content, md5){
		var that = this;
		var filepath = path.join(that.cpath, md5);
		var params = Array.prototype.slice.call(arguments, 2);
		fs.writeFileSync(filepath, content);
		that.conf[md5] = 1;
		for(var i = 0; i < params.length; i++){
			that.conf[params[i]] = md5;
		}
		that.saveConf();
	},
	getFile: function (key){
		var that = this;
		var filepath = path.join(that.cpath, key);
		var ret = that.conf[key]
		if(typeof ret === 'number'){
			ret++;
			that.saveConf();
			return fs.readFileSync(filepath);
		}else{
			return ret;
		}
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