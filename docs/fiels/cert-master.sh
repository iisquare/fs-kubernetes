#!/bin/bash
USER=`whoami`
HOST=$1
if [ "${HOST}" == "" ]; then
  echo "command:./$0 target-ip"
  exit
fi
TARGET="${USER}@${HOST}"
FILES=(
  /etc/kubernetes/pki/ca.crt
  /etc/kubernetes/pki/ca.key
  /etc/kubernetes/pki/sa.key
  /etc/kubernetes/pki/sa.pub
  /etc/kubernetes/pki/front-proxy-ca.crt
  /etc/kubernetes/pki/front-proxy-ca.key
  /etc/kubernetes/pki/etcd/ca.crt
  /etc/kubernetes/pki/etcd/ca.key # Quote this line if you are using external etcd
)

echo "copy to ${TARGET}"
ssh ${TARGET} "mkdir -p /etc/kubernetes/pki/etcd"
for file in ${FILES[@]}; do
  echo $file
  scp $file ${TARGET}:$file
done
