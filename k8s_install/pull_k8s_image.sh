#!/usr/bin/env bash

# dockerhub镜像仓库
# DOCKERHUB_PROXY="dockerhub.azk8s.cn"
DOCKERHUB_PROXY="registry.cn-hangzhou.aliyuncs.com"

# k8s.gcr.io镜像仓库
# GCR_PROXY="gcr.azk8s.cn"
GCR_PROXY="registry.cn-hangzhou.aliyuncs.com"

# quay.io镜像仓库
# QUAY_PROXY="quay.azk8s.cn"
QUAY_PROXY="quay-mirror.qiniu.com"

function azk8spull()
{
	image=$1
	if [ -z $image ]; then
		echo "***Image name cannot be null."
	else
		array=(`echo $image | tr '/' ' '` )

		domainName=""
		repoName=""
		imageName=""

		if [ ${#array[*]} -eq 3 ]; then
			repoName=${array[1]}
			imageName=${array[2]}
			if [ "${array[0]}"x = "docker.io"x ]; then
				domainName=${DOCKERHUB_PROXY}
			elif [ "${array[0]}"x = "gcr.io"x ]; then
				domainName=${GCR_PROXY}
			elif [ "${array[0]}"x = "quay.io"x ]; then
				domainName=${QUAY_PROXY}
			else
				echo '***Can not support pull $image right now.'
			fi
		elif [ ${#array[*]} -eq 2 ]; then
			if [ "${array[0]}"x = "k8s.gcr.io"x ]; then
				domainName=${GCR_PROXY}
				repoName="google_containers"
				imageName=${array[1]}
			else
				domainName=${DOCKERHUB_PROXY}
				repoName=${array[0]}
				imageName=${array[1]}
			fi
		elif [ ${#array[*]} -eq 1 ]; then
				domainName=${DOCKERHUB_PROXY}
				repoName="library"
				imageName=${array[0]}
		else
			echo '***Warning: Can not support pull $image right now.'
		fi
		if [ "$domainName"x != x ]; then
			echo "***Pulling image from mirror $domainName/$repoName/$imageName..."
			docker pull  $domainName/$repoName/$imageName
			if [ $? -eq 0 ]; then
				echo "***Taging $domainName/$repoName/$imageName to $image..."
				docker tag $domainName/$repoName/$imageName $image
				if [ $? -eq 0 ]; then
					echo "***Pull $image successfully."
				fi
				echo "***Removing iamge $domainName/$repoName/$imageName..."
				docker rmi $domainName/$repoName/$imageName
			fi
		fi
	fi
}
azk8spull $@
