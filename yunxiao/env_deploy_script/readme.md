## env部署脚本说明

### 使用步骤

1. 修改```conf/env.cfg```中的配置
    ```shell
    # 配置项api地址
    GET_ANTX_PROPERTIES_URL="https://devops.yunxiaodemo.com/aenv-config/api/export/exportAntxProperties"

    #显示log的行数
    LOG_LINE_NUM=100 

    # java相关变量
    JAVA8_HOME=/usr/install/java8

    # Nginx相关变量
    NGINX_HOME=/usr/install/nginx

    # 获取tomcat版本
    TOMCAT_VERSION="apache-tomcat-7.0.54"
    # 如果下载地址不知道，则会根据TOMCAT_PATH这个路径查找TOMCAT_VERSION版本的包
    TOMCAT_PATH="/usr/install"
    TOMCAT_DOWNLOAD_URL="http://package.switch.aliyun.com:8088/upload/tools/${TOMCAT_VERSION}.zip"

   ```

  -  部署脚本执行逻辑
    1. 根据传入的下载包地址判断属于jar、war、docker、还是nginx部署
    2. 根据配置项api获取配置项并将配置项写入到变量脚本中
    3. 加载变量，执行部署
    4. 检查部署状态


2. 使用root账号执行脚本添加用户
   ```shell
   sh env_server_init.sh all | <username ...>

   all: 将脚本复制到所有用户家目录下
   username: 指定用户添加脚本，可以接多个用户