#
# Cookbook Name:: webserver
# Definition:: nginx_site
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

define :nginx_site,
	   :enable => true,
	   :username => nil,
	   :project_root => nil,
	   :log_dir => nil,
	   :domains => nil,
	   :vhost => nil,
	   :redirect_domains => {} do
	
	raise 'missing param' if params[:username].nil? || params[:project_root].nil? || params[:domains].nil? || params[:vhost].nil?

	if params[:enable]

		template 'nginx-vhost' do
			cookbook 'nginx'
			source 'sites-available/template.erb'
			path "#{node[:nginx][:dir]}/sites-available/#{params[:name]}"

			variables :username			=> params[:username],
					  :project_root		=> params[:project_root],
					  :log_dir			=> params[:log_dir],
					  :domains			=> params[:domains],
					  :redirects		=> params[:redirect_domains],
					  :vhost			=> params[:vhost]

			notifies :restart, resources(:service => 'nginx')
		end
		
		# symlink in sites-enableds
		link "#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}" do
			to "#{node[:nginx][:dir]}/sites-available/#{params[:name]}"
			not_if do File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") end

			notifies :restart, 'service[nginx]'
		end
		
	else
		
		# delete vhost and symlink
		file 'nginx-vhost' do
			path "#{node[:nginx][:dir]}/sites-available/#{params[:name]}"
		end
		
		file 'nginx-vhost' do
			path "#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}"
			action :delete

			notifies :restart, 'service[nginx]'
		end
	end
end
