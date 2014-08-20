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
(function(){var a,b,c,d;b=require("../helper/crhelper"),c=require("../helper/helper"),a=require("async"),d=function(a){var b,d,e,f,g,h,i,j,k;if(logger.trace("checking opt"),d=!0,c.opSplitCsv(a,"-g"),0!==a["-g"].length)for(j=a["-g"],f=0,h=j.length;h>f;f++)b=j[f],c.isName(b,!1)||(logger.error("invalid group name:"+b),console.log("E, invalid group name:"+b),d=!1);else logger.error("no groups supplied"),console.log("E, no groups supplied"),d=!1;if(logger.debug("-g :\n"+JSON.stringify(a["-g"],null,2)),c.opSplitCsv(a,"-u"),0!==a["-u"].length)for(k=a["-u"],g=0,i=k.length;i>g;g++)e=k[g],c.isName(e,!1)||(logger.error("invalid uid:"+e),console.log("E, invalid uid:"+e),d=!1);else logger.error("no users supplied"),console.log("E, no users supplied"),d=!1;return logger.debug("-u :\n"+JSON.stringify(a["-u"],null,2)),d},exports.run=function(c){var e;logger.trace("running : add-to-groups\n\n\n"),logger.debug(c),d(c)&&(e=c.crowd,a.each(c["-g"],function(d,f){logger.trace("Group: "+d),a.each(c["-u"],function(a,c){var f;logger.trace(d+" + "+a);try{b.addUserToGroup(e,a,d,function(b){return b?(logger.warn(b.message),console.log("W, FAIL: "+d+" + "+a)):(logger.info(d+" + "+a),console.log("I, DONE: "+d+" + "+a)),c()})}catch(g){f=g,logger.error(f.message),c()}},function(a){logger.trace("all users for group "+d+" Done"),console.log("I, finished processing "+d),f(a)})},function(a){a&&logger.error(a.message),logger.info("DONE"),console.log("I, DONE.")}))}}).call(this);