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

  if(
    typeof opt['options']['name'] != 'undefined' &&
    opt['options']['name'].length != 0
  )
    for group in opt['options']['name']
      if !help.isName(group, false)
        console.log 'invalid group name:' + group
        rc = false
  else
    console.log 'no groups supplied'
    rc = false

  if(
    typeof opt['options']['uid'] != 'undefined' &&
    opt['options']['uid'].length != 0
  )
    for user in opt['options']['uid']
      if !help.isName(user, false)
        console.log 'invalid uid:' + user
        rc = false
  else
    console.log 'no users supplied'
    rc = false

  return rc

exports.run = (options) ->
  console.log 'running : rm-from-groups\n\n\n'
  console.log options

  if !isOptOK(options)
    return

  crowd = options['crowd']

  async.each(options['options']['name'],
    (group, gDone) ->
      # Iterate over users
      async.each(options['options']['uid'],
        (user, uDone) ->
          try
            crhelp.rmUserFromGroup(crowd, user, group, (err) ->
              if err
                console.log err.message
              else
                console.log group + ' - ' + user
              uDone() # ignore error
            )
          catch err
            console.log err.message
            uDone()
          return
        , (err) ->
          # all user iterations done for a group
          gDone(err)
          return
      ) # /USER ITERATION
      return
    , (err) ->
      # all group iterations done
      if err
        console.log err.message
      console.log 'DONE'
      return
  )
  return

