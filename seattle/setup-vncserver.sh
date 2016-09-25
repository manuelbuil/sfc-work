#!/bin/bash
set -e
sudo apt-get update
sudo apt-get -y install tightvncserver lubuntu-desktop autocutsel


sudo vncserver

sudo cp vncserver /etc/init.d/vncserver
sudo chmod +x /etc/init.d/vncserver
sudo cp xstartup ~/.vnc/xstartup

sudo service vncserver restart
sudo chown -R $USER:$USER $HOME

#xset -dpms
#xset s noblank
#xset s off

echo "On windows install TightVNC viewer"
