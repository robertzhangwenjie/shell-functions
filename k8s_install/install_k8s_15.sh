#!/bin/bash
# Installing k8s of version 1.15.0


# prepare yum repos
prepare_yum_repos() {
  echo "Preparing yum repos for k8s and docker-ce"
  cp repos.d/* /etc/yum.repos.d/

  yum install wget -y
  wget https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
  wget https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg 
  rpm --import rpm-package-key.gpg
  rpm --import yum-key.gpg
}


# required images for installing k8s
images=(
k8s.gcr.io/kube-apiserver:v1.15.0
k8s.gcr.io/kube-controller-manager:v1.15.0
k8s.gcr.io/kube-scheduler:v1.15.0
k8s.gcr.io/kube-proxy:v1.15.0
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.3.10
)

# docker and kube-serials version
DOCKER_VERSION=18.09.8
KUBELET_VERSION=1.15.0
KUBECTL_VERSION=1.15.0
KUBEADM_VERSION=1.15.0

DOCKER=docker-ce-${DOCKER_VERSION}
KUBELET=kubelet-${KUBELET_VERSION}
KUBECTL=kubectl-${KUBECTL_VERSION}
KUBEADM=kubeadm-${KUBEADM_VERSION}

# install kubelet kubectl kubeadm and docker
# docker acceleration mirror
install_acceleration_mirror() {
  echo '{ "registry-mirrors": ["https://jre91sie.mirror.aliyuncs.com"] }' > /etc/docker/daemon.json
  systemctl daemon-reload 
  systemctl restart docker
}

install_docker() {
  echo "installing $DOCKER" 
  yum install $DOCKER -y
  install_acceleration_mirror
}

install_kube_master() {
  echo "installing $KUBELET $KUBECTL $KUBEADM"
  install_docker
  yum install $KUBELET $KUBECTL $KUBEADM -y
  systemctl enable kubelet
}

install_kube_node() {
  echo "installing $KUBELET $KUBEADM"
  install_docker
  yum install $KUBELET $KUBEADM
  systemctl enable kubelet
}

# close firewalld, iptables and selinux
prepare_system_settings() {
  # 禁用防火墙
  echo "closing firewalld iptables"
  systemctl stop iptables && systemctl disable iptables
  systemctl stop firewalld && systemctl disable firewalld

  # 禁用SELINUX
  echo "disable selinux"
  setenforce 0
  sed -i.bak 's@SELINUX=penforcing@SELINUX=disabled@' /etc/selinux/config
 
  # 设置忽略SWAP错误 
  echo "set kubelet ignore errors for Swap"
  sed -i.bak 's@KUBELET_EXTRA_ARGS.*@KUBELET_EXTRA_ARGS="--fail-swap-on=false"@' /etc/sysconfig/kubelet
  
  # 开启ipv4流量接入到iptables的链
  cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
  modprobe br_netfilter
  sysctl -p /etc/sysctl.d/k8s.conf
}


# 拉取k8s镜像
pull_k8s_image() {
  echo "pulling image for k8s.gcr.io"
  for image in ${images[@]} ; do
	./pull_k8s_image.sh $image
  done  
}

# 初始化K8s-master
init_k8s_master() {
  echo "init k8s master"
  # 删除残留的manifest
  rm -rf /etc/kubernetes/manifests/*
  # 删除残留的etcd相关信息
  rm -rf /var/lib/etcd/*
  kubeadm init --kubernetes-version=v1.15.0 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=Swap
}

FUNCTION_MENUS='install_kube_master install_kube_node'
select menu in $FUNCTION_MENUS; do
  prepare_yum_repos
  eval $menu
  prepare_system_settings
  pull_k8s_image
  case $menu in
    install_kube_master)
      init_k8s_master
      break
      ;;
  esac
done
