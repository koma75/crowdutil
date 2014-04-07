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
(function(){var a,b,c,d,e,f,g,h;h=require("validator"),g=function(){return encodeURIComponent(require("crypto").randomBytes(18).toString("base64"))},c=function(a){return"string"!=typeof a?!1:0===a.length?!1:!0},b=function(a,b){var c;return c=b?/^[a-zA-Z0-9_\-. ]*$/:/^[a-zA-Z0-9_\-.]*$/,"string"!=typeof a?!1:0===a.length?!1:a.match(c)?!0:!1},a=function(a){return"string"!=typeof a?!1:0===a.length?!1:h.isEmail(a)},d=function(a,b){var c;return c=!1,"undefined"!=typeof a[b]&&(c=!0),c},e=function(a,b,c){var d;return d=!1,"object"==typeof a[b]&&typeof a[b][0]===c&&(d=!0),d},f=function(a,b){var c,e,f,g,h;if(c=[],d(a,b))for(h=a[b],f=0,g=h.length;g>f;f++)e=h[f],c=c.concat(e.split(","));a[b]=c},exports.randPass=g,exports.isEmail=a,exports.isName=b,exports.isPass=c,exports.opIsAvail=d,exports.opIsType=e,exports.opSplitCsv=f}).call(this);