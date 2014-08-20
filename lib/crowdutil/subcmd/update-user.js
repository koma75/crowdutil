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
(function(){var a,b,c;a=require("../helper/crhelper"),b=require("../helper/helper"),c=function(a){var c;return c=!0,b.opIsType(a,"-f","string")&&!b.isName(a["-f"][0],!1)&&(c=!1,logger.error("first name not valid"),console.log("E, first name not valid")),b.opIsType(a,"-l","string")&&!b.isName(a["-l"][0],!1)&&(c=!1,logger.error("last name not valid"),console.log("E, last name not valid")),b.opIsType(a,"-d","string")&&!b.isName(a["-d"][0],!0)&&(c=!1,logger.error("disp name not valid"),console.log("E, disp name not valid")),b.opIsType(a,"-e","string")&&!b.isEmail(a["-e"][0])&&(c=!1,logger.error("email not valid"),console.log("E, email not valid")),b.opIsType(a,"-u","string")&&b.isName(a["-u"][0],!1)||(c=!1,logger.error("uid not given or invalid"),console.log("E, uid not given or invalid")),b.opIsType(a,"-a","string")&&!b.isName(a["-a"][0],!1)&&(c=!1,logger.error("active state not valid"),console.log("E, active state not valid")),c},exports.run=function(d){var e,f,g;return logger.trace("running : update-user\n\n\n"),logger.debug(d),c(d)?(logger.debug("updating user with:\n"+JSON.stringify(d,null,2)),g={},b.opIsType(d,"-f","string")&&(g["first-name"]=d["-f"][0]),b.opIsType(d,"-l","string")&&(g["last-name"]=d["-l"][0]),b.opIsType(d,"-d","string")&&(g["display-name"]=d["-d"][0]),b.opIsType(d,"-e","string")&&(g.email=d["-e"][0]),b.opIsType(d,"-a","string")&&("true"===d["-a"][0]&&(g.active=!0),"false"===d["-a"][0]&&(g.active=!1)),f=d["-u"][0],0===Object.getOwnPropertyNames(g).length?(logger.info("nothing to update!"),void console.log("I, nothing to update!")):(e=d.crowd,a.updateUser(e,f,g,function(a){return a?(logger.error(a.message),console.log("E, Error updating "+f+". Check the log for details.")):(logger.info(" * update user "+f+", done."),console.log("I, update user "+f+", done."))}))):void 0}}).call(this);