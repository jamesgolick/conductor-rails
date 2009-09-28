define :mysql_user, :host => '%', :privileges => ["ALL"], :on => "*.*" do
  grant_statement = %{GRANT #{params[:privileges].join(', ')} 
                      ON #{params[:on]} 
                      TO '#{params[:name]}'@'#{params[:host]}'
                      IDENTIFIED BY '#{params[:password]}'}

  execute "Add mysql user #{params[:name]}" do
    command %{/usr/bin/mysql -uroot -e"#{grant_statement}"}
    not_if "mysql -u#{params[:name]} -p#{params[:password]} -e'show databases'"
  end
end

