maintainer        "Jonathan Tron"
maintainer_email  "jonathan@tron.name"
license           "MIT"
description       "Define helper for RVM usage"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"

supports "suse"

provides "rvm_gem(name, source, version, gemset, ruby_version)"
provides "rvm_gemset(name, action, ruby_version)"
provides "rvm_rvmrc(name, action)"