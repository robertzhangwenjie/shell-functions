## env部署脚本说明

### 使用步骤

1. 修改 `env_server_init.sh`中的配置参数
    ```shell
    UPLOAD_URL="http://package.switch.aliyun.com:9090/upload" #上传包的api
    DOWNLOAD_URL="http://package.switch.aliyun.com:8088"  #下载包的api
    ```

2. 使用root账号执行脚本添加用户
   ```shell
   sh env_server_init.sh <username ...>
   ```
   - 脚本执行流程
     1. 压缩env_script目录，将压缩后的env_script.zip上传到指定的地址
     2. 添加用户组yunxiao，设置sudo权限
     3. 新增用户，将新用户加入yuxiao组
     4. 下载env_script.zip包到用户目录并解压
   
3. 修改```conf/env.cfg```中的定义的配置
    ```shell
    # 脚本相关变量
    DOWNLOAD_URL="http://package.switch.aliyun.com:8088"
    # 脚本下载url,与env_server_init.sh中要保持一致
    ENV_SCRIPT_URL="${DOWNLOAD_URL}/upload/0/yunxiao/ATON_INTEGRATION/1/1/${ENV_SCRIPT}"
    # 获取应用配置项的api
    GET_ANTX_PROPERTIES_URL="https://devops.linewellcloud.com/aenv-config/api/export/exportAntxProperties"

    # 云效日志文件保存路径，根据实际部署情况配置，默认为env_script
    LOG_DIR=logs

    # 应用日志路径
    LOG_LINE_NUM=100 #显示log的行数

    # nginx相关全局变量
    NGINX_TEMPLATE_PATH=$ENV_SCRIPT_PATH/template
    NGINX_TEMPLATE=$NGINX_TEMPLATE_PATH/nginx.conf.tpl
    NGINX_CONF=${APP_NAME}-${ENV_TYPE}-${USER}.conf
 
    # java相关变量
    export JAVA_HOME=/usr/install/java8
  
    # 获取tomcat版本
    TOMCAT_VERSION="apache-tomcat-7.0.54"

    # 如果下载地址不知道，则会根据TOMCAT_PATH这个路径查找TOMCAT_VERSION版本的包
    TOMCAT_DOWNLOAD_URL="http://package.switch.aliyun.com:8088/upload/tools/${TOMCAT_VERSION}.zip"
    TOMCAT_PATH="/usr/install"
    TOMCAT_LOG="${TOMCAT_HOME}/logs/catalina.out"

   ```

-  部署脚本执行逻辑
  1. 判断传入的参数是否满足条件
  2. 根据传入的下载包地址判断属于jar、war、docker、还是nginx部署
  3. 根据配置项api获取配置项并将配置项写入到变量脚本中
  4. 加载变量，执行部署
  5. 检查部署状态