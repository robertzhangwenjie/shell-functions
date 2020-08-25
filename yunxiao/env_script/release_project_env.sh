#!/bin/bash
# 这个脚本用于释放部署的应用
# $1: 应用名
# $2：项目的CRID, 如果是公共环境则是trunk
# $3: 环境类型

appName=$1
projectCrid=$2
typeUse=$3

cd $HOME
source $HOME/env_script/commons

project_env_source $ENV_NAME

if [ $appName ] && [ $typeUse ]; then 
      echo "do nothing" > out.log
else
      echo "kill ws" > out.log
      # 停服务
      kill_ws
      # 清理环境
      clear_env
fi
exit 0
