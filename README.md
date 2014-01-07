My Chef-Cookbooks used for my server
========
Here you can see my cookbooks to configure my web server. On my web server I have running different websites and a central git repository (with gitolite).

With this configuration each user has full SSH access to his account, where he can manage his websites.
Currently there are PHP and Pyhton installed as scripting languages. PHP is executed through PHP-FPM and Pyhton through FastCGI.

Furthermore there are MySQL as database server and nginx as web server.
My aim is to extend my configuration with further applications, just be patient :)

This configuration is work in progress. However, feel free to use it for your own purposes.

Configuration
------------
You can configure this installation, add users and manage the virtual hosts by adjusting the variables in the `solo.json`-File (for development) oder in the `solo-prod.json`-File (for production).

Please note that this configuration sets all passwords every time it is executed! So if a user changes its passwords, it will be reset to your configurations value. I'm not sure, whether I will change this.

Users
--------
You can create users by adding them to your configuration and running chef-solo.

Each user is allowed to connect to my server using SSH. He can run whatever command he likes to, there are (nearly) no restrictions.
In his home folder (`/home/{user}`) there are three symlinks: `www`, `fcgi` and `logs`.

- `www`  
  In this folder you can put your plain HTML documents or your PHP files.
Please note that I am using nginx as a web server, so you can't use `.htaccess`-Files!  You need to rewrite the URLs within the nginx configuration (*which is not supported through my configuration yet*).
- `fcgi`  
  In this folder you can put your fcgi-Scripts. For more information see below.
- `logs`  
  I think it's obvious :)

The goal of this configuration is, that mostly everything can be run from within the user space, so that the root account is not necessary for many tasks.

PHP
------
PHP is installed from a third-party-PPA to get a more current version. Currently there is PHP 5.5.4.
This configuration installs PHP with the following extra packages: cli, mysql, curl, intl and pear.
As a dependency manager it will install composer.

Just place your PHP-Files into your www-Folder. If your www-Folder isn't your Document Root, you can move it adjusting the variable in your configuration file.

Python
-------
In Ubuntu 13.04 are both, Python 2.7 and Python 3 available.
As a package manager for third party python packages, I have installed pip. You can install every package with `pip --user` into your user space.

FastCGI
--------
Through FastCGI you can run any script within the web server (like Python, Perl etc.). In your configuration you can specify on which port your application should listen for FCGI requests. Currently, this is the only option to connect nginx with FastCGI Application.

Currently you have to start the application by yourself and take care that it doesn't stop. I'm planning to automate this process (which is the reason for the fcgi-folder).

MySQL
--------
To enable mysql for a specific user, just add the `mysql_password` and `mysql_databases` variable to the users configuration. It will automatically create the user and its databases.
When the user starts the mysql cli, he is automatically logged in. 

Gitolite
--------
It's the same with each gitolite installation. For further information, read their documentation!
You can clone the gitolite-admin-Repository from git@example.com:gitolite-admin.git

Disclaimer
----------
You can use this configuration for your own purposes. However, I give absolutely NO WARRANTY – use it at your own risk!
I am currently using it within a Ubuntu 13.04 box, so I don't know how it behaves on other boxes!


My Todo List (or things that will come soon)
--------------
- Fail2Ban
- MyWebSQL
- IDS (maybe...)
- Bin
