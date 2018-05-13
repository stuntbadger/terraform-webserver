#!/bin/sh
sudo yum install -y httpd
sudo service httpd start
sudo chkonfig httpd on
sudo echo "<html><h1>Hello World</h2></html>" > /var/www/html/index.html

