#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-28 14:19:05
 # @LastEditors: robert zhang
 # @Description: 
 # @
### 
# 这个脚本用于分支搭建流程
# $1:搭建环境的Id（必须）
# $1：搭建的环境名（必须）
# $2: 项目的CRID（必须）
# $3：环境类型（必须）
# $4：TAR包地址

source $HOME/env_script/commons

# 获取当前文件的绝对路径
COMMONS_PATH=$(
  cd $(dirname $0)
  pwd
)

APP_NAME=$1
CRID=$2
ENV_TYPE=$3
TAR_ADDRESS=$4
NEED_RESTORE=$5
DEPLOY_ID=$6

# INT -- CTRL + C
# TERM 要求程序正常退出
trap 'cancel_deploy;killAllChildren' INT TERM

# 获取配置项的api
GET_ANTX_PROPERTIES_URL="https://devops.linewellcloud.com/aenv-config/api/export/exportAntxProperties"
PID_FILE=$HOME/${APP_NAME}.pid
WORK_DIR=$HOME
CHECK_URL=""
RESTORE_FILE=last_deploy_cmd.sh
RESTORE_FILE_PATH=$HOME/${RESTORE_FILE}
USER=$(whoami)
PORT=$(whoami)

# 用来查找pid的字符串
PID_FIND_STR=""

# nginx相关全局变量
NGINX_HOME=/usr/install/nginx
NGINX_CONFIG_DIR=$NGINX_HOME/conf/conf.d
NGINX_TEMPLATE_PATH=$COMMONS_PATH/template
NGINX_CONF=${APP_NAME}-${ENV_TYPE}-${USER}.conf
NGINX_CMD=${NGINX_HOME}/sbin/nginx
rpm -ql nginx >/dev/null 2>&1

if [ $? -eq 0 ]; then
  NGINX_HOME=/etc/nginx
  NGINX_CONFIG_DIR=${NGINX_HOME}/conf.d
  NGINX_CMD=nginx
fi

# java相关变量
if [ -z "$JAVA_HOME" ]; then
  export JAVA_HOME=/usr/install/java8
  export PATH=$JAVA_HOME/bin:$PATH
  export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
fi

# 获取tomcat版本
TOMCAT_VERSION="apache-tomcat-7.0.54"
TOMCAT_HOME="/home/${USER}/${TOMCAT_VERSION}"
TOMCAT_DOWNLOAD_URL="http://package.switch.aliyun.com:8088/upload/tools/${TOMCAT_VERSION}.zip"
TOMCAT_PATH="/usr/install"


# 清理环境
do_it clean_env

# 获取当前环境的部署配置项
do_it get_project_antx_properties

# 启动环境，开始部署
do_it start_env

# 创建pid文件
do_it createPIDfile

# 检查部署是否成功
do_it check_deploy_status

# 部署成功，记录本次部署命令
echo "$SUDO_COMMAND" > $RESTORE_FILE_PATH
log_info "部署成功"
exit 0
