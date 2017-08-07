#!/bin/bash
echo "Start: LAMP Stack Installer"

echo "Update OS"
apt-get update > /dev/null
echo "Done: Update OS"

echo "Installing HTOP Activity Monitor"
apt-get install htop -y > /dev/null
echo "Done: HTOP Activity Monitor"

echo "Installing Background Supervisor"
apt-get install supervisor -y > /dev/null
echo "Done: Installing Background Supervisor"

echo "Installing MultiWindow TMUX"
apt-get install tmux -y > /dev/null
echo "Done: Installing MultiWindow TMUX"

echo "Installing PHPUNIT Testing Unit"
apt-get install phpunit -y > /dev/null
echo "Done: Installing PHPUNIT Testing Unit"

echo "Installing GIT"
apt-get install git -y > /dev/null
echo "Done: Installing GIT"

echo "Installing Ondrej PHP Repository"
apt-get install python-software-properties build-essential -y > /dev/null
apt-get install software-properties-common -y > /dev/null
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
apt-get update > /dev/null
echo "Done: Installing Ondrej PHP Repository"

echo "Installing PHP 7.1"
apt-get install php7.1 -y > /dev/null
apt-get install php7.1-common php7.1-dev php7.1-cli php7.1-fpm -y > /dev/null
apt-get install php7.1.zip -y > /dev/null
echo "Done: Installing PHP 7.1"

echo "Installing PHP 7.1 extensions"
apt-get install curl zip imagemagick php-imagick php7.1-soap php7.1-intl php7.1-xsl php7.1-curl php7.1-gd php7.1-mcrypt php7.1-mysql php7.1-mbstring -y > /dev/null
rm /etc/php/7.1/fpm/php.ini > /dev/null
cp /var/www/provision/config/php-development.ini /etc/php/7.1/fpm/php.ini > /dev/null
echo "Done: Installing PHP 7.1 extensions"

echo "Installing Percona MySQL Instance"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8507EFA5
sudo apt-get update > /dev/null
echo "deb http://repo.percona.com/apt `lsb_release -cs` main" >> /etc/apt/sources.list.d/percona.list
echo "deb-src http://repo.percona.com/apt `lsb_release -cs` main" >> /etc/apt/sources.list.d/percona.list
apt-get update > /dev/null
echo "Done: Installing Percona MySQL Instance"

echo "Preparing Percona MySQL 5.7 Configuration"
apt-get install debconf-utils -y > /dev/null
#debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
#debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
DEBCONF_PREFIX="percona-server-server-5.7 percona-server-server"
sudo debconf-set-selections >> /dev/null <<DEBCONF
${DEBCONF_PREFIX}/root_password password 1234
${DEBCONF_PREFIX}/root_password_again password 1234
DEBCONF
apt-get install percona-server-server-5.7 -y > /dev/null
apt-get install percona-server-common-5.7 -y > /dev/null
apt-get install percona-server-client-5.7 -y > /dev/null
mysql -u root -p1234 -e "create database site"
echo "Done: Preparing Percona MySQL 5.7 Configuration"

echo "Installing NGINX WebServer"
add-apt-repository ppa:nginx/stable
sudo apt-get update > /dev/null

apt-get install nginx -y
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
cp /var/www/provision/config/nginx_vhost /etc/nginx/sites-available/default > /dev/null

ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

update-rc.d nginx defaults
service nginx restart > /dev/null

apt-get remove apache2 -y > /dev/null
apt-get remove nginx -y > /dev/null
apt-get install nginx -y > /dev/null
service nginx restart > /dev/null

sudo php7.1dismod xdebug > /dev/null
sudo service php7.1-fpm restart > /dev/null
echo "Done: Installing NGINX WebServer"

echo "Installing Redis Instance"
apt-get install redis-server -y > /dev/null
echo "Done: Installing Redis Instance"

echo "Installing NodeJs  6.x"
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y > /dev/null
echo "Done: Installing NodeJs 6.x"

sudo apt-get install nginx-extras
