#!/bin/bash
sudo apt -y update
sudo apt -y upgrade
# sudo apt-get -f install
sudo apt -y autoclean 
sudo apt autoremove
# pkexec bleachbit
#sudo /etc/cron.daily/prelink
echo 'Операция обновления и очистки завершена'
sleep 5s

