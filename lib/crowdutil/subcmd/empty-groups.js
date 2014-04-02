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
(function(){var a,b,c,d,e,f;b=require("../helper/crhelper"),d=require("../helper/helper"),f=require("readline"),a=require("async"),e=function(a){var b,c,e,f,g;if(c=!0,"undefined"!=typeof a.options.name&&0!==a.options.name.length)for(g=a.options.name,e=0,f=g.length;f>e;e++)b=g[e],d.isName(b,!1)||(logger.error("invalid group name:"+b),c=!1);else logger.error("no groups supplied"),c=!1;return"undefined"==typeof a.options.force&&(a.options.force=!1),c},c=function(c,d){var e;try{b.findGroupMembers(c,d,function(e){return logger.debug(e),a.each(e,function(a,e){var f;try{b.rmUserFromGroup(c,a,d,function(b){return b?logger.warn(b.message):logger.info(d+" - "+a),e()})}catch(g){f=g,logger.warn(f.message),e()}},function(a){a?logger.warn(a.meesage):logger.info("DONE emptying "+d)})})}catch(f){e=f,logger.warn(e.message)}},exports.run=function(a){var b,d,g,h,i,j,k,l,m;if(logger.trace("running : empty-groups\n\n\n"),logger.debug(a),e(a)){if(b=a.crowd,!a.options.force){for(d=f.createInterface({input:process.stdin,output:process.stdout,terminal:!1}),d.setPrompt("> "),logger.warn("Are you sure you want to empty the following groups?:"),m=a.options.name,i=0,k=m.length;k>i;i++)g=m[i],logger.warn("  * "+g);return d.prompt(),d.on("line",function(e){var f,h,i;if("yes"===e.trim())for(logger.info("removing users"),i=a.options.name,f=0,h=i.length;h>f;f++)g=i[f],c(b,g);else logger.info("abort");return d.close()})}for(logger.info("removing users"),l=a.options.name,h=0,j=l.length;j>h;h++)g=l[h],c(b,g)}}}).call(this);