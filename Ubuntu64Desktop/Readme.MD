# VM Creation for Testing

This creates 1 Ubunutu Desktop 22.10 node with vagrant and virtual box

use 'vagrant up' to create the VMs and it uses private network 192.168.58.101.

Change bootstrap.sh to install other tools/libraries.

It also maps GeniusTokens directory to /Development/GeniusTokens to be able to compile under Linux using the same source
code provided by the host system.

To ssh into the individual VMs use 'vagrant ssh desktop-1' for instance.

On Windows, setup ssh to 127.0.0.1 port 2300 with user 'vagrant' because if you use vagrant ssh, Ctrl-C will exit out of git-bash process.

```
host vlinux-desktop
   Hostname 127.0.0.1
   user vagrant
   port 2300
   IdentityFile <root path to this directory>/TestVMs/Ubuntu64Desktop/.vagrant/machines/desktop-1/virtualbox/private_key
```

Also if you modify the bootstrap.sh file you will have to do 'vagrant destroy -f' to destroy the VMs and 'vagrant up' to
recreate and install default systems
