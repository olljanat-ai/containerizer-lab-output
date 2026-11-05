# containerization-challenge-field-service: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 90/100 · confidence 1.0  
Stateless: yes

2/2 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| FieldService.Web | web | net8.0 | Ready with configuration (no code changes) | 89 | - |
| FieldService.Worker | worker | net8.0 | Ready with configuration (no code changes) | 90 | - |

### FieldService.Web

`src/FieldService.Web/FieldService.Web.csproj` · web · Ready with configuration (no code changes)

Facts: port=27089; entry=FieldService.Web.dll; connection_strings=['FieldService']

- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/FieldService.Web/web.config:14: <requestFiltering>`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/FieldService.Web/Services/PhotoStore.cs:35: await using var target = File.Create(Path.Combine(folder, storedName));`

### FieldService.Worker

`src/FieldService.Worker/FieldService.Worker.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=FieldService.Worker.dll; connection_strings=['FieldService']

- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/FieldService.Worker/Jobs/FolderLock.cs:19: Directory.CreateDirectory(lockFolder);`
