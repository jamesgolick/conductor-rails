$LOAD_PATH << File.expand_path("../../../../vendor/chef-deploy/lib", __FILE__)
require 'chef-deploy'

deploy "/var/www/#{@node[:apps].first}" do
  repo            @node[:app_clone_url]
  user            @node[:user]
  role            @node[:role]
  environment     @node[:rails_env]
  migrate         true if @node[:master]
  migrate_command "rake db:migrate"
  restart_command "sudo /opt/ruby-enterprise/bin/god restart mongrels" if @node[:role] == "app" && @node[:configured]
  action          :deploy
end

