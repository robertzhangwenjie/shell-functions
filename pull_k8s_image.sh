#!/bin/bash
# How to get k8s images whit dockerhub and github
# https://blog.csdn.net/sjyu_ustc/article/details/79990858 
images=(
kube-apiserver:v1.15.0
kube-controller-manager:v1.15.0
kube-scheduler:v1.15.0
kube-proxy-amd64:v1.15.0
pause:3.1
etcd:3.3.10
coredns:1.3.1
)
DOCKERHUB_URL=mirrorgooglecontainers
ALIYUN_URL=registry.cn-shenzhen.aliyuncs.com/cookcodeblog
URL=${DOCKERHUB_URL}
for imageName in ${images[@]} ; do
    docker pull ${URL}/$imageName
    docker tag ${URL}/$imageName k8s.gcr.io/$imageName
    docker rmi ${URL}/$imageName
done
