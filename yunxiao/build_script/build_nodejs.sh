#!/bin/bash
###
 # @Author: robert zhang
 # @Date: 2020-09-01 20:35:22
 # @LastEditTime: 2020-09-01 20:37:50
 # @LastEditors: robert zhang
 # @Description: vue构建脚本
 # @
### 
#!/bin/bash

# 设置环境变量
export NodeHome=/usr/install/node-v12.18.1
export PATH=$PATH:$NodeHome/bin

# 进入前端目录
cd ${appName}

# 安装依赖
npm install

# 构建
npm run build

# 将静态资源dist目录打包并重命名
mv dist ${appName}
# 压缩
package_name=${appName}.tar.gz
tar -cf ${package_name} ${appName}

request1="buildNum=${BUILD_NUMBER}"
packageName="warName=@${package_name}"

#上传包
curl -X POST -F "${packageName}" -F 'crid=${crid}'  -F 'compileId=${compileId}' -F 'appName=${appName}'  -F "${request1}"  http://package.switch.aliyun.com:9090/upload