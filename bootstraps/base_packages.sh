#!/usr/bin/env bash

function bootstrap_base_packages {

  echo "= Base packages"
  if [ "10" -eq "$VERSION"]; then
    zypper install gcc gcc-c++ zlib-devel openssl-devel curl-devel readline-devel
  elif [ "11" -eq "$VERSION" ]; then
    zypper install gcc gcc-c++ zlib-devel libopenssl-devel libcurl-devel readline-devel
  else
    echo "== Unhandled version: $VERSION"
    exit
  fi
  echo "= Base packages installed"
}