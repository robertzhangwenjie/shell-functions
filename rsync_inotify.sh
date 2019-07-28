#!/bin/sh

function sync() {
	a="inotifywait -mrq -e create,delete,modify /data/gitlab-master"
	b="rsync -avz /data/gitlab-master/* root@192.168.43.240:/gitlab-master/"
	#监控该目录的所有文件是否有变动
	$a | while read directory event file; do
  		$b
	done
}

sync > $HOME/rsync.log 2>&1 & 
