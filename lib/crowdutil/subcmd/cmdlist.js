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
(function(){var a,b;a=function(a){a.parameters(["-D","--directory"],"target directory"),a.options(["-v","--verbose"],"verbose mode")},b=function(b,c){var d,e;d=require("operetta").Operetta,e=new d,e.command("test-connect","test connection to selected Directory",function(d){a(d),d.start(function(a){c(b,a)?require("./test-connection").run(a):logger.error("initialization failed")})}),e.command("create-user","create user in selected Directory",function(d){a(d),d.parameters(["-f","--first"],"user's first name"),d.parameters(["-l","--last"],"user's last name"),d.parameters(["-d","--dispname"],"user's display name [optional]"),d.parameters(["-e","--email"],"user's email address"),d.parameters(["-u","--uid"],"user's login ID"),d.parameters(["-p","--pass"],"user's password [optional]"),d.start(function(a){c(b,a)?require("./create-user").run(a):logger.error("initialization failed")})}),e.command("create-group","create group in selected Directory",function(d){a(d),d.parameters(["-n","--name"],"group name"),d.parameters(["-d","--desc"],"description of the group"),d.start(function(a){c(b,a)?require("./create-group").run(a):logger.error("initialization failed")})}),e.command("add-to-groups","add users to groups",function(d){a(d),d.parameters(["-g","--group"],"comma separated list of groups to add users to"),d.parameters(["-u","--uid"],"comma separated list of users to add to groups"),d.start(function(a){c(b,a)?require("./add-to-groups").run(a):logger.error("initialization failed")})}),e.command("rm-from-groups","remove users from groups",function(d){a(d),d.parameters(["-g","--group"],"comma separated list of groups to remove users from"),d.parameters(["-u","--uid"],"comma separated list of users to remove from groups"),d.start(function(a){c(b,a)?require("./rm-from-groups").run(a):logger.error("initialization failed")})}),e.command("empty-groups","empty the specified group",function(d){a(d),d.parameters(["-g","--group"],"comma separated list of groups to empty out"),d.options(["-f","--force"],"force emptying the group"),d.start(function(a){c(b,a)?require("./empty-groups").run(a):logger.error("initialization failed")})}),e.banner="crowdutil. Atlassian Crowd utility command line tool\n\n",e.options(["-V","--version"],"display version info"),e.on("-V",function(){var a;a=require("../../../package.json"),console.log(a.name+" version "+a.version)}),e.start()},exports.start=b}).call(this);