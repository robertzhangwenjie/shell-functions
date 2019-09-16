#!/bin/bash
# Installing k8s of version 1.15.0


# prepare yum repos
prepare_yum_repos() {
  echo "starting prepare yum repos of k8s and docker-ce"
  cp repos.d/* /etc/yum.repos.d/

  yum install wget -y
  wget https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
  wget https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg 
  rpm --import rpm-package-key.gpg
  rpm --import yum-key.gpg
}


# required images for installing k8s
images=(
kube-apiserver:v1.15.0
kube-controller-manager:v1.15.0
kube-scheduler:v1.15.0
kube-proxy:v1.15.0
pause:3.1
etcd:3.3.10
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
install_docker() {
  echo "installing $DOCKER" 
  yum install $DOCKER -y
  systemctl enable docker && systemctl start docker
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
  echo "closing firewalld iptables"
  systemctl stop iptables && systemctl disable iptables
  systemctl stop firewalld && systemctl disable firewalld

  echo "disable selinux"
  setenforce 0
  sed -i.bak 's@SELINUX=penforcing@SELINUX=disabled@' /etc/selinux/config
  
  echo "set kubelet ignore errors for Swap"
  sed -i.bak 's@KUBELET_EXTRA_ARGS=@KUBELET_EXTRA_ARGS=--fail-swap-on=false@' /etc/sysconfig/kubelet
}

# REPOSITORY_URL=registry.cn-shenzhen.aliyuncs.com/cookcodeblog
REPOSITORY_URL=mirrorgooglecontainers

pull_k8s_image() {
  echo "pulling image for k8s.gcr.io"
  for imageName in ${images[@]} ; do
      docker pull ${REPOSITORY_URL}/$imageName
      docker tag ${REPOSITORY_URL}/$imageName k8s.gcr.io/$imageName
      docker rmi ${REPOSITORY_URL}/$imageName
  done
  
  echo "pulling coredns image"
  docker pull coredns/coredns:1.3.1
  docker tag coredns/coredns:1.3.1 k8s.gcr.io/coredns:1.3.1
  docker rmi coredns/coredns:1.3.1
}

init_k8s_master() {
  echo "init k8s master"
  kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=Swap
}

FUNCTIOIN_MENUS='install_kube_master install_kube_node'
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
