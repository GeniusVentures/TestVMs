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

### disable apt-daily service and timer
systemctl disable apt-daily.service
systemctl disable apt-daily.timer
###
# update repos
###
echo -e "$CYAN--- Updating Repos ---$NO_COLOR"
apt-get -y update

###ls -
# Development Tools
###
echo -e "$CYAN--- Installing Development tools/libraries ---$NO_COLOR"
apt-get -y install g++ clang llvm cmake ntp zlib1g-dev libgtk-3-dev ninja-build libjsoncpp25 libsecret-1-0 libjsoncpp-dev libsecret-1-dev git cmake default-jre curl libc++-dev
echo -e "$CYAN--- Downloading OpenSSL 1.1.1t ---$NO_COLOR"
cd /usr/local/src
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1t.tar.gz >/dev/null 2>&1
tar -xf openssl-1.1.1t.tar.gz >/dev/null 2>&1 
cd openssl-1.1.1t
echo -e "$CYAN--- Building OpenSSL 1.1.1t ---$NO_COLOR"
./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib >build.log 2>&1
make install >>build.log 2>&1
echo -e "$CYAN--- Installing Rust/Cargo ---$NO_COLOR"
cd ~/
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env" 
echo -e "$CYAN--- Installing cbindgen ---$NO_COLOR"
cargo install cbindgen >rust-install.log 2>&1
echo -e "$CYAN--- Installing wasm32-unknown-emscripten ---$NO_COLOR"
rustup target add wasm32-unknown-emscripten >rust-install.log 2>&1
cp -R /root/.cargo /home/vagrant >/dev/null 2>&1
cp -R /root/.rustup /home/vagrant >/dev/null 2>&1
chown -R vagrant:vagrant /home/vagrant/.cargo /home/vagrant/.rustup
echo -e "$CYAN--- Installing RVM/Ruby GPG Keys ---$NO_COLOR"
apt-get -y install gnupg2
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -

echo -e "$CYAN--- Downloading RVM/Ruby ---$NO_COLOR"
curl -sSL https://get.rvm.io | bash -s stable  >>ruby-build.log 2>&1
echo -e "$CYAN--- Installing Ruby 2.7.8 ---$NO_COLOR"
source /etc/profile.d/rvm.sh
rvm install ruby-2.7.8 --with-openssl-dir=/usr/local/ssl/ >>ruby-build.log 2>&1
rvm --default use ruby-2.7.8 



# setup android NDK link.

cat << EOF >> /home/vagrant/.profile
export MAKEFLAGS="-j8"
export CMAKE_BUILD_PARALLEL_LEVEL=8
declare -x ANDROID_HOME="//Development/ThirdParty/Android"
declare -x ANDROID_NDK="\$ANDROID_HOME/ndk/android-ndk-r25b"
declare -x ANDROID_NDK_HOME="\$ANDROID_NDK"
declare -x ANDROID_TOOLCHAIN="\$ANDROID_NDK/toolchains/llvm/prebuilt/Linux-x86_64/bin"
export PATH="\$ANDROID_TOOLCHAIN:\$PATH"
alias sd='cd /Development/GeniusVentures/GeniusTokens/' 
. "\$HOME/.cargo/env"
. /etc/profile.d/rvm.sh
export PATH="\$PATH:/Development/GeniusVentures/GeniusTokens/thirdparty/flutter/bin:\$ANDROID_HOME/cmdline-tools/bin"

EOF

echo -e "$CYAN--- Setting clang as default ---$NO_COLOR"
update-alternatives --set c++ /usr/bin/clang++
update-alternatives --set cc /usr/bin/clang

ln -s /usr/bin/python3 /usr/bin/python

echo -e "$CYAN--- Installing Minimal Desktop ---$NO_COLOR"
apt-get -y install ubuntu-desktop-minimal
systemctl start graphical.target
systemctl set-default graphical.target

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

