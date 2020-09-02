#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-09-01 20:18:06
 # @LastEditTime: 2020-09-02 12:11:24
 # @LastEditors: robert zhang
# @Description: nodejs_docker 部署脚本
# @
###

#!/bin/bash

#设置环境变量
export NodeHome=/usr/install/node-v12.18.1
export PATH=$PATH:$NodeHome/bin

# 获取代码后，进入应用目录
cd ${appName}
# 安装依赖
npm install
# 获取最新的commitId
commitId=$(git rev-parse --short HEAD)
# 设置镜像信息
image_host="hub.docker.com"
imageName="${image_host}/zhangwenjie/${appName}:${commitId}"
# 构建镜像
docker build -t ${imageName} .

# 推送镜像
docker login --username=${username} --password=${password} ${image_host}
docker push ${imageName}

# 设置参数
packageName="imageName=${imageName}"

# 上传镜像地址
curl -X POST -F "${packageName}" -F "crid=${crid}" -F "compileId=${compileId}" -F "appName=${appName}" http://package.switch.aliyun.com:9090/callBack
