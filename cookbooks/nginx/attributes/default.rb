# configuration named "webserver" to make nginx replacable
default[:webserver][:virtual_root]	= '/var/virtual'
default[:webserver][:user]			= 'www-data'
default[:webserver][:group]			= 'www-data'

# this folders are inside the users folder
default[:webserver][:www_dir]		= 'www'
default[:webserver][:fcgi_dir]		= 'fcgi'
default[:webserver][:log_dir]		= 'logs'

default[:nginx][:dir]				= '/etc/nginx'