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
(function(){var a,b,c,d,e,f,g;b=require("argv"),f=require("log4js"),a=require("atlassian-crowd"),c=require("./subcmd/cmdlist"),g=function(){return require(process.cwd()+"/crowdutil.json")},d=function(b,c,d){var e,f,g;if("string"==typeof b.options.directory)e=b.options.directory;else{if("string"!=typeof c.defaultDirectory)throw new Error("Directory not specified!");e=c.defaultDirectory}if("undefined"==typeof c.directories[e])throw g=new Error("Directory not defined.");try{b.crowd=new a(c.directories[e]),b.crowd.ping(function(a){if(a)throw a;return d()})}catch(h){throw f=h}},e=function(a,b){var c;c="undefined"!=typeof b.logConfig?b.logConfig:{appenders:[{type:"file",filename:"./crowdutil.log",maxLogSize:20480,backups:2,category:"main"},{type:"console",category:"main"}],replaceConsole:!0},f.configure(c),global.logger=f.getLogger("main"),"boolean"==typeof a.options.verbose&&a.options.verbose===!0?(logger.setLevel("TRACE"),logger.debug("log level set to trace")):logger.setLevel("INFO")},exports.run=function(){var a,f,h,i,j,k;console.log("\n\n\n\ncrowdutil: Atlassian Crowd Utility!\n\n\n\n"),k=c.list;for(h in k)j=k[h],b.mod(j.arg);i=b.run(),a=g(),e(i);try{return d(i,a,function(){var a;try{require(c.list[i.mod].require).run(i)}catch(b){a=b,logger.error(a.message)}})}catch(l){return f=l,logger.error(f.message),-1}}}).call(this);