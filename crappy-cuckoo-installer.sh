#!/bin/bash

##Crappy-Cuckoo-Installer
##This was designed for Debian based operating systems
##It was adapted from the installation guide from http://cuckoo.readthedocs.org/en/lastest/installation/host/requirements
##because lazy.

# Init
FILE="/tmp/out.$$"
GREP="/bin/grep"
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
  tput setaf 1; echo "This script must be run as root" 1>&2
  tput sgr0;
   exit 1
fi

tput bold;
tput setaf 6; echo $"


 ██████╗     ██████╗    ██╗
██╔════╝    ██╔════╝    ██║
██║         ██║         ██║
██║         ██║         ██║
╚██████╗    ╚██████╗    ██║
 ╚═════╝     ╚═════╝    ╚═╝
                           


"
echo "Just another crappy cuckoo sandbox installer"
tput sgr0;
sleep 2

tput setaf 3; echo "This script will now install the basic prerequisites for the cuckoo malware sandbox. It will also create the cuckoo user and the other things that are needed before creating the Virtualbox Guests."
tput sgr0;
sleep 2

tput setaf 3; echo "Now installing Python based things"
tput sgr0;
sleep 2

#Install Python
sudo apt-get install python python-pip -y

tput setaf 3; echo "Now installing MongoDB"
tput sgr0;
sleep 2

#Install MongoDB
sudo apt-get install mongodb -y

tput setaf 3; echo "Now installing Cybox and MAEC libraries for MAEC support (all optional)"
tput sgr0;
sleep 2

#Install Cybox and MAEC
sudo pip install cybox==2.1.0.9
sudo pip install maec==4.1.0.11

read -r -p "Do you plan to use KVM instead of VirtualBox? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    tput setaf 3; echo "Now installing KVM prequisites for cuckoo"
    tput sgr0; 
    sleep 2

    sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils python-libvirt
else
    tput setaf 3; echo "Now continuing without installing KVM things..."
    tput sgr0;
    sleep 2
fi

read -r -p "Do you plan to use XenServer instead of VirtualBox? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    tput setaf 3; echo "Now installing the XenAPI Python package"
    tput sgr0; 
    sleep 2

    sudo pip install XenAPI
else
    tput setaf 3; echo "Going forward without XenAPI..."
    tput sgr0;
    sleep 2
fi

read -r -p "Do you want to use Virtualbox (mostly because it's the easiest) or to update it? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    tput setaf 3; echo "Now installing Virtualbox"
    tput sgr0; 
    sleep 2

    sudo apt-get install virtualbox
else
    tput setaf 3; echo "Moving on without Virtualbox..."
    tput sgr0;
    sleep 2
fi

tput setaf 3; echo "Installing tcpdump"
tput sgr0; 
sleep 2

#Install tcpdump
sudo apt-get install tcpdump

tput setaf 3; echo "Now giving cuckoo limited permissions in regards to tcpdump..."
tput sgr0;
sleep 2

#Setting up cuckoo with limited tcpdump permissions
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

tput setaf 3; echo "Now checking to see if the command worked"
tput sgr0;
sleep 2

#Doing the check to see if correct
GETCAP="$(getcap /usr/sbin/tcpdump)" 
echo "${GETCAP}" | grep "/usr/sbin/tcpdump = cap_net_admin,cap_net_raw+eip"
if [ $? -eq 0 ] 
then
   tput setaf 2; echo "everything checked out"
   tput sgr0;
   sleep 2
else
   tput setaf 1; echo "something done goofed ¯\_(ツ)_/¯ . Check the cuckoo documenation to see how to proceed on this one."
   tput sgr0;
   sleep 2;
fi

#Volatility installation (optional)
read -r -p "Do you want to install Volatility? It's an optional memory dump forensics analysis tool [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    tput setaf 3; echo "Now installing volatility"
    tput sgr0; 
    sleep 2

    sudo apt-get install volatility
else
    tput setaf 3; echo "These aren't the droids you're looking for..."
    tput sgr0;
    sleep 2
fi

tput setaf 3; echo "Now adding the cuckoo user and setting up permssions and groups"
tput sgr0;
sleep 2

#Check to see if cuckoo is already a user and adding if not

CHKUSER="$(ls /home/)"
echo "${CHKUSER}" | grep "cuckoo"
if [ $? -eq 0 ]
then
   tput setaf 2; echo "cuckoo user already exists"
   tput sgr0;
   sleep 2
else
   tput setaf 3; echo "adding cuckoo as a user"
   tput sgr0;
   sleep 2

   sudo adduser cuckoo
fi

#Add cuckoo to vboxusers if applicable
read -r -p "Are you using Virtualbox? And if so, do you want to add cuckoo to the vboxusers group? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    tput setaf 3; echo "Now adding cuckoo to the vboxusers group"
    tput sgr0; 
    sleep 2

    sudo usermod -a -G vboxusers cuckoo
else
    tput setaf 3; echo "Fair enough... let us continue..."
    tput sgr0;
    sleep 2
fi

read -r -p "Are you using KVM? And if so, do you want to add cuckoo to the libvirtd group? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    tput setaf 3; echo "Now adding cuckoo to the libvirtd group"
    tput sgr0;
    sleep 2

    sudo usermod -a -G libvirtd cuckoo
else
    tput setaf 3; echo "Okey dokey... let us continue..."
    tput sgr0;
    sleep 2
fi




echo "did it work? still working on development so just checking..."
exit
