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
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */
(function(){var a,b,c;b=require("fs"),a={directories:{test:{crowd:{base:"http://localhost:8059/crowd/"},application:{name:"test application",password:"pass123"}},sample1:{crowd:{base:"http://localhost:8059/crowd/"},application:{name:"sample application 1",password:"pass123"}}},defaultDirectory:"test",logConfig:{appenders:[{type:"file",filename:"./crowdutil.log",maxLogSize:"204800",backups:2,category:"crowdutil"}],replaceConsole:!1}},c=function(){return process.env.USERPROFILE||process.env.HOME},exports.run=function(d){var e;if("undefined"!=typeof d["-o"]&&"string"==typeof d["-o"][0])if("/"===d["-o"][0][0]||":"===d["-o"][0][1])e=d["-o"][0];else{if("stdout"===d["-o"][0])return void console.log(JSON.stringify(a,null,2));""!==d["-o"][0]?e=process.cwd()+"/"+d["-o"][0]:console.log("E, invalid filename")}else b.existsSync(c()+"/.crowdutil")||b.mkdirSync(c()+"/.crowdutil",511&~process.umask()),e=c()+"/.crowdutil/config.json";d["-f"]||!b.existsSync(e)?(console.log("writing to "+e),b.writeFile(e,JSON.stringify(a,null,2),function(a){return console.log(a?a.message:""+e+" saved!")})):console.log(""+e+" already exists!")}}).call(this);