# containerization-challenge-retail-backoffice: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 89/100 · confidence 1.0  
Stateless: yes

13/13 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| VanArsdel.Allocation.Api | web | net6.0 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.BackOffice | web | net6.0 | Ready with configuration (no code changes) | 88 | - |
| VanArsdel.Catalog.Api | web | netcoreapp3.1 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.Customers.Api | web | net5.0 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.Gateway | web | netcoreapp3.1 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.Inventory.Api | web | net5.0 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.Notifications | worker | net6.0 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.Orders.Api | web | net6.0 | Ready with configuration (no code changes) | 87 | - |
| VanArsdel.Pricing.Api | web | netcoreapp3.1 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.Returns.Api | web | net6.0 | Ready with configuration (no code changes) | 88 | - |
| VanArsdel.Scheduler | worker | net5.0 | Ready with configuration (no code changes) | 90 | - |
| VanArsdel.StoreManager | web | netcoreapp3.1 | Ready with configuration (no code changes) | 89 | - |
| VanArsdel.StoreOps.Api | web | netcoreapp3.1 | Ready with configuration (no code changes) | 89 | - |

### VanArsdel.Allocation.Api

`src/VanArsdel.Allocation.Api/VanArsdel.Allocation.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5204; entry=VanArsdel.Allocation.Api.dll; connection_strings=['Allocation']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Allocation.Api/VanArsdel.Allocation.Api.csproj: TargetFramework=net6.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Allocation.Api/web.config:14: <requestFiltering removeServerHeader="true">`

### VanArsdel.BackOffice

`src/VanArsdel.BackOffice/VanArsdel.BackOffice.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health/live; port=5210; entry=VanArsdel.BackOffice.dll

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.BackOffice/VanArsdel.BackOffice.csproj: TargetFramework=net6.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.BackOffice/web.config:14: <requestFiltering removeServerHeader="true">`
- ⚙ **Blazor Server (interactive server rendering)** [config]
  - Why: Each user has a stateful circuit over a WebSocket held by one pod. With several replicas the ingress must keep users on their pod, and circuits are lost when a pod restarts or is rescheduled.
  - Fix: Enable cookie-based session affinity and WebSockets (long proxy timeouts) on the ingress, persist Data Protection keys, and use graceful shutdown/reconnect UI; or Azure SignalR Service.
  - Learn more: [learn.microsoft.com: server](https://learn.microsoft.com/en-us/aspnet/core/blazor/host-and-deploy/server)
  - Evidence: `src/VanArsdel.BackOffice/Program.cs:73: builder.Services.AddServerSideBlazor();`

### VanArsdel.Catalog.Api

`src/VanArsdel.Catalog.Api/VanArsdel.Catalog.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5201; entry=VanArsdel.Catalog.Api.dll; connection_strings=['Catalog']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Catalog.Api/VanArsdel.Catalog.Api.csproj: TargetFramework=netcoreapp3.1`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Catalog.Api/web.config:14: <requestFiltering removeServerHeader="true">`

### VanArsdel.Customers.Api

`src/VanArsdel.Customers.Api/VanArsdel.Customers.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5206; entry=VanArsdel.Customers.Api.dll; connection_strings=['Customers', 'CustomersMongo']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Customers.Api/VanArsdel.Customers.Api.csproj: TargetFramework=net5.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Customers.Api/web.config:14: <requestFiltering removeServerHeader="true">`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/VanArsdel.Customers.Api/Documents/LiteDbCustomerStore.cs:21: if (!string.IsNullOrEmpty(dir)) Directory.CreateDirectory(dir);`

### VanArsdel.Gateway

`src/VanArsdel.Gateway/VanArsdel.Gateway.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5000; entry=VanArsdel.Gateway.dll

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Gateway/VanArsdel.Gateway.csproj: TargetFramework=netcoreapp3.1`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Gateway/web.config:14: <requestFiltering removeServerHeader="true">`

### VanArsdel.Inventory.Api

`src/VanArsdel.Inventory.Api/VanArsdel.Inventory.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5001; entry=VanArsdel.Inventory.Api.dll; connection_strings=['Inventory']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Inventory.Api/VanArsdel.Inventory.Api.csproj: TargetFramework=net5.0`
- ⚙ **gRPC server (HTTP/2)** [config]
  - Why: gRPC needs HTTP/2. Behind an ingress without TLS to the pod, Kestrel must accept cleartext HTTP/2 (h2c), which an Http1AndHttp2 endpoint does not do without TLS; the ingress also needs the gRPC backend protocol, and HTTP probes do not work on an HTTP/2-only port.
  - Fix: Expose an Http2 endpoint (Kestrel__Endpoints__Grpc__Protocols=Http2) next to an HTTP/1 port for probes, set the ingress backend protocol to GRPC/h2c, use gRPC health checks (Grpc.AspNetCore.HealthChecks + grpc probes), or gRPC-Web for browsers.
  - Learn more: [learn.microsoft.com: aspnetcore](https://learn.microsoft.com/en-us/aspnet/core/grpc/aspnetcore), [learn.microsoft.com: health checks](https://learn.microsoft.com/en-us/aspnet/core/grpc/health-checks)
  - Evidence: `src/VanArsdel.Inventory.Api/Startup.cs:30: services.AddGrpc(o => o.EnableDetailedErrors = Configuration.GetValue("Grpc:DetailedErrors", false));`

### VanArsdel.Notifications

`src/VanArsdel.Notifications/VanArsdel.Notifications.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=VanArsdel.Notifications.dll; connection_strings=['Notifications']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Notifications/VanArsdel.Notifications.csproj: TargetFramework=net6.0`

### VanArsdel.Orders.Api

`src/VanArsdel.Orders.Api/VanArsdel.Orders.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5205; entry=VanArsdel.Orders.Api.dll; connection_strings=['Orders']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Orders.Api/VanArsdel.Orders.Api.csproj: TargetFramework=net6.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Orders.Api/web.config:14: <requestFiltering removeServerHeader="true">`
- ⚙ **Windows certificate store** [config]
  - Why: Certificates are looked up in the Windows certificate store (LocalMachine\My). On Linux the .NET X509Store is a per-user directory, empty in a fresh container.
  - Fix: Mount the certificate (PFX/PEM) from a Secret and load it from a file path; use cert-manager for TLS at the ingress.
  - Learn more: [learn.microsoft.com: cross platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography)
  - Evidence: `src/VanArsdel.Orders.Api/Integration/PaymentClient.cs:61: using (var store = new X509Store(StoreName.My, StoreLocation.LocalMachine))`

### VanArsdel.Pricing.Api

`src/VanArsdel.Pricing.Api/VanArsdel.Pricing.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5202; entry=VanArsdel.Pricing.Api.dll; connection_strings=['Pricing']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Pricing.Api/VanArsdel.Pricing.Api.csproj: TargetFramework=netcoreapp3.1`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Pricing.Api/web.config:14: <requestFiltering removeServerHeader="true">`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/VanArsdel.Pricing.Api/Data/Db.cs:63: if (!string.IsNullOrEmpty(dir)) Directory.CreateDirectory(dir);`

### VanArsdel.Returns.Api

`src/VanArsdel.Returns.Api/VanArsdel.Returns.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5207; entry=VanArsdel.Returns.Api.dll; connection_strings=['Returns']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Returns.Api/VanArsdel.Returns.Api.csproj: TargetFramework=net6.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.Returns.Api/web.config:14: <requestFiltering removeServerHeader="true">`

### VanArsdel.Scheduler

`src/VanArsdel.Scheduler/VanArsdel.Scheduler.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=VanArsdel.Scheduler.dll; connection_strings=['Quartz']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.Scheduler/VanArsdel.Scheduler.csproj: TargetFramework=net5.0`

### VanArsdel.StoreManager

`src/VanArsdel.StoreManager/VanArsdel.StoreManager.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5211; entry=VanArsdel.StoreManager.dll; writable_dirs=['wwwroot']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
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

### VanArsdel.StoreOps.Api

`src/VanArsdel.StoreOps.Api/VanArsdel.StoreOps.Api.csproj` · web · Ready with configuration (no code changes)

Facts: port=5208; entry=VanArsdel.StoreOps.Api.dll; connection_strings=['StoreOps']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It is containerized without code changes: it runs on its own runtime image, which Microsoft no longer patches (or, where there is none, rolls forward onto the supported .NET 10 runtime).
  - Fix: Nothing to change in code: the generated Dockerfile builds the project for the framework it targets and runs it on that framework's runtime image. Keep the target framework; upgrading .NET is a separate project, not part of containerizing the application.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/VanArsdel.StoreOps.Api/VanArsdel.StoreOps.Api.csproj: TargetFramework=netcoreapp3.1`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/VanArsdel.StoreOps.Api/web.config:14: <requestFiltering removeServerHeader="true">`
