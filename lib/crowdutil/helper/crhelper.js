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
(function(){var a,b,c,d,e,f,g,h,i,j,k;b=require("async"),d=function(a,b,c){var d,e;return b=b||{},d=b.name||"*",e='name="'+d+'"',a.search("group",e,function(a,b){return a?logger.warn(a.message):c(b)})},f=function(a,b,c){var d,e,f,g,h;return b=b||{},h=b.uid||"*",e=b.fname||"*",f=b.lname||"*",d=b.email||"*",g='name="'+h+'"',g=g+' and firstName="'+e+'"',g=g+' and lastName="'+f+'"',g=g+' and email="'+d+'"',a.search("user",g,function(a,b){return a?logger.warn(a.message):c(b)})},h=function(a,b,c){var d;if(""===b||"undefined"==typeof b)throw d=new Error("invalid user name");return a.user.groups(b,function(a,b){return a?logger.warn(a.message):c(b)})},e=function(a,b,c){var d;if(""===b||"undefined"==typeof b)throw d=new Error("findGroupMembers: invalid input"),myError;return a.groups.directmembers(b,function(a,b){return a?logger.warn(a.message):c(b)})},a=function(a,b,c,d){var e;if(""===b||"undefined"==typeof b||""===c||"undefined"==typeof c)throw e=new Error("addUserToGroup: invalid input");a.groups.addmember(b,c,function(a){return d(a)})},i=function(a,b,c,d){var e;if(""===b||"undefined"==typeof b||""===c||"undefined"==typeof c)throw e=new Error("rmUserFromGroup: invalide input");a.groups.removemember(b,c,function(a){return d(a)})},c=function(a,c,d,f){var g;try{e(a,c,function(e){return logger.debug(e),b.eachLimit(e,d,function(b,d){var e;try{i(a,b,c,function(a){return a?logger.warn(a.message):logger.info(c+" - "+b),d()})}catch(f){e=f,logger.warn(e.message),d()}},function(a){a?f(a):(logger.info("DONE emptying "+c),f())})})}catch(h){g=h,f(g)}},"undefined"==typeof global.crowdutil&&(global.crowdutil={}),"undefined"==typeof global.crowdutil.crhelper&&(global.crowdutil.crhelper={}),"undefined"==typeof global.crowdutil.crhelper.defaultCrowd&&(global.crowdutil.crhelper.defaultCrowd=null),"undefined"==typeof global.crowdutil.crhelper.crowds&&(global.crowdutil.crhelper.crowds={some:!0}),k=function(){var a,b,c,d,e,f;logger.trace("setupCROWD"),b=require(process.cwd()+"/crowdutil.json"),a=require("atlassian-crowd"),f=b.directories;for(c in f){e=f[c],logger.debug("setupCROWD: adding "+c+"\n"+JSON.stringify(e,null,2));try{global.crowdutil.crhelper.crowds[c]=new a(e)}catch(g){d=g,logger.warn(d.message)}}return logger.debug(""+JSON.stringify(global.crowdutil.crhelper))},g=function(a){var b,c;return c=global.crowdutil.crhelper.defaultCrowd,b=global.crowdutil.crhelper.crowds,logger.trace("getCROWD: "+a),logger.debug("getCROWD: "+JSON.stringify(b)),"object"==typeof b[a]?(logger.debug("getCROWD: using "+a),b[a]):(logger.debug("getCROWD: using default directory"),c)},j=function(a){"object"==typeof a&&(global.crowdutil.crhelper.defaultCrowd=a)},exports.findUser=f,exports.findGroup=d,exports.listUsersGroup=h,exports.findGroupMembers=e,exports.addUserToGroup=a,exports.rmUserFromGroup=i,exports.emptyGroup=c,exports.setupCROWD=k,exports.getCROWD=g,exports.setDefaultCrowd=j}).call(this);