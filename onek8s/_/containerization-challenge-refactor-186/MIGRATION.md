# containerization-challenge-parts-catalog-refactor-186: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 90/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| PartsCatalog | web | net8.0 | Ready with configuration (no code changes) | 90 | - |

### PartsCatalog

`src/PartsCatalog/PartsCatalog.csproj` · web · Ready with configuration (no code changes)

Facts: health=/ping; port=5080; entry=PartsCatalog.dll; connection_strings=['Catalog']; writable_dirs=['App_Data', 'logs']

- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/PartsCatalog/Program.cs:24: Directory.CreateDirectory(Path.Combine(app.Environment.ContentRootPath, dataFolder));`
