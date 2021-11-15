#!/usr/bin/env bash

# Define colors
RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
PURPLE="\033[0;35m"
BLUE="\033[0;34m"
LBLUE="\033[1;34m"
CYAN="\033[1;36m"
NO_COLOR="\033[0m"

echo -e "$LBLUE--- Good morning, Let's get your vagrant machine setup! ---$NO_COLOR"

###
# update repos
###
echo -e "$CYAN--- Updating Repos ---$NO_COLOR"
apt-get -y update

###ls -
# Development Tools
###
echo -e "$CYAN--- Installing Development tools/libraries ---$NO_COLOR"
apt-get -y install g++ llvm clang++ clang cmake

###
# open up ports
###
#ufw allow from any to any port 8085 proto tcp
#ufw allow from any to any port 8086 proto tcp
#ufw allow from any to any port 8087 proto tcp

###
# Done
###
echo -e "$GREEN--- DONE! ---$NO_COLOR"

