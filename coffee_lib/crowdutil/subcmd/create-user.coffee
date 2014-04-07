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

  if(
    !help.opIsType(opts, '-f', 'string') ||
    !help.isName(opts['-f'][0], false)
  )
    rc = false
    logger.error 'first name not valid'
  if(
    !help.opIsType(opts, '-l', 'string') ||
    !help.isName(opts['-l'][0], false)
  )
    rc = false
    logger.error 'last name not supplied'
  if(
    !help.opIsType(opts, '-d', 'string') ||
    !help.isName(opts['-d'][0], true)
  )
    logger.info 'disp name not supplied'
    opts['-d'] = []
    opts['-d'][0] = opts['-f'][0] +
      ' ' + opts['-l'][0]
  if(
    !help.opIsType(opts, '-e', 'string') ||
    !help.isEmail(opts['-e'][0])
  )
    rc = false
    logger.error 'email not supplied or invalid'
  if(
    !help.opIsType(opts, '-u', 'string') ||
    !help.isName(opts['-u'][0], false)
  )
    rc = false
    logger.error 'uid not supplied'
  if(
    !help.opIsType(opts, 'p', 'string') ||
    !help.isPass(opts['-p'][0])
  )
    logger.info 'password not supplied. using a random password.'
    opts['-p'] = []
    opts['-p'][0] = help.randPass()
  return rc

###
###
exports.run = (options) ->
  logger.trace 'running : create-user\n\n\n'
  logger.debug options

  if !isOptOK(options)
    logger.error 'parameter invalid!'
    return
  logger.debug 'creating user with:\n' + JSON.stringify(options,null,2)

  crowd = options['crowd']
  crowd.user.create(
    options['-f'][0],
    options['-l'][0],
    options['-d'][0],
    options['-e'][0],
    options['-u'][0],
    options['-p'][0],
    (err) ->
      if err
        logger.error err.message
      else
        # check if user really was created
        try
          crhelp.findUser(crowd, {
            uid: options['-u'][0]
          }, (res) ->
            logger.info JSON.stringify(res)
          )
        catch err
          logger.warn err.message
    )
