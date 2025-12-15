#!/usr/bin/env bash
set -euo pipefail
IMAGE_NAME="demo-api:local"
KIND_CLUSTER="kind-demo"
NAMESPACE="demo-app"

docker build -t $IMAGE_NAME ./app
echo "Built $IMAGE_NAME"

kind load docker-image $IMAGE_NAME --name $KIND_CLUSTER
echo "Loaded image into kind"

pushd terraform
terraform init -input=false
terraform apply -auto-approve
popd


kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/service.yaml

kubectl rollout status deployment/demo-api -n $NAMESPACE --timeout=120s || true

kubectl get pods -n $NAMESPACE
kubectl get svc -n $NAMESPACE
