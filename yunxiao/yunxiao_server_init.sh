#!/bin/bash
#
# init server your adding to yunxiao machine group

# default path of env_script
ENV_SCRIPT=/root/env_script.zip

function usage() {
    echo "Useage:"
    echo "$0 -a/d -u <user_string>"
    echo "-a    useradd"
    echo "-d    userdel"
    echo "-u    user <string>   delimited by comma" 
    echo "example:
    $0 -a -u '1080,2080,3080'
    "
}

function add_user() {
    useradd $1 -p $1
    echo "useradd $1 successfully"
}

function del_user() {
    userdel -r $1 && echo "userdel $1 successfully"
}

function install_env_script() {
   # $1 user
   cp $ENV_SCRIPT /home/$1/ 
   chown $1:$1 -R /home/$1/
   echo "install $ENV_SCRIPT to /home/$1 successfully"
   for filename in `ls /home/$1`;do
      [ ${filename#*.} == "zip" ] && yes| unzip $filename
  done
}

while getopts ":adu:" opt;do
    case $opt in
        a)
            COMMAND=useradd
            ;;
        d)
            COMMAND=userdel
            ;;
        u)
            USERNAMES=`echo $OPTARG | sed 's@\,@ @g'`
            ;;
        ?)
            # 命令错误时的提示信息
            echo -e "your command has error, please see below usage\n "
            usage && exit 1
            ;;
    esac
done

shift $(( $OPTIND - 1 ))

[ -z $COMMAND ] && echo "you must select a argument -a or -d." && exit 1

if [ -z $USERNAMES ];then
    for i in {1..8};do
        USERNAMES="${USERNAMES} ${i}080"
    done
fi

if [ $COMMAND == "useradd" ];then
    for USER in $USERNAMES;do
        add_user $USER
        install_env_script $USER
    done
fi

if [  $COMMAND == "userdel" ];then
    for USER in $USERNAMES;do
        del_user $USER
    done
fi

