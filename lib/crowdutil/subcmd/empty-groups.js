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
(function(){var a,b,c,d;b=require("../helper/crhelper"),d=require("readline"),a=require("async"),c=function(a,c){var d;try{b.findGroupMembers(a,c,function(a){return console.log(a)})}catch(e){d=e,console.log(d.message)}},exports.run=function(a){var b,e,f,g,h,i;for(console.log("running : empty-groups\n\n\n"),console.log(a),b=a.crowd,e=d.createInterface({input:process.stdin,output:process.stdout,terminal:!1}),e.setPrompt("> "),console.log("Are you sure you want to empty the following groups?:"),i=a.options.name,g=0,h=i.length;h>g;g++)f=i[g],console.log("  * "+f);return e.prompt(),e.on("line",function(d){var g,h,i;if("yes"===d.trim())for(console.log("removing users"),i=a.options.name,g=0,h=i.length;h>g;g++)f=i[g],c(b,f);else console.log("abort");return e.close()})}}).call(this);