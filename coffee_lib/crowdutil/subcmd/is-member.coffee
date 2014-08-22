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
  logger.trace 'checking opt'
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
  logger.debug '-g :\n' + JSON.stringify(opt['-g'], null, 2)

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
  logger.debug '-u :\n' + JSON.stringify(opt['-u'], null, 2)

  return rc

exports.run = (options) ->
  logger.trace 'running : is-member\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return

  crowd = options['crowd']
  # uMembership.<uid> = [groupname, groupname ...]
  uMembership = {}

  # TODO: first, get the users group list
  async.eachLimit(options['-u'],1,
    (user, Done) ->
      logger.trace "searching for users group memberships"
      crhelp.listUsersGroup(crowd, user, (err, res) ->
        if err
          Done(err)
        else
          logger.info "#{JSON.stringify(res,null,2)}"
          uMembership[user] = res
          Done()
        return
      )
      return
    , (err) ->
      if err
        logger.error err.message
        console.log "E, failed to find user memberships"
      else
        for group in options['-g']
          for uid,membership of uMembership
            isMember = false
            for v in membership
              if v == group
                isMember = true
                break
            if isMember
              console.log "= #{group} : #{uid}"
            else
              console.log "! #{group} : #{uid}"
      return
  )

  return
