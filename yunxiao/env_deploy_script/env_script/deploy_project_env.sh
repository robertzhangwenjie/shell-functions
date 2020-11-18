#!/bin/bash
###
# @Author: robert zhang
# @Date: 2019-09-02 12:23:30
 # @LastEditTime: 2020-11-01 21:48:01
 # @LastEditors: robert zhang
# @Description: 环境一键部署脚本
# @
###
# 传递参数案例：
#  自有环境部署spring-demo 5 FUNC upload/.../SNAPSHOT.jar no 15 1
#  公共环境部署spring-demo trunk PUBLIC-AUTO upload/.../SNAPSHOT.jar yes 18 1
# $1: 部署应用的名称
# $2：项目的ID(自有环境)|分支类型(公共环境)
# $3：环境类型别名（'FUNC':自有,'PUBLIC'公共功能,"PUBLIC-AUTO":公共自动化,'FIXATION':固定）
# $4：部署包地址
# $5  部署失败是否需要恢复上一版本，公共环境默认为true，其它为false，因为公共环境需要提供稳定的服务
# $6：应用部署的ID
# 获取当前文件的绝对路径

ENV_SCRIPT_PATH=$(
  cd $(dirname $0) || return
  pwd
)

export APP_NAME=$1
export CRID=$2
export ENV_TYPE=$3
export TAR_ADDRESS=$4
export NEED_RESTORE=$5
export DEPLOY_ID=$6
export CHECK_URL=$7

# 部署完成后等待时间
SLEEP_TIME=20

source "${ENV_SCRIPT_PATH}/functions"
source "${ENV_SCRIPT_PATH}/conf/env.cfg"

# INT -- CTRL + C
# TERM 要求程序正常退出
trap 'cancel_deploy;killAllChildren' INT TERM HUP

# 检查是否有传递CHECK_URL,如果传入的值是1，则表示为空
if [ "$CHECK_URL" == 1 ]; then
  CHECK_URL=""
fi

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
  log_error "envType should not be empty"
  exit 1
fi

# 检查部署包是否传递
if [ -z "${TAR_ADDRESS}" ]; then
  log_error "deployPackage cannot be empty"
  exit 1
fi

# 清理环境
clean_env

# 获取当前环境的部署配置项
get_project_antx_properties

# 启动环境，开始部署
start_env

# 创建pid文件
createPIDfile

log_info "等待${SLEEP_TIME}s检查部署状态"
sleep 20

# 检查部署状态
check_deploy_status

# 部署成功，记录本次部署命令
echo "$SUDO_COMMAND" > $RESTORE_FILE_PATH

# 获取应用日志
get_app_log

log_success "应用部署成功" 

# 打印内部访问地址
host_internal_ip=$(get_internal_ip) && log_info "内部访问地址:http://${host_internal_ip}:${PORT}"

exit 0
