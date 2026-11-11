# containerizer-app

Shared Helm chart for one component of an application containerized by Containerizer. Each
component (`onek8s/_/<app>/<component>/`) is one release of this chart, installed by a Flux
`HelmRelease` in the application's namespace. The chart comes from the application's own
`GitRepository` (this repository), so it needs no Helm repository.

What every component gets, with the hardened defaults in `values.yaml`:

| Object | When |
| --- | --- |
| `ServiceAccount` (no token mounted) | always |
| `Deployment`, or `CronJob` with `kind: CronJob` | always |
| `NetworkPolicy`: DNS, the pods of the same application, plus the egress listed in values | always |
| `Service` (port 80 → `http`) | `port` set and `service.enabled` |
| `Ingress` (TLS, `containerizer.io/url`) | `port` set and `ingress.enabled` |
| `PersistentVolumeClaim` `<name>-<volume>` | each `volumes` entry with `persistentVolumeClaim` |
| `Password` generator + `ExternalSecret` `<name>-dataprotection` | `dataProtection.enabled` |
| `ExternalSecret` `<name>-<entry>` from the secret store | each `externalSecrets` entry |

Labels are `app.kubernetes.io/name` (the release name) and `app.kubernetes.io/part-of` (the
release namespace). They are also the selectors, so do not change them on a live release.

## Values

A component sets only what differs from `values.yaml`; typically:

```yaml
image:
  repository: localhost:5000/sandbox/<namespace>/<component>
  tag: 1.20261107.200 # {"$imagepolicy": "<namespace>:<component>:tag"}
env: [...]                       # as in a pod spec
port: 8080                       # omit for workers: no probes, Service or Ingress
probe: {type: tcpSocket}         # default httpGet /health
volumes:
- {name: tmp, mountPath: /tmp, emptyDir: {sizeLimit: 256Mi}}
ingress: {enabled: true, host: <component>-<namespace>.sandbox.lab}
networkPolicy:
  annotations: {containerizer.io/egress: sql-server}
  egress:
    publicPorts: [{port: 1433, protocol: TCP}]
    lab: [{service: sqlserver, port: 1433}]
dataProtection: {enabled: true, keyId: <uuid>}
externalSecrets:
- {name: secrets, keys: [ConnectionStrings__Default]}
```

See the comments in `values.yaml` for every value.

## Changing the chart

The `HelmRelease`s use `reconcileStrategy: ChartVersion`: bump `version` in `Chart.yaml` with every
change, or Flux keeps the chart it already has. Check the output with
`helm template <component> charts/containerizer-app -n <namespace> -f <values>` before you push.
