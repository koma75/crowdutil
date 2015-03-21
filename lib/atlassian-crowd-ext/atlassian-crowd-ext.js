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
  OUT OF OR IN crowdECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */
(function(){var a,b,c,d,e;a=require("atlassian-crowd"),e=require("url"),c=require("http"),d=require("https"),a.prototype.user.update=function(a,c,d){var e,f;return e=null,a&&c?"string"!=typeof c.name||"string"!=typeof c["first-name"]||"string"!=typeof c["last-name"]||"string"!=typeof c["display-name"]||"string"!=typeof c.email||"boolean"!=typeof c.active?(e=new Error("missing input"),e.type="BAD_REQUEST"):c.name!==a&&(e=new Error("username missmatch"),e.type="BAD_REQUEST"):(e=new Error("missing input"),e.type="BAD_REQUEST"),e?d(e):("undefined"!=typeof c.password&&delete c.password,f={method:"PUT",data:JSON.stringify(c),path:"/user?username="+a},b(f,function(a,b){return d(a,b)}))},b=function(a,b){var e,f,g,h,i;if(e="",f=void 0,g={hostname:this.settings.hostname,port:this.settings.port,auth:this.settings.authstring,method:a.method,path:settings.pathname+settings.apipath+a.path,rejectUnauthorized:"rejectUnauthorized"in this.settings?this.settings.rejectUnauthorized:!0,headers:{Accept:"application/json"}},"POST"===a.method||"PUT"===a.method){if(!a.data)return f=new Error("Missing POST Data"),f.type="BAD_REQUEST",b(f);g.headers["content-type"]="application/json",g.headers["content-length"]=a.data.length}else"DELETE"===a.method&&(g.headers["content-length"]="0");h="https:"===settings.protocol?d:c,i=h.request(g,function(a){return a.on("data",function(a){e+=a.toString()}),204===a.statusCode?b(null,a.statusCode):401===a.statusCode?(f=new Error("Application Authorization Error"),f.type="APPLICATION_ACCESS_DENIED",b(f)):403===a.statusCode?(f=new Error("Application Permission Denied"),f.type="APPLICATION_PERMISSION_DENIED",b(f)):void a.on("end",function(){return"application/json"!==a.headers["content-type"]?(f=new Error("Invalid Response from Atlassian Crowd"),f.type="INVALID_RESPONSE",b(f)):e?(e=JSON.parse(e),e.reason||e.message?("undefined"==typeof e.reason&&(e.reason="BAD_REQUEST",e.message="Invalid Request to Atlassian Crowd"),f=new Error(e.message),f.type=e.reason,b(f)):b(null,e)):b(null,a.statusCode)})}),a.data?i.end(a.data):i.end()},module.exports=a}).call(this);