#
# Cookbook Name:: gitolite
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

# just install it once...
# i don't know about side effects executing the installation multiple time
# i review it later...
if not File.exists? node[:gitolite][:home]
	
	git_dir = "#{node[:gitolite][:home]}/#{node[:gitolite][:git_dir]}"
	bin_dir = "#{node[:gitolite][:home]}/#{node[:gitolite][:bin_dir]}"
	
	package 'git'
	
	group node[:gitolite][:group]
	user node[:gitolite][:user] do
		group node[:gitolite][:group]
		home node[:gitolite][:home]
	end
	
	directory node[:gitolite][:home] do
		owner node[:gitolite][:user]
		group node[:gitolite][:group]
		mode 0700
	end
	
	# save the initial keyfile
	keyfile = "#{node[:gitolite][:home]}/#{node[:gitolite][:init_user]}.pub"
	file keyfile do
		user node[:gitolite][:user]
		group node[:gitolite][:group]
		content node[:gitolite][:init_key]
	end
	
	git 'gitolite-clone' do
		#user node[:gitolite][:user] 	# there were problems, when executing this as user git...
		destination git_dir
		repository 'git://github.com/sitaramc/gitolite'
		action :sync
	end
	
	# fix rights after git clone (bug)
	execute "chown #{node[:gitolite][:user]}:#{node[:gitolite][:group]} -R #{git_dir}"

	directory bin_dir do
		owner node[:gitolite][:user]
		group node[:gitolite][:group]
	end
	
	execute 'gitolite-install' do
		user node[:gitolite][:user]
		environment 'HOME' => node[:gitolite][:home]
		command "#{git_dir}/install -to #{bin_dir}"
	end
	
	execute 'gitolite-init-key' do
		user node[:gitolite][:user]
		environment 'HOME' => node[:gitolite][:home]
		command "#{bin_dir}/gitolite setup -pk #{keyfile}"
	end

	file keyfile do
		action :delete
	end

end