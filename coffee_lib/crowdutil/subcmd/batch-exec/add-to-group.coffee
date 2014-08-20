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
  # cmds[2] UID
  # cmds[3] Group name
  if cmds.length < 4
    logger.warn "batch-exec: not enough parameters"
    console.log "E, add-to-group: not enough parameters"
    rc = false

  if(
    typeof cmds[2] != 'string' ||
    !help.isName(cmds[2], false)
  )
    logger.warn 'batch-exec: invalid uid'
    console.log "E, add-to-group: invalid uid"
    rc = false
  if(
    typeof cmds[3] != 'string' ||
    !help.isName(cmds[3], false)
  )
    logger.warn 'batch-exec: invalid group name'
    console.log "E, add-to-group: invalid group name"
    rc = false

  return rc

exports.run = (cmds, done) ->
  logger.trace "batch-exec: add-to-group"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"

  err = false

  if !isOptOK(cmds)
    setTimeout(() ->
      logger.debug("batch-exec:add-to-group param error")
      console.log "E, add-to-group: param error: #{JSON.stringify(cmds)}"
      done(new Error("batch-exec:add-to-group param error"))
      return
    ,0)
  else
    # select the crowd application
    crowd = crhelp.getCROWD(cmds[1])

    # Run the command
    try
      crhelp.addUserToGroup(crowd, cmds[2], cmds[3], (err) ->
        if err
          logger.error "batch-exec: #{err.message}\n#{JSON.stringify(cmds)}"
          console.log "E, add-to-group: FAIL: #{cmds[3]} + #{cmds[2]} (#{cmds[1]})"
          done(err)
        else
          logger.info cmds[3] + ' + ' + cmds[2]
          console.log "I, add-to-group: DONE: #{cmds[3]} + #{cmds[2]} (#{cmds[1]})"
          done()
      )
    catch err
      if err
        logger.error "batch-exec: #{err.message}\n#{JSON.stringify(cmds)}"
        done(err)

  return
