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
  if typeof opt['options']['force'] == 'undefined'
    opt['options']['force'] = false

  return rc

emptyGroup = (crowd, group) ->
  try
    crhelp.findGroupMembers(crowd, group, (res) ->
      console.log res
      # res [ 'uid1' , 'uid2' ]
      async.each(res,
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
          if err
            console.log err.meesage
          else
            console.log "DONE emptying " + group
          return
      )
    )
  catch err
    console.log err.message
  return

exports.run = (options) ->
  console.log 'running : empty-groups\n\n\n'
  console.log options

  if !isOptOK(options)
    return

  crowd = options['crowd']

  if options['options']['force']
    console.log 'removing users'
    for v in options['options']['name']
      emptyGroup(crowd, v)
    return

  rl = readline.createInterface({
    input: process.stdin
    output: process.stdout
    terminal: false
  })

  rl.setPrompt('> ')

  console.log(
    "Are you sure you want to empty the following groups?:"
  )
  for v in options['options']['name']
    console.log("  * " + v)

  rl.prompt()

  rl.on('line',
    (answer) ->
      if answer.trim() == "yes"
        console.log 'removing users'
        for v in options['options']['name']
          emptyGroup(crowd, v)
      else
        console.log 'abort'
      rl.close()
  )

