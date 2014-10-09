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

#
# Operetta implementation
#

defaultOpts = (cmd) ->
  cmd.parameters(['-c', '--config'], "config file to use [optional]")
  cmd.parameters(['-D', '--directory'], "target directory [optional]")
  cmd.options(['-v', '--verbose'], "verbose mode")
  return

# callback(opts): common initialization function. connects to crowd
# to add a new command, use the following snippet:
#
#  operetta.command(
#    'command-name',
#    'command description',
#    (cmd) ->
#      cmd
#        .banner = "crowdutil: command-name\n" +
#          "command description.\n\n"
#      defaultOpts(cmd)  # add default set of flags(-D and -v)
#      cmd.parameters(['-p','--param'],
#        "parameter flag which takes input")
#      cmd.options(['-o','--option'],
#        "options flag which takes no input")
#      cmd.start(
#        (opts) ->
#          if callback(opts)
#            require('./command-name').run(opts)
#          else
#            logger.error 'initialization failed'
#          return
#      )
#      return
#  )
#
# change the command-name, command description and the parameters/options.
# leave everything else intact!!

start = (callback) ->
  Operetta = require('operetta').Operetta
  operetta = new Operetta()

  # TEST COMMAND
  operetta.command(
    'test-connect',
    'test connection to selected Directory',
    (cmd) ->
      cmd
        .banner = "crowdutil: test-connect\n" +
          "test connection to selected directory.\n\n"
      defaultOpts(cmd)
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./test-connection').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # CREATE USER
  operetta.command(
    'create-user',
    'create user in selected Directory',
    (cmd) ->
      cmd
        .banner = "crowdutil: create-user\n" +
          "create user in selected directory\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-f','--first'],
        "user's first name")
      cmd.parameters(['-l','--last'],
        "user's last name")
      cmd.parameters(['-d','--dispname'],
        "user's display name [optional]")
      cmd.parameters(['-e','--email'],
        "user's email address")
      cmd.parameters(['-u','--uid'],
        "user's login ID")
      cmd.parameters(['-p','--pass'],
        "user's password [optional]")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./create-user').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # SEARCH USER
  operetta.command(
    'search-user',
    'search user in selected Directory',
    (cmd) ->
      cmd
        .banner = "crowdutil: search-user\n" +
          "search user in selected directory\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-f','--first'],
        "user's first name")
      cmd.parameters(['-l','--last'],
        "user's last name")
      cmd.parameters(['-e','--email'],
        "user's email address")
      cmd.parameters(['-u','--uid'],
        "user's login ID")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./search-user').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # UPDATE USER
  operetta.command(
    'update-user',
    'update user in selected Directory',
    (cmd) ->
      cmd
        .banner = "crowdutil: update-user\n" +
          "update user in selected directory\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-f','--first'],
        "user's first name [optional]")
      cmd.parameters(['-l','--last'],
        "user's last name [optional]")
      cmd.parameters(['-d','--dispname'],
        "user's display name [optional]")
      cmd.parameters(['-e','--email'],
        "user's email address [optional]")
      cmd.parameters(['-u','--uid'],
        "target user ID to update")
      cmd.parameters(['-a','--active'],
        "user's account active status (true|false)[optional]")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./update-user').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # CREATE GROUP
  operetta.command(
    'create-group',
    'create group in selected Directory',
    (cmd) ->
      cmd
        .banner = "crowdutil: create-group\n" +
          "create group in selected directory.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-n','--name'],
        "group name")
      cmd.parameters(['-d','--desc'],
        "description of the group")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./create-group').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # ADD USERS TO GROUPS
  operetta.command(
    'add-to-groups',
    'add users to groups',
    (cmd) ->
      cmd
        .banner = "crowdutil: add-to-groups\n" +
          "add list of users to list of groups.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-g','--group'],
        "comma separated list of groups to add users to")
      cmd.parameters(['-u','--uid'],
        "comma separated list of users to add to groups")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./add-to-groups').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # LIST GROUP MEMBERS
  operetta.command(
    'list-group',
    'list group membership of a user',
    (cmd) ->
      cmd
        .banner = "crowdutil: list-group\n" +
          "list group membership of a user.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-u','--uid'],
        "uid to find group membership of.")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./list-group').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # LIST GROUP MEMBERS
  operetta.command(
    'list-member',
    'list members of the group',
    (cmd) ->
      cmd
        .banner = "crowdutil: list-member\n" +
          "list members of the specified group.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-g','--group'],
        "group to find members of.")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./list-member').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # CHECK MEMBERSIHP OF USERS IN GROUPS
  operetta.command(
    'is-member',
    'check membership of users in groups',
    (cmd) ->
      cmd
        .banner = "crowdutil: is-member\n" +
          "check membership of users in groups.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-g','--group'],
        "comma separated list of groups")
      cmd.parameters(['-u','--uid'],
        "comma separated list of users")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./is-member').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # REMOVE USERS FROM GROUPS
  operetta.command(
    'rm-from-groups',
    'remove users from groups',
    (cmd) ->
      cmd
        .banner = "crowdutil: rm-from-groups\n" +
          "remove list of users from list of groups.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-g','--group'],
        "comma separated list of groups to remove users from")
      cmd.parameters(['-u','--uid'],
        "comma separated list of users to remove from groups")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./rm-from-groups').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # EMPTY GROUPS
  operetta.command(
    'empty-groups',
    'empty the specified group',
    (cmd) ->
      cmd
        .banner = "crowdutil: empty-groups\n" +
          "remove all direct members from the list of groups.\n" +
          "If no -f option is supplied, you must answer 'yes' to proceed.\n\n"
      defaultOpts(cmd)
      cmd.parameters(['-g','--group'],
        "comma separated list of groups to empty out")
      cmd.options(['-f','--force'],
        "force emptying the group")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./empty-groups').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # BATCH EXECUTE
  operetta.command(
    'batch-exec',
    'execute according to batch file',
    (cmd) ->
      cmd
        .banner = "crowdutil: batch-exec\n" +
          "execute according to given batch file.\n\n"
      defaultOpts(cmd)  # add default set of flags(-D and -v)
      cmd.parameters(['-b','--batch'],
        "path to the batch file to execute")
      cmd.options(['-f','--force'],
        "ignore errors and continue processing the batch")
      cmd.start(
        (opts) ->
          if callback(opts)
            require('./batch-exec').run(opts)
          else
            logger.error 'initialization failed'
          return
      )
      return
  )

  # INIT CONFIG
  operetta.command(
    'create-config',
    'create a sample config file',
    (cmd) ->
      cmd
        .banner = "crowdutil: create-config\n" +
          "create a sample config file.\n\n"
      cmd.parameters(['-o','--out'],
        "output filename (default to $HOME/.crowdutil/config.json). stdout to print")
      cmd.options(['-f','--force'],
        "force overwriting file.")
      cmd.start(
        (opts) ->
          require('./create-config').run(opts)
          return
      )
      return
  )

  operetta
    .banner = "crowdutil. Atlassian Crowd utility command line tool\n\n"
  operetta.options(
    ['-V','--version'],
    "display version info"
  )
  operetta.on(
    '-V',
    (value) ->
      pjson = require '../../../package.json'
      console.log pjson.name + " version " + pjson.version
      return
  )
  operetta.start()

  return

exports.start = start
