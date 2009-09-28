define :logrotate, :frequency => "daily", :rotate_count => 10, :rotate_if_empty => false, :missing_ok => true, :compress => true, :delaycompress => true, :enable => true, :restart_command => false, :extra_commands => nil, :size => nil do
  template "/etc/logrotate.d/#{params[:name]}" do
    action params[:enable] ? :create : :delete
    cookbook "logrotate"
    source "logrotate.conf.erb"
    variables(:p => params)
    backup false
  end
end
