#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2020-10-28 17:36:49
 # @LastEditTime: 2020-10-28 17:41:10
 # @LastEditors: robert zhang
 # @Description: web应用构建脚本
 # @symbol_custom_string_obkoro1: 
### 

#使用jdk的版本
#source /etc/profile
export JAVA_HOME=/usr/install/java8
#进入应用目录如果是应用名字可以写成{appName}
cd ${appName}
#编译打包
/usr/install/maven3/bin/mvn clean install -Dmaven.test.skip -U
#进入target目录
cd target
#命名一个参数
request1="buildNum=${BUILD_NUMBER}"
#命名一个参数，warName上传的jar包一定要写正确
war=$(ls ./*.jar)
packageName="warName=@${war}"
#上传jar包
curl -X POST -F "${packageName}" -F 'crid=${crid}' -F 'compileId=${compileId}' -F 'appName=${appName}' -F "${request1}"  http://package.switch.aliyun.com:9090/upload