crowdutil
========================================================================

About
------------------------------------------------------------------------

crowdutil is a set of utility command-line tool to help administer
Atlassian Crowd users and groups.

### Versions

Date        | Version   | Changes
:--         | --:       | :--
2014.04.02  | 0.3.0     | logging feature implemented using log4js
            |           | added --verbose mode.
2014.03.28  | 0.2.1     | documentation fix.
2014.03.28  | 0.2.0     | parameter check implemented.
            |           | some command line options changed to optional
            |           | default directory option added
            |           | Fixed program execution path.
2014.03.24  | 0.1.0     | First Release

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
The config file is a json file "crowdutil.json" and **needs to be present
in the working directory** where you execute the command.

Also you will need to setup the crowd server to accept remote REST commands
from your machine.

#### crowdutil.json

crowdutil.json hosts the settings for the tool and must reside in the
current working directory where you invoke the command.

the setting file is a hash table in the following format:

* "directories" key that hosts hash object of different connection targets.
    * the value of this key has key-value where the key is the name of 
      the directory
        * this name is used to specify which application the crowdutil
          will use to connect by the -D switch.
    * value for each key is the application setting hash object 
      according to [atlassian-crowd npm](https://www.npmjs.org/package/atlassian-crowd)
* "defaultDirectory" key has a string specifying the default directory 
  to use.  If this is specified and no -D option is provided, the directory
  with the same name as defaultDirectory will be used.
* "logConfig" key may hold the configuration object to pass to 
  [log4js](https://www.npmjs.org/package/log4js) logging library.
    * if ommitted, the default values will be used
    * appenders MUST have category: "crowdutil" to be used by crowdutil, 
      otherwise it will be ignored.

#### Sample crowdutil.json

~~~JSON
{
  "directories": {
    "internal": {
      "crowd": {
        "base": "http://localhost:8059/crowd/"
      },
      "application": {
        "name": "my application",
        "password": "pass123"
      }
    },
    "external": {
      "crowd": {
        "base": "http://localhost:8059/crowd/"
      },
      "application": {
        "name": "my external application",
        "password": "pass123"
      }
    }
  },
  "defaultDirectory": "internal",
  "logConfig": {
    "appenders": [
      {
        "type": "file",
        "filename": "./crowdutil.log",
        "maxLogSize": 20480,
        "backups": 2,
        "category": "crowdutil"
      }, {
        "type": "console",
        "category": "crowdutil"
      }
    ],
    "replaceConsole": true
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
      names specified in crowdutil.json file
    * optional: if defaultdirectory is defined in the crowdutil.json, 
      this option can be ommited.
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

### create-group

create a group in the specified directory

~~~Shell
crowdutil create-group -D directory -n groupname -d "group description"
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in crowdutil.json file
    * optional: if defaultdirectory is defined in the crowdutil.json, 
      this option can be ommited.
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
crowdutil add-to-groups -D directory -n group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in crowdutil.json file
    * optional: if defaultdirectory is defined in the crowdutil.json, 
      this option can be ommited.
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -n, --name
    * comma separated list of group names to add users to
* -u, --uid
    * comma separated list of usernames/uids to add to the groups

### rm-from-groups

remove multiple users from a set of groups.  All users specified will be
removed from all the groups specified.

~~~Shell
crowdutil rm-from-groups -D directory -n group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in crowdutil.json file
    * optional: if defaultdirectory is defined in the crowdutil.json, 
      this option can be ommited.
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -n, --name
    * comma separated list of group names to remove users from
* -u, --uid
    * comma separated list of usernames/uids to remove from the groups

### empty-groups

empty out the specified groups so no users are direct members of the group.
nested group members will not be removed

~~~Shell
crowdutil empty-groups -D directory -n group1,group2,group3
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in crowdutil.json file
    * optional: if defaultdirectory is defined in the crowdutil.json, 
      this option can be ommited.
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file
* -n, --name
    * comma separated list of group names to empty users of
* -f, --force=[true|false]
    * set true to supress prompt (not yet implemented)
    * optional: default to false

### test-connection

test connection to selected directory.

~~~Shell
crowdutil test-connection -D directory
~~~

* -D, --directory
    * target directory application. needs to match one of the directory
      names specified in crowdutil.json file
    * optional: if defaultdirectory is defined in the crowdutil.json, 
      this option can be ommited.
* -v, --verbose
    * optional: verbose mode.  outputs more info to console and log file

Known issues & Bugs
------------------------------------------------------------------------

* has not been tested rigorousely yet.

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
2. Run "grunt coffee:lib" to compile all coffee-script into the lib directory.
3. While in development, you can run "grunt" to start the watch task, which 
   will compile any changes.
    * You can also choose to run "grunt watch:coffee_lib" which will only
      lint and compile the coffee-script files without minifying.
    * see the Gruntfile.coffee for all the possible tasks.

### Pull-requests

* feature branches will be used for individual change-sets.
    * branch names shall be feature/featurename
    * we may use a develop branch to merge several feature branches
      before we send pull requests to master.
* pull requests in github will be used for review of a feature branch
  before merging
    * for smooth merging, please re-base the feature branch to the latest
      master and make sure there are no conflicts right before sending
      a pull request.
    * set references to issues if relevant with the pull request
      by adding a line in the comment in the form of "resolves #issuenum" 
      where issuenum is the relevant issue number.
* master branches may be altered by owner for purposes of releases (i.e.
  bumping versions in package.json, fixing README), or for documentation
  fixes.

### Versioning

We will follow the [semver2.0](http://semver.org/) versioning scheme.  
With initial development phase starting at 0.1.0 and increasing 
minor/patch versions until we deploy the tool to production 
(and reach 1.0.0).

The interface relevant to versioning is whatever defined in this 
document's "Usage" section (includes all subcommands, their cli arguments,
the format of the configuration file "crowdutil.json").

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

