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

fs = require 'fs'

crowdutilJSON =
  directories:
    test:
      crowd:
        base: "http://localhost:8059/crowd/"
      application:
        name: "test application"
        password: "pass123"
    sample1:
      crowd:
        base: "http://localhost:8059/crowd/"
      application:
        name: "sample application 1"
        password: "pass123"
  defaultDirectory: "test"
  logConfig:
    appenders: [
      {
        type: "file"
        filename: "./crowdutil.log"
        maxLogSize: "204800"
        backups: 2
        category: "crowdutil"
      }
    ]
    replaceConsole: false
  cas: []

getUserHome = () ->
  return process.env.USERPROFILE || process.env.HOME

exports.run = (options) ->
  if(
    typeof options['-o'] != 'undefined' &&
    typeof options['-o'][0] == 'string'
  )
    if options['-o'][0][0] == '/' || options['-o'][0][1] == ':'
      file = options['-o'][0]
    else if options['-o'][0] == 'stdout'
      console.log JSON.stringify(crowdutilJSON, null, 2)
      return
    else if options['-o'][0] != ''
      file = process.cwd() + '/' + options['-o'][0]
    else
      console.log "E, invalid filename"
  else
    if !fs.existsSync(getUserHome() + '/.crowdutil')
      fs.mkdirSync(getUserHome() + '/.crowdutil', (0o777 & (~process.umask())))
    file = getUserHome() + '/.crowdutil/config.json'

  if(
    options['-f'] ||
    !fs.existsSync(file)
  )
    console.log "writing to #{file}"
    fs.writeFile(
      file,
      JSON.stringify(crowdutilJSON, null, 2),
      (err) ->
        if err
          console.log err.message
        else
          console.log "#{file} saved!"
    )
  else
    console.log "#{file} already exists!"
  return
