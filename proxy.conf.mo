server_tokens off;
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;

server {
    listen 443 ssl default deferred;
    server_name {{HOSTNAME}};

    ssl_certificate /etc/ssl/private/certificate.crt;
    ssl_certificate_key /etc/ssl/private/certificate.key;

    ssl_protocols TLSv1.2;
    ssl_session_cache shared:SSL:10m;

    ssl_prefer_server_ciphers on;
    ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;
    ssl_dhparam /etc/ssl/private/dhparam.pem;
   
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    location / {
      proxy_set_header HOST $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_pass http://upstream;
      proxy_read_timeout 90;

      proxy_redirect http://upstream https://{{HOSTNAME}};
    }
}

server {
    listen 80;
    server_name {{HOSTNAME}};
    return 301 https://$host$request_uri;
}
