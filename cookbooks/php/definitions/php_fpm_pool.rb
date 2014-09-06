#
# Cookbook Name:: php
# Definition:: php_fpm_pool
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

# enabe like this:
# php_fpm_pool "foobar"


# disable like this
# php_fpm_pool "foobar" do
# 	enable false
 #end

define :php_fpm_pool,
	   :enable => true,
	   :log_dir => nil do
	
	filename = "#{node[:php][:fpm_pool_dir]}/#{params[:name]}.conf"
	
	if params[:enable]
		# create fpm pool for this user
		template "php-fpm-config" do
			source "fpm/pool.d/template.conf.erb"
			path filename
			cookbook "php"
			
			variables :user => params[:name],
					  :log_dir => params[:log_dir]
			notifies :restart, 'service[php5-fpm]'
		end
	else
		# delete fpm pool for this user
		file filename do
			action :delete
		end
	end
	
end
