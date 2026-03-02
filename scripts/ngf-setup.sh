#!/bin/bash

# NGINX Gateway Fabric Setup Script
# Installs NGF (experimental) with the Gateway API Inference Extension
# Based on:
#   https://docs.nginx.com/nginx-gateway-fabric/install/manifests/
#   https://docs.nginx.com/nginx-gateway-fabric/how-to/gateway-api-inference-extension/

set -e

NGF_VERSION="v2.3.0"
NAMESPACE="nginx-gateway"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing NGINX Gateway Fabric ${NGF_VERSION} (experimental) with Gateway API Inference Extension${NC}"
echo -e "${YELLOW}WARNING: The Gateway API Inference Extension is in alpha status and should not be used in production${NC}"

echo -e "\n${GREEN}Step 1: Creating namespace ${NAMESPACE}${NC}"
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

echo -e "\n${GREEN}Step 2: Installing Gateway API resources (experimental channel)${NC}"
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=${NGF_VERSION}" | kubectl create -f -

echo -e "\n${GREEN}Step 3: Installing NGINX Gateway Fabric CRDs${NC}"
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/${NGF_VERSION}/deploy/crds.yaml

echo -e "\n${GREEN}Step 3b: Installing Gateway API Inference Extension CRDs${NC}"
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/inference-extension/?ref=${NGF_VERSION}" | kubectl apply -f -

echo -e "\n${GREEN}Step 4: Installing NGINX Gateway Fabric with Inference Extension${NC}"
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/${NGF_VERSION}/deploy/inference/deploy.yaml

echo -e "\n${GREEN}Step 5: Waiting for NGINX Gateway Fabric to be ready${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/nginx-gateway -n ${NAMESPACE}

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "\n${GREEN}Pods in ${NAMESPACE} namespace:${NC}"
kubectl get pods -n ${NAMESPACE}

echo -e "\n${GREEN}Gateway API Inference Extension CRDs installed:${NC}"
kubectl get crd | grep inference.networking.k8s.io
