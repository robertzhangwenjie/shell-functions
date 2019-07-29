#/bin/sh

# re-tag k8s image and put it to my docker hub

images=(
kube-apiserver:v1.15.0
kube-controller-manager:v1.15.0
kube-scheduler:v1.15.0
kube-proxy:v1.15.0
pause:3.1
etcd:3.3.10
)

for image in ${images[@]};do
  docker image tag k8s.gcr.io/$image zhangwenjie/$image
  docker push zhangwenjie/$image
  docker rmi zhangwenjie/$image
done
