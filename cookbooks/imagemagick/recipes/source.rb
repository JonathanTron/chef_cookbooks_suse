#
# Cookbook Name:: imagemagick
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

packages = %W{
  zlib-devel
  readline-devel
  libxml2-devel
  libxslt-devel
  libjpeg-devel
  libpng-devel
  libtiff-devel
  freetype2-devel
  freetype-tools
  fontconfig-devel
}

package_provider = nil

case node[:platform]
when "suse"
  case node[:platform_version].to_f
  when 11.0..11.2
    packages << "libopenssl-devel"
  when 10.0..10.2
    packages << "openssl-devel"
    package_provider = Chef::Provider::Package::Rug
  end
end

packages.each do |package_name|
  package package_name do
    provider package_provider
  end
end

remote_file "/tmp/ImageMagick-#{node[:imagemagick][:version]}.tar.bz2" do
  source "http://ftp.nluug.nl/ImageMagick/ImageMagick-#{node[:imagemagick][:version]}.tar.bz2"
  action :create_if_missing
end

configure_flags = node[:imagemagick][:configure_flags].join(" ")
bash "install_imagemagick" do
  cwd "/tmp"
  user "root"
  code <<-EOH
    tar xjf ImageMagick-#{node[:imagemagick][:version]}.tar.bz2
    cd ImageMagick-#{node[:imagemagick][:version]} && ./configure #{configure_flags}
    make && make install
    ldconfig
  EOH
  not_if "convert --version | grep '#{node[:imagemagick][:version]}'"
end