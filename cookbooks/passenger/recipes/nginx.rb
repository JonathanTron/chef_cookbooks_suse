#
# Cookbook Name:: passenger
# Recipe:: nginx
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

include_recipe "nginx::source"

packages = ["zlib-devel"]
package_provider = nil
case node[:platform]
when "suse"
  case node[:platform_version].to_f
  when 11.0..11.2
    packages << "libcurl-devel"
  when 10.0..10.2
    packages << "curl-devel"
    package_provider = Chef::Provider::Package::Rug
  end
end

packages.each do |package_name|
  package package_name do
    provider package_provider
  end
end

rvm_gem "passenger" do
  version node[:passenger][:version]
  ruby_version node[:passenger][:rvm_ruby_version]
  gemset node[:passenger][:rvm_gemset]
end

configure_flags = node[:nginx][:configure_flags].join(" ")
nginx_install = node[:nginx][:install_path]
nginx_version = node[:nginx][:version]
nginx_dir = node[:nginx][:dir]

service "nginx" do
  action :stop
  not_if "#{nginx_install}/sbin/nginx -V 2>&1 | grep -q '#{node[:passenger][:rvm_ruby_version]}@#{node[:passenger][:rvm_gemset]}/gems/passenger-#{node[:passenger][:version]}/ext/nginx'"
end

execute "passenger_nginx_module" do
  command %Q{
    rvm #{node[:passenger][:rvm_ruby_version]}@#{node[:passenger][:rvm_gemset]} exec passenger-install-nginx-module \
    --auto --prefix=#{nginx_install} \
    --nginx-source-dir=/tmp/nginx-#{nginx_version} \
    --extra-configure-flags='#{configure_flags}'
  }
  not_if "#{nginx_install}/sbin/nginx -V 2>&1 | grep -q '#{node[:passenger][:rvm_ruby_version]}@#{node[:passenger][:rvm_gemset]}/gems/passenger-#{node[:passenger][:version]}/ext/nginx'"
  notifies :restart, resources(:service => "nginx")
end

template "/etc/nginx/conf.d/passenger.conf" do
  source "passenger.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end