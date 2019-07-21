#!/bin/bash
images=(
kube-apiserver:v1.15.0
kube-controller-manager:v1.15.0
kube-scheduler:v1.15.0
kube-proxy:v1.15.0
pause:3.1
etcd:3.3.10
)

# ALIYUN_URL=registry.cn-shenzhen.aliyuncs.com/cookcodeblog
ALIYUN_URL=mirrorgooglecontainers
for imageName in ${images[@]} ; do
    docker pull ${ALIYUN_URL}/$imageName
    docker tag ${ALIYUN_URL}/$imageName k8s.gcr.io/$imageName
    docker rmi ${ALIYUN_URL}/$imageName
done
docker pull coredns/coredns:1.3.1
docker tag coredns/coredns:1.3.1 k8s.gcr.io/coredns:1.3.1
docker rmi coredns/coredns:1.3.1
