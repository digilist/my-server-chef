sql_path = '/tmp/phpmyadmin_create_tables.sql'


range = [*'0'..'9', *'a'..'z', *'A'..'Z']
node.default[:phpmyadmin][:control_user_password] = Array.new(8){range.sample}.join

template sql_path do
	source 'mysql/create_tables.sql.erb'
	owner 'root'
    group 'root'
	mode 0600
	action :create
end

execute 'phpmyadmin-create-tables' do
	command "HOME=/root mysql < \"#{sql_path}\""
end

file sql_path do
	action :delete
	only_if { File.exists?(sql_path) }
end
