## 环境准备
  1. 准备两台服务器，分别添加一块磁盘/dev/sdb
  2. 使用fdisk工具，对/dev/sdb进行分区，两个主分区/dev/sdb1，/dev/sdb2
     ``` fdisk /dev/sdb
	如果使用internal模式的drbd，则不需要分区
     ```  
  3. 格式化/dev/sdb1
     ```mkfs.ext4 /dev/sdb1```
  4. 挂载/dev/sdb2
     ```mount /dev/sdb2 /mnt```
  5. 执行脚本```install.sh```
