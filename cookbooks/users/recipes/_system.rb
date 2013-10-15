#
# Cookbook Name:: users
# Recipe:: system
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
	
	group username
	
	# use defaults, if there are no values set
	shell = user.fetch(:shell, '/usr/bin/zsh')
	
	user username do
		username username
		password (`openssl passwd -1 "#{user[:password]}"`.strip!) if user.has_key? :password
		home user[:home]
		gid username
		shell shell
		
		supports :manage_home => true
	end
	
	# set mode for user home directory
	directory user[:home] do
		mode 0700
	end
	
	# create an empty .zshrc for this user (to prevent the zsh first start notice)
	if shell == '/usr/bin/zsh'
		file "#{user[:home]}/.zshrc" do
			action :create_if_missing
		end
	end
end