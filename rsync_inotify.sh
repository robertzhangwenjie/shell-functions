#!/bin/sh

function sync() {
	a="inotifywait -mrq -e create,delete,modify /filesrc"
	b="rsync -avz /filesrc/* root@192.168.43.240:/filedest"
	#监控该目录的所有文件是否有变动
	$a | while read directory event file; do
  		$b
	done
}

sync > $HOME/rsync.log 2>&1 & 
