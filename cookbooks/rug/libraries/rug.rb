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

require 'chef/provider/package'
require 'chef/mixin/command'
require 'chef/resource/package'
require 'singleton'

class Chef
  class Provider
    class Package
      class Rug < Chef::Provider::Package

        def load_current_resource
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)

          is_installed=false
          version=''
          is_out_of_date=false
          oud_version=''
          Chef::Log.debug("Checking rug for #{@new_resource.package_name}")
          status = popen4("rug info #{@new_resource.package_name}") do |pid, stdin, stdout, stderr|
            stdout.each do |line|
              case line
              when /^Version: (.+)$/
                version = $1
                Chef::Log.debug("rug version=#{$1}")
              when /^Installed: Yes$/
                is_installed=true
                Chef::Log.debug("rug installed true")
              when /^Installed: No$/
                is_installed=false
                Chef::Log.debug("rug installed false")
              when /^Status: out-of-date \(version (.+) installed\)$/
                is_out_of_date=true
                oud_version=$1
                Chef::Log.debug("rug out of date version=#{$1}")
              end
            end
          end

          if !is_installed
            @candidate_version=version
            @current_resource.version(nil)
            Chef::Log.debug("rug installed false");
          end

          if is_installed
            if is_out_of_date
              @current_resource.version(oud_version)
              @candidate_version=version
              Chef::Log.debug("rug installed outofdate");
            else
              @current_resource.version(version)
              @candidate_version=version
              Chef::Log.debug("rug installed");
            end
          end


          unless status.exitstatus == 0
            raise Chef::Exceptions::Package, "rug failed - #{status.inspect}!"
          end

          if @candidate_version == ''
            raise Chef::Exceptions::Package, "rug does not have a version of package #{@new_resource.package_name}"
          end

          Chef::Log.debug("rug current resource      #{@current_resource}")
          @current_resource
        end

        def install_package(name, version)
          if version
            run_command(
              :command => "rug --quiet install -y --agree-to-third-party-licences #{name}-#{version}"
            )
          else
            run_command(
              :command => "rug --quiet install -y --agree-to-third-party-licences #{name}"
            )
          end
        end

        def upgrade_package(name, version)
          install_package(name, version)
        end

        def remove_package(name, version)
          if version
            run_command(
              :command => "rug --quiet remove -y #{name}-#{version}"
            )
          else
            run_command(
              :command => "rug --quiet remove -y #{name}"
            )
          end


        end

        def purge_package(name, version)
          remove_package(name, version)
        end

      end
    end
  end
end