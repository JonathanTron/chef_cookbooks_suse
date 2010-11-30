maintainer        "Jonathan Tron"
maintainer_email  "jonathan@tron.name"
license           "MIT"
description       "Install passenger"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"

supports "suse"

depends "nginx::source"

recipe "passenger::nginx", "Install Passenger's nginx module"

attribute "passenger",
  :display_name => "Passenger",
  :description => "Hash of Passenger attributes",
  :type => "hash"

attribute "passenger/version",
  :display_name => "Passenger Version",
  :description => "Passenger version to install",
  :default => "3.0.0"

attribute "passenger/rvm_ruby_version",
  :display_name => "Passenger RVM Ruby Version",
  :description => "Passenger RVM Ruby version to install",
  :default => "ruby-1.9.2-p0"
  
attribute "passenger/rvm_gemset",
  :display_name => "Passenger RVM Gemset",
  :description => "Passenger RVM Gemset to install",
  :default => "global"
  
attribute "passenger/pool_idle_time",
  :display_name => "Passenger pool_idle_time",
  :description => "Passenger pool_idle_time to use",
  :default => 300

attribute "passenger/max_pool_size",
  :display_name => "Passenger max_pool_size",
  :description => "Passenger max_pool_size to use",
  :default => 6

attribute "passenger/max_instances_per_app",
  :display_name => "Passenger max_instances_per_app",
  :description => "Passenger max_instances_per_app to use",
  :default => 0