#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-27 21:44:17
 # @LastEditors: robert zhang
 # @Description: 
 # @
### 
# 这个脚本用于释放部署的应用
# $1: 应用名
# $2：项目的CRID, 如果是公共环境则是trunk
# $3: 环境类型

APP_NAME=$1
CRID=$2

source $HOME/env_script/commons

if [ -z $APP_NAME ]; then 
  echo "释放失败，缺少参数：appName"
  exit 1 
fi

# 释放环境
clear_env

exit 0
