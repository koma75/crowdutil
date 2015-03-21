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
(function(){var a,b,c;a=require("../../helper/crhelper"),b=require("../../helper/helper"),c=function(a){var c;return c=!0,a.length<7&&(logger.warn("batch-exec: not enough parameters"),console.log("E, create-user: not enough params"),c=!1),"string"==typeof a[4]&&b.isName(a[4],!1)||(logger.warn("batch-exec: first name not valid"),console.log("E, create-user: first name not valid"),c=!1),"string"==typeof a[5]&&b.isName(a[5],!1)||(logger.warn("batch-exec: last name not valid"),console.log("E, create-user: last name not valid"),c=!1),"string"==typeof a[6]&&b.isName(a[6],!0)||(logger.info("batch-exec: display name not supplied"),a[6]=a[4]+" "+a[5],console.log("I, create-user: display name not supplied... using "+a[6])),"string"==typeof a[7]&&b.isEmail(a[7])||(logger.warn("batch-exec: email not valid"),console.log("E, create-user: email not valid"),c=!1),"string"==typeof a[2]&&b.isName(a[2],!1)||(logger.warn("batch-exec: uid not valid"),console.log("E, create-user: uid not valid"),c=!1),"string"==typeof a[3]&&b.isPass(a[3])||(logger.info("batch-exec: password not supplied"),a[3]=b.randPass(),console.log("I, create-user: password not supplied... using "+a[3])),c},exports.run=function(b,d){var e,f;logger.trace("batch-exec: create-user"),logger.debug("cmds = : \n"+JSON.stringify(b,null,2)),f=!1,c(b)?(e=a.getCROWD(b[1]),e.user.create(b[4],b[5],b[6],b[7],b[2],b[3],function(a){return a?(logger.error("batch-exec: "+a.message+"\n"+JSON.stringify(b)),console.log("E, create-user: FAIL: "+b[2]+", "+b[6]+", "+b[7]+", "+b[3]+" ("+b[1]+")"),d(a)):(console.log("I, create-user: DONE: "+b[2]+", "+b[6]+", "+b[7]+", "+b[3]+" ("+b[1]+")"),d())})):setTimeout(function(){logger.error("batch-exec: create-user parameter error"),console.log("E, create-user: param error: "+JSON.stringify(b)),d(new Error("batch-exec: create-user parameter error"))},0)}}).call(this);