#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# traverse users in data bag and see if they set a ruby attribute
search(:users, "*:*") do |u|
  Chef::Log.info("#{u['ruby']}")
  
  rbenv_user = u['id']
  rbenv_user_dir = "/home/#{rbenv_user}"
  rubies = u['ruby']
  rbenv_dir = "/home/#{rbenv_user}/.rbenv"
  
  directory rbenv_dir do
    owner rbenv_user
    group "sysadmin"
    mode "0755"
    action :create
  end
  
  git rbenv_dir do
    repository "git://github.com/sstephenson/rbenv.git"
    action :sync
  end
  
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
  
  bash "set up rbenv" do
    user rbenv_user
    cwd rbenv_dir
    code <<-EOH
    source .profile
    exec $SHELL
    EOH
  end
  
end