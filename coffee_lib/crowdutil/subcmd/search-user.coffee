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

isOptOK = (opts) ->
  rc = true

  if(
    help.opIsType(opts, '-f', 'string') &&
    !help.isSearchString(opts['-f'][0])
  )
    rc = false
    logger.error "invalid first name: #{opts['-f'][0]}"
    console.log "E, invalid first name: #{opts['-f'][0]}"
  if(
    help.opIsType(opts, '-l', 'string') &&
    !help.isSearchString(opts['-l'][0])
  )
    rc = false
    logger.error "invalid last name: #{opts['-l'][0]}"
    console.log "E, invalid last name: #{opts['-l'][0]}"
  if(
    help.opIsType(opts, '-e', 'string') &&
    !help.isSearchString(opts['-e'][0])
  )
    rc = false
    logger.error "invalid email address: #{opts['-e'][0]}"
    console.log "E, invalid email address: #{opts['-e'][0]}"
  if(
    help.opIsType(opts, '-u', 'string') &&
    !help.isSearchString(opts['-u'][0])
  )
    rc = false
    logger.error "invalid uid: #{opts['-u'][0]}"
    console.log "E, invalid uid: #{opts['-u'][0]}"
  return rc

###
###
exports.run = (options) ->
  logger.trace 'running : search-user\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return
  logger.debug 'searching user with:\n' + JSON.stringify(options,null,2)

  crowd = options['crowd']

  opts = {}
  if help.opIsType(options, '-u', 'string')
    opts.uid = options['-u'][0]
  if help.opIsType(options, '-f', 'string')
    opts.fname = options['-f'][0]
  if help.opIsType(options, '-l', 'string')
    opts.lname = options['-l'][0]
  if help.opIsType(options, '-e', 'string')
    opts.email = options['-e'][0]

  crhelp.findUser(crowd, opts, (err, res) ->
    if err
      logger.error err.message
      console.log "E, failed to find user:\n#{JSON.stringify(opts,null,2)}"
      return
    logger.debug "search results: \n#{JSON.stringify(res,null,2)}"
    console.log "I, found #{res.users.length} users:"
    async.eachLimit(res.users, 1,
      (user, uDone) ->
        crowd.user.find(user.name, (err, res) ->
          if err
            logger.error err.message
            console.log "E, failed to get user info for #{user.name}"
          else
            logger.debug "---\n#{JSON.stringify(res,null,2)}"
            console.log "--- #{res.name}:\n" +
              "  uid:           #{res["name"]}\n" +
              "  first name:    #{res["first-name"]}\n" +
              "  last name:     #{res["last-name"]}\n" +
              "  display name:  #{res["display-name"]}\n" +
              "  email address: #{res["email"]}\n" +
              "  active:        #{res["active"]}"
          uDone()
        )
        return
      , (err) ->
        if err
          logger.error err.message
        return
    )
  )
