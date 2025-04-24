#!/bin/bash
# Предварительно установить sudo apt install neofetch
lsb_release -a
uname -a
echo; 
echo 'Версия:'
cat /etc/debian_version
echo '=================================================='
neofetch
sleep 1200s
