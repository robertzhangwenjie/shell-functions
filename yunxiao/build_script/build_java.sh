#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2020-07-04 18:25:17
 # @LastEditTime: 2020-09-01 20:32:46
 # @LastEditors: robert zhang
 # @Description: java构建脚本
 # @
### 
#!/bin/bash

#source /etc/profile
#使用jdk的版本
export JAVA_HOME=/usr/install/java8

#进入应用目录如果是应用名字可以写成{appName}
cd ${appName}

#编译打包
/usr/install/maven3/bin/mvn clean install -Dmaven.test.skip

#进入target目录
cd target

#设置构建参数
request1="buildNum=${BUILD_NUMBER}"

#获取构建包名
for file in `ls`;do
    file_suffix=${file##*.}
    if [[ "$file_suffix" =~ (war|jar) ]];then
        package_name=$file
        break 
    fi
done
packageName="warName=@${package_name}"

#上传包
curl -X POST -F "${packageName}" -F 'crid=${crid}' -F 'compileId=${compileId}' -F 'appName=${appName}' -F "${request1}"  http://package.switch.aliyun.com:9090/upload



