#!/bin/bash
images=(
kube-apiserver:v1.15.0
kube-controller-manager:v1.15.0
kube-scheduler:v1.15.0
kube-proxy-amd64:v1.15.0
pause:3.1
etcd:3.3.10
coredns:1.3.1
)

ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/cookcodeblog
for imageName in ${images[@]} ; do
    docker pull ${ALIYUN_URL}/$imageName
    docker tag ${ALIYUN_URL}/$imageName k8s.gcr.io/$imageName
    docker rmi ${ALIYUN_URL}/$imageName
done
