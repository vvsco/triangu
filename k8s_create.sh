#!/bin/bash

#
#
#


## loading credentials environments:
source tf_aws.sh


## creating network:
pushd ./network
terraform init -input=false
terraform apply -input=false -auto-approve
popd

## creating k8s cluster:
#pushd ./k8s
#terraform init
#terraform apply -input=false
#source k8s_cluster.sh

#popd

## creating needed servers:
#pushd ./servers
#terraform init
#terraform apply -input=false
#popd
