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
readline = require 'readline'
async = require 'async'

emptyGroup = (crowd, group) ->
  try
    crhelp.findGroupMembers(crowd, group, (res) ->
      console.log res
      # TODO: now remove each member from the group
      # ignore each remove errors. only log.
    )
  catch err
    console.log err.message
  return

exports.run = (options) ->
  console.log 'running : empty-groups\n\n\n'
  console.log options

  crowd = options['crowd']
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

