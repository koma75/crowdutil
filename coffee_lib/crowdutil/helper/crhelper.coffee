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

async = require 'async'

findGroup = (crowd, opts, callback) ->
  opts = opts || {}
  name = opts.name || "*"

  query = 'name="' + name + '"'
  crowd.search('group', query, (err, res) ->
    if err
      logger.warn err.message
    else
      callback(res)
  )

findUser = (crowd, opts, callback) ->
  opts = opts || {}
  uid = opts.uid || "*"
  fname = opts.fname || "*"
  lname = opts.lname || "*"
  email = opts.email || "*"

  query = 'name="' + uid + '"'
  query = query + ' and firstName="' + fname + '"'
  query = query + ' and lastName="' + lname + '"'
  query = query + ' and email="' + email + '"'
  crowd.search('user', query, (err, res) ->
    if err
      logger.warn err.message
    else
      callback(res)
  )

listUsersGroup = (crowd, uid, callback) ->
  if uid == "" || typeof uid == "undefined"
    myErr = new Error("invalid user name")
    throw myErr
  else
    crowd.user.groups(uid, (err, res) ->
      if err
        logger.warn err.message
      else
        callback(res)
    )

findGroupMembers = (crowd, group, callback) ->
  if group == "" || typeof group == "undefined"
    myErr = new Error("findGroupMembers: invalid input")
    throw myError
  else
    crowd.groups.directmembers(group, (err, res) ->
      if err
        logger.warn err.message
      else
        callback(res)
    )

addUserToGroup = (crowd, uid, group, callback) ->
  if (
    uid == "" ||
    typeof uid == "undefined" ||
    group == "" ||
    typeof group == "undefined"
  )
    myErr = new Error("addUserToGroup: invalid input")
    throw myErr
  else
    crowd.groups.addmember(uid, group, (err) ->
      callback(err)
    )
  return

rmUserFromGroup = (crowd, uid, group, callback) ->
  if (
    uid == "" ||
    typeof uid == "undefined" ||
    group == "" ||
    typeof group == "undefined"
  )
    myErr = new Error("rmUserFromGroup: invalide input")
    throw myErr
  else
    crowd.groups.removemember(uid, group, (err) ->
      callback(err)
    )
  return

emptyGroup = (crowd, group, limit, callback) ->
  try
    findGroupMembers(crowd, group, (res) ->
      logger.debug res
      # res [ 'uid1' , 'uid2' ]
      async.eachLimit(res, limit
        (user, uDone) ->
          try
            rmUserFromGroup(crowd, user, group, (err) ->
              if err
                logger.warn err.message
              else
                logger.info group + ' - ' + user
              uDone() # ignore error
            )
          catch err
            logger.warn err.message
            uDone()
          return
        , (err) ->
          if err
            callback(err)
          else
            logger.info "DONE emptying " + group
            callback()
          return
      )
    )
  catch err
    callback(err)
  return

#
# Initialize Global variables
#
if typeof global.crowdutil == 'undefined'
  global.crowdutil = {}

if typeof global.crowdutil.crhelper == 'undefined'
  global.crowdutil.crhelper = {}

if typeof global.crowdutil.crhelper.defaultCrowd == 'undefined'
  global.crowdutil.crhelper.defaultCrowd = null

if typeof global.crowdutil.crhelper.crowds == 'undefined'
  global.crowdutil.crhelper.crowds = {"some": true}

setupCROWD = () ->
  #
  # Setup Global for Batch execution helper
  #
  logger.trace "setupCROWD"
  cfg = require process.cwd() + '/crowdutil.json'
  AtlassianCrowd = require '../../atlassian-crowd-ext/atlassian-crowd-ext'

  for directory,options of cfg['directories']
    logger.debug(
      "setupCROWD: adding #{directory}\n#{JSON.stringify(options,null,2)}"
    )
    try
      global.crowdutil.crhelper.crowds[directory] = new AtlassianCrowd(
        options
      )
    catch err
      logger.warn err.message
  logger.debug "#{JSON.stringify(global.crowdutil.crhelper)}"

getCROWD = (directory) ->
  defaultCrowd = global.crowdutil.crhelper.defaultCrowd
  crowds = global.crowdutil.crhelper.crowds

  logger.trace "getCROWD: #{directory}"
  logger.debug "getCROWD: #{JSON.stringify(crowds)}"
  if typeof crowds[directory] == 'object'
    logger.debug "getCROWD: using #{directory}"
    return crowds[directory]
  else
    logger.debug "getCROWD: using default directory"
    return defaultCrowd

setDefaultCrowd = (crowd) ->
  if typeof crowd == 'object'
    global.crowdutil.crhelper.defaultCrowd = crowd
  return

###
exports
###
exports.findUser = findUser
exports.findGroup = findGroup
exports.listUsersGroup = listUsersGroup
exports.findGroupMembers = findGroupMembers
exports.addUserToGroup = addUserToGroup
exports.rmUserFromGroup = rmUserFromGroup
exports.emptyGroup = emptyGroup
exports.setupCROWD = setupCROWD
exports.getCROWD = getCROWD
exports.setDefaultCrowd = setDefaultCrowd
