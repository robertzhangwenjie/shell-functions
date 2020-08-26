#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2020-08-25 11:34:37
 # @LastEditTime: 2020-08-26 00:13:59
 # @LastEditors: robert zhang
 # @Description: 初始化账号配置,需要root权限
 # @  
### 

# 需要先将脚本存放到package.switch服务器上
# 如果不支持拷贝，可以使用curl命令上传 
# 例如 curl -X POST -F warName=@env_script.zip -F crid=0  -F appName=yunxiao -F buildNum=1 -F compileId=1 http://package.switch.aliyun.com:9090/upload
# 云效用户组
YUNXIAO_GOURP=yunxiao
ENV_SCRIPT_URL="http://package.switch.aliyun.com:8088/upload/env_script.zip"
ENV_SCRIPT="/root/env_script.zip"

# 下载env_scropt脚本包
get_env_script() {
  wget -nv -O ${ENV_SCRIPT} ${ENV_SCRIPT_URL}
}

# 添加sudo组，并设置sudo权限
add_sudo_group() {
  groupadd ${YUNXIAO_GOURP} >/dev/null 2>&1
  # 设置yunxiao用户组拥有sudo权限，在执行docker命令时不需要密码
  local add_group_cfg="%${YUNXIAO_GROUP:-yunxiao} ALL=(ALL) NOPASSWD:/usr/bin/docker"
  local add_env_cfg='Defaults env_keep += "PATH"'
  grep "^$add_group_cfg" /etc/sudoers > /dev/null
  [ $? -eq 1 ] && echo "$add_group_cfg" >> /etc/sudoers
  # 设置执行sudo权限时保留环境变量PATH
  grep "^$add_env_cfg" /etc/sudoers > /dev/null
  [ $? -eq 1 ] && echo "$add_env_cfg" >> /etc/sudoers
}

# 添加脚本到用户家目录
install_env_script() {
   local username=$1
   cp $ENV_SCRIPT /home/$username/ 
   chown $1:$1 -R /home/$username/
   echo "install $ENV_SCRIPT to /home/$username successfully"
   for filename in `ls /home/$username`;do
      [ "${filename}" == "env_script.zip" ] && yes| unzip $filename
  done
}

# 添加用户
add_user() {
  local username=$1
  useradd $username -p $username -G ${YUNXIAO_GOURP}
  install_env_script $username
  echo "useradd $username successfully"
}

# 获取脚本
get_env_script
# 添加sudo执行权限组
add_sudo_group
# 添加用户，并copy脚本到对应家目录下
add_user $1