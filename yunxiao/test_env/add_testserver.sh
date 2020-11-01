#!/bin/bash
###
# @Author: robert zhang
# @Date: 2020-10-29 14:42:30
 # @LastEditTime: 2020-11-01 20:19:32
 # @LastEditors: robert zhang
# @Description: 添加测试服务器脚本中的add_tag函数
# @symbol_custom_string_obkoro1:
###
#!/bin/bash

function add_tag() {
  SERVICE_URL=$1
  GROUP_ID=$2
  sn=''
  space=' '
  if [[ $(/usr/sbin/dmidecode -s system-serial-number) =~ $space ]]; then
    if [ "$(cat /usr/sbin/staragent_sn)" = '' ] || [[ $(cat /usr/sbin/staragent_sn) =~ $space ]]; then
      echo -e "$(cat /proc/sys/kernel/random/uuid)" >/usr/sbin/staragent_sn
    fi
    sn=$(cat /usr/sbin/staragent_sn)
  else
    sn=$(/usr/sbin/dmidecode -s system-serial-number)
  fi
  ip=$(hostname --all-ip-addresses | awk '{print $1}')
  hostname=$(hostname)
  echo "use sn:$sn ip:$ip"
  url="${SERVICE_URL}aenv-config/api/machine/tag?groupId=${GROUP_ID}&serviceTag=${sn}&machineIp=${ip}&hostName=${hostname}"
  echo "$url"
  wget -q -O - "$url"
}
