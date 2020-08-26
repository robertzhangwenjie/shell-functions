#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-26 22:40:00
 # @LastEditors: robert zhang
 # @Description: 
 # @
### 
# 这个脚本用于分支搭建流程
# $1:搭建环境的Id（必须）
# $1：搭建的环境名（必须）
# $2: 项目的CRID（必须）
# $3：环境类型（必须）
# $4：TAR包地址
APP_NAME=$1
CRID=$2
ENV_TYPE=$3
TAR_ADDRESS=$4
NEED_RESTORE=$5
DEPLOY_ID=$6

source $HOME/env_script/commons

# 清理环境
kill_ws
clear_env

# 获取当前环境的部署配置项
get_project_antx_properties

# 启动环境，开始部署
start_env
# 创建pid文件
createPIDfile

# 检查部署是否成功
after_check

# 部署成功，记录本次部署命令
echo "$SUDO_COMMAND" > $RESTORE_FILE_PATH
log_info "部署成功"
exit 0
