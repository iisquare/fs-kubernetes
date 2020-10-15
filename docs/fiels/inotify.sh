#!/bin/bash

WATCH_PATH=/data/nfs/
declare -A NODES=([node74]="192.168.2.74" [node75]="192.168.2.75" [node76]="192.168.2.76")
NODE_NAME=`hostname`
NODE_USER=`whoami`

monitor() {
  inotifywait -mrq ${WATCH_PATH} --format '%w%f' -e create,close_write,delete $1 | while read line; do
    for key in $(echo ${!NODES[*]})
    do
      if [ ${NODE_NAME} == ${key} ]; then
        continue
      fi
      if [ ! -f $line ]; then
        line=${WATCH_PATH}
      fi
      echo "rsync to $key(${NODES[$key]}) $line"
      rsync -avz $line --delete ${NODE_USER}@${NODES[$key]}:${line}
    done
  done
}

diffuse() {
  for key in $(echo ${!NODES[*]})
  do
    if [ ${NODE_NAME} == ${key} ]; then
      continue
    fi
    line=${WATCH_PATH}
    echo "rsync to $key(${NODES[$key]}) $line"
    rsync -avz $line --delete ${NODE_USER}@${NODES[$key]}:${line}
  done
}

case $1 in
    "monitor")
      monitor
    ;;
    "diffuse")
      diffuse
    ;;
    *)
      echo 'use [monitor|diffuse] to synchronize files.'
    ;;
esac
