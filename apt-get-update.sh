#! /bin/bash
echo "STORE souces.list"
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "DELETE souces.list"
rm /etc/apt/sources.list

echo "TOUCH souces.list"
touch /etc/apt/sources.list

echo "WRITTING souces.list"
mirror="mirrors.tencent.com"

echo "deb http://$mirror/debian bullseye main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://$mirror/debian bullseye main contrib non-free" >> /etc/apt/sources.list
echo "deb http://$mirror/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://$mirror/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://$mirror/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://$mirror/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list
echo "deb http://$mirror/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://$mirror/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list
echo "#deb http://$mirror/debian bullseye-proposed-updates main contrib non-free" >> /etc/apt/sources.list
echo "#deb-src http://$mirror/debian bullseye-proposed-updates main contrib non-free" >> /etc/apt/sources.list

echo "UPDATE apt"
apt-get update

#echo "AUTOREMOVE apt"
#apt-get autoremove

#echo "UPGRADE apt"
#echo Y | apt-get upgrade

echo -e "\n"
cat /etc/apt/sources.list
