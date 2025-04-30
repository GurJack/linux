#!/bin/bash
cd ~
sudo dpkg -i *.deb 
sudo apt-get -f install
echo 'Операция установки завершена'
sleep 15s

