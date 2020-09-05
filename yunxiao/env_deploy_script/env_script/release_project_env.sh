#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-09-05 14:09:18
 # @LastEditors: robert zhang
 # @Description: 释放环境脚本
 # @
### 
# 这个脚本用于释放部署的应用
# $1: 应用名
# $2：项目的CRID, 如果是公共环境则是trunk
# $3: 环境类型

source "$HOME/env_script/functions"

export APP_NAME=$1
export CRID=$2

if [ -z "$APP_NAME" ]; then 
  log_error "释放失败，缺少参数：appName"
  exit 1 
fi

# 释放环境
clean_env

exit 0
