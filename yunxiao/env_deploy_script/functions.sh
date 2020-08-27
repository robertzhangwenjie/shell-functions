#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2020-08-27 09:36:23
 # @LastEditTime: 2020-08-27 09:57:10
 # @LastEditors: robert zhang
 # @Description: 部署脚本公共函数
 # @
### 
source /etc/rc.d/init.d/functions

# 执行语句并打印失败或成功
do_it() {
  local execute_cmd=$@
  eval $execute_cmd

  local isSuccess=$?
  if [ $isSuccess -eq 0 ];then
    action "$execute_cmd"  /bin/true
    return 0
  else
    action "$execute_cmd"  /bin/false
    return 1
  fi
}