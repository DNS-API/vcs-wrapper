vcs-wrapper
===========

This project contains a simple wrapper which can be used to protect a number of git and mercurial repositories, each of which is stored under a single Unix UID on a remote server.

There are many existing wrappers like this, for different revision control systems.  For example:

* [hg-gateway](http://parametricity.net/b/hg-gateway)
* [mercurial-server](http://www.lshift.net/work/open-source/mercurial-server/)
* [git-shell](https://git-scm.com/docs/git-shell)

Each works the same way, a single dedicated Unix account hosts the repositories, and clients connect using SSH.  The server knows which users is connecting due to a forced-command in the `~/.ssh/authorized_keys` file like so:

   command="/path/to/wrapper login steve" ssh-rsa ..

This will identify the remote user as `steve`, at which point the wrapper-command can see if that user has permission for the named repository by consulting a configuration-file.

Given the existance of several alternatives why this project?  Because it can handle __both__ git and mercurial repositories.


Installation
------------

Install to `/usr/bin/vcs-wrapper`, then update the `~/.ssh/authorized_keys` file for your shared user to include:

     command="/usr/bin/vcs-wrapper user steve",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-rsa ..

Once you've defined your users populate their permissions in `/etc/vcs-wrapper/vcs-wrapper.conf`:

     steve=repo1,repo2,repo3
     admin=all

If you're writing inline you can instead just write:

     command="/usr/bin/vcs-wrapper repo all",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-rsa ..
     command="/usr/bin/vcs-wrapper repo fw1-example,fw3-example",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-rsa ..


Contributions
-------------

Contributions are welcome, especially if you add support for SVN, DARCS, or similar.


Steve
--
