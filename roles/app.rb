name "app"
recipes "users", "god", "haproxy", "logrotate", "mysql::client", 
        "gems", "database.yml", "nginx", "memcached", "applications",
        "deployment" # rails-deployment really needs to happen last

