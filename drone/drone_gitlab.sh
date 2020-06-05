#!/bin/bash

docker run \
      --volume=/var/lib/drone:/data \
        --env=DRONE_GITLAB_SERVER="http://gitlab.robertzwj.com" \
          --env=DRONE_GITLAB_CLIENT_ID="31ad422ae7b9e8bf48edcfefe066e84da58421d703867968dfeff5044d7cf1af" \
            --env=DRONE_GITLAB_CLIENT_SECRET="4391feea87743c7600eff48988af8f533eb80f0bf77b20aa4ae3f22ec5071b3b" \
                --env=DRONE_SERVER_HOST="drone.robertzwj.com" \
                --env=DRONE_GIT_ALWAYS_AUTH=true \
                --env=DRONE_RPC_SECRET="dd3c999d207d0a025d87c4f13066a4b2" \
                --env=DRONE_USER_CREATE="username:root,admin:true" \
                  --env=DRONE_SERVER_PROTO=http \
                    --publish=4080:80 \
                      --publish=4443:443 \
                        --restart=always \
                          --detach=true \
                            --name=drone \
                              drone/drone
