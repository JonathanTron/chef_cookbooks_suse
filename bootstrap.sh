#!/usr/bin/env bash

# Load required bootstrap methods
if [ -f "/etc/SuSE-release" ]; then
  VERSION=`cat /etc/SuSE-release | grep VERSION | sed s/VERSION\ =\ //`
  case "$VERSION" in
    10)
      rvm_ruby="rvm_ree"
    ;;
    11)
      rvm_ruby="rvm_ruby_1.9.2-p0"
    ;;
  esac
fi

bootstraps="base_packages git rvm_system_wide rvm_profile_suse ${rvm_ruby} chef chef_solo"
for i in $bootstraps; do source bootstraps/$i.sh; done

# Run bootstrap in tmp directory
if [ -d /tmp/bootstrap ]; then
  echo "/tmp/bootstrap directory already exists"
else
  mkdir -p /tmp/bootstrap
  pushd /tmp/bootstrap
    for i in $bootstraps; do
      "bootstrap_$i"
      echo
    done
  popd
fi