#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2013, DAA
#
# All rights reserved - Do Not Redistribute
#


package 'phpmyadmin'

include_recipe 'phpmyadmin::configuration'
include_recipe 'phpmyadmin::mysql'
include_recipe 'phpmyadmin::nginx'
