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
(function(){var a,b,c;a=require("../helper/crhelper"),b=require("../helper/helper"),c=function(a){var c;return c=!0,b.opIsType(a,"-n","string")&&b.isName(a["-n"][0],!1)||(logger.warn("invalid group name"),console.log("E, invalid group name"),c=!1),b.opIsType(a,"-d","string")||(a["-d"]=[""]),c},exports.run=function(b){var d;return logger.trace("running : create-group\n\n\n"),logger.debug(b),c(b)?(d=b.crowd,d.groups.create(b["-n"][0],b["-d"][0],function(c){if(c)return logger.warn(c.message),console.log("E, failed to create "+b["-n"][0]);try{return a.findGroup(d,{name:b["-n"][0]},function(a){return logger.debug(JSON.stringify(a)),console.log("I, group created successfully"),console.log(JSON.stringify(a,null,2))})}catch(e){return c=e,console.log("W, group creation returned success but could not be found."),console.log("W, Confirm at the Crowd admin console for assurance."),logger.warn(c.message)}})):void 0}}).call(this);