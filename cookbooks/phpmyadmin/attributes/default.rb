default[:phpmyadmin][:cfg_path]               = '/etc/phpmyadmin'
default[:phpmyadmin][:path]                   = '/usr/share/phpmyadmin'

default[:phpmyadmin][:auth_type]              = 'cookie'
default[:phpmyadmin][:allow_root]             = false
default[:phpmyadmin][:allow_no_password]      = false

default[:phpmyadmin][:control_database]       = 'phpmyadmin'
default[:phpmyadmin][:control_user]           = 'phpmyadmin'
#default[:phpmyadmin][:control_user_password] = '' - will be set to an automatically generated password unless specified

default[:phpmyadmin][:url]                    = 'phpmyadmin'
default[:phpmyadmin][:user]                   = 'phpmyadmin'
