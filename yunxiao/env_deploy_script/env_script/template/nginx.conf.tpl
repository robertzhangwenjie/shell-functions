server {
  server_name ${ENV_TYPE,,}.${APP_NAME}.${COMPANY:-com};
  listen ${PORT};

  access_log ${HOME}/nginx_logs/access.log main;
  error_log ${HOME}/nginx_logs/error.log;

  location / {
    root ${HOME}/${APP_NAME};
  }
}