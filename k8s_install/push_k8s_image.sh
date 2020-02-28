#!/bin/sh
images=`docker image ls | awk -v OFS=":" '$0 ~ "(^k8s.gcr.io|^quay.io)"{print $1,$2}'`
for image in $images;do
   fullImageName=${image%:*}
   imageName=${fullImageName#**/}
   version=${image#*:}
   docker image tag $image zhangwenjie/$imageName:$version
   #docker push zhangwenjie/$imageName:$version
   docker rmi zhangwenjie/$imageName:$version
done
