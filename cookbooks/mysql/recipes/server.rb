#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
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

include_recipe "mysql::client"

package "mysql-server" do
  action :install
end

package "xfsprogs" do
  action :install
end

service "mysql" do
  supports :status  => true, 
           :restart => true, 
           :reload  => true
  action :enable
end

template "/etc/mysql/my.cnf" do
  source   "my.cnf.erb"
  mode     0644
  owner    "root"
  group    "root"
  notifies :restart, resources(:service => "mysql")
end

if node[:ec2]
  mysql_server_path = ""
  
  case node[:platform]
  when "ubuntu","debian"
    mysql_server_path = "/var/lib/mysql"
  else
    mysql_server_path = "/var/mysql"
  end
  
  if !FileTest.symlink?(mysql_server_path)
    service "mysql" do
      action :stop
    end
    
    execute "install-mysql" do
      command "mv #{mysql_server_path} #{node[:mysql_ec2_path]}"
      not_if do FileTest.directory?(node[:mysql_ec2_path]) end
    end

    execute "remove original mysql dir" do
      command "rm -Rf #{mysql_server_path}"
      only_if { FileTest.directory?(mysql_server_path) }
    end
    
    link mysql_server_path do
      to node[:mysql_ec2_path]
    end

    execute "remove mysql server path" do
      command "rm -Rf #{node[:mysql_ec2_path]}/ib_log*"
    end
  end

  mysql_log_path     = "/var/log/mysql"
  mysql_ec2_log_path = "/mnt/mysql-log"

  if !FileTest.symlink?(mysql_log_path)
    service "mysql" do
      action :stop
    end

    execute "move log dir to /mnt" do
      command "mv #{mysql_log_path} #{mysql_ec2_log_path}"
      not_if { FileTest.directory?(mysql_ec2_log_path) }
    end

    link mysql_log_path do
      to mysql_ec2_log_path
    end

    execute "sleep for a bit, because mysql sucks at stopping" do
      command "sleep 120"
    end

    service "mysql" do
      action :stop
    end

    service "mysql" do
      supports :status => true, :restart => true, :reload => true
      action :start
    end
  end

  mysql_user @node[:mysql_replication_user] do
    password @node[:mysql_replication_password]
    privileges ["REPLICATION SLAVE", "REPLICATION CLIENT"]
  end
end

mysql_user node[:db_username] do
  password node[:db_password]
end

template "/usr/local/bin/deb_maint_credentials" do
  source "deb_maint_credentials.erb"
  mode "0744"
  owner "root"
  group "root"
end

mysql_user "`deb_maint_credentials user`" do
  password "`deb_maint_credentials password`"
  host "localhost"
end

db = "#{@node[:apps].first}_#{@node[:rails_env]}"
execute "create database #{db}" do
  command "mysql -uroot -e'create database #{db}'"
  not_if "mysql -uroot -e'show databases' | grep -q #{db}"
end

