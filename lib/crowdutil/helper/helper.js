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
(function(){var a,b,c,d,e;e=require("validator"),d=function(){return encodeURIComponent(require("crypto").randomBytes(18).toString("base64"))},c=function(a){return"string"!=typeof a?!1:0===a.length?!1:!0},b=function(a,b){var c;return c=b?/^[a-zA-Z0-9_\-. ]*$/:/^[a-zA-Z0-9_\-.]*$/,"string"!=typeof a?!1:0===a.length?!1:a.match(c)?!0:!1},a=function(a){return"string"!=typeof a?!1:0===a.length?!1:e.isEmail(a)},exports.randPass=d,exports.isEmail=a,exports.isName=b,exports.isPass=c}).call(this);