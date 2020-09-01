#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-08-25 11:34:37
 # @LastEditTime: 2020-09-01 16:06:33
 # @LastEditors: robert zhang
# @Description: 初始化账号配置,需要root权限
# @
###

# 获取当前文件的绝对路径
WORK_PATH=$(
  cd $(dirname $0)
  pwd
)

source $WORK_PATH/env_script/commons

YUNXIAO_GOURP=yunxiao
UPLOAD_URL="http://package.switch.aliyun.com:9090/upload"
DOWNLOAD_URL="http://package.switch.aliyun.com:8088"
ENV_SCRIPT="env_script.zip"
UPLOAD_SCRIPT="curl -X POST -F warName=@${ENV_SCRIPT} -F crid=0  -F appName=yunxiao -F buildNum=1 -F compileId=1 ${UPLOAD_URL}"

# 安装依赖包
install_dependeces() {
  yum install -y git unzip zip jq
}

# 上传env_script
upload_env_script() {
  log_info "压缩 env_script"
  chmod 755 -R env_script/*
  do_it zip -qr ${ENV_SCRIPT} env_script/*
  log_info "上传 ${ENV_SCRIPT}:$UPLOAD_SCRIPT"
  ENV_SCRIPT_ADDRESS=$(eval $UPLOAD_SCRIPT)

  if [ $? -eq 0 ]; then
    local response_code=$($UPLOAD_SCRIPT | jq .status)
    if [ "$response_code" == "200" ]; then
      log_info "上传成功，下载地址：$ENV_SCRIPT_ADDRESS"
      return 0
    else
      log_warning "上传失败: $ENV_SCRIPT_ADDRESS"
      return 1
    fi
  else
    log_warning "上传失败"
    return 1
  fi
}

# 下载env_script脚本包
get_env_script() {
  upload_env_script
  if [ $? -eq 0 ]; then
    log_info "downloading ${DOWNLOAD_URL}/${ENV_SCRIPT_ADDRESS}"
    wget -nv -O ${HOME}/${ENV_SCRIPT} ${DOWNLOAD_URL}/${ENV_SCRIPT_ADDRESS}

    [ ! $? -eq 0 ] && log_info "download ${ENV_SCRIPT_ADDRESS} failed"
    log_info "downloaded ${ENV_SCRIPT} to ${HOME} successful"
  else
    log_info "复制${ENV_SCRIPT} 到 ${HOME}"
    cp ${WORK_PATH}/$ENV_SCRIPT ${HOME}
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

# 注释掉配置项
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
  grep "^${YUNXIAO_GOURP}" /etc/group >/dev/null
  [ $? -ne 0 ] && do_it groupadd ${YUNXIAO_GOURP} || log_warning "用户组已存在:${YUNXIAO_GOURP}"

  log_info "设置sudo权限"
  # 添加sudo账户的权限
  local add_group_cfg="%${YUNXIAO_GROUP:-yunxiao} ALL=(ALL) NOPASSWD:/usr/bin/docker,/bin/cp,/usr/sbin/nginx,/usr/bin/netstat"
  # 传递换进变量到sudo账户
  local add_env_cfg='Defaults env_keep += "PATH"'
  # tty设置,适合sudo-1.6.9-1.7.2
  local del_tty_cfg1='requiretty'
  # tty设置，适合sudo-1.7.2+
  local add_tty_cfg='Defaults visiblepw'
  local del_tty_cfg2='!visiblepw'

  add_sudo_cfg $add_group_cfg
  add_sudo_cfg $add_env_cfg
  add_sudo_cfg $add_tty_cfg
  del_sudo_cfg $del_tty_cfg1
  del_sudo_cfg $del_tty_cfg2

  # 还原"!"执行历史功能
  set -H
}

# 添加脚本到用户家目录
install_env_script() {

  local username=$1
  log_info "复制${ENV_SCRIPT} 到 /home/${username}"
  do_it /bin/cp -rf /root/$ENV_SCRIPT /home/$username
  do_it unzip -o -d /home/$username /home/$username/$ENV_SCRIPT
  # 授权
  do_it chown $username:$username -R /home/$username
}

# 添加用户
add_user() {
  local username=$1
  log_info "添加用户${username}"
  id -u ${username} >/dev/null
  if [ $? -eq 0 ]; then
    log_info "用户已存在，将其添加到group:${YUNXIAO_GOURP}"
    usermod -a -G ${YUNXIAO_GOURP} ${username}
  else
    do_it useradd $username -p $username -G ${YUNXIAO_GOURP}
  fi
  install_env_script $username
}

cd $WORK_PATH

# 安装依赖
install_dependeces
# 获取脚本
get_env_script
# 添加sudo执行权限组
add_sudo_group
# 添加用户，并copy脚本到对应家目录下
if [ -n "$1" ]; then
  case $1 in
  all)
    users=$(ls /home)
    for user in $users; do
      add_user $user
    done
    ;;
  *)
    add_user $1
    ;;
  esac
fi
