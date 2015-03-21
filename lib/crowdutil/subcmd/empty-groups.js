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
(function(){var a,b,c,d,e,f;b=require("../helper/crhelper"),d=require("../helper/helper"),f=require("readline"),a=require("async"),e=function(a){var b,c,e,f,g;if(f=!0,d.opSplitCsv(a,"-g"),0!==a["-g"].length)for(g=a["-g"],c=0,e=g.length;e>c;c++)b=g[c],d.isName(b,!1)||(logger.error("invalid group name:"+b),console.log("E, invalid group name:"+b),f=!1);else logger.error("no groups supplied"),console.log("E, no groups supplied"),f=!1;return d.opIsType(a,"-f","boolean")||(a["-f"]=[!1]),f},c=function(c,d){b.findGroupMembers(c,d,function(e,f){return e?(logger.warn(e.message),void console.log("E, could not find any members of "+d)):(logger.debug(f),a.each(f,function(a,e){b.rmUserFromGroup(c,a,d,function(b){return b?(logger.warn(b.message),console.log("W, FAIL: "+d+" - "+a)):(logger.info(d+" - "+a),console.log("I, DONE: "+d+" - "+a)),e()})},function(a){a?(logger.warn(a.meesage),console.log("E, there was an error processing "+d+". Check log for details.")):(logger.info("DONE emptying "+d),console.log("I, finished processing "+d))}))})},exports.run=function(a){var b,d,g,h,i,j,k,l,m;if(logger.trace("running : empty-groups\n\n\n"),logger.debug(a),e(a)){if(b=a.crowd,!a["-f"][0]){for(l=f.createInterface({input:process.stdin,output:process.stdout,terminal:!1}),l.setPrompt("> "),console.log("Are you sure you want to empty the following groups?:"),k=a["-g"],g=0,i=k.length;i>g;g++)m=k[g],console.log("  * "+m);return l.prompt(),l.on("line",function(d){var e,f,g;if("yes"===d.trim())for(logger.info("removing users"),console.log("removing users"),g=a["-g"],e=0,f=g.length;f>e;e++)m=g[e],c(b,m);else logger.info("abort"),console.log("abort");return l.close()})}for(logger.info("removing users"),j=a["-g"],d=0,h=j.length;h>d;d++)m=j[d],c(b,m)}}}).call(this);