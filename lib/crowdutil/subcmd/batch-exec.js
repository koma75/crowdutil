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
(function(){var a,b,c,d,e,f,g,h,i,j,k;h=require("fs"),e=require("../helper/crhelper"),i=require("../helper/helper"),a=require("jglr"),j=function(a){var b;return b=!0,i.opIsType(a,"-b","string")&&h.existsSync(a["-b"][0])||(b=!1,logger.error("invalid file: "+a["-b"])),b},d=function(a,b){logger.trace("create-user"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),b()},c=function(a,b){logger.trace("create-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),b()},b=function(a,b){logger.trace("add-to-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),b()},k=function(a,b){logger.trace("rm-from-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),b()},g=function(a,b){logger.trace("empty-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),b()},f=function(a,b){logger.trace("deactivate-user"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),b()},exports.run=function(e){var h,i,l;return logger.trace("running : batch-exec"),logger.debug("options: \n"+JSON.stringify(e,null,2)),j(e)?(logger.debug("executing batch!"),h=e.crowd,i=new a.Jglr({logger:global.logger}),i.load(e["-b"][0]),logger.debug(i),i.registerCmd("create-user",d),i.registerCmd("create-group",c),i.registerCmd("add-to-group",b),i.registerCmd("rm-from-group",k),i.registerCmd("empty-group",g),i.registerCmd("deactivate-user",f),l=function(a){return a?i.dispatchNext(l):void 0},i.dispatchNext(l)):void logger.error("parameter invalid!")}}).call(this);