#!/bin/bash

set -e

resource_name=r0
master_host=master
meta_data=external

yum install -y elrepo-release
yum install -y drbd90-utils kmod-drbd90

# 加载内核模块
modprobe drbd
echo drbd > /etc/modules-load.d/drbd.conf

# 创建配置文件
mv /etc/drbd.d/global_common.conf /etc/drbd.d/global_common.conf.orig
cp conf/global_common.conf /etc/drbd.d/

if [ "${meta_data}" == "internal" ]; then
  cp conf/rc-internal.res /etc/drbd.d/
else
  cp conf/rc-external.res /etc/drbd.d/
fi

# 初始化设备文件
drbdadm down all
drbdadm create-md all

# 启动drbd服务
drbdadm up ${resource_name}
if [ "$(hostname)" == "${master_host}" ]; then
  drbdadm primary ${resource_name} --force
fi

# 查看drbd状态
drbdadm status ${resource_name}
