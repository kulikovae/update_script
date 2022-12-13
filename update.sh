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

echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `service zeekad status | grep active` =~ "running" ]]; then
  echo -e "Your zeekad node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice zeekad status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your zeekad node \e[31mwas not installed correctly\e[39m, please reinstall."
fi