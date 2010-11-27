#!/usr/bin/env bash

function bootstrap_chef {

  echo "= Chef Install"
  rvm --create @global
  if [ -n "`gem list | grep chef`" ]; then
    echo "== Skipped, already installed"
  else
    gem install chef
  fi
  echo "== Version: $(chef-client --version)"
  echo "= Chef Installed"

}