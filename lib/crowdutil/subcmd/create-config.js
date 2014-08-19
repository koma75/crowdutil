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
(function(){var a,b;b=require("fs"),a={directories:{test:{crowd:{base:"http://localhost:8059/crowd/"},application:{name:"test application",password:"pass123"}},sample1:{crowd:{base:"http://localhost:8059/crowd/"},application:{name:"sample application 1",password:"pass123"}}},defaultDirectory:"test",logConfig:{appenders:[{type:"file",filename:"./crowdutil.log",maxLogSize:"204800",backups:2,category:"crowdutil"}]}},exports.run=function(c){var d;if("undefined"!=typeof c["-o"]&&"string"==typeof c["-o"][0])if("/"===c["-o"][0][0])d=c["-o"][0];else{if("stdout"===c["-o"][0])return void console.log(JSON.stringify(a,null,2));""!==c["-o"][0]?d=process.cwd()+"/"+c["-o"][0]:console.log("E, invalid filename")}else d=process.cwd()+"/crowdutil.json";c["-f"]||!b.existsSync(d)?(console.log("writing to "+d),b.writeFile(d,JSON.stringify(a,null,2),function(a){return console.log(a?a.message:""+d+" saved!")})):console.log(""+d+" already exists!")}}).call(this);