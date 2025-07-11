#!/bin/bash

# Update
apt-get update && apt-get upgrade-y

# Install required packages
apt install -y nginx mysql-server php-fpm php-cli php-mysql

# Start services
systemctl start nginx
systemctl enable nginx
systemctl start mysql
systemctl enable mysql

# Configure MySQL for WordPress
mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Download Wordpress
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/

# Setup Nginx
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.php index.html index.htm;        

    location / {
        try_files $uri $uri/ /index.php?$args;   
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;       
        fastcgi_pass unix:/run/php/php-fpm.sock; 
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Setup config file
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
sed -i "s/password_here/password/" /var/www/html/wp-config.php

# Restart nginx
systemctl reload nginx