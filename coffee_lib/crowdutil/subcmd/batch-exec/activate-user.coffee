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
  if cmds.length < 3
    logger.warn "batch-exec: not enough parameters"
    console.log "E, activate-user: not enough params: #{JSON.stringify(cmds)}"
    rc = false

  return rc

exports.run = (cmds, done) ->
  logger.trace "batch-exec: activate-user"
  logger.debug "cmds = : \n#{JSON.stringify(cmds, null, 2)}"

  err = false

  if !isOptOK(cmds)
    setTimeout(() ->
      done(new Error("batch-exec:activate-user param error"))
      return
    ,0)
  else
    # select the crowd application
    crowd = crhelp.getCROWD(cmds[1])

    # Run the command
    setTimeout(() ->
      done(new Error("batch-exec:activate-user NOT IMPLEMENTED"))
      return
    ,0)

  return
