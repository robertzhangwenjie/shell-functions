#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-08-28 09:19:42
 # @LastEditors: robert zhang
# @Description:
# @
###
# 环境一键部署脚本
# 传递参数案例：
#  自有环境部署spring-demo 5 FUNC upload/.../SNAPSHOT.jar no 15 1
#  公共环境部署spring-demo trunk PUBLIC-AUTO upload/.../SNAPSHOT.jar yes 18 1
# $1: 部署应用的名称
# $2：项目的ID(自有环境)|分支类型(公共环境)
# $3：环境类型别名（'FUNC':自有,'PUBLIC'公共功能,"PUBLIC-AUTO":公共自动化,'FIXATION':固定）
# $4：部署包地址
# $5  部署失败是否需要恢复上一版本，公共环境默认为true，其它为false，因为公共环境需要提供稳定的服务
# $6：应用部署的ID

source ${HOME}/env_script/commons

APP_NAME=$1
CRID=$2
ENV_TYPE=$3
TAR_ADDRESS=$4
NEED_RESTORE=$5
DEPLOY_ID=$6

ENV_SCRIPT_PATH="$HOME/env_script"
ENV_SCRIPT_URL="http://package.switch.aliyun.com:8088/upload/0/yunxiao/ATON_INTEGRATION/1/1/env_script.zip"


update_env_script() {
  cd ${HOME}
  log_info "starting update env_script"
  log_info "clearing env_script"
  do_it rm -rf env_script

  # 下载到指定目录
  log_info "Try download env_script"
  wget -nv ${ENV_SCRIPT_URL}
  local download=$?
  if [ ! $download -eq 0 ]; then
    log_warning "下载失败，尝试拷贝/root/env_script.zip"
    sudo cp -f /root/env_script.zip $HOME
    if [ $? -eq 0 ]; then
      log_info "拷贝成功，开始解压$ENV_SCRIPT_PATH"
      do_it unzip -o env_script.zip
    else
      log_info "拷贝失败"
    fi
  else
    do_it unzip -o env_script.zip
  fi

  # 解压并赋权
  log_info "unzip env_script successful"
  chown -R ${USER}:${USER} /home/${USER}
  log_info "update env_script done"
}

# 检查应用名
if [ "x$APP_NAME" = "x" ]; then
  log_error "appName should not be empty"
  exit 1
fi

# 检查项目CRID
if [ "x$CRID" = "x" ]; then
  log_error "CRID should not be empty"
  exit 1
fi

# 检查配置项类型
if [ "x$ENV_TYPE" = "x" ]; then
  ENV_TYPE="FUNC"
fi

# 检查部署包是否传递
if [ -z ${TAR_ADDRESS} ]; then
  echo -n -e "\e[0;32;1mDeployPackage should not be empty\e[0m"
  exit 1
fi

# 更新部署脚本
log_info "starting update_env_script"
update_env_script

#项目环境部署，必要参数：$APP_NAME $CRID
$ENV_SCRIPT_PATH/env_deploy_flow.sh $APP_NAME $CRID $ENV_TYPE $TAR_ADDRESS $NEED_RESTORE $DEPLOY_ID
