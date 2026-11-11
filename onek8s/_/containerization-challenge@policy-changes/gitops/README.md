# Deploying containerization-challenge-policy-changes with GitOps

Commit the generated app folder (the one with `kustomization.yaml`) to `https://github.com/olljanat-ai/containerizer-lab-output.git` at
`onek8s/_/containerization-challenge@policy-changes` on `main`, then apply the Flux files below. They apply the manifests with tight
limits: only namespace `containerization-challenge-policy-changes`, Pod Security "restricted" on the namespace, pruning and drift correction on.

## Flux

```sh
kubectl apply -f flux/tenant.yaml          # platform admin: namespace, ServiceAccounts, RoleBinding, store access
kubectl apply -f flux/git/sync.yaml        # or flux/oci/sync.yaml, not both
kubectl apply -f flux/git/image-automation.yaml   # optional
```

- `tenant.yaml` is the only part that needs cluster rights. Everything else lives in `containerization-challenge-policy-changes` and is
  applied as ServiceAccount `containerization-challenge-policy-changes-reconciler`, bound to the built-in `admin` role in that
  namespace only. Run the controllers with `--no-cross-namespace-refs` and
  `--default-service-account` for a full lockdown.
- No credential is in these files. Each Secret Flux needs is an `ExternalSecret` that External Secrets
  Operator fills from the secret store (see `../HARDENING.md` and docs/external-secrets.md). Put these
  remote secrets in the store first:

  | Remote key | Keys | Used by |
  | --- | --- | --- |
  | `containerization-challenge-policy-changes--cz-git` | `identity` + `known_hosts` (deploy key), or `username` + `password` (token) | `GitRepository` (read-only; write for image automation) |
  | `containerization-challenge-policy-changes--cz-registry` | `.dockerconfigjson` | `OCIRepository`, `ImageRepository`, image pulls |
  | `containerization-challenge-policy-changes--cz-cosign-pub` | `cosign.pub` | `OCIRepository` signature check |

- `git/sync.yaml`: `GitRepository` with a read-only deploy key and a `Kustomization`
  (prune, wait, health checks). Set commit verification (`spec.verify`) when your commits are signed.
- `oci/sync.yaml`: the same, from an OCI artifact (`flux push artifact oci://<registry>/containerization-challenge-policy-changes/manifests:1.0.0
  --path=onek8s/_/containerization-challenge@policy-changes`), accepted only when signed with the cosign key in Secret `containerization-challenge-policy-changes-cosign-pub`.
- `git/image-automation.yaml`: `ImageRepository`, `ImagePolicy` (semver `>=1.0.0`) and
  `ImageUpdateAutomation`; the `$imagepolicy` markers in `kustomization.yaml` say what it may change.
  It needs a deploy key with write access, so keep it separate from the read-only sync key if you
  can.

Each component is a `HelmRelease` (`<component>/helmrelease.yaml`) of the shared chart
`charts/containerizer-app` at the root of this repository, read from the same `GitRepository`; its
`values` hold only what differs from the chart's defaults. helm-controller installs it with the
namespace's reconciler ServiceAccount, like the `Kustomization`.
