/*
  @license
  crowdutil

  The MIT License (MIT)

  Copyright (c) 2014 Yasuhiro Okuno

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN crowdECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */
(function(){var a,b,c,d,e,f,g,h,i;h=require("log4js"),a=require("../atlassian-crowd-ext/atlassian-crowd-ext"),b=require("./subcmd/cmdlist"),d=require("fs"),e=function(){return process.env.USERPROFILE||process.env.HOME},i=function(a){var b;if(b=null,"object"==typeof a["-c"]&&"string"==typeof a["-c"][0]){if(!d.existsSync(a["-c"][0]))return console.log("E, file "+a["-c"][0]+" NOT FOUND!"),null;b=a["-c"][0]}return null===b&&d.existsSync(process.cwd()+"/crowdutil.json")&&(b=process.cwd()+"/crowdutil.json"),null===b&&d.existsSync(e()+"/.crowdutil/config.json")&&(b=e()+"/.crowdutil/config.json"),null!==b?(global.crowdutil_cfg=b,require(b)):null},c=function(b,c){var d,e,f;if("object"==typeof b["-D"]&&"string"==typeof b["-D"][0])d=b["-D"][0];else{if("string"!=typeof c.defaultDirectory)throw new Error("Directory not specified!");d=c.defaultDirectory}if("undefined"==typeof c.directories[d])throw f=new Error("Directory not defined.");try{b.crowd=new a(c.directories[d])}catch(g){throw e=g}},g=function(a,b){var c;c="undefined"!=typeof b.logConfig?b.logConfig:{appenders:[{type:"file",filename:"./crowdutil.log",maxLogSize:20480,backups:2,category:"crowdutil"}]},h.configure(c),global.logger=h.getLogger("crowdutil"),"object"==typeof a["-v"]&&"boolean"==typeof a["-v"][0]&&a["-v"][0]===!0?(logger.setLevel("TRACE"),logger.debug("log level set to trace")):logger.setLevel("INFO")},f=function(a){var b,d,e;if(b=i(a),null===b)return console.log("E, could not load config file"),!1;e=!0,g(a,b),logger.info("==============================================="),logger.info("crowdutil: Atlassian CROWD cli utility tool");try{c(a,b)}catch(f){d=f,d&&(logger.debug(d.message),e=!1)}return e},exports.run=function(){b.start(f)}}).call(this);