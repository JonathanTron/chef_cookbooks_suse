maintainer       "Jonathan Tron"
maintainer_email "jonathan@tron.name"
license          "MIT"
description      "Installs/Configures imagemagick"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

supports "suse"

attribute "imagemagick",
  :display_name => "ImageMagick",
  :description => "Hash of ImageMagick attributes",
  :type => "hash"

attribute "imagemagick/version",
  :display_name => "ImageMagick Version",
  :description => "ImageMagick version to install",
  :default => "6.6.5-8"

attribute "imagemagick/configure_flags",
  :display_name => "ImageMagick configure flags",
  :description => "ImageMagick flags to pass to configure",
  :type => "array"
  :default => ["--with-quantum-depth=8"]