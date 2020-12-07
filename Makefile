.PHONY: uninstall, add-helm-repos, pre-install, install

add-helm-repos:
	helm repo add jetstack https://charts.jetstack.io
	helm repo add nginx https://helm.nginx.com/stable
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update

pre-install:
	kubectl apply -f namespaces/namespaces.yaml
	kubectl apply -f cert-manager/crds.yaml

helm-install:
	helm upgrade --install cert-manager  jetstack/cert-manager --namespace cert-manager  --version 1.1.0  --values ./cert-manager/values.yaml
	kubectl apply -f cert-manager/cluster-issuer.yaml

	helm upgrade --install nginx-ingress nginx/nginx-ingress   --namespace nginx-ingress --version 0.7.1  --values ./nginx-ingress/values.yaml
	helm upgrade --install argo-cd	     argo/argo-cd          --namespace argo-cd       --version 2.10.0 --values ./argo-cd/values.yaml

uninstall:
	helm uninstall -n argo-cd argo-cd
	helm uninstall -n nginx-ingress nginx-ingress
	kubectl apply -f cert-manager/cluster-issuer.yaml
	helm uninstall -n cert-manager cert-manager
	kubectl delete -f cert-manager/crds.yaml
	kubectl delete -f namespaces/namespaces.yaml