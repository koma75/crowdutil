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

isOptOK = (cmds) ->
  rc = true

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
    rc = false
  if(
    typeof cmds[3] != 'string' ||
    !help.isName(cmds[3], false)
  )
    logger.warn "batch-exec: last name not valid"
    rc = false
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
    rc = false
  if(
    typeof cmds[6] != 'string' ||
    !help.isName(cmds[6], false)
  )
    logger.warn "batch-exec: uid not valid"
    rc = false
  if(
    typeof cmds[7] != 'string' ||
    !help.isPass(cmds[7])
  )
    logger.info "batch-exec: password not supplied"
    cmds[7] = help.randPass()

  return rc

exports.run = (cmds, done) ->
  logger.trace "batch-exec: create-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"

  err = false

  if !isOptOK(cmds)
    setTimeout(() ->
      done()
      return
    ,0)
  else
    # select the crowd application
    crowd = crhelp.getCROWD(cmds[1])

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