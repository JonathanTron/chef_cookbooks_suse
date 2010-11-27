#!/usr/bin/env bash

function bootstrap_git {

  echo "= Git Install"
  if [ -e /usr/local/bin/git ]; then
    echo "== Skipped, already installed"
  else
    echo "== From sources"
    wget http://kernel.org/pub/software/scm/git/git-1.7.3.2.tar.bz2
    tar xvjf git-1.7.3.2.tar.bz2
    pushd git-1.7.3.2
      ./configure --without-python
      make && make install
    popd
  fi
  echo "== Version: $(`git --version`)"
  echo "= Git Installed"

}