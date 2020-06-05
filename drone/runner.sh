#!/bin/bash
docker run -d \
      -v /var/run/docker.sock:/var/run/docker.sock \
        -e DRONE_RPC_PROTO=http \
          -e DRONE_RPC_HOST=drone.robertzwj.com \
            -e DRONE_RPC_SECRET="dd3c999d207d0a025d87c4f13066a4b2" \
              -e DRONE_RUNNER_CAPACITY=2 \
                -e DRONE_RUNNER_NAME=aliyun \
                -p 3000:3000 \
                  --restart always \
                    --name runner \
                      drone/drone-runner-docker
