server {
  server_name ${ENV_TYPE,,}.${APP_NAME}.${COMPANY:-com};
  listen ${PORT};

  location / {
    root ${HOME}/${APP_NAME};
  }
}