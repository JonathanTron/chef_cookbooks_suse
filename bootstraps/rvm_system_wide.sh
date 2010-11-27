#!/usr/bin/env bash

function bootstrap_rvm_system_wide {

  echo "= RVM Install"
  if \grep -q "rvm" /etc/group ; then
    echo "== Skipped, rvm group already exists"
  else
    echo "== Create rvm group"
    groupadd -g 1400 rvm
  fi

  if [ -e /usr/local/bin/rvm ]; then
    echo "== Skipped, already installed"
  else
    echo "== From sources"
    bash < <( curl -L http://bit.ly/rvm-install-system-wide )
  fi
  source /usr/local/lib/rvm
  echo "= RVM Installed"

}