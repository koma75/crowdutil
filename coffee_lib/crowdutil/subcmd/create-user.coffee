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

crhelp = require '../helper/crhelper'
help = require '../helper/helper'

isOptOK = (opts) ->
  rc = true

  if !help.isName(opts['options']['first'], false)
    rc = false
    console.log 'first name not valid'
  if !help.isName(opts['options']['last'], false)
    rc = false
    console.log 'last name not supplied'
  if !help.isName(opts['options']['dispname'], true)
    console.log 'disp name not supplied'
    opts['options']['dispname'] = opts['options']['first'] +
      ' ' + opts['options']['last']
  if !help.isEmail(opts['options']['email'])
    rc = false
    console.log 'email not supplied or invalid'
  if !help.isName(opts['options']['uid'], false)
    rc = false
    console.log 'uid not supplied'
  if !help.isPass(opts['options']['pass'])
    console.log 'password not supplied. using a random password.'
    opts['options']['pass'] = help.randPass()
  return rc

###
options = {
  targets: [],
  options:
   { directory: 'internal',
     first: 'fname',
     last: 'lname',
     dispname: 'y o',
     email: 'email',
     uid: 'j01234',
     pass: 'aaa' },
  mod: 'create-user',
  crowd: {} }
###
exports.run = (options) ->
  console.log 'running : create-user\n\n\n'
  console.log options

  if !isOptOK(options)
    console.log 'parameter invalid!'
    return

  crowd = options['crowd']
  crowd.user.create(
    options['options']['first'],
    options['options']['last'],
    options['options']['dispname'],
    options['options']['email'],
    options['options']['uid'],
    options['options']['pass'],
    (err) ->
      if err
        console.log err.message
      else
        # check if user really was created
        try
          crhelp.findUser(crowd, {
            uid: options['options']['uid']
          }, (res) ->
            console.log res
          )
        catch err
          throw err
    )
