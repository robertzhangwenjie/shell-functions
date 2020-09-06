## env部署脚本说明

### 脚本功能说明
1. 支持多系统部署，支持ubuntu和redhat发行版系统
2. 支持服务器一键初始化，无需手动配置
3. 支持docker、jar、war、tar.gz格式的包一键自动化部署
4. 支持公共环境部署失败后，自动回退上一个成功部署的版本
5. 支持nginx配置文件自动生成，免人工配置
6. 支持部署后url检测，排除部署假成功
7. 部署成功后，自动打印出访问该应用的内网和外网地址


### 脚本执行逻辑
1. 初始化脚本执行流程
   1. 清空当前用户运行的所有服务
   2. 清空当前用户家目录，除了env_script
   3. 创建日志目录`$LOG_DIR`
2. 部署脚本执行流程
   1. 根据传入的下载包地址判断属于jar、war、docker、还是nginx部署
       - 如果包的名称包含":"，则匹配docker方式部署
       - 根据后缀匹配.jar、.war来匹配jar和war包方式部署
       - 根据后缀匹配.tar.gz来匹配nginx部署
   2. 根据配置项api地址获取应用配置项并将配置项写入到变量脚本中 
   3. 加载配置变量，执行对应的部署方法
   4. 检查部署状态
      - 检查当前进程是否运行
      - 检查`check_url`访问是否正常
   5. 打印部署日志和访问地址  
3. nginx部署流程
   1. 检查环境选择对应模板渲染引擎
   2. 根据模板和应用配置项自动生成nginx配置文件
      1. 根据配置项`location`、`backend_url`、`ws_location`、`ws_backend_url`来渲染模板
   3. 复制nginx配置文件到`$NGINX_CONFIG_DIR`目录，重启nginx服务
   4. 运行nginx的用户需要拥有读取其他用户家目录的权利，最好以root账户运行Nginx
4. docker部署流程
   1. 获取应用配置项，判断是否有`container_port`，该应用为容器端口，宿主机端口默认为用户名后4位
   2. 清空当前用户运行的docker服务
   3. 部署应用
   4. 根据容器运行状态判断当前应用状态
   5. 根据`check_url`检查应用是否正常运行

### 脚本使用步骤

1. 修改```conf/env.cfg```中的配置
    ```shell
    # 配置项api地址
    GET_ANTX_PROPERTIES_API="http://devops.yunxiaodemo.com/aenv-config/api/export/exportAntxProperties"
    # 配置项获取地址，单租户时，不需要group参数
    GET_ANTX_PROPERTIES_URL="${GET_ANTX_PROPERTIES_API}?appName=${APP_NAME}&antxType=${ENV_TYPE}&crid=${CRID}&group=52"

    # log目录
    LOG_DIR=logs
    # 显示log的行数
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
   **参数说明**
   -  `GET_ANTX_PROPERTIES_API`: 获取应用的配置项的api地址，更换为实际的部署地址
   -  `GET_ANTX_PROPERTIES_URL`: 获取应用配置项的具体请求url，根据是否为多租户来决定添加group参数
   -  `JAVA8_HOME`: java8的home路径，如果已经设置了全局的JAVA_HOME，则可以忽略
   -  `NGINX_HOME`: nginx的home路径，如果已经使用yum安装，则可以忽略
   -  `TOMCAT_PATH`:  tomcat的包路径，包的版本为`TOMCAT_VERSION`
   -  `LOG_DIR`:  保存云效log日志文件的目录，需要与`star.agent.deploy.log.path`全局配置项的值一致

2. 使用root账号执行脚本添加用户
   ```shell
   sh env_server_init.sh all | <username ...>

   all: 将脚本复制到所有用户家目录下
   username: 指定用户添加脚本，可以接多个用户

   ```

### 前置条件
  - 配置文件
     1. 应用配置项获取地址配置正确 
     2. 已安装nginx，在配置文件中配置正确
     3. 已设置java环境，在配置文件中配置正确
     4. 已下载tomcat包，在配置文件中配置正确
  - 配置项管理
    1. 如果为nginx部署，且希望自动生成配置文件，则需要配置对应的location和backend_url配置项 
  - 构建包配置
     1. nginx配置文件中的root指令所对应的地址默认为`$HOME/$APP_NAME`,因此要求构建的部署包解压后目录名称与应用名称一致
  - 测试管理-应用配置
    1. 服务器组配置
       1. 服务器组的账号要求后4位为数字代表部署的端口，例如`a1080`或`1080`
    2. 部署脚本
       1. 第1个参数`${appName}`
       2. 第2个参数`${projectCrid}`
       3. 第3个参数`${typeAlias}`
       4. 第4个参数`${deployPackage}`
       5. 第5个参数`${needRestore}`
       6. 第6个参数`${deployId}`
       7. 第7个参数为`check_url`,由用户自定义，用来检查部署状态
    3. 初始化部署脚本
       1. 第一个参数需要为`${appName}`
       2. 第二个参数需要为`${typeAlias}`
    4. 释放部署脚本
       1. 第一个参数需要为`${appName}`
       2. 第三个参数为`${typeAlias}`
   

