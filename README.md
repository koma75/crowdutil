crowdutil
========================================================================

About
------------------------------------------------------------------------

crowdutil is a set of utility command-line tool to help administer
Atlassian Crowd users and groups.

Usage
------------------------------------------------------------------------

### Installation

~~~Shell
npm install crowdutil
~~~

or directly from github

~~~Shell
npm install https://github.com/koma75/crowdutil.git
~~~

### Initial setup

You will need to create a settings file that hosts the directory options
for crowd (with login information) to supply to the tool.
The config file is a json file "crowdutil.json" and **needs to be provided**
via command-line, $PWD/crowdutil.json or $HOME/.crowdutil/config.json.

#### CROWD setup

You will need to set up an application in CROWD for each directory you
would like to manage through crowdutil.

See [Atlassian Crowd Documentation (Adding an Application)](https://confluence.atlassian.com/display/CROWD/Adding+an+Application#AddinganApplication-add) for details.

1. Login to your CROWD server using an administrator account
2. Select the Application menu
3. Add Application for each directory
    1. Details
        * Select Generic Application for Application Type
        * Type the name
        * set the password to use.
    2. Connection
        * URL should be the host name of one of your hosts you will use
          crowdutil on.
    3. Directories
        * Select one directory to associate to
    4. Authentication
        * leave blank
    5. Confirmation
        * confirm and add application
4. Go to Search Applications and select the application you have made
5. select the Remote Addresses Tab
6. add all the remote addresses (IP or resolvable Hostname) that you
   plan to use crowdutil on.
7. repeat steps 3-6 for all target directories.

#### Configuration file

Configuration file hosts the settings for the tool.  You may specify the
configuration file to read from the command line option --config (-c) or
crowdutil will check $PWD/crowdutil.json, then $HOME/.crowdutil/config.json
for possible configuration file to read from if not option is omitted.

the configuration file is a hash table in the following format:

* "directories" key that hosts hash object of different connection targets.
    * the value of this key has key-value where the key is the name of
      the directory
        * this name is used to specify which application the crowdutil
          will use to connect by the -D switch.
    * value for each key is the application setting hash object
      according to [atlassian-crowd npm](https://www.npmjs.org/package/atlassian-crowd)
        * the application name must match one of the application names
          you have setup in the "CROWD setup" section.
* "defaultDirectory" key has a string specifying the default directory
  to use.  If this is specified and no -D option is provided, the directory
  with the same name as defaultDirectory will be used.
* "logConfig" key may hold the configuration object to pass to
  [log4js](https://www.npmjs.org/package/log4js) logging library.
    * if ommitted, the default values will be used
    * appenders MUST have category: "crowdutil" to be used by crowdutil,
      otherwise it will be ignored.

#### Sample configuration file

~~~JSON
{
  "directories": {
    "test": {
      "crowd": {
        "base": "http://localhost:8059/crowd/"
      },
      "application": {
        "name": "test application",
        "password": "pass123"
      }
    },
    "sample1": {
      "crowd": {
        "base": "http://localhost:8059/crowd/"
      },
      "application": {
        "name": "sample application 1",
        "password": "pass123"
      }
    }
  },
  "defaultDirectory": "test",
  "logConfig": {
    "appenders": [
      {
        "type": "file",
        "filename": "./crowdutil.log",
        "maxLogSize": "204800",
        "backups": 2,
        "category": "crowdutil"
      }
    ],
    "replaceConsole": false
  }
}
~~~

### create-user

create a user in the specified directory.

~~~Shell
crowdutil create-user -D directory -f firstname -l lastname -d dispname \
  -e user@example.com -u username -p password
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -f, --first
    * first name of the user
* -l, --last
    * last name of the user
* -d, --dispname
    * display name of the user
    * optional: defaulting to first last
* -e, --email
    * email address of the user
* -u, --uid
    * username/uid of the user
* -p, --pass
    * password of the user
    * optional: defaulting to a random string
        * useful for delegated directories (i.e. LDAP authentication)

### search-user

search a user in the specified directory.
wildcards ( * ) can be used for each field.
all fields are searched with an AND operator.

~~~Shell
crowdutil search-user -D directory -f firstname -l lastname \
  -e email -u username
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -f, --first
    * optional: first name of the user
* -l, --last
    * optional: last name of the user
* -e, --email
    * optional: email address of the user
* -u, --uid
    * optional: username/uid of the user

### update-user

update a user in the specified directory.  Any non-specified value
will be unchanged.

~~~Shell
crowdutil update-user -D directory -f firstname -l lastname -d dispname \
  -e user@example.com -u username -a [true|false]
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -f, --first
    * first name of the user (optional)
* -l, --last
    * last name of the user (optional)
* -d, --dispname
    * display name of the user (optional)
* -e, --email
    * email address of the user (optional)
* -u, --uid
    * username/uid of the user to update
* -a, --active
    * active/inactive state of the user (optional)

### create-group

create a group in the specified directory

~~~Shell
crowdutil create-group -D directory -n groupname -d "group description"
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -n, --name
    * name of the group
* -d, --desc
    * description of the group
    * optional: default to an empty string

### add-to-groups

add multiple users to a set of groups.  All users specified will be added
to all the  groups specified.

~~~Shell
crowdutil add-to-groups -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -g, --group
    * comma separated list of group names to add users to
* -u, --uid
    * comma separated list of usernames/uids to add to the groups

### list-group

list the group membership of the specified user

~~~Shell
crowdutil list-group -D directory -u uid
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -u, --uid
    * uid to find membership of

### list-member

list the members of the specified group

~~~Shell
crowdutil list-member -D directory -g group1
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -g, --group
    * group name to find members from

### is-member

Check if specified users are members of the specified groups

~~~Shell
crowdutil is-member -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to log file
* -g, --group
    * comma separated list of groups to check
* -u, --uid
    * comma separated list of usernames/uids to check

### rm-from-groups

remove multiple users from a set of groups.  All users specified will be
removed from all the groups specified.

~~~Shell
crowdutil rm-from-groups -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -g, --group
    * comma separated list of group names to remove users from
* -u, --uid
    * comma separated list of usernames/uids to remove from the groups

### empty-groups

empty out the specified groups so no users are direct members of the group.
nested group members will not be removed

~~~Shell
crowdutil empty-groups -D directory -g group1,group2,group3
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -g, --group
    * comma separated list of group names to empty users of
* -f, --force
    * supress prompt (not yet implemented)
    * optional: default to false

### batch-exec

Execute the specified batch file (a csv based batch file).

~~~Shell
crowdutil batch-exec -D directory -b path/to/batchfile.csv
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuration file
    * optional: if defaultdirectory is defined in the configuration,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if not set, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -b, --batch
    * path to batch file.
* -f, --force
    * if set, batch-exec will try to continue processing the batch
      even on errors.
    * optional: if not set, the batch execution will stop as error
      is reported from the dispatched command.

#### batchfile format

Basic format of the batch file is based on
[Jglr](https://www.npmjs.org/package/jglr)

The following cmmands can be used:

* create-user
    * create a user
    * params: directory,uid,pass,first,last,disp,email
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * uid: user ID
        * pass: password (optional)
        * first: first name
        * last: last name
        * disp: display name (optional)
        * email: email address
* update-user
    * update a user
    * params: directory,uid,active,first,last,disp,email
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * uid: user ID to update
        * active: state of the user. [true|false], (optional)
        * first: first name (optional)
        * last: last name (optional)
        * disp: display name (optional)
        * email: email address (optional)
* create-group
    * create a group
    * params: directory,name,desc
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * name
        * desc
* add-to-group
    * add a user to group
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * user
        * groupname
* is-member
    * check if user is a member of the group
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * user
        * groupname
* rm-from-group
    * remove a user from group
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * user
        * groupname
* empty-group
    * empty specified group
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * groupname
* remove-group
    * remove group from target directory
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in configuration file
        * groupname
* seq
    * wait for commands to finish and set to sequential execution mode
* par
    * wait for commands to finish and set to parallel execution mode
    * params: numParallel
        * numParallel (optional)
            * any integer value to set how many parallel connections to
              CROWD is allowed.  Defaults to 10.
            * WARNING: if this number is set higher than the database
              connection pool or the capacity of CROWD web interface,
              the batch process may fail.
* wait
    * wait for commands to finish

Any (optional) parameters should be left blank, but not skipped (except
optional parameters at the very end).  All excess parameters are ignored.

Invalid:

~~~
create-user,joed,john,doe,joed@example.com
~~~

Valid:

~~~
create-user,,joed,,john,doe,,joed@example.com
           ^     ^         ^
           these cannot be skipped.
update-user,,joed,true
                      ^ all trailing options can be omitted
empty-group,,groupname,foo,bar,baz,,,
           ^          ^ these are all ignored
           cannot be skipped
~~~

### test-connect

test connection to selected directory.

~~~Shell
crowdutil test-connect -D directory
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in configuratoin file
    * optional: if defaultdirectory is defined in the configuratoin,
      this option can be ommited.
* -c, --config
    * specify the config file to use.
    * optional: if omitted, crowdutil will search for config file in the
      following order: $PWD/crowdutil.json, $HOME/.crowdutil/config.json
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file

### create-config

Create a sample configuration file

~~~Shell
crowdutil create-config -o sample.json
~~~

* -o, --out
    * optional: output filename. defaults to $HOME/.crowdutil/config.json
        * default value is %USERPROFILE%\.crowdutil\config.json for Windows
    * set to stdout to print the results to console
* -f, --force
    * force overwriting the file.  If not set, the command will not overwrite
      any files.

Known issues & Bugs
------------------------------------------------------------------------

* has not been tested rigorousely yet.
* when using parallel execution, the following limitations apply
    * you cannot have a mix of target directories in a single parallel operation
    * even when --force is enabled, a single set of parallel batch will halt on
      a single error.  Which will result in unpredictable results (no control
      over what is and what isn't executed)


Development
------------------------------------------------------------------------

### basic structure

All library code is written with coffee script and reside in coffee_lib
folder.  Everything is compiled into lib/crowdutil folder.

The actual implementation of each commands are implemented in subcmd
folder and configured via cmdlist.js.  cmdlist.js hosts the command line
option settings and entrypoints for each command.  the subcommands are
accessed via the command.js script.

### compilation

1. Initially, you will need to run "npm install" to install devDependencies.
    * Also install grunt-cli globally or set the path to the local install.
2. Run "npm run build" to compile all coffee-script into the lib directory.
3. While in development, you can run "npm run watch" to start the watch task,
   which will compile any changes.
    * You can also choose to run "npm run watch-test" which will only
      lint and compile the coffee-script files without minifying.
    * see the Gruntfile.coffee and package.json for all the possible tasks.

### Pull-requests

* feature branches will be used for individual change-sets.
    * branch names shall be feature/featurename
    * we may use a develop branch to merge several feature branches
      before we send pull requests to master.
* pull requests in github will be used for review of a feature branch (or fork)
  before merging
    * for smooth merging, please merge all the latest changes in master to your
      feature branch and make sure there are no conflicts right before sending a pull request.
    * set references to issues if relevant with the pull request
      by adding a line in the comment in the form of "resolves #issuenum"
      where issuenum is the relevant issue number.
* master branches may be altered by owner for purposes of releases (i.e.
  bumping versions in package.json, fixing README), or for minor fixes (i.e.
  minor bug fix, small code refactoring etc.)
* since it is not a large project, the develop branch is not used unless
  multiple features are being developed simultaneousely and features are
  directly merged into master branch via pull requests.

### Versioning

We will follow the [semver2.0](http://semver.org/) versioning scheme.  
With initial development phase starting at 0.1.0 and increasing
minor/patch versions until we deploy the tool to production
(and reach 1.0.0).

The interface relevant to versioning is whatever defined in this
document's "Usage" section (includes all subcommands, their cli arguments,
the format of the configuration file "crowdutil.json").

Change History
------------------------------------------------------------------------

Date        | Version   | Changes
:--         | --:       | :--
2013.10.09  | 0.6.2     | added --config option
            |           | default config path set to $HOME/.crowdutil/config.json
            |           | changed create-config to default to $HOME/.crowdutil/config.json
2014.08.22  | 0.6.1     | added list-group command.
2014.08.22  | 0.6.0     | added STDOUT messages separately from log message for use with other cli tools
            |           | fixed error handling for asynchronous functions.
            |           | added search-user command.
            |           | added list-member command.
            |           | added is-member command/batch-command.
2014.08.16  | 0.5.3     | fixed issue with new line character
2014.07.25  | 0.5.2     | fixed issue for batch exec not using proper directory
            |           | fixed parameter check bug
2014.04.22  | 0.5.0     | added update-user command
            |           | changed the parameter ordering in the create-user batch file command to match the new update-user command.
2014.04.15  | 0.4.0     | added batch-exec command
            |           | added create-config command
            |           | fixed a few README documentation errors
2014.04.02  | 0.3.2     | fixed --help command
            |           | fixed vague command options ("-n, --name")
            |           | fixed debug logging of Objects
            |           | fixed command name of test-connection to test-connect, to fit inside the help
2014.04.02  | 0.3.0     | logging feature implemented using log4js
            |           | added --verbose mode.
2014.03.28  | 0.2.1     | documentation fix.
2014.03.28  | 0.2.0     | parameter check implemented.
            |           | some command line options changed to optional
            |           | default directory option added
            |           | Fixed program execution path.
2014.03.24  | 0.1.0     | First Release

License
------------------------------------------------------------------------

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

### documents

This readme file by Yasuhiro Okuno is licensed under CC-BY 3.0 international
license.
