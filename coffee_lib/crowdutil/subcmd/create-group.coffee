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

isOptOK = (opts) ->
  rc = true

  if(
    !help.opIsType(opts, '-n', 'string') ||
    !help.isName(opts['-n'][0], false)
  )
    logger.warn 'invalid group name'
    console.log 'E, invalid group name'
    rc = false
  if !help.opIsType(opts, '-d', 'string')
    # just put an empty string
    opts['-d'] = ['']

  return rc

exports.run = (options) ->
  logger.trace 'running : create-group\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return

  crowd = options['crowd']
  crowd.groups.create(
    options['-n'][0],
    options['-d'][0],
    (err) ->
      if err
        logger.error err.message
        console.log "E, failed to create #{options['-n'][0]}"
      else
        # check if group is created as intended
        crhelp.findGroup(
          crowd,
          {
            name: options['-n'][0]
          },
          (err, res) ->
            if err
              console.log "W, group creation returned success but could not be found."
              console.log "W, Confirm at the Crowd admin console for assurance."
              logger.warn err.message
              return
            logger.debug JSON.stringify(res)
            console.log "I, group created successfully"
            console.log JSON.stringify(res,null,2)
        )
  )
