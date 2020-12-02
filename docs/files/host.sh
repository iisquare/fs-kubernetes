#!/bin/bash
USER=`whoami`
PROJECT_ROOT=$(dirname $(readlink -f $0))

file=${PROJECT_ROOT}/hosts
cat $file | while read line
do
    echo $line
    if [[ $line =~ "node" ]]; then
      IP=`echo $line | awk -F " " '{print $1}'`
      echo "copy to ${IP}..."
      scp $file $USER@$IP:/etc/hosts
    fi
done
