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
(function(){var a,b,c,d,e;b=require("argv"),a=require("atlassian-crowd"),c=require("./subcmd/cmdlist"),e=function(){return require(process.cwd()+"/crowdutil.json")},d=function(b,c,d){var e,f,g;if("string"==typeof b.options.directory)e=b.options.directory;else{if("string"!=typeof c.defaultDirectory)throw new Error("Directory not specified!");e=c.defaultDirectory}if("undefined"==typeof c.directories[e])throw g=new Error("Directory not defined.");try{b.crowd=new a(c.directories[b.options.directory]),b.crowd.ping(function(a,b){if(a)throw a;return console.log(b),d()})}catch(h){throw f=h}},exports.run=function(){var a,f,g,h,i,j;console.log("\n\n\n\ncrowdutil: Atlassian Crowd Utility!\n\n\n\n"),j=c.list;for(g in j)i=j[g],b.mod(i.arg);h=b.run(),a=e();try{return d(h,a,function(){var a;try{require(c.list[h.mod].require).run(h)}catch(b){a=b,console.log(a.message)}})}catch(k){return f=k,console.log(f.message),-1}}}).call(this);