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

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
        docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
    done
