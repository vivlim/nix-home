{ pkgs, system, channels, ... }: {
  systemd.user.services.nginx-webdav-notes = let
  config = pkgs.writeText "nginx-webdav-config" ''
    daemon off;
    pid $tmp_dir/nginx.pid;
    events {
      worker_connections 1024;
    }
    http {
      dav_ext_lock_zone zone=notesdav:5m;
      server {
        listen 4121 default_server;
        listen 4122 ssl default_server; # 4=D 1=A 22=V
        listen [::]:4122 ssl default_server;

        ssl_certificate $SSL_CERT;
        ssl_certificate_key $SSL_KEY;

        access_log $tmp_dir/access.log;
        client_body_temp_path $tmp_dir/client_body_temp;
        fastcgi_temp_path $tmp_dir/fastcgi_temp;
        proxy_temp_path $tmp_dir/proxy_temp;
        scgi_temp_path $tmp_dir/scgi_temp;
        uwsgi_temp_path $tmp_dir/uwsgi_temp;

        location / {
          if ($request_method = 'OPTIONS'){
            add_header 'Access-Control-Allow-Origin' '$ALLOWED_ORIGIN' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, MKCOL, COPY, MOVE, PROPFIND, OPTIONS' always;
            add_header 'Access-Control-Allow-Headers' 'Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization,X-CSRF-Token,Depth' always;
            add_header 'Access-Control-Allow-Credentials' 'true' always;
            return 204;
          }

          root                  $HOME/notes;

          # macos: enable creating directories without trailing slash
          set $x $uri$request_method;
          if ($x ~ [^/]MKCOL$) {
              rewrite ^(.*)$ $1/;
          }

          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS LOCK UNLOCK;
          dav_ext_lock zone=notesdav;

          create_full_put_path  on;
          dav_access            group:rw  all:r;
          
          autoindex on;

          #allow 127.0.0.1;
          #deny all;

          #limit_except GET {
          #    allow 192.168.1.0/32;
          #    deny  all;
          #}

          add_header 'Access-Control-Allow-Origin' '$ALLOWED_ORIGIN' always;
          add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, MKCOL, COPY, MOVE, PROPFIND, OPTIONS' always;
          add_header 'Access-Control-Allow-Headers' 'Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization,X-CSRF-Token,Depth' always;
          add_header 'Access-Control-Allow-Credentials' 'true' always;


          auth_basic "webbed site";
          auth_basic_user_file $HTPASS;
        }
      }
    }
  '';
  startScript = pkgs.writeShellScript "start-nginx-webdav.sh" ''
    export ALLOWED_ORIGIN="https://organice.200ok.ch"
    export HTPASS=$HOME/.htpass-nginx-webdav
    if [ ! -f "$HTPASS" ]; then
      USER=$(whoami)
      NEW_PASS=$(${pkgs.xkcdpass}/bin/xkcdpass -n 9 -d -)

      echo "$USER:$NEW_PASS" > "$HTPASS.plaintext.delete.this"

      echo "$NEW_PASS" | ${pkgs.apacheHttpd}/bin/htpasswd -c -i "$HTPASS" "$USER"
      
      echo "generated a webdav password, see $HTPASS.plaintext.delete.this (and then delete it)"
    fi

    mkdir -p ~/.tmp
    export tmp_dir=$(mktemp -d -p ~/.tmp nginx-webdav.XXXXXXXX)
    echo "using tmp_dir: $tmp_dir"

    if [[ -f "$HOME/.nginx-webdav-ssl.crt" && "$HOME/.nginx-webdav-ssl.key" ]]; then
      export SSL_CERT="$HOME/.nginx-webdav-ssl.crt"
      export SSL_KEY="$HOME/.nginx-webdav-ssl.key"
      echo "use $SSL_CERT and $SSL_KEY"
    else
      echo "generate ephemeral ssl certs"
      ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $tmp_dir/selfsigned.key -out $tmp_dir/selfsigned.crt -subj "/C=US/O=viv ephemeral selfsigned cert/CN=localhost"
      export SSL_CERT="$tmp_dir/selfsigned.crt"
      export SSL_KEY="$tmp_dir/selfsigned.key"
    fi


    echo "patch config file to inject environment vars"
    # only the vars specified below will be injected
    ${pkgs.gettext}/bin/envsubst \$tmp_dir,\$HTPASS,\$HOME,\$ALLOWED_ORIGIN,\$SSL_CERT,\$SSL_KEY < ${config} > $tmp_dir/nginx.cfg

    ${pkgs.nginx}/bin/nginx -c $tmp_dir/nginx.cfg -e stderr -p $tmp_dir
  '';
  in {
    Unit = {
      Description = "Run a webdav server for ~/notes as a user";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {       
      ExecStart = "${startScript}";
    };
  };
}
