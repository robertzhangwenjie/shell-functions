server {
  server_name ${ENV_TYPE,,}.${APP_NAME}.${COMPANY:-com};
  listen ${PORT};

  access_log ${APP_LOG} main;

  location / {
    root ${HOME}/${APP_NAME};
  }

  location ${location} {
    proxy_set_header Host '$host';
    proxy_redirect off;
    proxy_pass http://${backend_url};
  }

  location ~ .*\.(js|css|ico|png|jpg|eot|svg|ttf|woff|html) {
    root ${HOME}/${APP_NAME};
  }
}