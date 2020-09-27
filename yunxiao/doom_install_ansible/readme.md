# 脚本使用步骤
  1. 修改hosts文件中不同主机的ip为实际部署的ip地址，目前nginx属于测试阶段，需要注释掉
  2. 修改group_vars/all.yml中的license
  3. 拷贝安装包到/opt/binary_pkg目录
  4. 执行部署脚本，输入主机的密码
    ``` ansible-playbook -i hosts single-doom-deploy.yml -uroot -p
    ```
  5. 修改hosts```<doom-server-ip> doompoc.rdc.aliyun.com```
