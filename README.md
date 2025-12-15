# demo-k8s-monitoring

## Summary
Local demo that simulates AKS using kind (Kubernetes-in-Docker). Deploys a demo Flask microservice, uses Terraform (kubernetes provider) to manage namespace/secret/deployment, installs monitoring stack via Helm (kube-prometheus-stack), and scans Terraform code with Checkov.

## Quick start (local)
1. Install: docker, kind, kubectl, helm, terraform, checkov.
2. Create kind cluster: `kind create cluster --name kind-demo`
3. Build & deploy: `./ci/local_deploy.sh`
4. Install monitoring: `helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace`
5. Port-forward Grafana: `kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80`
6. Access app: `kubectl -n demo-app port-forward svc/demo-api 8080:80` -> `http://localhost:8080/api`

## CI/CD
- GitHub Actions workflow included at `.github/workflows/ci-cd.yml`.

## Security scanning
- Run Checkov: `checkov -f tfplan.json` (plan scanning) or `checkov -d .` for directory scan.

## Design decisions
- Local kind chosen to demo AKS-like Kubernetes quickly. Terraform kubernetes provider used to show Terraform flows and to be scanned by Checkov. kube-prometheus-stack chosen to bundle Prometheus + Grafana + dashboards.