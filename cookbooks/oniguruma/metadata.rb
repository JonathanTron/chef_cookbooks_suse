maintainer       "Jonathan Tron"
maintainer_email "jonathan@tron.name"
license          "MIT"
description      "Installs and configures Oniguruma"
version          "0.1"

recipe "oniguruma::source", "Installs oniguruma from source"

supports "suse"

attribute "oniguruma",
  :display_name => "Oniguruma",
  :description => "Hash of Oniguruma attributes",
  :type => "hash"

attribute "oniguruma/version",
  :display_name => "Oniguruma Version",
  :description => "Oniguruma version to install",
  :default => "5.9.2"

attribute "oniguruma/configure_flags",
  :display_name => "Oniguruma Configuration Flags",
  :description => "Oniguruma flags passed to configure script",
  :type => "array",
  :default => []
