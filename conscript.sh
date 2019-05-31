#!/bin/bash

#1.��root�û�
sudo passwd root

#2.��װ net-tools��������
#root@ubuntu:/home/xjk# apt-get install net-tools
#E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
#E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?
#���
rm /var/lib/dpkg/lock 

#3��װvim
apt-get install -y vim

#4 װsamba �� ssh
touch install.sh


clear
echo "#############################################################"
echo "# SSH Auto Setup Tool for Ubuntu 18.04"
echo "#############################################################"
echo ""

echo "This script will install SSH and set root login."

echo "installing SSH..."
sudo apt-get install -y openssh-server > /dev/null 2>&1
echo "service ssh start..."
sudo service ssh start
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/PermitRootLogin/#&/' /etc/ssh/sshd_config
echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config >/dev/null
sudo service ssh restart

echo "Done!"

echo "#############################################################"
echo "# Samba Auto Setup Tool for Ubuntu 16.04"
echo "#############################################################"
echo ""

SharePath="/home/share"

echo "This script will install samba and set up a shared directory."
echo "The shared directory is ${SharePath}"

echo "installing Samba..."
sudo apt install -y samba > /dev/null 2>&1
echo "Setting up the shared directory..."
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo mkdir -p $SharePath
sudo chmod 777 $SharePath

echo "[share]" | sudo tee -a /etc/samba/smb.conf >/dev/null
echo "        path = ${SharePath}" | sudo tee -a /etc/samba/smb.conf >/dev/null
echo "        browseable = yes" | sudo tee -a /etc/samba/smb.conf >/dev/null
echo "        writable = yes" | sudo tee -a /etc/samba/smb.conf >/dev/null

echo "Using the current user to add a Samba user."
echo "please input the password, and make sure it is the same password as the current user."
sudo smbpasswd -a $USER

sudo service smbd restart
echo "Done!"

# �޸���������
 cp /etc/network/interfaces /etc/network/interfaces.back
#vim /etc/network/interfaces
#auto lo
#iface lo inet loopback

echo "auto ens33" | sudo tee -a /etc/network/interfaces >/dev/null
echo "iface ens33 inet static" | sudo tee -a /etc/network/interfaces >/dev/null
echo "address 10.0.10.111" | sudo tee -a /etc/network/interfaces >/dev/null
echo "netmask 255.255.255.0" | sudo tee -a /etc/network/interfaces >/dev/null
echo "gateway 10.0.10.1" | sudo tee -a /etc/network/interfaces >/dev/null
echo "dns-nameservers 8.8.8.8" | sudo tee -a /etc/network/interfaces >/dev/null

#�����������
#���¼�����·�����ļ�
sudo /etc/init.d/networking force-reload
sudo /etc/init.d/networking restart

