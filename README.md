# Test Virtural Machines.

Install vagrant instructions here:

[Vagrant Installation](https://developer.hashicorp.com/vagrant/docs/installation)

Install VirtualBox (recommended VM Manager)

[Virtual Box Download](https://www.virtualbox.org/wiki/Downloads)

This currently has only one instance that is launches.  You can modify Vagrantfile under Ubunutu to launch more than one instance.

```
cd Ubunutu
vagrant up
```

Wait for the instance to launch.

```
vagrant ssh 
```

will get you into the vagrant Linux Instance.

If using Windows and git-bash, you will have to set up a config in your .ssh/config as if you hit control-c in git-bashe.exe it aborts the vagrant ssh command.

.ssh/config

```
host vlinux
   Hostname 127.0.0.1
   user vagrant
   port 2222
   IdentityFile C:/Development/GeniusVentures/GeniusTokens/TestVMs/Ubuntu64/.vagrant/machines/node-1/virtualbox/private_key
```

now you instead, do the following on git-bash in Windows.

```
ssh vlinux
```
