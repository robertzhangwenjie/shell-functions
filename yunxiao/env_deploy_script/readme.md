<!--
 * @Author: robert zhang
 * @Date: 2020-08-26 12:47:08
 * @LastEditTime: 2020-08-26 21:58:13
 * @LastEditors: robert zhang
 * @Description: 
 * @
-->
### env部署脚本说明
  
####  使用步骤
  1. 在测试服务器上执行初始化脚本 ```env_server_init.sh <username>```
    1.1 首先该脚本会添加用户组，并设置sudo权限，后续添加该用户到组中
    1.2 然后压缩env_script.zip包，并上传到package-switch
    1.3 复制并解压env_script.zip到用户家目录中
  2. 修改commons中的变量
    ```GET_ANTX_PROPERTIES_URL```: antx获取的api地址
    ```NGINX_HOME```：nginx安装目录
    ```JAVA_HOME```：java安装目录
  3. 修改
  
  
