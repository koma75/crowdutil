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
readline = require 'readline'
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

  if !help.opIsType(opt, '-f', 'boolean')
    opt['-f'] = [ false ]

  return rc

emptyGroup = (crowd, group) ->
  crhelp.findGroupMembers(crowd, group, (err, res) ->
    if err
      logger.warn err.message
      console.log "E, could not find any members of #{group}"
      return
    logger.debug res
    # res [ 'uid1' , 'uid2' ]
    async.each(res,
      (user, uDone) ->
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
        if err
          logger.warn err.meesage
          console.log "E, there was an error processing #{group}. Check log for details."
        else
          logger.info "DONE emptying " + group
          console.log "I, finished processing #{group}"
        return
    )
  )
  return

exports.run = (options) ->
  logger.trace 'running : empty-groups\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return

  crowd = options['crowd']

  if options['-f'][0]
    logger.info 'removing users'
    for v in options['-g']
      emptyGroup(crowd, v)
    return

  rl = readline.createInterface({
    input: process.stdin
    output: process.stdout
    terminal: false
  })

  rl.setPrompt('> ')

  console.log "Are you sure you want to empty the following groups?:"
  for v in options['-g']
    console.log "  * #{v}"

  rl.prompt()

  rl.on('line',
    (answer) ->
      if answer.trim() == "yes"
        logger.info 'removing users'
        console.log 'removing users'
        for v in options['-g']
          emptyGroup(crowd, v)
      else
        logger.info 'abort'
        console.log 'abort'
      rl.close()
  )
