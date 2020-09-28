#!/bin/bash

set -e

work_dir=$(cd $(dirname $0); pwd)
binary_pkg=${work_dir}/packages
package_dir=/opt/heartbeat
conf_dir=${work_dir}/conf

packages=(
gcc
gcc-c++
autoconf
automake
libtool
glib2-devel
libxml2-devel
bzip2
bzip2-devel
e2fsprogs-devel
libxslt-devel
libtool-ltdl-devel
asciidoc
net-tools
)

# 安装基础环境包
yum install -y "${packages[@]}"


# 设置环境
if [ "$(getenforce)" == "Enforcing" ]; then 
  setenforce 0 
else
  echo "selinux is closed"
fi
systemctl stop firewalld && systemctl disable firewalld

# 拷贝安装包
function extract_packages() {
[ ! -d "${package_dir}" ] && mkdir -pv ${package_dir}
cp ${binary_pkg}/* ${package_dir}/

# 解压安装包
for package in `ls "${package_dir}"`;do
  cd "${package_dir}"
  [[ ${package} =~ (.gz|.bz2)$ ]] && tar -xvf "$package"
done
}

# 安装gluster-glue
function install_gluster_glue() {
if ! grep -E "^haclient" /etc/group;then
  groupadd haclient
  useradd -g haclient hacluster
fi

cd Reusable-Cluster-Components-glue*
./autogen.sh
./configure --prefix=/usr/local/heartbeat --with-daemon-user=hacluster --with-daemon-group=haclient --enable-fatal-warnings=no LIBS='/lib64/libuuid.so.1'
make && make install

}

# 安装Resource-agent
function install_resource_agent() {
cd ${package_dir}/resource-agents-*
./autogen.sh 
./configure --prefix=/usr/local/heartbeat --with-daemon-user=hacluster --with-daemon-group=haclient --enable-fatal-warnings=no LIBS='/lib64/libuuid.so.1'
make && make install

}

# 安装HeartBeat
function install_heartbeat() {
cd ${package_dir}/Heartbeat*
./bootstrap
export CFLAGS="$CFLAGS -I/usr/local/heartbeat/include -L/usr/local/heartbeat/lib"
./configure --prefix=/usr/local/heartbeat --with-daemon-user=hacluster --with-daemon-group=haclient --enable-fatal-warnings=no LIBS='/lib64/libuuid.so.1'
make && make install

}


# 配置网卡插件
function install_plugins() {
mkdir -pv /usr/local/heartbeat/usr/lib/ocf/lib/heartbeat/
cp /usr/lib/ocf/lib/heartbeat/ocf-* /usr/local/heartbeat/usr/lib/ocf/lib/heartbeat/
ln -svf /usr/local/heartbeat/lib64/heartbeat/plugins/RAExec/* /usr/local/heartbeat/lib/heartbeat/plugins/RAExec/
ln -svf /usr/local/heartbeat/lib64/heartbeat/plugins/* /usr/local/heartbeat/lib/heartbeat/plugins/

}


# 拷贝模板配置文件
cd ${package_dir}/Heartbeat*
cp ${conf_dir}/{ha.cf,haresources,authkeys} /usr/local/heartbeat/etc/ha.d/

# 配置文件权限
chmod 600 /usr/local/heartbeat/etc/ha.d/authkeys

# 启动heartbeat
systemctl start heartbeat
systemctl enable heartbeat
