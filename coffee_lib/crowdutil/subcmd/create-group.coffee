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

  if !help.isName(opts['options']['name'], false)
    logger.warn 'invalid group name'
    rc = false
  if typeof opts['options']['desc'] != 'string'
    # just put an empty string
    opts['options']['desc'] = ''

  return rc

exports.run = (options) ->
  logger.trace 'running : create-group\n\n\n'
  logger.debug options

  if !isOptOK(options)
    return

  crowd = options['crowd']
  crowd.groups.create(
    options['options']['name'],
    options['options']['desc'],
    (err) ->
      if err
        logger.warn err.message
      else
        # check if group is created as intended
        try
          crhelp.findGroup(
            crowd,
            {
              name: options['options']['name']
            },
            (res) ->
              logger.debug res
          )
        catch err
          throw err
  )
