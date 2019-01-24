#!/bin/bash

sudo service neo4j stop
aws configure
aws s3 ls s3://gdelt-raw/
sudo su neo4j cd /Var/lib/neo4j/
sudo su neo4j neo4j-admin unbind
sudo su neo4j mkdir data/files
sudo su neo4j chmod -R 777 data/files
sudo su neo4j aws s3 cp s3://gdelt-raw/graph2.db.tar.gz /var/lib/neo4j/data/files/
sudo su neo4j neo4j-admin load —from=../files/graph2.db.tar.gz --database=graph.db --force=true
sudo service neo4j start
tailf /var/log/neo4j/debug.log

