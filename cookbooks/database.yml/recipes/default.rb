#
# Cookbook Name:: database.yml
# Recipe:: default
#
# Copyright 2009, Protose, Inc.
#
# All rights reserved - Do Not Redistribute
#

@node[:apps].each do |app|
  template "/var/www/#{app}/shared/config/database.yml" do
    source   "database.yml.erb"
    mode     0755
    owner    @node[:user]
    group    @node[:user]
    variables :database => "#{app}_#{@node[:rails_env]}"
  end
end
