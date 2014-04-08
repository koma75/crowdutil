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

fs = require 'fs'
crhelp = require '../helper/crhelper'
help = require '../helper/helper'
Jglr = require 'jglr'

isOptOK = (opts) ->
  rc = true

  if(
    !help.opIsType(opts, '-b', 'string') ||
    !fs.existsSync(opts['-b'][0])
  )
    rc = false
    logger.error "invalid file: #{opts['-b']}"

  return rc

create_user = (cmds, done) ->
  logger.trace "create-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  done()
  return

create_group = (cmds, done) ->
  logger.trace "create-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  done()
  return

add_to_group = (cmds, done) ->
  logger.trace "add-to-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  done()
  return

rm_from_group = (cmds, done) ->
  logger.trace "rm-from-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  done()
  return

empty_group = (cmds, done) ->
  logger.trace "empty-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  done()
  return

deactivate_user = (cmds, done) ->
  logger.trace "deactivate-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  done()
  return

exports.run = (options) ->
  logger.trace 'running : batch-exec'
  logger.debug "options: \n#{JSON.stringify(options, null, 2)}"

  if !isOptOK(options)
    logger.error 'parameter invalid!'
    return
  logger.debug "executing batch!"

  crowd = options['crowd']

  jglr = new Jglr.Jglr({'logger': global.logger})

  jglr.load(options['-b'][0])
  logger.debug(jglr)

  jglr.registerCmd('create-user', create_user)
  jglr.registerCmd('create-group', create_group)
  jglr.registerCmd('add-to-group', add_to_group)
  jglr.registerCmd('rm-from-group', rm_from_group)
  jglr.registerCmd('empty-group', empty_group)
  jglr.registerCmd('deactivate-user', deactivate_user)

  myNext = (hasNext) ->
    if hasNext
      jglr.dispatchNext(myNext)
  
  jglr.dispatchNext(myNext)
