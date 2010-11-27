set_unless[:imagemagick] = Mash.new
set_unless[:imagemagick][:version] = "6.6.5-8"
set_unless[:imagemagick][:configure_flags] = ["--with-quantum-depth=8"]