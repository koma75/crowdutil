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

log4js = require 'log4js'
AtlassianCrowd = require '../atlassian-crowd-ext/atlassian-crowd-ext'
cmdlist = require './subcmd/cmdlist'
fs = require 'fs'

getUserHome = () ->
  # since %HOME% may exist in some Windows environments, we first check for
  # %USERPROFILE% then look for $HOME
  return process.env.USERPROFILE || process.env.HOME

###
read config file from current working directory
###
readConfig = (opts) ->
  path = null

  # PRIORITY 1: CHECK opts['-c']
  if(
    typeof opts['-c'] == 'object' &&
    typeof opts['-c'][0] == 'string'
    )
    if fs.existsSync(opts['-c'][0])
      path = opts['-c'][0]
    else
      console.log "E, file #{opts['-c'][0]} NOT FOUND!"
      return null

  # PRIORITY 2: CHECK process.cwd() + '/crowdutil.json'
  if(
    path == null &&
    fs.existsSync(process.cwd() + '/crowdutil.json')
    )
    path = process.cwd() + '/crowdutil.json'

  # PRIORITY 3: CHECK getUserHome() + '/.crowdutil/config.json'
  if(
    path == null &&
    fs.existsSync(getUserHome() + '/.crowdutil/config.json')
    )
    path = getUserHome() + '/.crowdutil/config.json'

  if path != null
    global.crowdutil_cfg = path
    return require path

  return null

###
Connect to Crowd service and save connection object in opts['crowd']
###
connectCrowd = (opts, cfg) ->
  # Figure out the target directory.
  # command line option -D taking precedance to default setting.
  # if no -D option is provided, we check if there is a default directory
  # directive in the configuration file.
  if(
    typeof opts['-D'] == 'object' &&
    typeof opts['-D'][0] == 'string'
  )
    directory = opts['-D'][0]
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
      ]

  log4js.configure(logConfig)
  global.logger = log4js.getLogger('crowdutil')
  if(
    typeof opts['-v'] == 'object' &&
    typeof opts['-v'][0] == 'boolean' &&
    opts['-v'][0] == true
  )
    logger.setLevel('TRACE')
    logger.debug 'log level set to trace'
  else
    logger.setLevel('INFO')
  return

###
inject CA certificates from option and config files if any are specified
###
injectCA = (opts, cfg) ->
  https = require 'https'
  path = require 'path'
  options = https.globalAgent.options
  options.ca = options.ca || []

  # cfg.cas should resolve relative to the config.json file.
  cfgpath = path.dirname(global.crowdutil_cfg)
  for ca in cfg.cas
    logger.debug "injecting: #{ca}"
    capath = path.resolve(cfgpath, ca)
    logger.debug "  full path: #{capath}"
    if fs.existsSync(capath)
      options.ca.push(fs.readFileSync(capath))

  # -C specified file will resolve relative to process.cwd()
  if(
    typeof opts['-C'] == 'object' &&
    typeof opts['-C'][0] == 'string'
    )
    logger.debug "injecting #{opts['-C'][0]}"
    capath = path.resolve(opts['-C'][0])
    if fs.existsSync(capath)
      options.ca.push(fs.readFileSync(capath))

  return

init = (opts) ->
  cfg = readConfig(opts)

  # could not find any valid config file
  if cfg == null
    console.log "E, could not load config file"
    return false

  rc = true
  initLogger(opts, cfg)

  logger.info "==============================================="
  logger.info "crowdutil: Atlassian CROWD cli utility tool"

  # try to inject custom root ca certificates if available through config or opt
  injectCA(opts, cfg)

  try
    connectCrowd(opts, cfg)
  catch err
    if err
      logger.debug err.message
      rc = false

  return rc

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
  cmdlist.start(init)

  return
