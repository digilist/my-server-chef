template "#{node[:phpmyadmin][:cfg_path]}/config-db.php" do
	source 'phpmyadmin/config-db.php.erb'
	owner 'root'
	group 'root'
	mode 0644
end

template "#{node[:phpmyadmin][:cfg_path]}/config.inc.php" do
	source 'phpmyadmin/config.inc.php.erb'
	owner 'root'
	group 'root'
	mode 0644
end
