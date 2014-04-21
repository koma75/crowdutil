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

crhelp = require '../../helper/crhelper'
help = require '../../helper/helper'

isOptOK = (cmds) ->
  rc = true

  # CHECK CMDS
  # cmds[0] command
  # cmds[1] Directory
  # cmds[2] uid
  # cmds[3] active flag
  # cmds[4] first name
  # cmds[5] last name
  # cmds[6] disp name
  # cmds[7] email
  if cmds.length < 4
    logger.warn "batch-exec: not enough parameters"
    rc = false

  if(
    typeof cmds[2] != 'string' ||
    !help.isName(cmds[2], false)
  )
    logger.warn "batch-exec: uid not valid"
    rc = false
  if(
    typeof cmds[3] == 'string' &&
    cmds[3].trim().length > 0 &&
    !help.isName(cmds[3], false)
  )
    logger.info "batch-exec: active flag not valid"
    rc = false
  if(
    typeof cmds[4] == 'string' &&
    cmds[4].trim().length > 0 &&
    !help.isName(cmds[4], false)
  )
    logger.warn "batch-exec: first name not valid"
    rc = false
  if(
    typeof cmds[5] != 'string' &&
    cmds[5].trim().length > 0 &&
    !help.isName(cmds[5], false)
  )
    logger.warn "batch-exec: last name not valid"
    rc = false
  if(
    typeof cmds[6] == 'string' &&
    cmds[6].trim().length > 0 &&
    !help.isName(cmds[6], true)
  )
    logger.info "batch-exec: display name not valid"
    rc = false
  if(
    typeof cmds[7] == 'string' &&
    cmds[7].trim().length > 0 &&
    !help.isEmail(cmds[7])
  )
    logger.warn "batch-exec: email not valid"
    rc = false

  return rc

exports.run = (cmds, done) ->
  logger.trace "batch-exec: update-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"

  err = false

  if !isOptOK(cmds)
    setTimeout(() ->
      logger.error "batch-exec: update-user parameter error"
      done(new Error("batch-exec: update-user parameter error"))
      return
    ,0)
  else
    update = {}

    # get the command parameters and prepare for update
    if typeof cmds[4] == 'string' && cmds[4].trim().length > 0
      update['first-name'] = cmds[4]
    if typeof cmds[5] == 'string' && cmds[5].trim().length > 0
      update['last-name'] = cmds[5]
    if typeof cmds[6] == 'string' && cmds[6].trim().length > 0
      update['display-name'] = cmds[6]
    if typeof cmds[7] == 'string' && cmds[7].trim().length > 0
      update['email'] = cmds[7]
    if typeof cmds[3] == 'string'
      if cmds[3] == 'true'
        update['active'] = true
      if cmds[3] == 'false'
        update['active'] = false
    
    uid = cmds[2]
    
    # If there was no input, ignore
    if Object.getOwnPropertyNames(update).length == 0
      logger.info "nothing to update!"
      setTimeout(done, 0)
      return

    # select the crowd application
    crowd = crhelp.getCROWD(cmds[1])

    # run update with the given user information
    crhelp.updateUser(crowd, uid, update, (err) ->
      if err
        logger.error "batch-exec:update-user:error processing #{uid}:\n" +
          "#{err.message}"
        done(err)
      else
        logger.info " * update user #{uid}, done."
        done()
    )

  return
