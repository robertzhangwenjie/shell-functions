#!/bin/bash
# Author: robertzhangwenjie <1648855816@qq.com>
# filter files by inputing a dir_path and some suffixes of filename
# print help doc
if [[ $1 =~ ^-(h|H)$ ]];then
    echo -e "usage: $0 [dir] [suffix ...] \nexample: $0 /tmp sh [war] [jar]"
fi
# get dir_name
dir=$1
if [ ! -d $dir ];then
    echo "$dir is not a existing path, please input correct path"
    exit 1
fi
# set default suffix_pattern 
suffix_pattern_inital="^(war|jar)\$"
suffix=$2
# judge if $3 is not zero
while [  -n "$3" ];do
    suffix=${suffix}:$3
    shift
done
# generate suffix_pattern by replace : with |
if [  -n "$suffix" ];then
    suffix_pattern=`echo "^(${suffix})\$" | sed 's@:@|@g' `
fi
# use defaullt pattern if no sufixx are passed in
[ -z "$suffix" ] && suffix_pattern=$suffix_pattern_inital
# use current dir as filter dir if no dir_name are passed in
filenames=$( ls ${dir} )

for filename in $filenames;do
    if [[ ${filename##*.} =~ $suffix_pattern ]];then
        echo $filename
    fi
done
