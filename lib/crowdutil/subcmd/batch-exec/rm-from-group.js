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
(function(){var a,b,c;a=require("../../helper/crhelper"),b=require("../../helper/helper"),c=function(a){var c;return c=!0,a.length<4&&(logger.warn("batch-exec: not enough parameters"),console.log("E, rm-from-group: not enough params"),c=!1),"string"==typeof a[2]&&b.isName(a[2],!1)||(logger.error("batch-exec: invalid uid"),console.log("E, rm-from-group: invalid uid"),c=!1),"string"==typeof a[3]&&b.isName(a[3],!1)||(logger.error("batch-exec: invalid group name"),console.log("E, rm-from-group: invalid group name"),c=!1),c},exports.run=function(b,d){var e,f;logger.trace("batch-exec: rm-from-group"),logger.debug("cmds = : \n"+JSON.stringify(b,null,2)),f=!1,c(b)?(e=a.getCROWD(b[1]),a.rmUserFromGroup(e,b[2],b[3],function(a){return a?(logger.error("batch-exec: "+a.message+"\n"+JSON.stringify(b)),console.log("E, rm-from-group: FAIL: "+b[3]+" - "+b[2]+" ("+b[1]+")"),d(a)):(logger.info(b[3]+" - "+b[2]),console.log("I, rm-from-group: DONE: "+b[3]+" - "+b[2]+" ("+b[1]+")"),d())})):setTimeout(function(){logger.error("batch-exec:rm-from-group param error"),console.log("E, rm-from-group: param error: "+JSON.stringify(b)),d(new Error("batch-exec:rm-from-group param error"))},0)}}).call(this);