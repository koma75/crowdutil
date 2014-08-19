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
(function(){var a,b,c,d,e,f,g;f=require("log4js"),a=require("../atlassian-crowd-ext/atlassian-crowd-ext"),b=require("./subcmd/cmdlist"),g=function(){return require(process.cwd()+"/crowdutil.json")},c=function(b,c){var d,e,f;if("object"==typeof b["-D"]&&"string"==typeof b["-D"][0])d=b["-D"][0];else{if("string"!=typeof c.defaultDirectory)throw new Error("Directory not specified!");d=c.defaultDirectory}if("undefined"==typeof c.directories[d])throw f=new Error("Directory not defined.");try{b.crowd=new a(c.directories[d])}catch(g){throw e=g}},e=function(a,b){var c;c="undefined"!=typeof b.logConfig?b.logConfig:{appenders:[{type:"file",filename:"./crowdutil.log",maxLogSize:20480,backups:2,category:"crowdutil"}]},f.configure(c),global.logger=f.getLogger("crowdutil"),"object"==typeof a["-v"]&&"boolean"==typeof a["-v"][0]&&a["-v"][0]===!0?(logger.setLevel("TRACE"),logger.debug("log level set to trace")):logger.setLevel("INFO")},d=function(a){var b,d,f;b=g(),f=!0;try{e(a,b)}catch(h){d=h,d&&(console.log(d.message),f=!1)}logger.info("==============================================="),logger.info("crowdutil: Atlassian CROWD cli utility tool");try{c(a,b)}catch(h){d=h,d&&(logger.debug(d.message),f=!1)}return f},exports.run=function(){b.start(d)}}).call(this);