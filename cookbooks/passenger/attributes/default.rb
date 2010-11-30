set_unless[:passenger] = Mash.new
set_unless[:passenger][:version] = "3.0.0"
set_unless[:passenger][:rvm_ruby_version] = "ruby-1.9.2-p0"
set_unless[:passenger][:rvm_gemset] = "global"

set_unless[:passenger][:pool_idle_time] = 300
set_unless[:passenger][:max_pool_size] = 6
set_unless[:passenger][:max_instances_per_app] = 0
