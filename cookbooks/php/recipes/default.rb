#
# Cookbook Name:: php
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

# provides php 5.5
apt_repository 'php5' do
	uri 'http://ppa.launchpad.net/ondrej/php5/ubuntu/'
	distribution node['lsb']['codename']
	components %w(main)
	keyserver 'keyserver.ubuntu.com'
	key 'E5267A6C'
end

package 'php5-fpm'
package 'php5-cli'
package 'php5-mysql'
package 'php5-curl'
package 'php5-intl'
package 'php-pear'

service 'php5-fpm' do
	provider Chef::Provider::Service::Upstart
	# start is graceful and includes reloading
	supports [:start, :stop, :restart, :reload]
end

#include_recipe 'php::composer'
