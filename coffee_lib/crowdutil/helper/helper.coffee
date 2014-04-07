###
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
###

validator = require 'validator'

randPass = () ->
  return encodeURIComponent(
    require('crypto').randomBytes(18).toString('base64')
  )

isPass = (str) ->
  if typeof str != 'string'
    return false
  if str.length == 0
    return false
  return true

isName = (str, allowSpace) ->
  if allowSpace
    pattern = /^[a-zA-Z0-9_\-. ]*$/
  else
    pattern = /^[a-zA-Z0-9_\-.]*$/

  if typeof str != 'string'
    return false
  if str.length == 0
    return false
  if !str.match(pattern)
    return false
  return true

isEmail = (str) ->
  if typeof str != 'string'
    return false
  if str.length == 0
    return false
  return validator.isEmail(str)

###
operetta helper
###

opIsAvail = (opt, flag) ->
  rc = false
  if typeof opt[flag] != 'undefined'
    rc = true
  return rc

opIsType = (opt, flag, type) ->
  rc = false
  if(
    typeof opt[flag] == 'object' &&
    typeof opt[flag][0] == type
  )
    rc = true
  return rc

opSplitCsv = (opt, flag) ->
  arr = []
  if opIsAvail(opt, flag)
    for csv in opt[flag]
      arr = arr.concat(csv.split(","))
  
  opt[flag] = arr
  return

###
exports
###
exports.randPass = randPass
exports.isEmail = isEmail
exports.isName = isName
exports.isPass = isPass
exports.opIsAvail = opIsAvail
exports.opIsType = opIsType
exports.opSplitCsv = opSplitCsv
