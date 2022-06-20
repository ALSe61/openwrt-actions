#!/bin/sh

#docker build -t openwrt-builder .
NAME="openwrt-builder"
docker run \
       -itd \
       --name $NAME \
       -h $NAME \
       -v "/data/documents/mir3p/build/openwrt":"/home/user/openwrt" \
       -v "/data/documents/mir3p/openwrt-actions":"/home/user/git" \
       openwrt-builder
docker exec "$NAME" sudo usermod -u 1001 user
docker exec "$NAME" sudo groupmod -g 1002 user
docker exec "$NAME" sudo chown -hR user:user ./openwrt
#if [ "$(docker inspect --format="{{ .State.Running }}" $NAME)" = "false" ]; then
#docker start $NAME
#else 
#docker attach $NAME
#fi
#docker exec -it openwrt-builder sudo passwd user
#docker restart openwrt-builder
