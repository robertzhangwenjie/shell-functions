#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-08-25 11:34:37
 # @LastEditTime: 2020-08-27 22:06:48
 # @LastEditors: robert zhang
# @Description: 初始化账号配置,需要root权限
# @
###

YUNXIAO_GOURP=yunxiao
UPLOAD_URL="http://package.switch.aliyun.com:9090/upload"
DOWNLOAD_URL="http://package.switch.aliyun.com:8088"
ENV_SCRIPT="env_script.zip"
UPLOAD_SCRIPT="curl -X POST -F warName=@${ENV_SCRIPT} -F crid=0  -F appName=yunxiao -F buildNum=1 -F compileId=1 ${UPLOAD_URL}"

# 获取当前文件的绝对路径
WORK_PATH=$(
  cd $(dirname $0)
  pwd
)

source $WORK_PATH/functions.sh

# 上传env_script
upload_env_script() {
  log_info "压缩 env_script"
  chmod 755 -R env_script/*
  do_it zip -qr ${ENV_SCRIPT} env_script/*
  log_info "上传 ${ENV_SCRIPT}"
  ENV_SCRIPT_ADDRESS=`eval $UPLOAD_SCRIPT`
}

# 下载env_scropt脚本包
get_env_script() {
  log_info "downloading ${DOWNLOAD_URL}/${ENV_SCRIPT_ADDRESS}"
  wget -nv -P ${HOME} -O ${ENV_SCRIPT} ${DOWNLOAD_URL}/${ENV_SCRIPT_ADDRESS}
  [ ! $? -eq 0 ] && log_info "download ${ENV_SCRIPT_ADDRESS} failed"
  log_info "downloaded ${ENV_SCRIPT} successful"
}

# 添加sudo权限
add_sudo_cfg() {
  local sudo_cfg="$*"
  grep "^$sudo_cfg" /etc/sudoers >/dev/null 2>&1
  local isCfgExist=$?

  # 判断是否拥有sudo权限，如果没有就添加
  if [ $isCfgExist -eq 0 ]; then
    action "Add sudo cfg: $sudo_cfg" /bin/true
  else
    echo "$sudo_cfg" >>/etc/sudoers &&
      action "Add sudo cfg: $sudo_cfg" /bin/true ||
      action "Add sudo cfg: $sudo_cfg" /bin/false
  fi
}

# 添加sudo组，并设置sudo权限
add_sudo_group() {

  log_info "添加用户组"
  groupadd ${YUNXIAO_GOURP} >/dev/null 2>&1

  log_info "设置sudo权限"
  local add_group_cfg="%${YUNXIAO_GROUP:-yunxiao} ALL=(ALL) NOPASSWD:/usr/bin/docker,/bin/cp"
  local add_env_cfg='Defaults env_keep += "PATH"'

  add_sudo_cfg $add_group_cfg
  add_sudo_cfg $add_env_cfg

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
  do_it useradd $username -p $username -G ${YUNXIAO_GOURP}
  install_env_script $username
}

cd $WORK_PATH
# 上传脚本
upload_env_script
# 获取脚本
get_env_script
# 添加sudo执行权限组
add_sudo_group
# 添加用户，并copy脚本到对应家目录下
if [ -n "$1" ]; then
  add_user $1
fi
