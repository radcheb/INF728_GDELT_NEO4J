# Exploring GDELT with Neo4j
This repo contains most of the scripts/templates/notebooks used in our GDELT exploration project.

## Files

* **save_raw_gdelt_2s3.json** a Zeppelin notebook for downloading GDELT 2018 data to AWS S3 bucket.

* **Create_nodes_emr.json** a Zeppelin notebook for reading GDELT data from S3 and creating CSV files that respects the Neo4j Schema, final result stored in S3.

* **load_1d.sh** a bash script for loading a 1 day sample data in a Neo4j Core server.

* **load_database.sh** a bash script for loading a 1 year data from a database dump into a Neo4j Core server.

* **neo4j_entreprise_template.json** a AWS CloudFormation template file for provisionning a Neo4j Causal Cluster.

* **start_zeppelin_apt.sh** a bash script for starting a Zeppelin instance from a docker image on Ubuntu Linux.

* **neo4j_final.json** a Zeppelin notebook for querying Neo4j and answering project questions. 