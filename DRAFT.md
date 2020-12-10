### Products used in the platform:

cert-manager tls with let's encrypt

Tracing:
Jaeger

Security:
OPA *
Falco *

CI/CD:
Tekton
ArgoCD X

Load balancing:
Nginx Ingress X

Storage:
Provided by GCP X

Certificates management:
cert-manager X

Monitoring:
Prometheus X

======

Service Mesh?
Centralized Logging?



https://app.cloudskew.com/
App demo:
https://github.com/GoogleCloudPlatform/microservices-demo/tree/v0.2.1
https://github.com/GoogleCloudPlatform/microservices-demo/blob/v0.2.1/release/kubernetes-manifests.yaml


To install and configure:

cert-manager -> configure with let's encrypt (already automated and installed)
jaeger
gatekeeper
falco-security
application components