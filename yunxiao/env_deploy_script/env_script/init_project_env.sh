#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-09-05 14:08:51
 # @LastEditors: robert zhang
# @Description: 初始化执行脚本
# @
###
# 申请环境时执行的初始化脚本
# $1:应用名称
# $2:公共环境--环境类型

source "$HOME/env_script/functions"

export APP_NAME=$1
export ENV_TYPE=$2
#根据agent的日志配置项决定
LOG_DIR=logs

# 清理环境
clean_env

# 清空log目录
[ -d "$LOG_DIR" ] && rm -rf "${LOG_DIR:?}/*"

mkdir $LOG_DIR

exit 0
