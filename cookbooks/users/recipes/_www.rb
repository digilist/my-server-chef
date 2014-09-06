#
# Cookbook Name:: nginx
# Recipe:: vhosts
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

node[:users].each do |username, user|

	if user.has_key? :vhosts

		user_virtual_root = "#{node[:webserver][:virtual_root]}/#{username}"
		user_www_dir = "#{user_virtual_root}/#{node[:webserver][:www_dir]}"
		fcgi_bin_dir = "#{user_virtual_root}/#{node[:webserver][:fcgi_dir]}"
		log_dir = "#{user_virtual_root}/#{node[:webserver][:log_dir]}"

		# create php fpm pool
		php_fpm_pool username do
			log_dir log_dir
		end

		[user_virtual_root, user_www_dir, fcgi_bin_dir, log_dir].each do |dir|
			directory dir do
				mode 0750
				user username
				group node[:webserver][:group]
			end
		end

		# symlinks from home directory
		link "#{user[:home]}/#{node[:webserver][:www_dir]}" do
			to user_www_dir
		end
		link "#{user[:home]}/#{node[:webserver][:fcgi_dir]}" do
			to fcgi_bin_dir
		end
		link "#{user[:home]}/#{node[:webserver][:log_dir]}" do
			to log_dir
		end

		user[:vhosts].each do |vhost|
			domains = vhost[:domains]
			main_domain = domains[0]
			redirect_domains = vhost.fetch(:redirect_domains, {})
			
			vhost_www_root = vhost.fetch(:www_root, '')
			vhost_root = "#{user_www_dir}/#{vhost_www_root}"

			# create project directory with an initial file
			if not File.directory? vhost_root
				
				# create project folder for user
				directory vhost_root do
					mode 0750
					user username
					group node[:webserver][:group]
					recursive true
				end
			
				file "#{vhost_root}/index.html" do
					owner username
					group username
					mode 0644

					content "Hello World! Welcome at #{main_domain}!"
				end
			end

			nginx_site main_domain do
				enable true
				username username
				www_root user_www_dir
				log_dir log_dir
				domains domains
				redirect_domains redirect_domains
				vhost vhost
				
				notifies :restart, 'service[nginx]'
			end
		end
	end
end
