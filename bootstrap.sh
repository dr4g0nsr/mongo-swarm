#!/usr/bin/env bash

#Pull visualizer
#docker run -it -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

#Mongo data nodes
#node.labels.mongo.role == dataX
#docker node update --label-add mongo.role=data1 node1
#docker node update --label-add mongo.role=data2 node2
#docker node update --label-add mongo.role=data3 node3

#Mongo config nodes
#node.labels.mongo.role == cfgX
#docker node update --label-add mongo.role=cfg1 node1
#docker node update --label-add mongo.role=cfg2 node2
#docker node update --label-add mongo.role=cfg3 node3

#Mongos nodes
#node.labels.mongo.role == mongosX
#docker node update --label-add mongo.role=mongos1 node1
#docker node update --label-add mongo.role=mongos2 node2

#Three nodes setup
docker node update --label-add mongo.data1=1 --label-add mongo.cfg1=1 --label-add mongo.mongos1=1 node1
docker node update --label-add mongo.data2=1 --label-add mongo.cfg2=1 --label-add mongo.mongos2=1 node2
docker node update --label-add mongo.data3=1 --label-add mongo.cfg3=1 --label-add mongo.mongos3=1 node3

#Create network
docker network create --attachable -d overlay mongo
docker network create --attachable -d overlay mongos

docker stack deploy -c swarm-compose.yml mongo
