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
  OUT OF OR IN crowdECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
###

# requires

argv = require 'argv'
AtlassianCrowd = require 'atlassian-crowd'
cmdlist = require './subcmd/cmdlist'

###
read config file from current working directory
###
readConfig = () ->
  #  read from where the command was invoked
  require process.cwd() + '/crowdutil.json'

###
Connect to Crowd service and save connection object in opts['crowd']
###
connectCrowd = (opts, cfg) ->
  # check if specified directory is valid
  if typeof cfg['directories'][opts['options']['directory']] != 'undefined'
    try
      # create connection based on settings
      opts['crowd'] = new AtlassianCrowd(
        cfg['directories'][opts['options']['directory']]
      )

      # test connection
      opts['crowd'].ping( (err,res) ->
        if err
          throw err
        else
          console.log res
      )
    catch err
      throw err
  else
    errConfig = new Error('Directory not defined.')
    throw errConfig
  return

###
cli entrypoint
command format:
  crowdutil command options
commands
  all commands are specified in list exported by subcmd/cmdlist.coffee
  list key is the command name as well as the require target for the
  command execution.
###
exports.run = () ->
  console.log "\n\n\n\ncrowdutil: Atlassian Crowd Utility!\n\n\n\n"

  # load all sub-command option settings into argv
  for k,v of cmdlist.list
    argv.mod v['arg']

  # parse command line options
  opts = argv.run()

  cfg = readConfig()

  try
    connectCrowd(opts, cfg)
  catch err
    console.log err.message
    return -1

  # require the module for the specified command and execute
  try
    require(cmdlist.list[opts['mod']]['require']).run(opts)
  catch err
    console.log err.message
    return -1
  return 0
