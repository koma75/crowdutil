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
help = require '../helper/helper'

Jglr = require 'jglr'

isOptOK = (opts) ->
  rc = true

  if(
    !help.opIsType(opts, '-b', 'string') ||
    !fs.existsSync(opts['-b'][0])
  )
    rc = false
    logger.error "invalid file: #{opts['-b']}"
  if !help.opIsType(opts, '-f', 'boolean')
    opts['-f'] = [ false ]

  return rc

CommandList =
  'create-user': require('./batch-exec/create-user').run
  'create-group': require('./batch-exec/create-group').run
  'add-to-group': require('./batch-exec/add-to-group').run
  'rm-from-group': require('./batch-exec/rm-from-group').run
  'empty-group': require('./batch-exec/empty-group').run
  'activate-user': require('./batch-exec/activate-user').run
  'deactivate-user': require('./batch-exec/deactivate-user').run
  'remove-user': require('./batch-exec/remove-user').run
  'remove-group': require('./batch-exec/remove-group').run

exports.run = (options) ->
  logger.trace 'running : batch-exec'
  logger.debug "options: \n#{JSON.stringify(options, null, 2)}"

  if !isOptOK(options)
    logger.error 'parameter invalid!'
    return
  logger.debug "executing batch!"

  #
  # Setup crhelper so all the possible crowd connections are ready
  #
  crhelp.setDefaultCrowd(options['crowd'])
  crhelp.setupCROWD()

  #
  # Initialize the batch execution framework
  #
  jglr = new Jglr.Jglr({'logger': global.logger})

  jglr.load(options['-b'][0])
  logger.debug(jglr)

  #
  # Register the batch commands
  #
  for cmdName,callback of CommandList
    logger.debug "register callback for #{cmdName}"
    jglr.registerCmd(cmdName, callback)

  #
  # Execute the batch file!
  #
  jglr.dispatch(
    (err) ->
      if err
        logger.error err.message
      logger.info "finished processing #{options['-b'][0]}"
      return
    , !options['-f'][0]
  )
