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
  crowd.search('group', query, callback)

findUser = (crowd, opts, callback) ->
  opts = opts || {}
  uid = opts.uid || "*"
  fname = opts.fname || "*"
  lname = opts.lname || "*"
  email = opts.email || "*"

  query = "name=\"#{uid}\""
  query = "#{query} and firstName=\"#{fname}\""
  query = "#{query} and lastName=\"#{lname}\""
  query = "#{query} and email=\"#{email}\""
  crowd.search('user', query, callback)

listUsersGroup = (crowd, uid, callback) ->
  if uid == "" || typeof uid == "undefined"
    setTimeout(() ->
      myErr = new Error("invalid user name")
      callback(myErr, null)
    , 0)
  else
    crowd.user.groups(uid, callback)

findGroupMembers = (crowd, group, callback) ->
  if group == "" || typeof group == "undefined"
    setTimeout(() ->
      myErr = new Error("findGroupMembers: invalid input")
      callback(myErr, null)
    , 0)
  else
    crowd.groups.directmembers(group, callback)

addUserToGroup = (crowd, uid, group, callback) ->
  if (
    uid == "" ||
    typeof uid == "undefined" ||
    group == "" ||
    typeof group == "undefined"
  )
    setTimeout(() ->
      myErr = new Error("addUserToGroup: invalid input")
      callback(myErr, null)
    , 0)
  else
    crowd.groups.addmember(uid, group, callback)
  return

rmUserFromGroup = (crowd, uid, group, callback) ->
  if (
    uid == "" ||
    typeof uid == "undefined" ||
    group == "" ||
    typeof group == "undefined"
  )
    setTimeout(() ->
      myErr = new Error("rmUserFromGroup: invalide input")
      callback(myErr, null)
    , 0)
  else
    crowd.groups.removemember(uid, group, callback)
  return

emptyGroup = (crowd, group, limit, callback) ->
  findGroupMembers(crowd, group, (err, res) ->
    if err
      callback(err)
      return
    logger.debug res
    # res [ 'uid1' , 'uid2' ]
    async.eachLimit(res, limit
      (user, uDone) ->
        rmUserFromGroup(crowd, user, group, (err) ->
          if err
            logger.warn err.message
          else
            logger.info group + ' - ' + user
          uDone() # ignore error
        )
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
  return

updateUser = (crowd, uid, update, callback) ->
  # if nothing is detected as changed, don't bother updating
  changed = false

  # MUST NOT change username since this creates a lot of confusion
  # with uid based links
  delete update.name

  # find the user
  crowd.user.find(uid, (err, userInfo) ->
    if err
      callback(err)
    else
      # update user info with update object
      logger.debug "found #{uid}:\n#{JSON.stringify(userInfo,null,2)}"
      for k,v of update
        if userInfo[k] != v
          logger.debug "updating #{uid}:#{k} with #{v}"
          changed = true
          userInfo[k] = v

      if changed
        # If anything has changed, call the update
        logger.debug "updating #{uid}:\n#{JSON.stringify(userInfo,null,2)}"
        crowd.user.update(uid, userInfo, (err, res) ->
          if err
            callback(err)
          else
            # SUCCESS
            callback()
        )
      else
        # Nothing was different.
        logger.debug "nothing to update for #{uid}"
        callback()
  )

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
  global.crowdutil.crhelper.crowds = {}

getCROWD = (directory) ->
  logger.trace "getCROWD"
  cfg = require global.crowdutil_cfg
  AtlassianCrowd = require '../../atlassian-crowd-ext/atlassian-crowd-ext'
  crowd = null

  if !cfg['directories'][directory]
    logger.debug("getCROWD: using default directory")
    directory = global.crowdutil.crhelper.defaultCrowd || cfg['defaultDirectory']

  logger.debug(
    "getCROWD: using #{directory}"
  )
  logger.debug(
    "getCROWD: #{JSON.stringify(cfg['directories'][directory],null,2)}"
  )
  crowd = new AtlassianCrowd(
    cfg['directories'][directory]
  )

  return crowd

setDefaultCrowd = (crowd) ->
  if typeof crowd == 'string'
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
exports.getCROWD = getCROWD
exports.setDefaultCrowd = setDefaultCrowd
exports.updateUser = updateUser
