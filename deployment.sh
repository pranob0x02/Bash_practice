#!/bin/bash

function print_color(){

	NO_COLOR='\033[0m' # No Color


	case $1 in
		"cyan") COLOR='\033[0;36m' ;;
		"red") COLOR='\033[0;31m' ;;
		"white") COLOR='\033[0;37m' ;;
		"*") COLOR='\033[0m' ;;
	esac

	echo -e "${COLOR} $2 ${NO_COLOR}"


}


function check_service_status(){
  service_is_active=$(sudo systemctl is-active $1)

  if [ $service_is_active = "active" ]
  then
    print_color "white" "$1 is active and running"
  else
    print_color "red" "$1 is not active/running"
    exit 1
  fi
}


function is_firewalld_rule_configured(){

firewalld_ports=$(sudo firewall-cmd --list-all --zone=public | grep ports)

if [[ $firewalld_ports = *$1* ]]
then
	print_color "white" "Port $1 configured"
else
	print_color "red" "Port $1 is not configured"
fi


}


#Install FirewallD
print_color "cyan" "Installing Firewalld......."
sudo apt install -y firewalld
sudo service firewalld start
sudo systemctl enable firewalld

#Check Firewalld status
check_service_status firewalld

# Install MariaDB
print_color "cyan" "Installing MariaDB"
sudo apt install -y mariadb-server
sudo service mariadb start
sudo systemctl enable mariadb

#Check MariaDB status
check_service_status mariadb



#Configure firewall for Database
print_color "cyan" "Configuring Firewall rules for database"
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload


#Check Port configuration
is_firewalld_rule_configured 3306

#Configure database
cat > configure-db.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES  ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;

EOF

sudo mysql < configure-db.sql


#Load inventory data into database
print_color "cyan" "Loading inventory data into database"
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF

sudo mysql < db-load-script.sql


#Check MySql
mysql_db_results=$(sudo mysql -e "use ecomdb; select * from products;")

if [[ $mysql_db_results == *Laptop* ]]
then
	print_color "white" "Inventory data loaded"
else
	print_color "red" "Inventory data not loaded"
fi




#Install required packages
print_color "cyan" "Installing all required packages"
sudo apt install -y apache2 php php-mysql
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

#Check port configuration
is_firewalld_rule_configured 80


#Start apache2
print_color "cyan" "Starting apache2 service"
sudo service apache2 start
sudo systemctl enable apache2

#Check Apache2 status
check_service_status apache2



#Download code
print_color "cyan" "Installing Git"
sudo apt install -y git
print_color "cyan" "Downloading code.............."
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/learning-app-ecommerce/

#Update index.php
print_color "cyan" "Updating index.php..........."
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/learning-app-ecommerce/index.php 


#Test
print_color "cyan" "Testing!"

firefox http://localhost/learning-app-ecommerce/



print_color "cyan" "COMPLETED............!"








