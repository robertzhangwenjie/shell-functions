#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-11-01 21:38:15
 # @LastEditors: robert zhang
# @Description: 初始化执行脚本
# @
###
# 申请环境时执行的初始化脚本
# $1:应用名称
# $2:公共环境--环境类型

source "$HOME/env_script/functions"
source "$HOME/env_script/conf/env.cfg"

export APP_NAME=$1
export ENV_TYPE=$2

if [ -z "$APP_NAME" ]; then 
  log_error "清理失败，缺少参数：appName"
  exit 1 
fi

if [ -z "$ENV_TYPE" ]; then 
  log_error "清理失败，缺少参数：envTypeAlias"
  exit 1 
fi

# 清理环境
clean_env

log_info "创建日志目录:$LOG_DIR"
if [ -d "$LOG_DIR" ] && [ "$LOG_DIR" != "/" ]; then
  do_it rm -rf ${LOG_DIR:?}/*
else
  do_it mkdir $LOG_DIR
fi

exit 0
