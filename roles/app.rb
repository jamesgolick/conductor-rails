name "app"
recipes "users", "dotfiles", "god", "haproxy::http", "logrotate", "applications",
        "mysql::client", "gems", "database.yml", "ncurses-term",
        "nagios::nrpe-server", "sphinx", "sphinx::config", "nginx", 
        "memcached", "workling", "known_hosts", "passenger", "imagemagick", 
        "rails-deployment", "deployment" # rails-deployment really needs to happen last

