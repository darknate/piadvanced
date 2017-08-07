#!/bin/sh
## Static wifi address

## Variables
script_dir=$(dirname $0)
source "$script_dir"/../../scriptvars/variables.var

## Current User
CURRENTUSER="$(whoami)"

whiptail --msgbox "Let's set a static IP using wlan0" 10 80 1
OLDWLAN_IP=`ip addr show wlan0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
OLDWLAN_GATEWAY=`ip route show 0.0.0.0/0 dev wlan0 | cut -d\  -f3`
NEWWLAN_IP=$(whiptail --inputbox "Please enter desired IP for wlan0" 10 80 "$OLDWLAN_IP" 3>&1 1>&2 2>&3)
sudo cp /etc/dhcpcd.conf /etc/piadvanced/backups/dhcpcd.conf
sudo sed -i '/#wlan0/d' /etc/dhcpcd.conf
sudo sed -i '/interface wlan0/d' /etc/dhcpcd.conf
sudo sed -i '/static ip_address=$OLDWLAN_IP/d' /etc/dhcpcd.conf
sudo sed -i '/static routers=$OLDWLAN_GATEWAY/d' /etc/dhcpcd.conf
sudo sed -i '/static domain_name_servers=$OLDWLAN_GATEWAY/d' /etc/dhcpcd.conf
sudo echo "" | sudo tee --append /etc/dhcpcd.conf
sudo echo "#wlan0" | sudo tee --append /etc/dhcpcd.conf
sudo echo "interface wlan0" | sudo tee --append /etc/dhcpcd.conf
sudo echo "static ip_address=$NEWWLAN_IP" | sudo tee --append /etc/dhcpcd.conf
sudo echo "static routers=$OLDWLAN_GATEWAY" | sudo tee --append /etc/dhcpcd.conf
sudo echo "static domain_name_servers=$OLDWLAN_GATEWAY" | sudo tee --append /etc/dhcpcd.conf
sudo ifconfig wlan0 $NEWWLAN_IP
