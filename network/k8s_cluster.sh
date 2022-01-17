#!/bin/bash

k8sClusterTpl="k8s_template.yaml"
k8sClusterCfg="cluster.yaml"
k8sTerraformCfg="kubernetes.tf"

TF_OUTPUT=$(terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .kubernetes_cluster_name.value)"

kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template $k8sClusterTpl --format-yaml > $k8sClusterCfg

STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket.value)"
kops replace -f $k8sClusterCfg --state ${STATE} --name ${CLUSTER_NAME} --force
kops update cluster --target terraform --state ${STATE} --name ${CLUSTER_NAME} --out .
kops create secret --name ${CLUSTER_NAME} --state ${STATE} --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub


