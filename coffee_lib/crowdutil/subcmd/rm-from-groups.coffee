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
async = require 'async'

isOptOK = (opt) ->
  rc = true

  help.opSplitCsv(opt, '-g')
  if opt['-g'].length != 0
    for group in opt['-g']
      if !help.isName(group, false)
        logger.error 'invalid group name:' + group
        console.log 'E, invalid group name:' + group
        rc = false
  else
    logger.error 'no groups supplied'
    console.log 'E, no groups supplied'
    rc = false
  logger.debug 'groups: \n' + JSON.stringify(opt['-g'], null, 2)

  help.opSplitCsv(opt, '-u')
  if opt['-u'].length != 0
    for user in opt['-u']
      if !help.isName(user, false)
        logger.error 'invalid uid:' + user
        console.log 'E, invalid uid:' + user
        rc = false
  else
    logger.error 'no users supplied'
    console.log 'E, no users supplied'
    rc = false
  logger.debug 'users: \n' + JSON.stringify(opt['-u'], null, 2)

  return rc

exports.run = (options) ->
  logger.trace 'running : rm-from-groups\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return

  crowd = options['crowd']

  async.each(options['-g'],
    (group, gDone) ->
      logger.trace 'processing ' + group
      # Iterate over users
      async.each(options['-u'],
        (user, uDone) ->
          logger.trace 'remove ' + user + ' from ' + group
          crhelp.rmUserFromGroup(crowd, user, group, (err) ->
            if err
              logger.warn err.message
              console.log "W, FAIL: " + group + ' - ' + user
            else
              logger.info group + ' - ' + user
              console.log "I, DONE: " + group + ' - ' + user
            uDone() # ignore error
          )
          return
        , (err) ->
          # all user iterations done for a group
          logger.trace 'all users in ' + group + ' done.'
          console.log "I, finished processing #{group}"
          gDone(err)
          return
      ) # /USER ITERATION
      return
    , (err) ->
      # all group iterations done
      if err
        logger.warn err.message
      logger.info 'DONE'
      console.log 'I, DONE.'
      return
  )
  return
