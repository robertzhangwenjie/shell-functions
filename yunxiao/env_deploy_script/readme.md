## env部署脚本说明


### 使用步骤

1. 修改 `env_server_init.sh`中的配置
```shell
  YUNXIAO_GOURP=yunxia
  UPLOAD_URL="http://package.switch.aliyun.com:9090/upload" #上传api地址
  DOWNLOAD_URL="http://package.switch.aliyun.com:8088"  #下载api地址
  ENV_SCRIPT="env_script.zip"
  UPLOAD_SCRIPT="curl -X POST -F warName=@${ENV_SCRIPT} -F crid=0 -F appName=yunxiao -F buildNum=1 -F compileId=1 ${UPLOAD_URL}" # 上传命令
 
```


2. 使用root账号执行脚本添加用户

   ```
   sh env_server_init.sh <username ...>
   ```

   - 脚本执行流程
     1. 解压env_script.zip上传到指定的地址，拷贝解压包到当前用户目录
     2. 添加用户组yunxiao，设置sudo权限
     3. 新增用户，将用户加入yuxiao组
     4. 下载env_script.zip包到用户目录

   

3. 修```depoy_project_env.sh```中的定义的配置
  ```shell
  GET_ANTX_PROPERTIES_URL="https://devops.linewellcloud.com/aenv-config/api/export/exportAntxProperties" # 获取配置项的api地址
  CHECK_URL="" # 部署完成的检查api地址
  RESTORE_FILE=last_deploy_cmd.sh # 上一次执行成功的脚本保存的文件名
  USER=$(whoami)
  PORT=$(whoami) # 默认使用当前用户名作为部署端口
  ENV_PROPERTIES_FILE="${HOME}/env.properties.${APP_NAME}.${ENV_TYPE}" # 全局变量文件

  # 云效部署保存日志的目录
  LOG_DIR=logs

  # nginx相关全局变量
  NGINX_HOME=/usr/install/nginx
  NGINX_CONFIG_DIR=$NGINX_HOME/conf/conf.d
  NGINX_TEMPLATE_PATH=$COMMONS_PATH/template # nginx模板所在目录
  NGINX_CONF=${APP_NAME}-${ENV_TYPE}-${USER}.conf # nginx配置文件的名称定义
  NGINX_CMD=${NGINX_HOME}/sbin/nginx

  # Yum安装nginx时的全局变量
  rpm -ql nginx >/dev/null 2>&1
  if [ $? -eq 0 ]; then
   NGINX_HOME=/etc/nginx
   NGINX_CONFIG_DIR=${NGINX_HOME}/conf.d
   NGINX_CMD=nginx
  fi

  # java相关变量
  if [ -z "$JAVA_HOME" ]; then
   export JAVA_HOME=/usr/install/java8
   export PATH=$JAVA_HOME/bin:$PATH
   export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
  fi

  # Tomcat相关变量
  TOMCAT_VERSION="apache-tomcat-7.0.54"
  TOMCAT_HOME="/home/${USER}/${TOMCAT_VERSION}"
  TOMCAT_DOWNLOAD_URL="http://package.switch.aliyun.com:8088/upload/tools/${TOMCAT_VERSION}.zip"
  TOMCAT_PATH="/usr/install"
  ```

-  部署脚本执行逻辑
  1. 判断传入的参数是否满足条件
  2. 根据传入的下载包地址判断属于jar、war、docker、还是nginx部署
  3. 根据配置项api获取配置项并将配置项写入到变量脚本中
  4. 加载变量，执行部署
  5. 检查部署状态