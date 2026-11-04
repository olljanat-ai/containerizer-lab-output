# containerization-challenge-retail-backoffice: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 89/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| VanArsdel.StoreManager | web | netcoreapp3.1 | Ready with configuration (no code changes) | 89 | - |

### VanArsdel.StoreManager

`src/VanArsdel.StoreManager/VanArsdel.StoreManager.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5211; entry=VanArsdel.StoreManager.dll; writable_dirs=['wwwroot']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.StoreManager/VanArsdel.StoreManager.csproj: TargetFramework=netcoreapp3.1`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.StoreManager/web.config:14: <requestFiltering removeServerHeader="true">`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/VanArsdel.StoreManager/Startup.cs:38: Directory.CreateDirectory(appFolder);`
