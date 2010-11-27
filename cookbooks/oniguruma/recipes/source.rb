#
# Cookbook Name:: oniguruma
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

onig_version = node[:oniguruma][:version]
configure_flags = node[:oniguruma][:configure_flags].join(" ")

remote_file "/tmp/onig-#{onig_version}.tar.gz" do
  source "http://www.geocities.jp/kosako3/oniguruma/archive/onig-#{onig_version}.tar.gz"
  action :create_if_missing
end

bash "compile_oniguruma_source" do
  cwd "/tmp"
  code <<-EOH
    tar zxf onig-#{onig_version}.tar.gz
    cd onig-#{onig_version} && ./configure #{configure_flags}
    make && make install
  EOH
  creates "/usr/local/lib/libonig.so"
end
