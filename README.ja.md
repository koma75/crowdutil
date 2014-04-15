crowdutil
========================================================================

About
------------------------------------------------------------------------

crowdutil �� Atlassian CROWD �̃��[�U�[����уO���[�v�Ǘ������邽�߂�
�R�}���h���C���c�[���ł��B

���p���@
------------------------------------------------------------------------

### �C���X�g�[��

~~~Shell
npm install crowdutil
~~~

���́Agithub���璼��

~~~Shell
npm install https://github.com/koma75/crowdutil.git
~~~

### �����Z�b�g�A�b�v

�c�[���𗘗p���邽�߂ɂ͂܂��ݒ�t�@�C�����쐬����K�v������܂��B
�ݒ�t�@�C���̖��O�́ucrowdutil.json�v�ŁA�R�}���h���C���c�[�������s����
��ƃf�B���N�g���ɑ��݂��Ȃ���΂Ȃ�܂���B�T���v����crowdutil.json 
�t�@�C���� `crowdutil create-config -o crowdutil.json` �Ő����\�ł��B

#### CROWD setup

CROWD�ɐڑ����邽�߂ɂ́A�ݒ�Ώۂ̃f�B���N�g������CROWD�A�v���P�[�V������
�o�^���Acrowdutil�����s����}�V����IP�A�h���X���z�X�g�������O�ɓo�^���Ă���
�K�v������܂��B

�ݒ���@�̏ڍׂɂ��Ă� [Atlassian Crowd Documentation (Adding an Application)](https://confluence.atlassian.com/display/CROWD/Adding+an+Application#AddinganApplication-add) ���Q�Ƃ��Ă��������B

1. CROWD�ɊǗ��҃��[�U�[�Ń��O�C��
2. Application���j���[��I��
3. �ݒ���s���Ώۂ̃f�B���N�g�����ɃA�v���P�[�V�������쐬
    1. Details
        * Generic Application ��I��
        * ���O����́icrowdutil.json�t�@�C���őΏۂ��w�肷��ۂɗ��p���܂��j
        * �p�X���[�h�����
    2. Connection
        * URL ��crowdutil�𗘗p����}�V���̃z�X�g�������
    3. Directories
        * ���̃A�v���P�[�V�����Ɋ֘A�t����f�B���N�g����I���i�P�̂݁j
    4. Authentication
        * ��
    5. Confirmation
        * ���e�m�F���쐬
4. Search Applications �Ɉړ����A�쐬�����A�v���P�[�V������I�� 
5. Remote Addresses �^�u��I��
6. crowdutil�𗘗p����}�V����IP�A�h���X���̓z�X�g����S�Ēǉ�
7. 3����6�̃X�e�b�v�𑀍�Ώۂ̃f�B���N�g�����ɌJ��Ԃ����{

#### crowdutil.json

crowdutil.json �t�@�C���ɂ̓c�[���̐ݒ���L�q���܂��Bcrowdutil�̓R�}���h��
���s������ƃf�B���N�g�����ɂ��� crowdutil.json �t�@�C���������œǂݍ���
���p���܂��B

�ݒ�t�@�C����JSON�t�@�C���ňȉ��̃L�[���L�ڂ���܂�
the setting file is a hash table in the following format:

* "directories" �L�[�ȉ��ɗ��p����Crowd�̃f�B���N�g�����̐ڑ��ݒ���
  �i�[����܂�
    * ���̒���key-value�y�A��key��crowdutil�R�}���h�ŗ��p����f�B���N�g���w��
      �̂��߂̖��O���L�ڂ��܂�
    * ���̒���key-value�y�A��value�ɂ�[atlassian-crowd npm](https://www.npmjs.org/package/atlassian-crowd) �ŗ��p����CROWD�̃A�v���P�[�V�����ڑ��ݒ��
      �L�ڂ��܂��B
        * ���̒��ɂ��� application name �́ACROWD�ō쐬�����A�v���P�[�V����
          �̖��O����͂��܂��B
* "defaultDirectory" �L�[�ɂ̓f�t�H���g�ŗ��p����f�B���N�g���̃L�[��
  ���͂��܂��i��Ldirectories���ɂ���key�̂ǂꂩ�����́j�B
    * -D�R�}���h�I�v�V�������ȗ������ꍇ�A���̒l�Ŏw�肳�ꂽ�f�B���N�g��
      �����p����܂��B
* "logConfig" �L�[�ɂ�[log4js](https://www.npmjs.org/package/log4js)�ŗ��p����
  �ݒ����͂��Ă��������B
    * �ȗ��\�B
    * appenders�̒l�͕K�� "crowdutil" �Ƃ��邱��

#### crowdutil.json �̃T���v��

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
      },
      {
        "type": "console",
        "category": "crowdutil"
      }
    ],
    "replaceConsole": true
  }
}
~~~

### create-user

�Ώۃf�B���N�g���Ƀ��[�U�[���쐬

~~~Shell
crowdutil create-user -D directory -f firstname -l lastname -d dispname \
  -e user@example.com -u username -p password
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�
* -f, --first
    * ���[�U�[�̖��O
* -l, --last
    * ���[�U�[�̕c��
* -d, --dispname
    * ���[�U�[�̕\����
    * �ȗ��\: �ȗ����� first last �ɂȂ�܂�
* -e, --email
    * ���[�U�[��e-mail�A�h���X
* -u, --uid
    * ���[�U�[ID
* -p, --pass
    * ���[�U�[�̃p�X���[�h
    * �ȗ��\: �ȗ����̓����_�������̕�����ɂȂ�܂��B

### create-group

�Ώۃf�B���N�g���ɃO���[�v���쐬

~~~Shell
crowdutil create-group -D directory -n groupname -d "group description"
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�
* -n, --name
    * �O���[�v��
* -d, --desc
    * �O���[�v�̐�����
    * �ȗ��\

### add-to-groups

�����̃��[�U�[�𕡐��̃O���[�v�Ɉ�Ēǉ��B�S���[�U�[�͂��ꂼ��S�O���[�v��
�ǉ�����܂��B

~~~Shell
crowdutil add-to-groups -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�
* -g, --group
    * �J���}��؂�̃O���[�v���̃��X�g
* -u, --uid
    * �J���}��؂��uid�̃��X�g

### rm-from-groups

�����̃��[�U�[�𕡐��̃O���[�v�����č폜�B�S���[�U�[�͑S�O���[�v����
�폜����܂��i���ڃ����o�̂݁j

~~~Shell
crowdutil rm-from-groups -D directory -g group1,group2,group3 \
  -u user1,user2,user3,user4
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�
* -g, --group
    * �J���}��؂�̃O���[�v���̃��X�g
* -u, --uid
    * �J���}��؂��uid�̃��X�g

### empty-groups

�w�肵���O���[�v�̒��ڃ����o�[��S�č폜

~~~Shell
crowdutil empty-groups -D directory -g group1,group2,group3
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�
* -g, --group
    * �J���}��؂�̃O���[�v���̃��X�g
    * comma separated list of group names to empty users of
* -f, --force
    * �m�F�����Ɏ��{���܂�
    * �ȗ��\: �ȗ����͍폜�̑O�Ɋm�F����܂��B
        * �m�F���ꂽ�ꍇ�� "yes" �Ɠ��͂��邱�ƂŎ��s����܂�

### batch-exec

CSV�i�J���}��؂�j�t�@�C���x�[�X�̃o�b�`�t�@�C������͂��A�o�b�`���������{

~~~Shell
crowdutil batch-exec -D directory -b path/to/batchfile.csv
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�
* -b, --batch
    * �o�b�`�t�@�C���̃t�@�C���ւ̃p�X
    * path to batch file.
* -f, --force
    * �o�b�`���̃R�}���h�ɃG���[�������Ă��������p�����܂�
    * �ȗ��\: �ȗ����̓o�b�`���̃R�}���h�̃G���[�����m�����ꍇ�A
      �ȍ~�̃o�b�`���R�}���h�̔��s���~���A�I�����܂��B

#### batchfile format

�o�b�`�t�@�C���̌`���� [Jglr](https://www.npmjs.org/package/jglr) ��
�t�H�[�}�b�g�ɏ������܂��B

�ȉ��̃R�}���h�����p�\�ł��F

* create-user
    * ���[�U�[���쐬
    * params: directory,first,last,disp,email,uid,pass
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * first: first name
        * last: last name
        * disp: display name (optional)
        * email: email address
        * uid: user ID
        * pass: password (optional)
* create-group
    * �O���[�v���쐬
    * params: directory,name,desc
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * name
        * desc
* add-to-group
    * ���[�U�[���O���[�v�ɒǉ�
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * user
        * groupname
* rm-from-group
    * ���[�U�[���O���[�v����폜
    * params: directory,user,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * user
        * groupname
* empty-group
    * �O���[�v����S�Ẵ��[�U�[���폜
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * groupname
* deactivate-user [������]
    * ���[�U�[���A�N�e�B�u��
    * params: directory,uid,rmfromgroupFlag
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * uid
        * rmfromgroupFlag
            * if rmfromgroupFlag is set to 1 or true, the user will be 
              removed from all groups.
* remove-group
    * �O���[�v���폜
    * params: directory,groupname
        * directory: target crowd directory (optional)
            * if ommitted it will default to the -D option
              or the defaultDirectory specified in crowdutil.json
        * groupname
* seq
    * ���̍s�ȑO�̃R�}���h���I������̂�҂��A�ȍ~�̃R�}���h��1�s����
      �V�[�P���V�����Ɏ��s
* par
    * ���̍s�ȑO�̃R�}���h���I������̂�҂��A�ȍ~�̃R�}���h�͕����
      �������s�i�f�t�H���g�͂P�O����j
    * params: numParallel
        * numParallel (optional)
            * ������s����R�}���h�ő吔���w��B
            * ���ӁF CROWD����t�\�Ȑڑ�������o�b�N�G���h��DB�̐ڑ�
              ������𒴂����ꍇ�A�R�}���h�����s����\��������܂�
* wait
    * ���̍s�ȑO�̃R�}���h���I������̂�҂��܂�

�e�o�b�`�t�@�C�����̃R�}���h�̃p�����[�^�̓I�v�V���i���ȏꍇ�ł��X�L�b�v��
�ł��܂���B���A�R�}���h�̎d�l��蒴�߂���]��̃p�����[�^�͑S�Ė�������܂��B

�s���ȗ�:

~~~
create-user,john,doe,joed@example.com,joed
~~~

����ȗ�:

~~~
create-user,,john,doe,,joed@example.com,joed
           ^         ^                      ^
           �X�L�b�v�͏o���܂���.       �Ō�̃I�v�V�����͏ȗ��\
empty-group,,groupname,foo,bar,baz,,,
           ^          ^ ��������ȍ~�̗]��p�����[�^�͖���
           �X�L�b�v�͏o���܂���B
~~~

### test-connect

�Ώۃf�B���N�g���ւ̐ڑ��e�X�g�����{

~~~Shell
crowdutil test-connect -D directory
~~~

* -D, --directory
    * �ݒ�����{����f�B���N�g���Bcrowdutil.json�t�@�C����directories���ɂ���
      key �̂ǂꂩ�ƈ�v����K�v����B
    * �ȗ��\�F �ȗ������ꍇ�� crowdutil.json �t�@�C���� defaultDirectory
      �ɂĎw�肵���f�B���N�g�������p����܂�
* -v, --verbose
    * �ȗ��\: �f�o�b�O�o�͂��o�͂���悤�ɂȂ�܂�

### create-config

�T���v���̐ݒ�t�@�C���𐶐�

~~~Shell
crowdutil create-config -o sample.json
~~~

* -o, --out
    * �o�̓t�@�C�����B�f�t�H���g�� crowdutil.json�ɂȂ�܂�
    * stdout �Ɛݒ肷�邱�ƂŕW���o�͂ɏo�͂��܂��B
* -f, --force
    * ���̃t���O��ݒ肵���ꍇ�A�t�@�C�����㏑�����܂��B�w�肵�Ȃ��ꍇ��
      �����̃t�@�C�����L��ꍇ�͏㏑�����܂���B

Known issues & Bugs
------------------------------------------------------------------------

* �Ђƒʂ蓮��m�F�͂��Ă��܂����A����e�X�g�s�\���ł��B

Change History
------------------------------------------------------------------------

Date        | Version   | Changes
:--         | --:       | :--
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

