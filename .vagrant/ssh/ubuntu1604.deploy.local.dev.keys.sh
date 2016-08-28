#!/bin/bash

if [ -f local.dev.private.key ]; then
  mv local.dev.private.key /home/ubuntu/.ssh/id_rsa
  chmod 0600 /home/ubuntu/.ssh/id_rsa
fi

if [ -f local.dev.public.key ]; then
  mv local.dev.public.key /home/ubuntu/.ssh/id_rsa.pub
  chmod 0644 /home/ubuntu/.ssh/id_rsa.pub
fi

mkdir -p /home/ubuntu/.ssh
touch /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu: /home/ubuntu/.ssh
sed -i -e '$a\' /home/ubuntu/.ssh/authorized_keys
cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
