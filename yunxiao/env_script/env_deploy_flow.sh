#!/bin/bash
# 这个脚本用于分支搭建流程
# $1:搭建环境的Id（必须）
# $1：搭建的环境名（必须）
# $2: 项目的CRID（必须）
# $3：环境类型（必须）
# $4：TAR包地址
ENV_NAME=$1
CRID=$2
ENV_TYPE=$3
TAR_ADDRESS=$4
NEED_RESTORE=$5

cd $HOME
source $HOME/env_script/commons

# 判断程序是否正在运行
if checkPIDfile ; then
  local pid=`<"$LOCK_FILE" `
  kill -9 pid
else 
  # 如果应用没有运行，则创建pid文件
  createPIDfile $$
fi

# 清理除env_script目录外的所有文件
clear_env

# 重置配置项，环境申请默认会有配置项，将配置项设置为环境变量
set_project_antx_properties
# 启动环境，开始部署
start_env
# 检查部署是否成功
after_check

exit 0
