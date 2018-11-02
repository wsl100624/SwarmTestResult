#!/bin/bash
  
REDIS_CONFIG='port 6379
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes'

network=host
num_replicas=6

#docker network create --driver overlay $network

docker service create --name redis \
  --network=$network \
  --replicas=$num_replicas \
  -e REDIS_CONFIG="$REDIS_CONFIG" \
  -e REDIS_CONFIG_FILE="/usr/local/etc/redis/redis.conf" \
  redis:5.0 sh -c 'mkdir -p $(dirname $REDIS_CONFIG_FILE) && echo "$REDIS_CONFIG" > $REDIS_CONFIG_FILE && cat $REDIS_CONFIG_FILE && redis-server $REDIS_CONFIG_FILE'
