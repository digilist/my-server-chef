#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, Markus Fasselt
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

apt_repository 'nginx-stable' do
	uri 'http://ppa.launchpad.net/nginx/stable/ubuntu'
	distribution node['lsb']['codename']
	components ['main']
	keyserver 'keyserver.ubuntu.com'
	key 'C300EE8C'
end

package 'nginx'

service 'nginx' do
	supports [:start, :stop, :restart, :reload]
	action :nothing
end

template 'nginx.conf' do
	source 'nginx.conf.erb'
	path "#{node[:nginx][:dir]}/nginx.conf"

	notifies :restart, resources(:service => 'nginx')
end

template 'nginx-default-vhost' do
	source 'sites-available/default.erb'
	path "#{node[:nginx][:dir]}/sites-available/default"
	
	notifies :restart, resources(:service => 'nginx')
end

link "#{node[:nginx][:dir]}/sites-enabled/default" do
	to "#{node[:nginx][:dir]}/sites-available/default"
end

# create www root
directory node[:webserver][:virtual_root] do
	user node[:webserver][:user]
	group node[:webserver][:group]
	mode 0755
	recursive true
end

# restrict access to vhosts
directory "#{node[:nginx][:dir]}/sites-available" do
	mode 0750
end
directory "#{node[:nginx][:dir]}/sites-enabled" do
	mode 0750
end

# firewall settings
firewall_rule 'http/https' do
	protocol :tcp
	ports [80, 443]
	action :allow
end
