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
(function(){var a,b,c,d,e,f;d=require("fs"),c=require("../helper/crhelper"),e=require("../helper/helper"),b=require("jglr"),f=function(a){var b;return b=!0,e.opIsType(a,"-b","string")&&d.existsSync(a["-b"][0])||(b=!1,logger.error("invalid file: "+a["-b"])),e.opIsType(a,"-f","boolean")||(a["-f"]=[!1]),b},a={"create-user":require("./batch-exec/create-user").run,"update-user":require("./batch-exec/update-user").run,"create-group":require("./batch-exec/create-group").run,"add-to-group":require("./batch-exec/add-to-group").run,"rm-from-group":require("./batch-exec/rm-from-group").run,"empty-group":require("./batch-exec/empty-group").run,"activate-user":require("./batch-exec/activate-user").run,"deactivate-user":require("./batch-exec/deactivate-user").run,"remove-user":require("./batch-exec/remove-user").run,"remove-group":require("./batch-exec/remove-group").run},exports.run=function(d){var e,g,h;if(logger.trace("running : batch-exec"),logger.debug("options: \n"+JSON.stringify(d,null,2)),!f(d))return void logger.error("parameter invalid!");logger.debug("executing batch!"),c.setDefaultCrowd(d.crowd),c.setupCROWD(),h=new b.Jglr({logger:global.logger}),h.load(d["-b"][0]),logger.debug(h);for(g in a)e=a[g],logger.debug("register callback for "+g),h.registerCmd(g,e);return h.dispatch(function(a){a&&logger.error(a.message),logger.info("finished processing "+d["-b"][0])},!d["-f"][0])}}).call(this);