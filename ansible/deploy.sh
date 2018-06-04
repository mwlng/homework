#!/bin/bash

PG_USER="postgres"
PG_PASS="ChangeIt!"

# SCEPTRE_RDSClusterEP
eval $(sceptre --dir ../ describe-stack-outputs prod airflow-postgres --export=envvar)
PG_URI="${PG_USER}:${PG_PASS}@${SCEPTRE_RDSClusterEP}"

# SCEPTRE_RedisCacheRepGrpConfigEP
eval $(sceptre --dir ../ describe-stack-outputs prod airflow-redisec --export=envvar)

ansible-playbook -i ./ec2.py --extra-vars "PG_URI=${PG_URI} REDIS_CONFIG_EP=${SCEPTRE_RedisCacheRepGrpConfigEP}" airflow.yml
