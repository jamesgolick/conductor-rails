include_recipe "haproxy"

config_path = case node[:platform]
when "ubuntu","debian"
  "/etc/haproxy.cfg"
else
  "/etc/haproxy/haproxy.cfg"
end

template config_path do
  source "haproxy-smtp.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "haproxy")
end

service "haproxy" do
  action :start
end

