#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-26 21:46:43
 # @LastEditors: robert zhang
# @Description: 初始化执行脚本
# @
###
# 申请环境时执行的初始化脚本
# $1:应用名称
# $2:公共环境--环境类型

APP_NAME=$1
ENV_TYPE=$2

source $HOME/env_script/commons

# 停服务
kill_ws
# 清理环境
clear_env

exit 0
