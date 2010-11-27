maintainer       "Jonathan Tron"
maintainer_email "jonathan@tron.name"
license          "MIT"
description      "Installs a global environment file"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

supports "suse"

attribute "environment",
  :display_name => "Environment",
  :description => "Hash of Environment attributes",
  :type => "hash"

attribute "environment/paths",
  :display_name => "Environment paths",
  :description => "Environment base paths",
  :type => "array",
  :default => ["/sbin", "/usr/sbin", "/usr/local/sbin", "/opt/gnome/sbin", "/usr/local/bin", 
    "/usr/bin", "/usr/X11R6/bin", "/bin", "/usr/games", "/opt/gnome/bin","/usr/lib/mit/bin",
    "/usr/lib/mit/sbin"]
  
attribute "environment/preprend_paths",
  :display_name => "Environment additional paths",
  :description => "Paths to be prepend to base paths",
  :type => "array",
  :default => []