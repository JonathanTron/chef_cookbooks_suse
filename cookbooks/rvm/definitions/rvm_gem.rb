define :rvm_gem, :source => nil, :version => nil, :gemset => "global", :ruby_version => nil do
  ruby_version_gemset = "#{params[:ruby_version]}@#{params[:gemset]}"
  execute "install gem #{params[:name]} (#{params[:version] || "no version specified"}) via rvm in ruby gemset #{ruby_version_gemset}" do
    command	"rvm #{ruby_version_gemset} gem install #{params[:name]}#{" -v '#{params[:version]}'" if params[:version]}"
    not_if "rvm #{ruby_version_gemset} gem search #{params[:name]} | grep -q #{params[:version]}"
  end
end