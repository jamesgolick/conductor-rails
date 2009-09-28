#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2009, Protose, Inc.
#
# Distributable under the terms of the MIT License.
#

@node[:apps].each do |app|
  user app do
    home  "/home/#{app}"
    shell "/usr/bin/bash"
  end
end

