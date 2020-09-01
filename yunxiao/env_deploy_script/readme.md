## env部署脚本说明

### 脚本说明
1. 支持docker、jar、war、tar.gz格式的包部署
    - 如果包的名称包含":"，则匹配docker方式部署
    - 根据后缀匹配.jar、.war来匹配jar和war包方式部署
    - 根据后缀匹配.tar.gz来匹配nginx部署
  
2. 脚本部署流程
   1. 根据传入的下载包地址判断属于jar、war、docker、还是nginx部署
   2. 根据配置项api地址获取应用配置项并将配置项写入到变量脚本中 
   3. 加载配置变量，执行对应的部署类型
   4. 检查部署状态

3. nginx部署流程
   1. 解压构建的部署包，根据应用配置项location和backend_url来选择nginx的模板
   2. 程序根据模板和配置项自动生成nginx配置文件
   3. nginx配置文件中的root指令所对应的地址默认为$HOME/$APP_NAME,因此要求构建的部署包解压后目录名称与应用名称一致
   4. 运行nginx的用户需要拥有读取其他用户家目录的权利，最好以root账户运行Nginx


### 使用步骤

1. 修改```conf/env.cfg```中的配置
    ```shell
    # 配置项api地址
    GET_ANTX_PROPERTIES_API="http://devops.yunxiaodemo.com/aenv-config/api/export/exportAntxProperties"
    # 配置项获取地址，单租户时，不需要group参数
    GET_ANTX_PROPERTIES_URL="${GET_ANTX_PROPERTIES_API}?appName=${APP_NAME}&antxType=${ENV_TYPE}&crid=${CRID}&group=52"

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

2. 使用root账号执行脚本添加用户
   ```shell
   sh env_server_init.sh all | <username ...>

   all: 将脚本复制到所有用户家目录下
   username: 指定用户添加脚本，可以接多个用户

   ```
