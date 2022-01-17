#!/bin/bash
#===========================================================
# Triangu test task
# Create k8s cluster in AWS
#===========================================================

## loading environment variables:
source env.sh

## loading credentials environments:
source tf_aws.sh

## creating network:
pushd ./$networkDirName
terraform init -input=false && \
terraform apply -input=false -auto-approve
source $networkSh
mv $k8sTerraformCfg ../$k8sDirName
popd

## creating k8s cluster:
pushd ./$k8sDirName
terraform init -input=false && \
terraform apply -input=false -auto-approve
source $k8sSh
popd

## creating needed servers:
#pushd ./servers
#terraform init -input=false && \
#terraform apply -input=false -auto-approve
#source $serversSh
#popd
