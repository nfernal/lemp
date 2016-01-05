#
# Cookbook Name:: lemp
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum-epel::default'
include_recipe 'iptables::default'


# bash 'yum_groupinstalls' do
#   user 'root'
#   cwd '/tmp'
#   code <<-EOH
#     declare -a arr=("Development tool" "Desktop" "Desktop Platform" "X Window System" "Fonts")
#     for p in "${arr[@]}" do yum groupinstall $p -y done 
#   EOH
# end

iptables_rule 'http' do
  action :enable
end

mysql_service 'foo' do
  port '3306'
  version '5.7'
  initial_root_password 'password'
  action [:create, :start]
end

package 'nginx' do
  action :install
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

%w{php-fpm php-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end

service 'php-fpm' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

cookbook_file '/etc/php.ini' do
  source 'php.ini'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/php-fpm.d/www.conf' do
  source 'www.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/default.conf' do
  source 'default.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[php-fpm]', :immediately
end

cookbook_file '/usr/share/nginx/html/info.php' do
  source 'info.php'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]', :immediately
end

