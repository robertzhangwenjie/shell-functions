#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2020-09-02 10:54:22
 # @LastEditTime: 2020-09-02 10:55:08
 # @LastEditors: robert zhang
 # @Description: 打印日志
 # @
### 

# 打印INFO级别日志
log_info() {
  echo -e "$(date +"%Y-%m-%d %H:%M:%S") [INFO] $1"
}

# 打印WARNING级别日志
log_warning() {
  echo -e "$(date +"%Y-%m-%d %H:%M:%S") \033[33m[WARNING]\033[0m" $1
}

# 打印错误日志
log_error() {
  echo -e "$(date +"%Y-%m-%d %H:%M:%S") \033[31m[ERROR]\033[0m" $1
}
