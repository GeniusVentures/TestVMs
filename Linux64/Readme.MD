# VM Creation for Testing

This creates 2 Ubunutu 18.04 nodes with vagrant and virtual box, node-1, node-2 and installs gcc and llvm.

use 'vagrant up' to create the VMs and it uses private network 192.168.33.1 as 

Change bootstrap.sh to install other tools/libraries.

It also maps GeniusTokens directory to /Development/GeniusTokens to be able to compile under Linux using the same source
code provided by the host system.

To ssh into the individual VMs use 'vagrant ssh node-1' for instance.

Also if you modify the bootstrap.sh file you will have to do 'vagrant destroy -f' to destroy the VMs and 'vagrant up' to
recreate and install default system.s