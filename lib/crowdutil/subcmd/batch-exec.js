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
(function(){var a,b,c,d,e,f,g,h,i,j,k;h=require("fs"),e=require("../helper/crhelper"),i=require("../helper/helper"),b=require("jglr"),j=function(a){var b;return b=!0,i.opIsType(a,"-b","string")&&h.existsSync(a["-b"][0])||(b=!1,logger.error("invalid file: "+a["-b"])),b},d=function(a,b){logger.trace("batch-exec: create-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},c=function(a,b){logger.trace("batch-exec: add-to-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<4&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},k=function(a,b){logger.trace("batch-exec: rm-from-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<4&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},g=function(a,b){logger.trace("batch-exec: empty-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},f=function(a,b){logger.trace("batch-exec: deactivate-user"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},a={"create-user":require("./batch-exec/create-user").run,"create-group":d,"add-to-group":c,"rm-from-group":k,"empty-group":g,"deactivate-user":f},exports.run=function(c){var d,f,g;if(logger.trace("running : batch-exec"),logger.debug("options: \n"+JSON.stringify(c,null,2)),!j(c))return void logger.error("parameter invalid!");logger.debug("executing batch!"),e.setDefaultCrowd(c.crowd),e.setupCROWD(),g=new b.Jglr({logger:global.logger}),g.load(c["-b"][0]),logger.debug(g);for(f in a)d=a[f],logger.debug("register callback for "+f),g.registerCmd(f,d);return g.dispatch(function(){logger.info("finished processing "+c["-b"][0])},!0)}}).call(this);