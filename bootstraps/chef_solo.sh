#!/usr/bin/env bash

function bootstrap_chef_solo {

  echo "= Chef-Solo configure"
  if [ -e /etc/chef ]; then
    echo "== Skipped, already configured"
  else
    mkdir -p /etc/chef
    (
      cat <<EOP
file_cache_path "/tmp/chef-solo"
cookbook_path   ["/tmp/chef-solo/cookbooks", "/tmp/chef-solo/site-cookbooks"]
role_path       "/tmp/chef-solo/roles"
EOP
    ) > /etc/chef/solo.rb
  fi
  echo "= Chef-Solo configured"

}