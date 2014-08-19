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
    help.opIsType(opts, '-f', 'string') &&
    !help.isName(opts['-f'][0], false)
  )
    rc = false
    logger.error 'first name not valid'
    console.log 'E, first name not valid'
  if(
    help.opIsType(opts, '-l', 'string') &&
    !help.isName(opts['-l'][0], false)
  )
    rc = false
    logger.error 'last name not valid'
    console.log 'E, last name not valid'
  if(
    help.opIsType(opts, '-d', 'string') &&
    !help.isName(opts['-d'][0], true)
  )
    rc = false
    logger.error 'disp name not valid'
    console.log 'E, disp name not valid'
  if(
    help.opIsType(opts, '-e', 'string') &&
    !help.isEmail(opts['-e'][0])
  )
    rc = false
    logger.error 'email not valid'
    console.log 'E, email not valid'
  if(
    !help.opIsType(opts, '-u', 'string') ||
    !help.isName(opts['-u'][0], false)
  )
    rc = false
    logger.error 'uid not given or invalid'
    console.log 'E, uid not given or invalid'
  if(
    help.opIsType(opts, '-a', 'string') &&
    !help.isName(opts['-a'][0], false)
  )
    rc = false
    logger.error 'active state not valid'
    console.log 'E, active state not valid'
  return rc

exports.run = (options) ->
  logger.trace 'running : update-user\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return
  logger.debug 'updating user with:\n' + JSON.stringify(options,null,2)

  update = {}

  # get the command parameters and prepare for update
  if help.opIsType(options, '-f', 'string')
    update['first-name'] = options['-f'][0]
  if help.opIsType(options, '-l', 'string')
    update['last-name'] = options['-l'][0]
  if help.opIsType(options, '-d', 'string')
    update['display-name'] = options['-d'][0]
  if help.opIsType(options, '-e', 'string')
    update['email'] = options['-e'][0]
  if help.opIsType(options, '-a', 'string')
    if options['-a'][0] == 'true'
      update['active'] = true
    if options['-a'][0] == 'false'
      update['active'] = false

  uid = options['-u'][0]

  # If there was no input, ignore
  if Object.getOwnPropertyNames(update).length == 0
    logger.info "nothing to update!"
    console.log "I, nothing to update!"
    return

  # run update with the given user information
  crowd = options['crowd']
  crhelp.updateUser(crowd, uid, update, (err) ->
    if err
      logger.error err.message
      console.log "E, Error updating #{uid}. Check the log for details."
    else
      logger.info " * update user #{uid}, done."
      console.log "I, update user #{uid}, done."
  )
