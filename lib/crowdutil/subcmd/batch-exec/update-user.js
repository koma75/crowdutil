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
(function(){var a,b,c;a=require("../../helper/crhelper"),b=require("../../helper/helper"),c=function(a){var c;return c=!0,a.length<4&&(logger.warn("batch-exec: not enough parameters"),c=!1),"string"==typeof a[2]&&b.isName(a[2],!1)||(logger.warn("batch-exec: uid not valid"),c=!1),"string"==typeof a[3]&&a[3].trim().length>0&&!b.isName(a[3],!1)&&(logger.info("batch-exec: active flag not valid"),c=!1),"string"==typeof a[4]&&a[4].trim().length>0&&!b.isName(a[4],!1)&&(logger.warn("batch-exec: first name not valid"),c=!1),"string"==typeof a[5]&&a[5].trim().length>0&&!b.isName(a[5],!1)&&(logger.warn("batch-exec: last name not valid"),c=!1),"string"==typeof a[6]&&a[6].trim().length>0&&!b.isName(a[6],!0)&&(logger.info("batch-exec: display name not valid"),c=!1),"string"==typeof a[7]&&a[7].trim().length>0&&!b.isEmail(a[7])&&(logger.warn("batch-exec: email not valid"),c=!1),c},exports.run=function(b,d){var e,f,g,h;if(logger.trace("batch-exec: update-user"),logger.debug("cmds = : \n"+JSON.stringify(b,null,2)),f=!1,c(b)){if(h={},"string"==typeof b[4]&&b[4].trim().length>0&&(h["first-name"]=b[4]),"string"==typeof b[5]&&b[5].trim().length>0&&(h["last-name"]=b[5]),"string"==typeof b[6]&&b[6].trim().length>0&&(h["display-name"]=b[6]),"string"==typeof b[7]&&b[7].trim().length>0&&(h.email=b[7]),"string"==typeof b[3]&&b[3].trim().length>0&&("true"===b[3]&&(h.active=!0),"false"===b[3]&&(h.active=!1)),g=b[2],0===Object.getOwnPropertyNames(h).length)return logger.info("nothing to update!"),void setTimeout(d,0);e=a.getCROWD(b[1]),a.updateUser(e,g,h,function(a){return a?(logger.error("batch-exec:update-user:error processing "+g+":\n"+a.message),d(a)):(logger.info(" * update user "+g+", done."),d())})}else setTimeout(function(){logger.error("batch-exec: update-user parameter error"),d(new Error("batch-exec: update-user parameter error"))},0)}}).call(this);