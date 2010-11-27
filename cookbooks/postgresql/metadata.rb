maintainer        "Jonathan Tron"
maintainer_email  "jonathan@tron.name"
license           "MIT"
description       "Install PostgreSQL"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"

supports "suse"

recipe "postgresql::client", "Install PostgreSQL's client libs"
recipe "postgresql::devel", "Install PostgreSQL's devel libs"