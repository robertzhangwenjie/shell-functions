#!/bin/bash
images=(
k8s.gcr.io/kube-apiserver:v1.15.0
k8s.gcr.io/kube-controller-manager:v1.15.0
k8s.gcr.io/kube-scheduler:v1.15.0
k8s.gcr.io/kube-proxy-amd64:v1.15.0
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.3.10
k8s.gcr.io/coredns:1.3.1
)

ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/cookcodeblog
for imageName in ${images[@]} ; do
    docker pull ${ALIYUN_URL}/$imageName
    docker tag ${ALIYUN_URL}/$imageName k8s.gcr.io/$imageName
    docker rmi ${ALIYUN_URL}/$imageName
done
