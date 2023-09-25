#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/itsme-srikanth/ecomm.git /var/www/html