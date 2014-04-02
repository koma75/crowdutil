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
(function(){var a,b,c;a=require("../helper/crhelper"),b=require("../helper/helper"),c=function(a){var c;return c=!0,b.isName(a.options.first,!1)||(c=!1,logger.error("first name not valid")),b.isName(a.options.last,!1)||(c=!1,logger.error("last name not supplied")),b.isName(a.options.dispname,!0)||(logger.info("disp name not supplied"),a.options.dispname=a.options.first+" "+a.options.last),b.isEmail(a.options.email)||(c=!1,logger.error("email not supplied or invalid")),b.isName(a.options.uid,!1)||(c=!1,logger.error("uid not supplied")),b.isPass(a.options.pass)||(logger.info("password not supplied. using a random password."),a.options.pass=b.randPass()),c},exports.run=function(b){var d;return logger.trace("running : create-user\n\n\n"),logger.debug(b),c(b)?(d=b.crowd,d.user.create(b.options.first,b.options.last,b.options.dispname,b.options.email,b.options.uid,b.options.pass,function(c){if(c)return logger.error(c.message);try{return a.findUser(d,{uid:b.options.uid},function(a){return logger.info(a)})}catch(e){throw c=e}})):void logger.error("parameter invalid!")}}).call(this);