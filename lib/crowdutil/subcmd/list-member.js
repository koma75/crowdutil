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
(function(){var a,b,c,d,e;b=require("../helper/crhelper"),c=require("../helper/helper"),e=require("readline"),a=require("async"),d=function(){var a,b;return b=!0,a=function(){},c.opIsType(opts,"-g","string")&&c.isName(opts["-g"][0],!1)||(b=!1,logger.error("invalid group name: "+opts["-g"]),console.log("E, invalid group name: "+opts["-g"])),b},exports.run=function(a){var b;return logger.trace("running : list-member\n\n\n"),logger.debug(a),d(a)?(b=a.crowd,findGroupMembers(b,a["-g"],function(b,c){var d,e,f;if(b)logger.error(b.message),console.log("E, failed to find members of "+a["-g"][0]);else for(logger.info(""+a["-g"][0]+": ¥n"+JSON.stringify(c,null,2)),console.log("I, members of "+a["-g"][0]+" are:"),e=0,f=c.length;f>e;e++)d=c[e],console.log(""+d)})):void 0}}).call(this);