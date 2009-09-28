#
# Cookbook Name:: applications
# Recipe:: default
#
# Copyright 2009, Engine Yard, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/var/www" do
  owner node[:user]
  group node[:user]
  mode 0755
end

node[:apps].each do |app|
  app_root        = "/var/www/#{app}/current/public"
  cap_directories = [
    "/var/www/#{app}",
    "/var/www/#{app}/shared",
    "/var/www/#{app}/shared/log",
    "/var/www/#{app}/shared/config",
    "/var/www/#{app}/shared/system",
    "/var/www/#{app}/releases"
  ]
  
  cap_directories.each do |dir|
    directory dir do
      owner node[:user]
      group node[:user]
      mode 0755
      recursive true
    end
  end

  template "/etc/nginx/sites-enabled/#{app}" do
    source "nginx-conf.erb"
    mode 0744
    variables :app      => app,
              :app_root => app_root
  end

  logrotate app do
    files "/var/www/#{app}/current/log/*"
    rotate_count 25
    size "100M"
    compress true
    delaycompress true
    missing_ok true
    rotate_if_empty false
    restart_command "touch /var/www/#{app}/current/tmp/restart.txt"
    extra_commands "create 640 #{app} #{app}"
  end
end

