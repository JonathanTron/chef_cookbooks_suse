#
# Cookbook Name:: nginx
# Recipe:: source
#
# Copyright (c) 2010 Jonathan Tron <jonathan@tron.name>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

package_provider = nil
case node[:platform]
when "suse"
  case node[:platform_version].to_f
  when 10.0..10.2
    package_provider = Chef::Provider::Package::Rug
  end
end

%W{
  pcre-devel
  openssl-devel
}.each do |package_name|
  package package_name do
    provider package_provider
  end
end

nginx_version = node[:nginx][:version]
configure_flags = node[:nginx][:configure_flags].join(" ")

remote_file "/tmp/nginx-#{nginx_version}.tar.gz" do
  source "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
  action :create_if_missing
end

bash "compile_nginx_source" do
  cwd "/tmp"
  code <<-EOH
    tar zxf nginx-#{nginx_version}.tar.gz
    cd nginx-#{nginx_version} && ./configure #{configure_flags}
    make && make install
  EOH
  creates node[:nginx][:src_binary]
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

directory node[:nginx][:dir] do
  owner "root"
  group "root"
  mode "0755"
end

#install init db script
template "/etc/init.d/nginx" do
  source "nginx.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

#install sysconfig file (not really needed but standard)
template "/etc/sysconfig/nginx" do
  source "nginx.sysconfig.erb"
  owner "root"
  group "root"
  mode "0644"
end

#register service
service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action :enable
  subscribes :restart, resources(:bash => "compile_nginx_source")
end

%w{ sites-available sites-enabled conf.d }.each do |dir|
  directory "#{node[:nginx][:dir]}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
  end
end

%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode "0755"
    owner "root"
    group "root"
  end
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx"), :immediately
end

cookbook_file "#{node[:nginx][:dir]}/mime.types" do
  source "mime.types"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx"), :immediately
end

directory "#{node[:nginx][:dir]}/helpers"

# helpers to be included in your vhosts
node[:nginx][:helpers].each do |h|
  template "#{node[:nginx][:dir]}/helpers/#{h}.conf" do
    notifies :reload, resources(:service => "nginx")
  end
end