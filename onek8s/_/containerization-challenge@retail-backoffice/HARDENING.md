# Hardening report: containerization-challenge-retail-backoffice

Controls from the NSA/CISA Kubernetes Hardening Guide (v1.2) and the CIS Kubernetes Benchmark, checked against the generated manifests. 14 applied, 8 cluster action, 2 not applied, 1 applied in gitops/.

| Control | Status | NSA/CISA guide section | CIS | Notes |
| --- | --- | --- | --- | --- |
| Containers run as a non-root user | applied | Pod security > Non-root containers and "rootless" container engines | 5.2.7 |  |
| Read-only root file system; writable paths are size-limited emptyDirs | applied | Pod security > Immutable container file systems | 5.7.3 |  |
| Minimal, patched base images; images scanned for vulnerabilities (containerizer gate) | applied | Pod security > Building secure container images |  |  |
| Only signed images run | cluster action | Pod security > Building secure container images | 5.5.1 | Sign each pushed image (cosign sign --yes <registry>/<image>@<digest>) and enforce it with cluster/verify-images.yaml (Kyverno) or your admission controller. |
| Images are deployed by digest | not applied | Pod security > Building secure container images |  | In the deploy pipeline: kustomize edit set image <image>=<registry>/<image>@sha256:<digest>; base images: generate --pin-digests. Now: image-digest: image localhost:5000/sandbox/containerization-challenge-retail-backoffice/vanarsdel-allocation-api:1.20261107.200 is not pinned to a digest (vanarsdel-allocation-api: Deployment/vanarsdel-allocation-api/vanarsdel-allocation-api); image-digest: image localhost:5000/sandbox/containerization-challenge-retail-backoffice/vanarsdel-backoffice:1.20261107.200 is not pinned to a digest (vanarsdel-backoffice: Deployment/vanarsdel-backoffice/vanarsdel-backoffice); image-digest: image localhost:5000/sandbox/containerization-challenge-retail-backoffice/vanarsdel-catalog-api:1.20261107.200 is not pinned to a digest (vanarsdel-catalog-api: Deployment/vanarsdel-catalog-api/vanarsdel-catalog-api); image-digest: image localhost:5000/sandbox/containerization-challenge-retail-backoffice/vanarsdel-customers-api:1.20261107.200 is not pinned to a digest (vanarsdel-customers-api: Deployment/vanarsdel-customers-api/vanarsdel-customers-api) |
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
| vanarsdel-allocation-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-backoffice | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-catalog-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-customers-api | sql-server,mongodb,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-gateway | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-inventory-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-notifications | sql-server,redis,rabbitmq,azure-service-bus,smtp,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-orders-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-pricing-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-returns-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-scheduler | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |
| vanarsdel-storemanager | seq,configured-ports |
| vanarsdel-storeops-api | sql-server,redis,rabbitmq,azure-service-bus,seq,http-apis,configured-ports,lab-sqlserver,lab-rabbitmq |

## Secret store keys

Put these in the secret store before the first sync (docs/external-secrets.md); External Secrets Operator copies them into the Secrets the workloads use. If one property is missing, that whole Secret is not created; the references are optional, so the pod still starts, without its values.

| Remote key | Property | Component | Secret |
| --- | --- | --- | --- |
| `containerization-challenge-retail-backoffice--cz-lab-rabbitmq` | every key | lab | `lab-rabbitmq` |
| `containerization-challenge-retail-backoffice--cz-lab-sqlserver` | every key | lab | `lab-sqlserver` |
| `containerization-challenge-retail-backoffice--vanarsdel-allocation-api` | `ConnectionStrings__Allocation` | vanarsdel-allocation-api | `vanarsdel-allocation-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-allocation-api` | `Messaging__Password` | vanarsdel-allocation-api | `vanarsdel-allocation-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-allocation-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-allocation-api | `vanarsdel-allocation-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-allocation-api` | `ServiceIdentity__ClientSecret` | vanarsdel-allocation-api | `vanarsdel-allocation-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-backoffice` | `Oidc__Providers__0__ClientSecret` | vanarsdel-backoffice | `vanarsdel-backoffice-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-backoffice` | `Oidc__Providers__1__ClientSecret` | vanarsdel-backoffice | `vanarsdel-backoffice-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-backoffice` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-backoffice | `vanarsdel-backoffice-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-catalog-api` | `ConnectionStrings__Catalog` | vanarsdel-catalog-api | `vanarsdel-catalog-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-catalog-api` | `Messaging__Password` | vanarsdel-catalog-api | `vanarsdel-catalog-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-catalog-api` | `Search__Elasticsearch__Password` | vanarsdel-catalog-api | `vanarsdel-catalog-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-catalog-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-catalog-api | `vanarsdel-catalog-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-catalog-api` | `ServiceIdentity__ClientSecret` | vanarsdel-catalog-api | `vanarsdel-catalog-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-customers-api` | `ConnectionStrings__CustomersMongo` | vanarsdel-customers-api | `vanarsdel-customers-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-customers-api` | `ConnectionStrings__Customers` | vanarsdel-customers-api | `vanarsdel-customers-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-customers-api` | `Messaging__Password` | vanarsdel-customers-api | `vanarsdel-customers-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-customers-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-customers-api | `vanarsdel-customers-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-customers-api` | `ServiceIdentity__ClientSecret` | vanarsdel-customers-api | `vanarsdel-customers-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-gateway` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-gateway | `vanarsdel-gateway-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-inventory-api` | `ConnectionStrings__Inventory` | vanarsdel-inventory-api | `vanarsdel-inventory-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-inventory-api` | `Kestrel__Endpoints__Https__Certificate__Password` | vanarsdel-inventory-api | `vanarsdel-inventory-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-inventory-api` | `Messaging__Password` | vanarsdel-inventory-api | `vanarsdel-inventory-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-inventory-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-inventory-api | `vanarsdel-inventory-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-inventory-api` | `ServiceIdentity__ClientSecret` | vanarsdel-inventory-api | `vanarsdel-inventory-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-inventory-api` | `inventory.corp.local.pfx` | vanarsdel-inventory-api | `vanarsdel-inventory-api-files` |
| `containerization-challenge-retail-backoffice--vanarsdel-notifications` | `ConnectionStrings__Notifications` | vanarsdel-notifications | `vanarsdel-notifications-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-notifications` | `Messaging__Password` | vanarsdel-notifications | `vanarsdel-notifications-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-notifications` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-notifications | `vanarsdel-notifications-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-notifications` | `ServiceIdentity__ClientSecret` | vanarsdel-notifications | `vanarsdel-notifications-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-orders-api` | `ConnectionStrings__Orders` | vanarsdel-orders-api | `vanarsdel-orders-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-orders-api` | `Messaging__Password` | vanarsdel-orders-api | `vanarsdel-orders-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-orders-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-orders-api | `vanarsdel-orders-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-orders-api` | `ServiceIdentity__ClientSecret` | vanarsdel-orders-api | `vanarsdel-orders-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-orders-api` | `WebShopBus__ConnectionString` | vanarsdel-orders-api | `vanarsdel-orders-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-pricing-api` | `ConnectionStrings__Pricing` | vanarsdel-pricing-api | `vanarsdel-pricing-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-pricing-api` | `Messaging__Password` | vanarsdel-pricing-api | `vanarsdel-pricing-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-pricing-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-pricing-api | `vanarsdel-pricing-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-pricing-api` | `ServiceIdentity__ClientSecret` | vanarsdel-pricing-api | `vanarsdel-pricing-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `ConnectionStrings__Returns` | vanarsdel-returns-api | `vanarsdel-returns-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `Messaging__Password` | vanarsdel-returns-api | `vanarsdel-returns-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `Returns__CarrierApiKey` | vanarsdel-returns-api | `vanarsdel-returns-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `Returns__CarrierWebhookSecret` | vanarsdel-returns-api | `vanarsdel-returns-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-returns-api | `vanarsdel-returns-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `ServiceIdentity__ClientSecret` | vanarsdel-returns-api | `vanarsdel-returns-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-returns-api` | `psp-merchant.pfx` | vanarsdel-returns-api | `vanarsdel-returns-api-files` |
| `containerization-challenge-retail-backoffice--vanarsdel-scheduler` | `ConnectionStrings__Quartz` | vanarsdel-scheduler | `vanarsdel-scheduler-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-scheduler` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-scheduler | `vanarsdel-scheduler-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-scheduler` | `ServiceIdentity__ClientSecret` | vanarsdel-scheduler | `vanarsdel-scheduler-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-storemanager` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-storemanager | `vanarsdel-storemanager-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-storeops-api` | `ConnectionStrings__StoreOps` | vanarsdel-storeops-api | `vanarsdel-storeops-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-storeops-api` | `Messaging__Password` | vanarsdel-storeops-api | `vanarsdel-storeops-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-storeops-api` | `Serilog__WriteTo__1__Args__apiKey` | vanarsdel-storeops-api | `vanarsdel-storeops-api-secrets` |
| `containerization-challenge-retail-backoffice--vanarsdel-storeops-api` | `ServiceIdentity__ClientSecret` | vanarsdel-storeops-api | `vanarsdel-storeops-api-secrets` |

## Files

- `security.yaml`: default-deny NetworkPolicy, LimitRange and ResourceQuota for the namespace
- `namespace.yaml`: Pod Security Admission `restricted` (enforce, warn, audit)
- `<component>/k8s.yaml`: hardened workloads, own ServiceAccount, least-privilege NetworkPolicy, ExternalSecrets
- `cluster/audit-policy.yaml`, `cluster/verify-images.yaml`, `cluster/secret-store.yaml` (the secret store and this namespace's read access): for the cluster operator, not applied with the app
