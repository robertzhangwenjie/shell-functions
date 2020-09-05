#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-08-25 11:34:37
 # @LastEditTime: 2020-09-05 18:34:56
 # @LastEditors: robert zhang
# @Description: 初始化账号配置,需要root权限
# @
###

#---help---
#
# USAGE:
#   $SCRIPTPATH [options] [all] | [user1 user2 ...]
#
# OPTIONS:
#   -h                Show this help message and exit.
#
# Example:
#   # Add all the users in system
#     $SCRIPTPATH all
#
#   # Add user 1080 2080
#     $SCRIPTPATH 1080 2080       
#
# Please report bugs at <https://github.com/robertzhangwenjie/shell-functions/issues>.
#---help---

# 获取当前文件的绝对路径
readonly WORK_PATH=$(
  cd "$(dirname "$0")" || exit
  pwd
)
export SCRIPTPATH=$0

source "${WORK_PATH}/env_script/functions"
source "${WORK_PATH}/env_script/conf/env.cfg"


UPLOAD_URL="http://package.switch.aliyun.com:9090/upload"
DOWNLOAD_URL="http://package.switch.aliyun.com:8088"
ENV_SCRIPT="env_script.zip"
UPLOAD_SCRIPT="curl -X POST -F warName=@${ENV_SCRIPT} -F crid=0  -F appName=yunxiao -F buildNum=1 -F compileId=1 ${UPLOAD_URL}"

# 安装依赖包
install_dependeces() {
  log_info "安装依赖: $*"
  # 判断是否有网
  if ! ping -w 3 www.baidu.com > /dev/null 2>&1;then
    log_error "无法访问外部网络，下载"$@"失败" && return 1
  fi
  do_it $PACKAGE_INSTALL_TOOL install -y $@
}

# 上传env_script
upload_env_script() {
  log_info "使用zip压缩目录：env_script"
  do_it chmod 755 -R env_script/*
  do_it zip -qr ${ENV_SCRIPT} env_script/*
  log_info "上传 ${ENV_SCRIPT}:$UPLOAD_SCRIPT"
  ENV_SCRIPT_ADDRESS=$(eval "${UPLOAD_SCRIPT}")

  if [ $? -eq 0 ]; then
    local response_code

    response_code=$($UPLOAD_SCRIPT | jq .status)
    if [ "$response_code" == "200" ]; then
      log_info "上传成功，下载地址：$ENV_SCRIPT_ADDRESS"
      return 0
    else
      log_warning "上传失败: $ENV_SCRIPT_ADDRESS"
      return 1
    fi
  else
    log_error "上传脚本到服务器失败"
    return 1
  fi
}

# 下载env_script脚本包
get_env_script() {
  upload_env_script
  if [ $? -eq 0 ]; then
    log_info "downloading ${DOWNLOAD_URL}/${ENV_SCRIPT_ADDRESS}"
    wget -nv -O "${HOME}"/${ENV_SCRIPT} ${DOWNLOAD_URL}/"${ENV_SCRIPT_ADDRESS}"

    [ ! $? -eq 0 ] && log_info "download ${ENV_SCRIPT_ADDRESS} failed"
    log_info "downloaded ${ENV_SCRIPT} to ${HOME} successful"
  else
    log_info "复制${ENV_SCRIPT} 到 ${HOME}"
    cp "${WORK_PATH}"/$ENV_SCRIPT "${HOME}"
  fi
}

# 添加sudo权限
add_sudo_cfg() {
  local sudo_cfg="$*"
  grep "^$sudo_cfg" /etc/sudoers >/dev/null 2>&1
  local isCfgExist=$?

  # 判断是否拥有sudo权限，如果没有就添加
  if [ $isCfgExist -eq 0 ]; then
    log_info "add sudo cfg success: $sudo_cfg"
  else
    echo "$sudo_cfg" >>/etc/sudoers &&
      log_info "add sudo cfg success: $sudo_cfg" ||
      log_error "add sudo cfg failed: $sudo_cfg"
  fi
}

# 注释掉sudo配置项
del_sudo_cfg() {
  # 匹配不以#开头的配置项，然后添加#
  log_info "注释掉$1所在的行"
  sed -i "s/^[^#].*$1$/#&/g" /etc/sudoers

}

# 添加用户组，并设置sudo权限
add_sudo_group() {

  # 禁用"!"功能
  set +H

  log_info "添加用户组"
  if ! grep "^${YUNXIAO_GROUP}" /etc/group >/dev/null; then
    do_it groupadd ${YUNXIAO_GROUP}
  else
    log_warning "用户组已存在:${YUNXIAO_GROUP}"
  fi

  log_info "设置sudo权限"
  # 添加sudo账户的权限
  local add_group_cfg="%${YUNXIAO_GROUP} ALL=(ALL) NOPASSWD:/usr/bin/docker,/bin/cp,/usr/sbin/nginx,/usr/bin/netstat,/usr/bin/ss"
  # 传递换进变量到sudo账户
  local add_env_cfg='Defaults env_keep += "PATH"'
  # tty设置,适合sudo-1.6.9-1.7.2
  local del_tty_cfg1='requiretty'
  # tty设置，适合sudo-1.7.2+
  local add_tty_cfg='Defaults visiblepw'
  local del_tty_cfg2='!visiblepw'

  add_sudo_cfg "$add_group_cfg"
  add_sudo_cfg "$add_env_cfg"
  add_sudo_cfg "$add_tty_cfg"
  del_sudo_cfg "$del_tty_cfg1"
  del_sudo_cfg "$del_tty_cfg2"

  # 还原"!"执行历史功能
  set -H
}

# 添加脚本到用户家目录
install_env_script() {

  local username=$1
  log_info "复制${ENV_SCRIPT} 到 /home/${username}"
  do_it /bin/cp -rf "/root/$ENV_SCRIPT" "/home/$username"
  # 删除老的目录
  do_it rm -rf "/home/$username/env_script"
  # 重新解压
  do_it unzip -o -d "/home/$username" "/home/$username/$ENV_SCRIPT"
  # 授权
  do_it chown $username:$username -R "/home/$username"
}

# 添加用户
add_user() {
  local username=$1
  log_info "添加用户${username}"
  id -u ${username} >/dev/null
  if [ $? -eq 0 ]; then
    log_warning "${username}用户已存在，将其添加到group:${YUNXIAO_GROUP}"
    usermod -a -G ${YUNXIAO_GROUP} ${username}
  else
    do_it useradd -m $username -p $username -G ${YUNXIAO_GROUP}
  fi
  install_env_script $username
}

add_all_user() {
  users=$(ls /home)
  for user in $users; do
    add_user "$user"
  done
}

# 打印帮助信息
print_help() {
  sed -En '/^#---help---/,/^#---help---/p' "$SCRIPTPATH" | sed -E 's/^# ?//; 1d;$d;' | envsubst
}

# 初始化系统
init_server() {
  # esh模板引擎
  log_info "安装esh模板引擎"
  esh_path="${WORK_PATH}/env_script/commons/esh"
  do_it chmod a+x "$esh_path"
  do_it cp "$esh_path" /usr/bin/

  # 安装依赖
  install_dependeces git unzip zip jq
  # 获取部署脚本
  get_env_script
  # 添加sudo执行权限组
  add_sudo_group
  # 添加nginx配置权限
  log_info "添加nginx配置目录写入权限"
  do_it chmod -R 770 "${NGINX_CONFIG_DIR:?}"
  do_it chown -R root:${YUNXIAO_GROUP:?} "$NGINX_CONFIG_DIR"
}

cd "${WORK_PATH}"  || exit

if [ -n "$1" ]; then
  case $1 in
  all)
    init_server
    users=$(ls /home)
    for user in $users; do
      add_user "$user"
    done
    ;;
  -h)
    print_help
    ;;
  *)
    init_server
    add_user "$1"
    ;;
  esac
else
  print_help
fi

