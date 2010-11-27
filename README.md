Opscode Chef Cookbooks to use with Suse Linux
=============================================

Those cookbooks are meant to be used (and have been tested) on:

  * Suse Linux Enterprise Server 10.1 SP2 (SLES 10.1)
  * Suse Linux Enterprise Server 11.0 SP2 (SLES 10.2)

Bootstrap
=========

Included is a script which allows to bootstrap a chef installation (solo currently, but config with server only requires small changes).
This means, for my usage, installing and configuring:

  * Some base package needed for Git/RVM and Ruby installation
  * [Git](http://git-scm.com/) from source
  * [RVM](http://rvm.beginrescueend.com) system wide installation
  * [RubyEE](http://www.rubyenterpriseedition.com/)
    * 1.8.7-2010.02 on SLES 10.1 because 1.9.2-p0 has a bug on this specific version which do not allow forking (which is required for chef and most ruby dev)
    * 1.9.2-p0 on SLES 11.0
  * Chef in @global gemset

Recipes
=======

  * environment
  * imagemagick::source
  * java::jdk
  * nginx::source
  * oniguruma::source
  * passenger::nginx
  * postgresql::client
  * postgresql::devel
  * ruby-shadow
  
Providers
=========

  * Rug
  
Definitions
===========

  * rvm_gem
  * rvm_gemset
  * rvm_rvmrc