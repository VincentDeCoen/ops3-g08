# Demo/playground server with a LAMP stack

This project sets up a development CentOS 7.1 server with a LAMP stack and Wordpress using Vagrant + Ansible. It is intended as a demo/playground machine and was set up for a introductory Linux workshop.

This should work on Linux, MacOS X, Windows, etc.

## Dependencies

In order to set up this environment, you need:

* [Git](https://git-scm.com/downloads) (including Git Bash)
* [VirtualBox, including the "Extension pack"](https://www.virtualbox.org/wiki/Downloads/)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* Optionally, [Ansible](http://docs.ansible.com/intro_installation.html) (on [supported platforms](http://docs.ansible.com/intro_installation.html#control-machine-requirements))

## Getting started

Open a Bash shell (Git Bash on Windows), go to a suitable directory to store this project and issue the following commands:

```ShellSession
$ git clone --config core.autocrlf=false https://github.com/bertvv/lampstack
$ cd lampstack
$ ./scripts/dependencies.sh
$ vagrant up
```

**Warning** On Windows, make sure that the Git setting `core.autocrlf` is `false` before cloning.

The VM will be attached to VirtualBox's [default Host-only network adapter](https://askubuntu.com/questions/198452/no-host-only-adapter-selected) and has a static IP address, 192.168.56.77.

To shut down the VM, execute `vagrant halt`. Start it again with `vagrant up`. If you made a mistake and the VM is broken, do

```ShellSession
$ vagrant destroy -f
$ vagrant up
```

## Accessing the virtual machine

* To start using the Wordpress site, surf to <http://192.168.56.77/wordpress/>
* To manage the database, surf to <http://192.168.56.77/phpmyadmin/>
* PHP code dropped in the `www/` directory is immediately visible on the website at <http://192.168.56.77/>
* To get shell access via ssh, do
    * `vagrant ssh` (no password)
    * or `ssh vagrant@192.168.56.77` (password `vagrant`)
    * prepend all commands that need root privileges with `sudo` (no password required)

