server {
  server_name ${ENV_TYPE,,}.${APP_NAME}.${COMPANY:-com};
  listen ${PORT};

  access_log ${APP_LOG} main;

  location / {
    root ${HOME}/${APP_NAME};
  }
}