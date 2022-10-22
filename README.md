# README

# nginx
sudo service vi /etc/nginx/conf.d/blog.conf

```bash
upstream puma {
  server unix:///var/www/rails_app/shared/tmp/sockets/puma.sock;
}

server {
  listen 80 ;
  root /var/www/rails_app/current/public;
  server_name 3.236.93.123;
  client_max_body_size 50M;

  #access_log /var/log/nginx/{{ nginx_server_name }}.access.log nginx-custom;
  #error_log /var/log/nginx/{{ nginx_server_name }}.error.log;

  try_files $uri/index.html $uri @puma;

  location @puma {
    proxy_redirect     off;
    proxy_set_header   Host             $host;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_read_timeout 10000;

    proxy_pass http://puma;
  }

  location /healthcheck {
    try_files $uri @puma;
    auth_basic      off;
  }

  error_page 500 502 503 504 /500.html;
  keepalive_timeout 10;

  location ~* ^.+\.(jpg|jpeg|gif|css|png|js|ico)$ {
    expires 1h;
  }
}
```

# puma
sudo vi /etc/systemd/system/puma.service
```ruby
WorkingDirectory=/var/www/rails_app/current

ExecStart=/home/deploy/.rbenv/shims/bundle exec puma -e production -C /var/www/rails_app/shared/config/puma.rb
PIDFile= /var/www/rails_app/shared/tmp/pids/puma.pid
Restart=always
Type=simple
User=deploy
Group=deploy
```

# reload
```bash
sudo systemctl daemon-reload
sudo service puma restart
sudo service nginx restart
```