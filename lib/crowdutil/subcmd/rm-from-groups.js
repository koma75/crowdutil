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
(function(){var a,b,c,d;b=require("../helper/crhelper"),c=require("../helper/helper"),a=require("async"),d=function(a){var b,d,e,f,g,h,i,j,k;if(h=!0,c.opSplitCsv(a,"-g"),0!==a["-g"].length)for(i=a["-g"],d=0,f=i.length;f>d;d++)b=i[d],c.isName(b,!1)||(logger.error("invalid group name:"+b),console.log("E, invalid group name:"+b),h=!1);else logger.error("no groups supplied"),console.log("E, no groups supplied"),h=!1;if(logger.debug("groups: \n"+JSON.stringify(a["-g"],null,2)),c.opSplitCsv(a,"-u"),0!==a["-u"].length)for(j=a["-u"],e=0,g=j.length;g>e;e++)k=j[e],c.isName(k,!1)||(logger.error("invalid uid:"+k),console.log("E, invalid uid:"+k),h=!1);else logger.error("no users supplied"),console.log("E, no users supplied"),h=!1;return logger.debug("users: \n"+JSON.stringify(a["-u"],null,2)),h},exports.run=function(c){var e;logger.trace("running : rm-from-groups\n\n\n"),logger.debug(c),d(c)&&(e=c.crowd,a.each(c["-g"],function(d,f){logger.trace("processing "+d),a.each(c["-u"],function(a,c){logger.trace("remove "+a+" from "+d),b.rmUserFromGroup(e,a,d,function(b){return b?(logger.warn(b.message),console.log("W, FAIL: "+d+" - "+a)):(logger.info(d+" - "+a),console.log("I, DONE: "+d+" - "+a)),c()})},function(a){logger.trace("all users in "+d+" done."),console.log("I, finished processing "+d),f(a)})},function(a){a&&logger.warn(a.message),logger.info("DONE"),console.log("I, DONE.")}))}}).call(this);