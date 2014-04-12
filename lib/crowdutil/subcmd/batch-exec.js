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
(function(){var a,b,c,d,e,f,g,h,i,j;g=require("fs"),d=require("../helper/crhelper"),h=require("../helper/helper"),a=require("jglr"),i=function(a){var b;return b=!0,h.opIsType(a,"-b","string")&&g.existsSync(a["-b"][0])||(b=!1,logger.error("invalid file: "+a["-b"])),b},c=function(a,b){logger.trace("batch-exec: create-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},b=function(a,b){logger.trace("batch-exec: add-to-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<4&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},j=function(a,b){logger.trace("batch-exec: rm-from-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<4&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},f=function(a,b){logger.trace("batch-exec: empty-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},e=function(a,b){logger.trace("batch-exec: deactivate-user"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},exports.run=function(g){var h;return logger.trace("running : batch-exec"),logger.debug("options: \n"+JSON.stringify(g,null,2)),i(g)?(logger.debug("executing batch!"),d.setDefaultCrowd(g.crowd),d.setupCROWD(),h=new a.Jglr({logger:global.logger}),h.load(g["-b"][0]),logger.debug(h),h.registerCmd("create-user",require("./batch-exec/create-user").run),h.registerCmd("create-group",c),h.registerCmd("add-to-group",b),h.registerCmd("rm-from-group",j),h.registerCmd("empty-group",f),h.registerCmd("deactivate-user",e),h.dispatch(function(){logger.info("finished processing "+g["-b"][0])},!0)):void logger.error("parameter invalid!")}}).call(this);