#!/bin/bash

WATCH_PATH=/data/nfs
NODES=([node74]="node74.k8s.iisquare.com" [node75]="node75.k8s.iisquare.com" [node76]="node76.k8s.iisquare.com")
NODE_NAME=`hostname`
NODE_USER=`whoami`

monitor() {
  inotifywait -mrq ${WATCH_PATH} --format '%w%f' -e create,close_write,delete $1 | while read line; do
    for key in $(echo ${!NODES[*]})
    do
      if [${NODE_NAME} eq ${key}]
        continue
      fi
      if [ ! -f $line ]; then
        line=${WATCH_PATH}
      fi
      echo "rsync -avz $line --delete ${NODE_USER}@${NODES[$key]}:${line}"
    done
  done
}

monitor;
