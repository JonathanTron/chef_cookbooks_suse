define :rvm_rvmrc, :action => :trust do
  execute "rvm rvmrc #{params[:action]} #{params[:name]}/.rvmrc" do
    command	"rvm rvmrc #{params[:action]} #{params[:name]}"
  end
end