#!/bin/bash

export LOGS=/root/logs

echo "--------------- RUN UPDATE SCRIPT -------------------" >> $LOGS/all.log
date >> $LOGS/all.log

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

echo "Stop service zeekad" >> $LOGS/all.log
sudo systemctl stop zeekad |& tee -a $LOGS/all.log 
cd ~/bazuka

echo "Pulling updates from git" >> $LOGS/all.log
git pull origin master |& tee -a $LOGS/all.log

echo "Build new zeekad service" >> $LOGS/all.log
echo "cargo update" >> $LOGS/all.log
/root/.cargo/bin/cargo update |& tee -a $LOGS/all.log
echo "cargo install" >> $LOGS/all.log
/root/.cargo/bin/cargo install --path . |& tee -a $LOGS/all.log

echo "Delete old service file" >> $LOGS/all.log
echo "rm bazuka" >> $LOGS/all.log
rm /root/.cargo/bin/bazuka |& tee -a $LOGS/all.log
rm /usr/local/bin/bazuka |& tee -a $LOGS/all.log

echo "Copy new service file" >> $LOGS/all.log
echo "cp bazuka /usr/local/bin/" >> $LOGS/all.log
cp ~/bazuka/target/release/bazuka /root/.cargo/bin/bazuka |& tee -a $LOGS/all.log
cp ~/bazuka/target/release/bazuka /usr/local/bin/bazuka |& tee -a $LOGS/all.log

sleep 3

echo "sudo systemctl daemon-reload" >> $LOGS/all.log
sudo systemctl daemon-reload |& tee -a $LOGS/all.log
echo "sudo systemctl enable zeekad" >> $LOGS/all.log
sudo systemctl enable zeekad |& tee -a $LOGS/all.log
echo "sudo systemctl restart zeekad" >> $LOGS/all.log
sudo systemctl restart zeekad |& tee -a $LOGS/all.log


echo "--------------- END RUN UPDATE SCRIPT -------------------" >> $LOGS/all.log