#!/bin/bash
apt-get update
apt-get install nginx -y
echo "HELLO!" >/var/www/html/index.nginx-debian.html