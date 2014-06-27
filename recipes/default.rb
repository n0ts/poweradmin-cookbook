#
# Cookbook Name:: poweradmin
# Recipe:: default
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php-wrapper'
include_recipe 'apache2'
include_recipe 'apache2::mod_php5'

%w{
  php53-gd
  php53-mbstring
  php53-mcrypt
  php53-mysql55
  php53-pdo
  php53-xmlrpc
}.each do |package|
  package package do
    action :install
  end
end

%w{
  mdb2
  mdb2_driver_mysql
}.each do |pear|
  php_pear pear do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/poweradmin.tgz" do
  source "https://github.com/downloads/poweradmin/poweradmin/poweradmin-#{node['poweradmin']['version']}.tgz"
  action :create
end

bash 'poweradmin-extract' do
  code <<-EOH
cd #{node['apache']['docroot_dir']};
tar zxf "#{Chef::Config[:file_cache_path]}/poweradmin.tgz";
chown -R #{node['apache']['user']}:#{node['apache']['group']} #{node['apache']['docroot_dir']}/poweradmin-#{node['poweradmin']['version']}
EOH
  action :run
  not_if { ::File.exists?("#{node['apache']['docroot_dir']}/poweradmin-#{node['poweradmin']['version']}") }
end

link "#{node['apache']['docroot_dir']}/poweradmin" do
  to "#{node['apache']['docroot_dir']}/poweradmin-#{node['poweradmin']['version']}"
  owner node['apache']['user']
  action :create
end

template "#{node['apache']['docroot_dir']}/poweradmin/inc/config.inc.php.sample" do
  source 'config.inc.php.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0640
  action :create_if_missing
end

htpasswd "#{node['apache']['docroot_dir']}/poweradmin/.htpasswd" do
  user "poweradmin"
  password "poweradmin"
  action :add
end

file "#{node['apache']['docroot_dir']}/poweradmin/.htaccess" do
  content <<-EOH
AuthUserFile #{node['apache']['docroot_dir']}/poweradmin/.htpasswd
AuthGroupFile /dev/null
AuthName "Secret Area"
AuthType Basic

require valid-user

<Files ~ "^.(htpasswd|htaccess)$">
    deny from all
</Files>
EOH
  owner node['apache']['user']
  group node['apache']['group']
  action :create
end
