name "mysql_master"
description "Master mysql servers"
recipes "vim", "dotfiles", "logrotate", "mysql::server",
        "ncurses-term", "ebs_snapshots", "nagios::nrpe-server"
