#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2013, DAA
#
# All rights reserved - Do Not Redistribute
#


package 'phpmyadmin'
group 'phpmyadmin'
user 'phpmyadmin' do
    group 'phpmyadmin'
end

include_recipe 'phpmyadmin::configuration'
include_recipe 'phpmyadmin::mysql'
include_recipe 'phpmyadmin::nginx'
