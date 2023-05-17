# VM Creation for Testing

This creates 1 Ubunutu 22.04 nodes with vagrant and virtual box, node-1
if you uncomment it can create 2 nodes, node-2 and installs gcc and llvm.

use 'vagrant up' to create the VMs and it uses private network 192.168.33.1.

Change bootstrap.sh to install other tools/libraries.

It also maps GeniusTokens directory to /Development/GeniusTokens to be able to compile under Linux using the same source
code provided by the host system.

To ssh into the individual VMs use 'vagrant ssh node-1' for instance.

On Windows, setup ssh to 192.168.31.1 or 127.0.0.1 with user 'vagrant' because if you use vagrant ssh, Ctrl-C will exit out of git-bash process.

```
host vlinux
   Hostname 127.0.0.1
   user vagrant
   port 2222
   IdentityFile <root path to this directory>/TestVMs/Ubuntu64/.vagrant/machines/node-1/virtualbox/private_key
```

Also if you modify the bootstrap.sh file you will have to do 'vagrant destroy -f' to destroy the VMs and 'vagrant up' to
recreate and install default system.s
