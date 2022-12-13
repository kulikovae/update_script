#!/bin/bash

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

sudo systemctl stop zeekad
cd
cd bazuka
git pull origin master
cargo update
cargo install --path .
cd /usr/local/bin/
rm bazuka
cd ~/bazuka/target/release
cp bazuka /usr/local/bin/



echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable zeekad
sudo systemctl restart zeekad

