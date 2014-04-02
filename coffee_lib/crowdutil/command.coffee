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
log4js = require 'log4js'
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
connectCrowd = (opts, cfg, callback) ->
  # Figure out the target directory.
  # command line option -D taking precedance to default setting.
  # if no -D option is provided, we check if there is a default directory
  # directive in the configuration file.
  if typeof opts['options']['directory'] == 'string'
    directory = opts['options']['directory']
  else
    if typeof cfg['defaultDirectory'] == 'string'
      directory = cfg['defaultDirectory']
    else
      throw new Error('Directory not specified!')

  # check if specified directory is valid
  if typeof cfg['directories'][directory] != 'undefined'
    try
      # create connection based on settings
      opts['crowd'] = new AtlassianCrowd(
        cfg['directories'][directory]
      )

      # test connection
      opts['crowd'].ping( (err,res) ->
        if err
          throw err
        else
          callback()
      )
    catch err
      throw err
  else
    errConfig = new Error('Directory not defined.')
    throw errConfig
  return

###
Setup global.logger
###
initLogger = (opts, cfg) ->
  if typeof cfg['logConfig'] != 'undefined'
    logConfig = cfg['logConfig']
  else
    logConfig =
      appenders: [
        {
          type: 'file'
          filename: './crowdutil.log'
          maxLogSize: 20480
          backups: 2
          category: 'crowdutil'
        }
        {
          type: 'console'
          category: 'crowdutil'
        }
      ]
      replaceConsole: true

  log4js.configure(logConfig)
  global.logger = log4js.getLogger('crowdutil')
  if(
    typeof opts['options']['verbose'] == 'boolean' &&
    opts['options']['verbose'] == true
  )
    logger.setLevel('TRACE')
    logger.debug 'log level set to trace'
  else
    logger.setLevel('INFO')
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

  initLogger(opts, cfg)

  try
    connectCrowd(opts, cfg, () ->
      # require the module for the specified command and execute
      try
        require(cmdlist.list[opts['mod']]['require']).run(opts)
      catch err
        logger.error err.message
      return
    )
  catch err
    logger.error(err.message)
    return -1

