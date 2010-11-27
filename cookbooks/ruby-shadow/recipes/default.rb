#
# Cookbook Name:: ruby-shadow
# Recipe:: default
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

case node[:languages][:ruby][:version].to_f
when 1.8
  source = "shadow-1.4.1-ruby-1.8"
  lib_version = "1.8"
when 1.9
  source = "shadow-1.4.1-ruby-1.9"
  lib_version = "1.9.1"
end

remote_directory "/tmp/shadow-1.4.1" do
  source source
  not_if { File.exists?("#{node[:languages][:ruby][:bin_dir].gsub(/bin$/, "lib/ruby/site_ruby/#{lib_version}/")}#{node[:languages][:ruby][:platform]}/shadow.so") }
end

bash "install ruby shadow library" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    cd shadow-1.4.1
    ruby extconf.rb
    make install
  EOH
  not_if { File.exists?("#{node[:languages][:ruby][:bin_dir].gsub(/bin$/, "lib/ruby/site_ruby/#{lib_version}/")}#{node[:languages][:ruby][:platform]}/shadow.so") }
end