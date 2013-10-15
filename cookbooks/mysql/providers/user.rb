#
# Cookbook Name:: mysql
# Provider:: user
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

# =====================================
# each command in this provider, requires correct root credentials
# in /root/.my.cnf
# =====================================

action :add do
	add_user(new_resource.host,
			 new_resource.username,
			 new_resource.password,
			 new_resource.grant,
			 new_resource.database,
			 new_resource.tables)
end

action :remove do
	remove_user (new_resource.username)
end

# add a mysql user, create databases and grant access
def add_user (hosts, username, password, grant, databases, tables)
	
	# as default, allow access to all tables
	tables << '*' if tables.empty?
	
	# convert to array
	hosts = [hosts] if not hosts.is_a? Array
	databases = [databases] if not databases.is_a? Array
	
	databases.each do |database|
		if database != '*'
			create_database database
		end
	end
	
	# create users and grant access
	hosts.each do |host|
		databases.each do |database|
			tables.each do |table|
	
				# add user
				execute 'add-user' do
					user 'root'
					command <<-EOF
HOME=/root
mysql -e "GRANT #{grant} ON #{database}.#{table} TO '#{username}'@'#{host}' IDENTIFIED BY '#{password}';"
EOF
				end
		
				# grant usage to database
				if database != '*' and grant == 'USAGE'
					execute 'grant privileges on database' do
						user 'root'
						command <<-EOF
HOME=/root
mysql -e "GRANT ALL PRIVILEGES ON #{database}.#{table} TO '#{username}'@'#{host}';"
EOF
					end
				end
			end
		end
	end
	
	flush_privileges
end

# create a database
def create_database (database_name)
	execute 'add-database' do
		user 'root'
		command <<-EOF
HOME=/root
mysql -e "CREATE DATABASE IF NOT EXISTS #{database_name}"
EOF
	end
end

# remove a user, databases won't be deleted!
def remove_user (username)
	execute 'sst-user' do
		user 'root'
		command <<-EOF
HOME=/root
mysql -e "DROP USER '#{username}'"
EOF
	end
	
	flush_privileges
end

def flush_privileges
	execute 'flush privileges' do
		user 'root'
		command <<-EOF
HOME=/root
mysql -e "FLUSH PRIVILEGES;"
EOF
	end
end