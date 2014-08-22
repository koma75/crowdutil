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
(function(){var a,b,c,d;b=require("../helper/crhelper"),c=require("../helper/helper"),a=require("async"),d=function(a){var b;return b=!0,c.opIsType(a,"-f","string")&&!c.isSearchString(a["-f"][0])&&(b=!1,logger.error("invalid first name: "+a["-f"][0]),console.log("E, invalid first name: "+a["-f"][0])),c.opIsType(a,"-l","string")&&!c.isSearchString(a["-l"][0])&&(b=!1,logger.error("invalid last name: "+a["-l"][0]),console.log("E, invalid last name: "+a["-l"][0])),c.opIsType(a,"-e","string")&&!c.isSearchString(a["-e"][0])&&(b=!1,logger.error("invalid email address: "+a["-e"][0]),console.log("E, invalid email address: "+a["-e"][0])),c.opIsType(a,"-u","string")&&!c.isSearchString(a["-u"][0])&&(b=!1,logger.error("invalid uid: "+a["-u"][0]),console.log("E, invalid uid: "+a["-u"][0])),b},exports.run=function(e){var f,g;return logger.trace("running : search-user\n\n\n"),logger.debug(e),d(e)?(logger.debug("searching user with:\n"+JSON.stringify(e,null,2)),f=e.crowd,g={},c.opIsType(e,"-u","string")&&(g.uid=e["-u"][0]),c.opIsType(e,"-f","string")&&(g.fname=e["-f"][0]),c.opIsType(e,"-l","string")&&(g.lname=e["-l"][0]),c.opIsType(e,"-e","string")&&(g.email=e["-e"][0]),b.findUser(f,g,function(b,c){return b?(logger.error(b.message),void console.log("E, failed to find user:\n"+JSON.stringify(g,null,2))):(logger.debug("search results: \n"+JSON.stringify(c,null,2)),console.log("I, found "+c.users.length+" users:"),a.eachLimit(c.users,1,function(a,b){f.user.find(a.name,function(c,d){return c?(logger.error(c.message),console.log("E, failed to get user info for "+a.name)):(logger.debug("---\n"+JSON.stringify(d,null,2)),console.log("--- "+d.name+":\n"+("  uid:           "+d.name+"\n")+("  first name:    "+d["first-name"]+"\n")+("  last name:     "+d["last-name"]+"\n")+("  display name:  "+d["display-name"]+"\n")+("  email address: "+d.email+"\n")+("  active:        "+d.active))),b()})},function(a){a&&logger.error(a.message)}))})):void 0}}).call(this);