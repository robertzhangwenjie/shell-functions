###
 # @Author: robert zhang
 # @Date: 2020-07-04 18:27:03
 # @LastEditTime: 2020-07-04 21:39:45
 # @LastEditors: robert zhang
 # @Description: git模板目录初始化脚本
 # @
### 

# 定义template目录
git_doc_path=`git --html-path`
# 根据相对路径找到templates目录和hooks目录
template_dir=${git_doc_path}/../../git-core/templates
hooks_dir=${template_dir}/hooks

# 复制hooks
baseDir=$(dirname $0)
cp -ir ${baseDir}/hooks/* ${hooks_dir}/
chmod -R a+x ${hooks_dir}


