name "app"
recipes "users", "god", "haproxy", "logrotate", "mysql::client", 
        "gems", "nginx", "applications", "memcached", "database.yml",
        "deployment" # rails-deployment really needs to happen last

