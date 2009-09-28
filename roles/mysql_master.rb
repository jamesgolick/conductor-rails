name "mysql_master"
description "Master mysql servers"
recipes "logrotate", "mysql::server"
        
