#!/bin/bash

sudo service neo4j stop

sudo -u neo4j neo4j-admin unbind

ls  /tmp/databases || sudo -u neo4j cp -p -r -P /var/lib/neo4j/data/databases /tmp/

FOLDER="neo4j_sample_1d"
FILES_DIR="/var/lib/neo4j/data/files"
declare -a NODES=(Event Actor Country Document Day)
declare -a RELATIONS=(MENTION SOURCE TARGET IN_AC ON_DD ON_ED IN_EC)

sudo -u neo4j mkdir -p $FILES_DIR
sudo -u neo4j chmod 777 -R $FILES_DIR

pushd $FILES_DIR ;

for NODE in ${NODES[@]} ; do
  echo "download node $NODE"
  ls $FILES_DIR/$NODE.csv.gz || wget "https://s3-eu-west-1.amazonaws.com/gdelt-raw/$FOLDER/nodes/$NODE/$NODE.csv.gz"
done

for REL in ${RELATIONS[@]} ; do
  echo "download relation $REL"
  ls $FILES_DIR/$REL.csv.gz || wget "https://s3-eu-west-1.amazonaws.com/gdelt-raw/$FOLDER/relations/$REL/$REL.csv.gz"
done

popd


pushd /var/lib/neo4j/data/databases

NODES_PATHS=""
  RELATIONS_PATHS=" --relationships:MENTION $FILES_DIR/MENTION.csv.gz --relationships:SOURCE $FILES_DIR/SOURCE.csv.gz
 --relationships:TARGET $FILES_DIR/TARGET.csv.gz --relationships:IN $FILES_DIR/IN_AC.csv.gz --relationships:IN $FILES_DIR/IN_EC.csv.gz 
 --relationships:ON $FILES_DIR/ON_ED.csv.gz --relationships:ON $FILES_DIR/ON_DD.csv.gz"

for NODE in ${NODES[@]} ; do
  NODES_PATHS="$NODES_PATHS --nodes:$NODE $FILES_DIR/$NODE.csv.gz"
done

#for REL in ${RELATIONS[@]} ; do
#  RELATIONS_PATHS="$RELATIONS_PATHS --relationships:$REL /tmp/$REL.csv.gz"
#done

sudo -u neo4j neo4j-import --ignore-duplicate-nodes true --skip-duplicate-nodes true --skip-bad-relationships true --skip-bad-entries-logging true \
             --into graph.db --max-memory 12G --processors 2 --high-io true --detailed-progress true --db-config /etc/neo4j/neo4j.conf \
             --bad-tolerance 1000000 \
    $NODES_PATHS \
    $RELATIONS_PATHS

popd

sudo service neo4j start




