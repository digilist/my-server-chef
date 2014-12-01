
php_fpm_pool node[:phpmyadmin][:user]

# add nginx host
template "nginx.conf" do
  source "phpmyadmin/nginx.conf.erb"
  path "#{node[:nginx][:dir]}/global.d/phpmyadmin.conf"

  notifies :restart, resources(:service => 'nginx')
end
