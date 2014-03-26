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

findGroup = (crowd, opts, callback) ->
  opts = opts || {}
  name = opts.name || "*"

  query = 'name="' + name + '"'
  crowd.search('group', query, (err, res) ->
    if err
      console.log err.message
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
      console.log err.message
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
        console.log err.message
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
        console.log err.message
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

###
exports
###
exports.findUser = findUser
exports.findGroup = findGroup
exports.listUsersGroup = listUsersGroup
exports.findGroupMembers = findGroupMembers
exports.addUserToGroup = addUserToGroup
exports.rmUserFromGroup = rmUserFromGroup
