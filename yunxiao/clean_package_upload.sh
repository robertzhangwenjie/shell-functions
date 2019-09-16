#!/bin/bash

# clean old build packages for web app
echo "you are cleaning the files you want remove." 
function select_time() {
PS3="please choose the time unit:"
echo "please select time unit you search:"
select menu in min day exit;do
    case $menu in
        min)
            file_property=mmin
            break
            ;;
        day)
            file_property=mtime
            break
            ;;
        exit)
            break
            ;;
        *)
            echo "you must select 1 or 2"
            ;;
    esac
done
read -p "please input the time of you want to find(num eg:+10,-20):" number
read -p  "you want to clean the files which hadn't been modified in ${number}${menu}?(y|n):" answer
[[ ! $answer =~ (y|Y) ]] && echo "exit successfully." && exit 1
}

function select_path() {
read -p "please input your file path:" file_path
while [ ! -d ${file_path} ];do
    echo "$file_path is not a dir or not exist."
    read -p "please input your file path:" file_path
done
}

function select_file() {
read -p "please input your file name:" file_name
[ -z "${file_name}" ] && echo "$file_name is empty" && exit 1
}

select_path
select_file
select_time
eval find ${file_path} -name "${file_name}" -${file_property} $number| xargs echo
