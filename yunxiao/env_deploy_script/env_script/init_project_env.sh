#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-27 21:43:29
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

# 清理环境
clean_env

exit 0
