#
# Cookbook Name:: postgresql
# Recipe:: client
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

case node[:platform]
when "suse"
  case node[:platform_version].to_f
  when 11.0..11.2
    package "postgresql"
    package "postgresql-libs"
  when 10.0..10.2
    cookbook_file "/tmp/postgresql-libs-8.3.3-8.1.x86_64.rpm" do
      source "postgresql-libs-8.3.3-8.1.x86_64.rpm"
    end
    cookbook_file "/tmp/postgresql-8.3.3-8.1.x86_64.rpm" do
      source "postgresql-8.3.3-8.1.x86_64.rpm"
    end
    package "postgresql-libs-8.3.3-8.1.x86_64.rpm" do
      provider Chef::Provider::Package::Rpm
      source "/tmp/postgresql-libs-8.3.3-8.1.x86_64.rpm"
    end
    package "postgresql-8.3.3-8.1.x86_64.rpm" do
      provider Chef::Provider::Package::Rpm
      source "/tmp/postgresql-8.3.3-8.1.x86_64.rpm"
    end
  end
end