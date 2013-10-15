#
# Cookbook Name:: mysql
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

node[:users].each do |username, user|

	# when no mysql_password is set, don't create a mysql user
	if user.has_key? :mysql_password and user.has_key? :mysql_databases and user[:mysql_databases].length > 0
		
		# create user and databases
		mysql_user username do
			password user[:mysql_password]
			database username
			database user[:mysql_databases]
		end
		
		# create $HOME/.my.cnf
		template 'client-my.cnf' do
			cookbook 'mysql'
			path "#{user[:home]}/.my.cnf"
			owner username
			group username
			mode 0600
			variables :user => username,
					  :password => user[:mysql_password]
		end
	end
end
