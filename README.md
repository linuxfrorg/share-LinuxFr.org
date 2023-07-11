Share on social networks for LinuxFr.org
========================================

When a news is published on LinuxFr.org, this daemon will share it on:

- twitter/X
- bsky
- ... maybe others again one day (was also used for former Google +/Buzz and Identi.ca at some point)


How to use it?
--------------

    $ gem install share-linuxfr
    $ mkdir share-linuxfr && cd share-linuxfr
    $ vim share.yml
    $ share-linuxfr --config share.yml --log share-linuxfr.log --output share-linuxfr.output

For the config file, see
[the example](https://github.com/linuxfrorg/share-LinuxFr.org/blob/master/config/share.yml.example).

How to use it? (with Docker)
-------------------------------

Build and run Docker image:

    $ docker build -t share-linuxfr.org .
    $ cp config/share.yml.example myconfigsomewhere/share.yml
    $ vim myconfigsomewhere/share.yml
    $ docker run --volume myconfigsomewhere:/home/app/config --volume mylogsomewhere:/home/app/log share-linuxfr.org
    or
    $ docker run --volume myconfigsomewhere:/home/app/config --volume mylogsomewhere:/home/app/log --env REDIS=someredis:6379/1 share-linuxfr.org

See also
--------

* [Git repository](https://github.com/linuxfrorg/share-LinuxFr.org)


Copyright
---------

The code is licensed as GNU AGPLv3. See the LICENSE file for the full license.

♡2011 by Bruno Michel. Copying is an act of love. Please copy and share.

♡2023 by Benoît Sibaud. Copying is an act of love. Please copy and share.
