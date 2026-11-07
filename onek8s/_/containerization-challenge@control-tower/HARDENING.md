# Hardening report: containerization-challenge-control-tower

Controls from the NSA/CISA Kubernetes Hardening Guide (v1.2) and the CIS Kubernetes Benchmark, checked against the generated manifests. 14 applied, 8 cluster action, 2 not applied, 1 applied in gitops/.

| Control | Status | NSA/CISA guide section | CIS | Notes |
| --- | --- | --- | --- | --- |
| Containers run as a non-root user | applied | Pod security > Non-root containers and "rootless" container engines | 5.2.7 |  |
| Read-only root file system; writable paths are size-limited emptyDirs | applied | Pod security > Immutable container file systems | 5.7.3 |  |
| Minimal, patched base images; images scanned for vulnerabilities (containerizer gate) | applied | Pod security > Building secure container images |  |  |
| Only signed images run | cluster action | Pod security > Building secure container images | 5.5.1 | Sign each pushed image (cosign sign --yes <registry>/<image>@<digest>) and enforce it with cluster/verify-images.yaml (Kyverno) or your admission controller. |
| Images are deployed by digest | not applied | Pod security > Building secure container images |  | In the deploy pipeline: kustomize edit set image <image>=<registry>/<image>@sha256:<digest>; base images: generate --pin-digests. Now: image-digest: image localhost:5000/sandbox/containerization-challenge-control-tower/controltower-carriergateway:1.20261107.200 is not pinned to a digest (controltower-carriergateway: Deployment/controltower-carriergateway/controltower-carriergateway); image-digest: image localhost:5000/sandbox/containerization-challenge-control-tower/controltower-events:1.20261107.200 is not pinned to a digest (controltower-events: Deployment/controltower-events/controltower-events); image-digest: image localhost:5000/sandbox/containerization-challenge-control-tower/controltower-telematics:1.20261107.200 is not pinned to a digest (controltower-telematics: Deployment/controltower-telematics/controltower-telematics); image-digest: image localhost:5000/sandbox/containerization-challenge-control-tower/controltower-tower-api:1.20261107.200 is not pinned to a digest (controltower-tower-api: Deployment/controltower-tower-api/controltower-tower-api) |
| Pod Security Admission "restricted" enforced on the namespace; workloads comply | applied | Pod security > Pod security enforcement | 5.2.1-5.2.13 |  |
| Own ServiceAccount per component; no token mounted | applied | Pod security > Protecting Pod service account tokens | 5.1.5, 5.1.6 | no component calls the Kubernetes API |
| Seccomp and AppArmor RuntimeDefault; all capabilities dropped | applied | Pod security > Hardening container environments | 5.7.2 |  |
| One namespace per application; nothing in default | applied | Network separation and hardening > Namespaces | 5.7.1, 5.7.4 |  |
| Default-deny ingress and egress; only DNS, sibling components and inferred dependencies allowed | applied | Network separation and hardening > Network policies | 5.3.2 | Needs a CNI that enforces NetworkPolicy (CIS 5.3.1): Calico, Cilium, Antrea, ... Review the inferred egress ports below. |
| Requests and limits on every container; LimitRange and ResourceQuota on the namespace | applied | Network separation and hardening > Resource policies |  |  |
| Control plane, etcd, kubelet and kubeconfig hardening | cluster action | Network separation and hardening > Control plane hardening, Etcd, Kubeconfig files | 1.x, 2.x, 4.x | Cluster operator: API server not public, TLS everywhere, anonymous auth off, etcd encrypted and reachable only from the API server, kubeconfigs protected. Check CIS 1-4 with kube-bench. |
| Worker nodes segmented from the rest of the network | cluster action | Network separation and hardening > Worker node segmentation |  | Cluster operator: nodes in their own subnet; firewall the kubelet (10250) and the NodePort range. |
| Traffic encrypted in transit | cluster action | Network separation and hardening > Encryption |  | Terminate TLS at the ingress; use a service mesh (mTLS) or TLS to databases (Encrypt=True in SQL Server connection strings). |
| Secret values come from an external store through External Secrets Operator, never from Git or images | applied | Network separation and hardening > Secrets | 5.4.2 |  |
| Each namespace reads only its own keys from the secret store | cluster action | Network separation and hardening > Secrets; Authentication and authorization | 5.1.2 | Cluster operator: install External Secrets Operator and apply cluster/secret-store.yaml (the store; with the kubernetes provider also this namespace's Role over exactly its remote keys). For Vault, Azure Key Vault or AWS Secrets Manager bind the namespace's ServiceAccount app-secrets-reader to an identity that can read only <namespace>--* (docs/external-secrets.md). |
| Secrets mounted as files rather than environment variables | not applied | Network separation and hardening > Secrets | 5.4.1 | Not applied: the applications read their settings from configuration/environment variables, and reading them from files needs a code change (e.g. AddKeyPerFile). Keys and certificates are already mounted as files under /secrets. |
| Cloud instance metadata endpoints are not reachable from application pods | applied | Network separation and hardening > Protecting sensitive cloud infrastructure |  |  |
| Strong user authentication and least-privilege RBAC for people | cluster action | Authentication and authorization | 3.1, 5.1.1-5.1.4 | Cluster operator: OIDC for users, no static tokens or client certificates for people, cluster-admin only for break-glass. |
| Applications get no RBAC permissions | applied | Authentication and authorization | 5.1.3, 5.1.5 | no component calls the Kubernetes API |
| API server audit logging | cluster action | Audit logging and threat detection > Kubernetes native audit logging configuration | 3.2.1, 3.2.2 | Cluster operator: enable audit logging with cluster/audit-policy.yaml (metadata for everything, request bodies for RBAC changes, never Secret payloads) and ship it to a SIEM. |
| Applications log to stdout for central collection (file-only log sinks are re-pointed to the console) | applied | Audit logging and threat detection > Worker node and container logging |  |  |
| Runtime threat detection and alerting | cluster action | Audit logging and threat detection > Threat detection, Alerting |  | Cluster operator: run a runtime detector (Falco, Tetragon) and alert on shells in containers, writes to read-only paths and denied egress. |
| Base images kept patched and supported (images --update, weekly bump workflow, end-of-support warnings) | applied | Upgrading and application security practices |  | Keep Kubernetes itself on a supported version; re-run containerizer gate for every release. |
| GitOps delivery is least privilege: Flux reconciles as a namespace-scoped ServiceAccount, decrypts with SOPS and verifies OCI artifacts with cosign | applied in gitops/ | Authentication and authorization; Upgrading and application security practices |  |  |

## Network egress per component

Inferred from packages and configuration; everything else is denied. Review before production.

| Component | Allowed external dependencies |
| --- | --- |
| controltower-carriergateway | sql-server,rabbitmq,sftp,http-apis,lab-sqlserver,lab-rabbitmq,lab-sftp |
| controltower-events | sql-server,rabbitmq,sftp,http-apis,lab-sqlserver,lab-rabbitmq,lab-sftp |
| controltower-telematics | sql-server,rabbitmq,sftp,http-apis,lab-sqlserver,lab-rabbitmq,lab-sftp |
| controltower-tower-api | sql-server,rabbitmq,sftp,http-apis,lab-sqlserver,lab-rabbitmq,lab-sftp |

## Secret store keys

Put these in the secret store before the first sync (docs/external-secrets.md); External Secrets Operator copies them into the Secrets the workloads use. If one property is missing, that whole Secret is not created; the references are optional, so the pod still starts, without its values.

| Remote key | Property | Component | Secret |
| --- | --- | --- | --- |
| `containerization-challenge-control-tower--controltower-carriergateway` | `Carriers__Api__AFX__ClientSecret` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `Carriers__Api__BALX__ApiKey` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `Carriers__Api__PRCL__ApiKey` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `Carriers__Api__PRCL__WebhookSecret` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `Carriers__Sftp__NSFL__Password` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `Carriers__Sftp__VNRL__Password` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `ConnectionStrings__ControlTower` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `ConnectionStrings__RabbitMq` | controltower-carriergateway | `controltower-carriergateway-secrets` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `nrdl_rsa.pem` | controltower-carriergateway | `controltower-carriergateway-files` |
| `containerization-challenge-control-tower--controltower-carriergateway` | `ocnx_rsa.pem` | controltower-carriergateway | `controltower-carriergateway-files` |
| `containerization-challenge-control-tower--controltower-events` | `ConnectionStrings__ControlTower` | controltower-events | `controltower-events-secrets` |
| `containerization-challenge-control-tower--controltower-events` | `ConnectionStrings__RabbitMq` | controltower-events | `controltower-events-secrets` |
| `containerization-challenge-control-tower--controltower-telematics` | `ConnectionStrings__ControlTower` | controltower-telematics | `controltower-telematics-secrets` |
| `containerization-challenge-control-tower--controltower-telematics` | `ConnectionStrings__RabbitMq` | controltower-telematics | `controltower-telematics-secrets` |
| `containerization-challenge-control-tower--controltower-telematics` | `Telematics__Password` | controltower-telematics | `controltower-telematics-secrets` |
| `containerization-challenge-control-tower--controltower-tower-api` | `ConnectionStrings__ControlTower` | controltower-tower-api | `controltower-tower-api-secrets` |
| `containerization-challenge-control-tower--controltower-tower-api` | `ConnectionStrings__RabbitMq` | controltower-tower-api | `controltower-tower-api-secrets` |
| `containerization-challenge-control-tower--cz-lab-rabbitmq` | every key | lab | `lab-rabbitmq` |
| `containerization-challenge-control-tower--cz-lab-sftp` | every key | lab | `lab-sftp` |
| `containerization-challenge-control-tower--cz-lab-sqlserver` | every key | lab | `lab-sqlserver` |

## Files

- `security.yaml`: default-deny NetworkPolicy, LimitRange and ResourceQuota for the namespace
- `namespace.yaml`: Pod Security Admission `restricted` (enforce, warn, audit)
- `<component>/k8s.yaml`: hardened workloads, own ServiceAccount, least-privilege NetworkPolicy, ExternalSecrets
- `cluster/audit-policy.yaml`, `cluster/verify-images.yaml`, `cluster/secret-store.yaml` (the secret store and this namespace's read access): for the cluster operator, not applied with the app
