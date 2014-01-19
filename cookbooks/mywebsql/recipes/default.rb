#
# Cookbook Name:: mywebsql
# Recipe:: default
#
# Copyright 2014, Markus Fasselt
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

if not File.exists? node[:mywebsql][:home]

  # create user and group
  group node[:mywebsql][:group]
  user node[:mywebsql][:user] do
    group node[:mywebsql][:group]
    home node[:mywebsql][:home]
    shell '/bin/false'
  end

  # set directory rights
  directory node[:mywebsql][:home] do
    owner node[:mywebsql][:user]
    group node[:mywebsql][:group]
    mode 0700
  end
  
  puts Chef::Config[:file_cache_path];

  # get mywebsql
  tmpFile = '/tmp/mywebsql.zip'
  remote_file tmpFile do
    source node[:mywebsql][:download_url]
  end
  
  # extract archive
  execute "unzip #{tmpFile} -d #{node[:mywebsql][:home]}" do
    user node[:mywebsql][:user]
    user node[:mywebsql][:group]
  end
  
  # there is a unneccessary subfolder, remove it
  execute "cd #{node[:mywebsql][:home]} && mv mywebsql/* . && mv mywebsql/.htaccess . && rmdir mywebsql " do
    user node[:mywebsql][:user]
  end
  
  file "#{node[:mywebsql][:home]}/install.php" do
    action :delete
  end
  
  # replace Tahoma with Arial :)
  execute "cd #{node[:mywebsql][:home]} && find . -type f -name '*.css' -exec sed -i 's/Tahoma/Arial/g' {} \\;"

end

# fix rights on mywebsql
execute "cd #{node[:mywebsql][:home]}; find . -type d -exec chmod 755 {} \\; ; find . -type f -exec chmod 644 {} \\;"

php_fpm_pool node[:mywebsql][:user]

# add nginx host
template "nginx.conf" do
  path "#{node[:nginx][:dir]}/global.d/mywebsql.conf"

  #notifies :restart, resources(:service => 'nginx')
end
