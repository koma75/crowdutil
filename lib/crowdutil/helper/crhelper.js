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
(function(){var a,b,c,d,e,f;b=function(a,b,c){var d,e;return b=b||{},d=b.name||"*",e='name="'+d+'"',a.search("group",e,function(a,b){return a?console.log(a.message):c(b)})},d=function(a,b,c){var d,e,f,g,h;return b=b||{},h=b.uid||"*",e=b.fname||"*",f=b.lname||"*",d=b.email||"*",g='name="'+h+'"',g=g+' and firstName="'+e+'"',g=g+' and lastName="'+f+'"',g=g+' and email="'+d+'"',a.search("user",g,function(a,b){return a?console.log(a.message):c(b)})},e=function(a,b,c){var d;if(""===b||"undefined"==typeof b)throw d=new Error("invalid user name");return a.user.groups(b,function(a,b){return a?console.log(a.message):c(b)})},c=function(a,b,c){var d;if(""===b||"undefined"==typeof b)throw d=new Error("findGroupMembers: invalid input"),myError;return a.groups.directmembers(b,function(a,b){return a?console.log(a.message):c(b)})},a=function(a,b,c,d){var e;if(""===b||"undefined"==typeof b||""===c||"undefined"==typeof c)throw e=new Error("addUserToGroup: invalid input");a.groups.addmember(b,c,function(a){return d(a)})},f=function(a,b,c,d){var e;if(""===b||"undefined"==typeof b||""===c||"undefined"==typeof c)throw e=new Error("rmUserFromGroup: invalide input");a.groups.removemember(b,c,function(a){return d(a)})},exports.findUser=d,exports.findGroup=b,exports.listUsersGroup=e,exports.findGroupMembers=c,exports.addUserToGroup=a,exports.rmUserFromGroup=f}).call(this);