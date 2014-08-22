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

  opIsType = (opt, flag, type) ->

  if(
    !help.opIsType(opt, '-g', 'string') ||
    !help.isName(opt['-g'][0], false)
  )
    rc = false
    logger.error "invalid group name: #{opt['-g']}"
    console.log "E, invalid group name: #{opt['-g']}"

  return rc

exports.run = (options) ->
  logger.trace 'running : list-member\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return

  crowd = options['crowd']

  crhelp.findGroupMembers(crowd, options['-g'], (err, res) ->
    if err
      logger.error err.message
      console.log "E, failed to find members of #{options['-g'][0]}"
    else
      logger.info "#{options['-g'][0]}: ¥n#{JSON.stringify(res,null,2)}"
      console.log "I, members of #{options['-g'][0]} are:"
      for member in res
        console.log "#{member}"
    return
  )
