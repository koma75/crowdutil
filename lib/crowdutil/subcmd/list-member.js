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
(function(){var a,b,c,d,e;b=require("../helper/crhelper"),c=require("../helper/helper"),e=require("readline"),a=require("async"),d=function(a){var b,d;return d=!0,b=function(){},c.opIsType(a,"-g","string")&&c.isName(a["-g"][0],!1)||(d=!1,logger.error("invalid group name: "+a["-g"]),console.log("E, invalid group name: "+a["-g"])),d},exports.run=function(a){var c;return logger.trace("running : list-member\n\n\n"),logger.debug(a),d(a)?(c=a.crowd,b.findGroupMembers(c,a["-g"],function(b,c){var d,e,f;if(b)logger.error(b.message),console.log("E, failed to find members of "+a["-g"][0]);else{for(logger.info(a["-g"][0]+": \n"+JSON.stringify(c,null,2)),console.log("I, members of "+a["-g"][0]+" are:"),d=0,e=c.length;e>d;d++)f=c[d],console.log(""+f);console.log("I, DONE")}})):void 0}}).call(this);