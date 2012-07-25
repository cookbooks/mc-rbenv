#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# traverse users in data bag and see if they set a ruby attribute and install rubies
search(:users, "ruby:*") do |u|
  rbenv_user = u['id']
  rbenv_user_dir = "/home/#{rbenv_user}"
  rubies = u['ruby']
  rbenv_dir = "#{rbenv_user_dir}/.rbenv"
  
  directory rbenv_dir do
    owner rbenv_user
    action :create
  end
  
  git rbenv_dir do
    user rbenv_user
    repository "git://github.com/sstephenson/rbenv.git"
    action :sync
  end
 
  # setup bash profile add ons
  # TODO move to it's own provider maybe
  cookbook_file "#{rbenv_user_dir}/.profile" do
    owner rbenv_user
    mode '0700'
    source "profile"
    action :create
  end
  
  directory "#{rbenv_user_dir}/profile.d" do
    owner rbenv_user
    action :create
  end
  
  cookbook_file "#{rbenv_user_dir}/profile.d/rbenv" do
    owner rbenv_user
    mode '0700'
    source "rbenv"
    action :create
  end
  
  directory "#{rbenv_dir}/plugins" do
    owner rbenv_user
    action :create
  end
  
  git "#{rbenv_dir}/plugins/ruby-build" do
    user rbenv_user
    repository "git://github.com/sstephenson/ruby-build.git"
    action :sync
  end
  
  
  
  rubies.each do |ruby|
  bash "install rubies" do
    user rbenv_user
    cwd rbenv_user_dir
    code <<-EOH
    export HOME=#{rbenv_user_dir}
    export TMPDIR=#{rbenv_user_dir}
    source .profile
    if [ "`rbenv versions | grep #{ruby}`" ];
    then echo "#{ruby} already installed";
    else rbenv install #{ruby};
    fi
    rbenv rehash;
    EOH
  end
end
end