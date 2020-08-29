#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-29 20:28:22
 # @LastEditors: robert zhang
# @Description: 初始化执行脚本
# @
###
# 申请环境时执行的初始化脚本
# $1:应用名称
# $2:公共环境--环境类型

source $HOME/env_script/commons

APP_NAME=$1
ENV_TYPE=$2
#根据agent的日志配置项决定
LOG_DIR=logs

# 清理环境
clean_env

# 创建log目录
[ -d "$LOG_DIR" ] && rm -rf $LOG_DIR/*

mkdir $LOG_DIR

exit 0
