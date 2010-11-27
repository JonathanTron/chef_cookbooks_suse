define :rvm_gemset, :action => :create, :ruby_version => nil do
  execute "#{params[:action]} gemset #{params[:name]} via rvm in ruby version #{params[:ruby_version]}" do
    command	"rvm #{params[:ruby_version]} gemset #{params[:action]} #{params[:name]}"
  end
end