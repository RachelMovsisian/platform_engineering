install kafka:

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace prod

helm install my-release bitnami/kafka \
  -f kafka-values.yaml \
  --namespace prod

install argocd:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
argocd login localhost:8080 --username admin --password <password>
argocd repo add https://github.com/RachelMovsisian/platform_engineering.git

argocd app create my-app \
  --repo https://github.com/RachelMovsisian/platform_engineering.git \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace prod \
  --sync-policy automated


kubectl get services
minikube ip
