#!/bin/bash

for file in `ls`;do
    file_suffix=${file##*.}
    if [[ "$file_suffix" =~ (war|jar) ]];then
        file_name=$file
        break 
    fi
done

[ -z $file_name ] && echo "jar/war package can not found." && exit 1
package=$file_name
echo $file_name


