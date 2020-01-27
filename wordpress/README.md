
wordpress and mysql installation
```
sudo apt-get install mysql-server
mysql_secure_installation
mysql -u root -p
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php php-mysql apache2
sudo systemctl restart apache2
vi /etc/apache2/sites-available/000-default.conf
```
add the below data in conf file
```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wordpress/
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
<Directory /var/www/wordpress/>
    AllowOverride All
</Directory>
</VirtualHost>
```

```
sudo systemctl restart apache2
sudo a2enmod rewrite
sudo apache2ctl configtest
sudo systemctl restart apache2
cd /root/
curl -O https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
cd wordpress/
vi .htaccess
```

```
# BEGIN WordPress
# The directives (lines) between `BEGIN WordPress` and `END WordPress` are
# dynamically generated, and should only be modified via WordPress filters.
# Any changes to the directives between these markers will be overwritten.
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

# END WordPress
```

```
cp wp-config-sample.php wp-config.php
mkdir wp-content/upgrade
cd ..
mv wordpress/ /var/www/.
sudo chown -R www-data:www-data /var/www/wordpress
sudo find /var/www/wordpress/ -type d -exec chmod 750 {} \;
sudo find /var/www/wordpress/ -type f -exec chmod 640 {} \;
curl -s https://api.wordpress.org/secret-key/1.1/salt/
## add the content in 
vi /var/www/wordpress/wp-config.php
service apache2 restart

```
