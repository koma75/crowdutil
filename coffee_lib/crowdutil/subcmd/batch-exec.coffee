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
AtlassianCrowd = require 'atlassian-crowd'
help = require '../helper/helper'

Jglr = require 'jglr'

defaultCrowd = null
crowds = {}

setupCROWD = () ->
  logger.trace "setupCROWD"
  cfg = require process.cwd() + '/crowdutil.json'
  for directory,options of cfg['directories']
    logger.debug(
      "setupCROWD: adding #{directory}\n#{JSON.stringify(options,null,2)}"
    )
    try
      crowds[directory] = new AtlassianCrowd(
        options
      )
    catch err
      logger.warn err.message

getCROWD = (directory) ->
  logger.trace "getCROWD: #{directory}"
  if typeof crowds[directory] == 'object'
    logger.debug "batch-exec: using #{directory}"
    return crowds[directory]
  else
    logger.debug "batch-exec: using default directory"
    return defaultCrowd

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
  logger.trace "batch-exec: create-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"

  err = false

  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] first name
  # cmds[3] last name
  # cmds[4] disp name
  # cmds[5] email
  # cmds[6] uid
  # cmds[7] password
  if cmds.length < 7
    logger.warn "batch-exec: not enough parameters"

  if(
    typeof cmds[2] != 'string' ||
    !help.isName(cmds[2], false)
  )
    logger.warn "batch-exec: first name not valid"
    err = true
  if(
    typeof cmds[3] != 'string' ||
    !help.isName(cmds[3], false)
  )
    logger.warn "batch-exec: last name not valid"
    err = true
  if(
    typeof cmds[4] != 'string' ||
    !help.isName(cmds[4], true)
  )
    logger.info "batch-exec: display name not supplied"
    cmds[4] = "#{cmds[2]} #{cmds[3]}"
  if(
    typeof cmds[5] != 'string' ||
    !help.isEmail(cmds[5])
  )
    logger.warn "batch-exec: email not valid"
    err = true
  if(
    typeof cmds[6] != 'string' ||
    !help.isName(cmds[6], false)
  )
    logger.warn "batch-exec: uid not valid"
    err = true
  if(
    typeof cmds[7] != 'string' ||
    !help.isPass(cmds[7])
  )
    logger.info "batch-exec: password not supplied"
    cmds[7] = help.randPass()

  if err
    setTimeout(() ->
      done()
      return
    ,0)
  else
    # select the crowd application
    crowd = getCROWD(cmds[1])

    # Run the command
    crowd.user.create(
      cmds[2],
      cmds[3],
      cmds[4],
      cmds[5],
      cmds[6],
      cmds[7],
      (err) ->
        if err
          logger.error(
            "create user #{cmds[6]}(#{cmds[5]}) failed: #{err.message}"
          )
        else
          logger.info "user #{cmds[6]}(#{cmds[5]}) created"
        done()
      )

  return

create_group = (cmds, done) ->
  logger.trace "batch-exec: create-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] Group name
  # cmds[3] Group Description
  if cmds.length < 3
    logger.warn "batch-exec: not enough parameters"
  setTimeout(done,0)
  return

add_to_group = (cmds, done) ->
  logger.trace "batch-exec: add-to-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] UID
  # cmds[3] Group name
  if cmds.length < 4
    logger.warn "batch-exec: not enough parameters"
  setTimeout(done,0)
  return

rm_from_group = (cmds, done) ->
  logger.trace "batch-exec: rm-from-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] UID
  # cmds[3] Group name
  if cmds.length < 4
    logger.warn "batch-exec: not enough parameters"
  setTimeout(done,0)
  return

empty_group = (cmds, done) ->
  logger.trace "batch-exec: empty-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] Group name
  if cmds.length < 3
    logger.warn "batch-exec: not enough parameters"
  setTimeout(done,0)
  return

deactivate_user = (cmds, done) ->
  logger.trace "batch-exec: deactivate-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"
  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] UID
  # cmds[3] Remove from group flag true if [true|1|yes]. false otherwise
  if cmds.length < 3
    logger.warn "batch-exec: not enough parameters"
  setTimeout(done,0)
  return

exports.run = (options) ->
  logger.trace 'running : batch-exec'
  logger.debug "options: \n#{JSON.stringify(options, null, 2)}"

  if !isOptOK(options)
    logger.error 'parameter invalid!'
    return
  logger.debug "executing batch!"

  defaultCrowd = options['crowd']
  setupCROWD()

  jglr = new Jglr.Jglr({'logger': global.logger})

  jglr.load(options['-b'][0])
  logger.debug(jglr)

  jglr.registerCmd('create-user', create_user)
  jglr.registerCmd('create-group', create_group)
  jglr.registerCmd('add-to-group', add_to_group)
  jglr.registerCmd('rm-from-group', rm_from_group)
  jglr.registerCmd('empty-group', empty_group)
  jglr.registerCmd('deactivate-user', deactivate_user)

  jglr.dispatch(
    (err) ->
      logger.info "finished processing #{options['-b'][0]}"
      return
  )
