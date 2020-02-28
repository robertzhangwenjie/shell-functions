#!/bin/sh

# 初始化系统


# 设置时区，并同步时间
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum insall -y ntpdate
if ! crontab -l | grep ntpdate &> /dev/null; then
    (echo "* 1 * * * ntpdate time.windwos.com &> /dev/null"; crontab -l) | crontab
fi

# 禁用selinux
echo "Disabling selinux"
setenforce 0
sed -i.bak 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config

# 关闭防火墙
if egrep "7.[0-9]" /etc/redhat-release &> /dev/null;then
    systemctl stop firewalld
    systemctl disable firewalld
elif egrep "6.[0-9]" /etc/redhat-release &> /dev/null;then
    service iptables stop
    chkconfig iptables off
fi

# 禁止root远程登陆
# sed -i.bak 's@#PermitRootLogin yes@PermitRootLogin no@' /etc/ssh/sshd_config

# 设置最大打开文件数
if ! grep "* soft nofile 65536" /etc/security/limits.conf &>/dev/null;then
    cat >> /etc/security/limits.conf << EOF
* soft nofile 65535
* hard nofile 65535
EOF
fi

# 系统内核优化
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies= 1	#表示开启SYNCookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse= 1	#表示开启重用。允许将TIME-WAITsockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle= 1	#表示开启TCP连接中TIME-WAITsockets的快速回收，默认为0，表示关闭；
net.ipv4.tcp_fin_timeout= 30	#修改系統默认的TIMEOUT 时间。
net.ipv4.tcp_max_tw_buckets = 20480 #表示系统同时保持TIME_WAIT的最大数量，如果超过这个数字，TIME_WAIT的连接将会被立即清除并警告，默认为180000
net.ipv4.tcp_max_syn_backlog = 20480 #记录那些尚未收到客户端确认信息的连接请求的最大值，对于有128M内存的系统而言，缺省值为1024
net.core.netdev_max_backlog = 262144 #每个网络接口接收数据包的速度比内核处理这些包的速度块时，允许送到队列的数据包的最大数
net.ipv4.tcp_fin_timeout = 20  #如果套接字由本段要求关闭，这个参数决定了它保持再FIN-WAIT-2状态的时间，缺省值为60
EOF
# 使配置生效
sysctl -p

# 减少SWAP使用
echo "0" > /proc/sys/vm/swappiness

# 安装系统性能分析及其他工具
yum install vim sysstat net-tools iostat iftop iotp lrzsz -y
