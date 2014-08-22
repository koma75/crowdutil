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
(function(){var a,b,c;a=require("../helper/crhelper"),b=require("../helper/helper"),c=function(a){var c;return c=!0,b.opIsType(a,"-f","string")&&b.isName(a["-f"][0],!1)||(c=!1,logger.error("first name not valid"),console.log("E, first name not valid")),b.opIsType(a,"-l","string")&&b.isName(a["-l"][0],!1)||(c=!1,logger.error("last name not supplied"),console.log("E, last name not supplied")),b.opIsType(a,"-d","string")&&b.isName(a["-d"][0],!0)||(logger.info("disp name not supplied"),console.log("I, disp name not supplied"),a["-d"]=[],a["-d"][0]=a["-f"][0]+" "+a["-l"][0]),b.opIsType(a,"-e","string")&&b.isEmail(a["-e"][0])||(c=!1,logger.error("email not supplied or invalid"),console.log("E, email not supplied or invalid")),b.opIsType(a,"-u","string")&&b.isName(a["-u"][0],!1)||(c=!1,logger.error("uid not supplied"),console.log("E, uid not supplied")),b.opIsType(a,"p","string")&&b.isPass(a["-p"][0])||(logger.info("password not supplied. using a random password."),console.log("I, password not supplied. using a random password."),a["-p"]=[],a["-p"][0]=b.randPass(),console.log("I, using a random password: "+a["-p"][0])),c},exports.run=function(b){var d;return logger.trace("running : create-user\n\n\n"),logger.debug(b),c(b)?(logger.debug("creating user with:\n"+JSON.stringify(b,null,2)),d=b.crowd,d.user.create(b["-f"][0],b["-l"][0],b["-d"][0],b["-e"][0],b["-u"][0],b["-p"][0],function(c){return c?(logger.error(c.message),console.log("E, user creation failed. See the log for details")):a.findUser(d,{uid:b["-u"][0]},function(a,b){return a?(console.log("W, user creation returned success but could not be found."),console.log("W, Confirm at the Crowd admin console for assurance."),void logger.warn(a.message)):(logger.info(JSON.stringify(b)),console.log("I, user created successfully:"),console.log(JSON.stringify(b,null,2)))})})):void 0}}).call(this);