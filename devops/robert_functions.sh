#!/bin/bash

# this is a set of special functions robert used 
. /etc/init.d/functions
PS3="please select a menu number:"


# del volumes of  sytem automatic created
del_noself_created_volumes() {
    docker volume ls | awk 'BEGIN{print "----------Volumes Listed Will Be Del----------"}/\w{50,100}/{print $2}END{print '\n'}'
    volumes=$(docker volume ls | awk '/\w{50,100}/{print $2}')
    echo -n "Are you ready to del all voluems above list, yes/no?"
    read flag
    [[ $flag =~ (no|No|N|n) ]] && exit 1
    for volume in $volumes;do
        docker volume rm $volume 
        [ $? == 0 ] && action "rm volume $volume successful" /bin/true 
        [ $? != 0 ] && action "rm volume $volume failed" /bin/false
    done
}

menus='del_noself_created_volumes 
    exit '
select menu in $menus;do
      echo -e "$menu\n"
      eval $menu
   done

