name "app"
recipes "users", "god", "haproxy", "logrotate", "applications",
        "mysql::client", "gems", "database.yml", "nginx", 
        "memcached", "deployment" # rails-deployment really needs to happen last

