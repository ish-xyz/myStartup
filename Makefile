.PHONY: add-helm-repos, pre-install, install, uninstall

add-helm-repos:
	helm repo add jetstack https://charts.jetstack.io
	helm repo add nginx https://helm.nginx.com/stable
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo add prometheus https://prometheus-community.github.io/helm-charts
	helm repo update

pre-install:
	kubectl apply -f namespaces/namespaces.yaml
	kubectl apply -f cert-manager/crds.yaml

install: add-helm-repos pre-install
	helm upgrade --wait --install cert-manager  jetstack/cert-manager --namespace cert-manager  --version 1.1.0  --values ./cert-manager/custom-values.yaml
	helm upgrade --wait --install nginx-ingress nginx/nginx-ingress   --namespace nginx-ingress --version 0.7.1  --values ./nginx-ingress/custom-values.yaml
	kubectl apply -f cert-manager/cluster-issuer.yaml
	helm upgrade --wait --install argo-cd	     argo/argo-cd          --namespace argo-cd       --version 2.10.0 --values ./argo-cd/custom-values.yaml
	helm upgrade --install argo-bootstrap argo-cd/bootstrap 
	

uninstall:
	helm uninstall -n argo-cd argo-cd || true
	helm uninstall -n nginx-ingress nginx-ingress || true
	kubectl delete -f cert-manager/cluster-issuer.yaml || true
	helm uninstall -n cert-manager cert-manager || true
	kubectl delete -f cert-manager/crds.yaml || true
	kubectl delete -f namespaces/namespaces.yaml || true

#argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc 