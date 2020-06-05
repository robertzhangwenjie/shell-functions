#!/bin/bash

docker run \
      --volume=/var/lib/drone_github:/data \
        --env=DRONE_GITHUB_SERVER="https://github.com" \
          --env=DRONE_GITHUB_CLIENT_ID="e3751ea51674d1ceb3f5" \
            --env=DRONE_GITHUB_CLIENT_SECRET="75dbe591c596cca907d5cbc7f2cd4b6f21663a9b" \
                --env=DRONE_SERVER_HOST="drone.robertzwj.com" \
                --env=DRONE_GIT_ALWAYS_AUTH=true \
                --env=DRONE_RPC_SECRET="dd3c999d207d0a025d87c4f13066a4b2" \
                --env=DRONE_USER_CREATE="username:robertzhangwenjie,admin:true" \
                  --env=DRONE_SERVER_PROTO=http \
                    --publish=4080:80 \
                      --publish=4443:443 \
                        --restart=always \
                          --detach=true \
                            --name=drone \
                              drone/drone
