#!/bin/bash

kops export kubecfg --name ${CLUSTER_NAME} --state ${STATE}
kubectl config set-cluster ${CLUSTER_NAME} --server=https://api.${CLUSTER_NAME}

kops validate cluster —-state ${STATE}
