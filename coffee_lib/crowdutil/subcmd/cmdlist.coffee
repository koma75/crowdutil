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

###
default option used for all commands
###
opt_dir =
  name: 'directory'
  short: 'D'
  type: 'string'
  description: 'select the directory'
  example: "'script --directory=value' or 'script -D value'"
opt_verb =
  name: 'verbose'
  short: 'v'
  type: 'boolean'
  description: 'verbose logging'
  example: "'script --verbose=[true|false]' or 'script -v [true|false]'"

###
list of commands available to the main script
list format:
list[command-name] = Object
  where Object holds information about the command
Object is of the following form
  require: PATH TO THE COMMAND IMPLEMENTATION
  arg:
    mod: COMMAND NAME RECOGNIZED BY argv MODULE
    description: DESCRIPTION
    options: [
      ARRAY OF COMMAND LINE OPTIONS TO PASS TO argv MODULE
    ]
require and mod will be generated automatically from the key of the list
hash.
###
list =
  "test-connection":
    arg:
      description: 'test connection to selected Directory'
      options: [ opt_dir , opt_verb]
  "empty-groups":
    arg:
      description: 'empty group in selected Directory'
      options: [
        opt_dir
        opt_verb
        {
          name: 'name'
          short: 'n'
          type: 'csv,string'
          description: "group to empty out"
          example: "'script --name=val1,val2' or 'script -n val1,val2'"
        }
        {
          name: 'force'
          short: 'f'
          type: 'boolean'
          description: "group to empty out"
          example: "'script --force=true' or 'script -f 1'"
        }
      ]
  "rm-from-groups":
    arg:
      description: 'remove user from groups in selected Directory'
      options: [
        opt_dir
        opt_verb
        {
          name: 'name'
          short: 'n'
          type: 'csv,string'
          description: "group name"
          example: "'script --name=val1,val2' or 'script -n val1,val2'"
        }
        {
          name: 'uid'
          short: 'u'
          type: 'csv,string'
          description: "uid to remove from group"
          example: "'script --uid=val1,val2' or 'script -u val1,val2'"
        }
      ]
  "add-to-groups":
    arg:
      description: 'add users to groups in selected Directory'
      options: [
        opt_dir
        opt_verb
        {
          name: 'name'
          short: 'n'
          type: 'csv,string'
          description: "group name"
          example: "'script --name=val1,val2' or 'script -n val1,val2'"
        }
        {
          name: 'uid'
          short: 'u'
          type: 'csv,string'
          description: "uid to add to group"
          example: "'script --uid=val1,val2' or 'script -u val1,val2'"
        }
      ]
  "create-group":
    arg:
      description: 'Create group in selected Directory'
      options: [
        opt_dir
        opt_verb
        {
          name: 'name'
          short: 'n'
          type: 'string'
          description: "group name"
          example: "'script --name=value' or 'script -n value'"
        }
        {
          name: 'desc'
          short: 'd'
          type: 'string'
          description: "group description"
          example: "'script --desc=value' or 'script -d value'"
        }
      ]
  "create-user":
    arg:
      description: 'Create user in selected Directory'
      options: [
        opt_dir
        opt_verb
        {
          name: 'first'
          short: 'f'
          type: 'string'
          description: "user's first name"
          example: "'script --first=value' or 'script -f value'"
        }
        {
          name: 'last'
          short: 'l'
          type: 'string'
          description: "user's last name"
          example: "'script --last=value' or 'script -l value'"
        }
        {
          name: 'dispname'
          short: 'd'
          type: 'string'
          description: "user's display name"
          example: "'script --dispname=value' or 'script -d value'"
        }
        {
          name: 'email'
          short: 'e'
          type: 'string'
          description: "user's email address"
          example: "'script --email=value' or 'script -e value'"
        }
        {
          name: 'uid'
          short: 'u'
          type: 'string'
          description: "user's login ID"
          example: "'script --uid=value' or 'script -u value'"
        }
        {
          name: 'pass'
          short: 'p'
          type: 'string'
          description: "user's password"
          example: "'script --pass=value' or 'script -p value'"
        }
      ]

# generate the require and mod value
for k,v of list
  list[k]['arg']['mod'] = k
  list[k]['require'] = './subcmd/' + k

exports.list = list

