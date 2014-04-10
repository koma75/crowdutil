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
(function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p;k=require("fs"),f=require("../helper/crhelper"),a=require("atlassian-crowd"),m=require("../helper/helper"),b=require("jglr"),i=null,g={},p=function(){var b,c,d,e,f,h;logger.trace("setupCROWD"),b=require(process.cwd()+"/crowdutil.json"),f=b.directories,h=[];for(c in f){e=f[c],logger.debug("setupCROWD: adding "+c+"\n"+JSON.stringify(e,null,2));try{h.push(g[c]=new a(e))}catch(i){d=i,h.push(logger.warn(d.message))}}return h},l=function(a){return logger.trace("getCROWD: "+a),"object"==typeof g[a]?(logger.debug("batch-exec: using "+a),g[a]):(logger.debug("batch-exec: using default directory"),i)},n=function(a){var b;return b=!0,m.opIsType(a,"-b","string")&&k.existsSync(a["-b"][0])||(b=!1,logger.error("invalid file: "+a["-b"])),b},e=function(a,b){var c,d;logger.trace("batch-exec: create-user"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),d=!1,a.length<7&&logger.warn("batch-exec: not enough parameters"),"string"==typeof a[2]&&m.isName(a[2],!1)||(logger.warn("batch-exec: first name not valid"),d=!0),"string"==typeof a[3]&&m.isName(a[3],!1)||(logger.warn("batch-exec: last name not valid"),d=!0),"string"==typeof a[4]&&m.isName(a[4],!0)||(logger.info("batch-exec: display name not supplied"),a[4]=""+a[2]+" "+a[3]),"string"==typeof a[5]&&m.isEmail(a[5])||(logger.warn("batch-exec: email not valid"),d=!0),"string"==typeof a[6]&&m.isName(a[6],!1)||(logger.warn("batch-exec: uid not valid"),d=!0),"string"==typeof a[7]&&m.isPass(a[7])||(logger.info("batch-exec: password not supplied"),a[7]=m.randPass()),d?setTimeout(function(){b()},0):(c=l(a[1]),c.user.create(a[2],a[3],a[4],a[5],a[6],a[7],function(c){return c?logger.error("create user "+a[6]+"("+a[5]+") failed: "+c.message):logger.info("user "+a[6]+"("+a[5]+") created"),b()}))},d=function(a,b){logger.trace("batch-exec: create-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},c=function(a,b){logger.trace("batch-exec: add-to-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<4&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},o=function(a,b){logger.trace("batch-exec: rm-from-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<4&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},j=function(a,b){logger.trace("batch-exec: empty-group"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},h=function(a,b){logger.trace("batch-exec: deactivate-user"),logger.debug("cmds = : \n"+JSON.stringify(a,null,2)),a.length<3&&logger.warn("batch-exec: not enough parameters"),setTimeout(b,0)},exports.run=function(a){var f;return logger.trace("running : batch-exec"),logger.debug("options: \n"+JSON.stringify(a,null,2)),n(a)?(logger.debug("executing batch!"),i=a.crowd,p(),f=new b.Jglr({logger:global.logger}),f.load(a["-b"][0]),logger.debug(f),f.registerCmd("create-user",e),f.registerCmd("create-group",d),f.registerCmd("add-to-group",c),f.registerCmd("rm-from-group",o),f.registerCmd("empty-group",j),f.registerCmd("deactivate-user",h),f.dispatch(function(){logger.info("finished processing "+a["-b"][0])})):void logger.error("parameter invalid!")}}).call(this);