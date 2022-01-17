#!/bin/bash
#===========================================================
# Triangu test task
# Create k8s cluster in AWS
#===========================================================

## loading credentials environments:
source tf_aws.sh

networkDirName="network"
k8sDirName="k8s"
k8sClusterTpl="k8s_template.yaml"
k8sClusterCfg="cluster.yaml"
k8sTerraformCfg="kubernetes.tf"


## creating network:
pushd ./$networkDirName
terraform init -input=false
terraform apply -input=false -auto-approve
source network.sh
popd

## creating k8s cluster:

pushd ./$k8sDirName
terraform init
terraform apply -input=false

#popd

## creating needed servers:
#pushd ./servers
#terraform init
#terraform apply -input=false
#popd
