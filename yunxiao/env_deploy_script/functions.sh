#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-08-27 09:36:23
 # @LastEditTime: 2020-08-28 14:27:48
 # @LastEditors: robert zhang
# @Description: 部署脚本公共函数
# @
###
source /etc/rc.d/init.d/functions

log_info() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO] $1"
}

log_warning() {
  echo -e "$(date +"%Y-%m-%d %H:%M:%S") \033[33m[WARNING]\033[0m" $1
}

log_error() {
  echo -e "$(date +"%Y-%m-%d %H:%M:%S") \033[31m[ERROR]\033[0m" $1
}

# 执行语句并打印失败或成功
do_it() {
  local execute_cmd=$@
  local ret=$($execute_cmd)
  local isSuccess=$?
  if [ $isSuccess -eq 0 ]; then
    action "$execute_cmd" /bin/true
    echo $ret
    return 0
  else
    action "$execute_cmd" /bin/false
    echo $ret
    return 1
  fi
}
