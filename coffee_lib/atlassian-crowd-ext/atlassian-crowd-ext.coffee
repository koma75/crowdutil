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

AtlassianCrowd = require 'atlassian-crowd'
url = require 'url'
http = require 'http'
https = require 'https'

# Add a method to update user
AtlassianCrowd.prototype.user.update = (username, userObj, callback) ->
  # MUST have username and object to update with
  error = null

  # Check for input
  if !username || !userObj
    # Missing Input
    error = new Error "missing input"
    error.type = "BAD_REQUEST"
  else if(
    typeof userObj["name"] != 'string' ||
    typeof userObj["first-name"] != 'string' ||
    typeof userObj["last-name"] != 'string' ||
    typeof userObj["display-name"] != 'string' ||
    typeof userObj["email"] != 'string' ||
    typeof userObj["active"] != 'boolean'
  )
    # Missing field in the user object
    error = new Error "missing input"
    error.type = "BAD_REQUEST"
  else if userObj.name != username
    # MUST NOT be updating user's username
    error = new Error "username missmatch"
    error.type = "BAD_REQUEST"

  if error
    return callback(error)

  # prune userobject of password since GET user?username=uid
  # returns a user object WITH password field
  if typeof userObj.password != 'undefined'
    delete userObj.password

  options =
    method: 'PUT'
    data: JSON.stringify(userObj)
    path: "/user?username=#{username}"

  _doRequest(options, (err, res) ->
    return callback(err, res)
  )

#
# The code below are copied from node-atlassian-crowd
# and converted to coffeescript by Js2coffee
#
# Copyright (c) 2012 Gary Steven
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

_doRequest = (options, callback) ->
  data = ""
  error = undefined
  opts =
    hostname: @settings.hostname
    port: @settings.port
    auth: @settings.authstring
    method: options.method
    path: settings.pathname + settings.apipath + options.path
    rejectUnauthorized: (if "rejectUnauthorized" of @settings then @settings.rejectUnauthorized else true)
    headers:
      Accept: "application/json"

  if options.method is "POST" or options.method is "PUT"
    if options.data
      opts.headers["content-type"] = "application/json"
      opts.headers["content-length"] = options.data.length
    else
      error = new Error("Missing POST Data")
      error.type = "BAD_REQUEST"
      return callback(error)
  else
    
    # nginx requires content-length header also for DELETE requests
    opts.headers["content-length"] = "0"  if options.method is "DELETE"
  protocol = (if (settings.protocol is "https:") then https else http)
  request = protocol.request(opts, (response) ->
    response.on "data", (chunk) ->
      data += chunk.toString()
      return

    return callback(null, response.statusCode)  if response.statusCode is 204
    if response.statusCode is 401
      error = new Error("Application Authorization Error")
      error.type = "APPLICATION_ACCESS_DENIED"
      return callback(error)
    if response.statusCode is 403
      error = new Error("Application Permission Denied")
      error.type = "APPLICATION_PERMISSION_DENIED"
      return callback(error)
    response.on "end", ->
      if response.headers["content-type"] isnt "application/json"
        error = new Error("Invalid Response from Atlassian Crowd")
        error.type = "INVALID_RESPONSE"
        callback error
      else
        if data
          data = JSON.parse(data)
          if data.reason or data.message
            if typeof data.reason is "undefined"
              data.reason = "BAD_REQUEST"
              data.message = "Invalid Request to Atlassian Crowd"
            error = new Error(data.message)
            error.type = data.reason
            callback error
          else
            callback null, data
        else
          callback null, response.statusCode

    return
  )
  if options.data
    request.end options.data
  else
    request.end()
  return

module.exports = AtlassianCrowd

