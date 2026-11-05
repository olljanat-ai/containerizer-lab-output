# containerization-challenge-control-tower: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 87/100 · confidence 1.0  
Stateless: yes

4/4 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| ControlTower.CarrierGateway | web | net6.0 | Ready with configuration (no code changes) | 87 | - |
| ControlTower.Events | worker | net6.0 | Ready with configuration (no code changes) | 88 | - |
| ControlTower.Telematics | worker | net7.0 | Ready with configuration (no code changes) | 88 | - |
| ControlTower.Tower.Api | web | net6.0 | Ready with configuration (no code changes) | 86 | - |

### ControlTower.CarrierGateway

`src/ControlTower.CarrierGateway/ControlTower.CarrierGateway.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; entry=ControlTower.CarrierGateway.dll; connection_strings=['ControlTower', 'RabbitMq']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/ControlTower.CarrierGateway/ControlTower.CarrierGateway.csproj: TargetFramework=net6.0`
- ⚙ **Secrets in configuration files** [config]
  - Why: Passwords or keys are committed in config files and would be baked into the image.
  - Fix: Remove them from the image (.dockerignore) and inject via Kubernetes Secrets as environment variables.
  - Learn more: [learn.microsoft.com: app secrets](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets), [kubernetes.io: secret](https://kubernetes.io/docs/concepts/configuration/secret/)
  - Evidence: `src/ControlTower.CarrierGateway/appsettings.Development.json:28: "PRCL": { "Mode": "Simulator", "WebhookSecret": "dev-webhook-secret" }`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/ControlTower.CarrierGateway/GatewayOptions.cs:20: Directory.CreateDirectory(path);`
- ⚙ **Windows drive paths as defaults in code** [config]
  - Why: Paths like @"D:\Data\Import" are not paths on Linux: the whole string becomes one oddly named relative file in the (read-only) working directory, so reads fail with FileNotFound and writes fail. As option defaults or fallbacks (?? @"D:\...") they apply whenever the setting is not configured.
  - Fix: Set the corresponding settings to Linux paths on mounted volumes with environment variables (Section__Key=/data/...); better, change the defaults to relative or Linux-friendly paths.
  - Learn more: [learn.microsoft.com: system.io.path.directoryseparatorchar](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.directoryseparatorchar), [learn.microsoft.com: configuration](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/)
  - Evidence: `src/ControlTower.CarrierGateway/GatewayOptions.cs:8: public string WorkFolder { get; set; } = @"D:\ControlTower\Edi";`
- ⚙ **Windows certificate store** [config] (in library ControlTower.Integration)
  - Why: Certificates are looked up in the Windows certificate store (LocalMachine\My). On Linux the .NET X509Store is a per-user directory, empty in a fresh container.
  - Fix: Mount the certificate (PFX/PEM) from a Secret and load it from a file path; use cert-manager for TLS at the ingress.
  - Learn more: [learn.microsoft.com: cross platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography)
  - Evidence: `src/ControlTower.Integration/Customs/WcfCustomsGateway.cs:113: using var store = new X509Store(StoreName.My, location);`

### ControlTower.Events

`src/ControlTower.Events/ControlTower.Events.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=ControlTower.Events.dll; connection_strings=['ControlTower', 'RabbitMq']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/ControlTower.Events/ControlTower.Events.csproj: TargetFramework=net6.0`
- · **Windows certificate store** [info] (in library ControlTower.Integration, not referenced by this component)
  - Why: Certificates are looked up in the Windows certificate store (LocalMachine\My). On Linux the .NET X509Store is a per-user directory, empty in a fresh container.
  - Fix: Mount the certificate (PFX/PEM) from a Secret and load it from a file path; use cert-manager for TLS at the ingress.
  - Learn more: [learn.microsoft.com: cross platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography)
  - Evidence: `src/ControlTower.Integration/Customs/WcfCustomsGateway.cs:113: using var store = new X509Store(StoreName.My, location);`

### ControlTower.Telematics

`src/ControlTower.Telematics/ControlTower.Telematics.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=ControlTower.Telematics.dll; connection_strings=['ControlTower', 'RabbitMq']; writable_dirs=['proseware/telematics']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/ControlTower.Telematics/ControlTower.Telematics.csproj: TargetFramework=net7.0`
- · **Windows certificate store** [info] (in library ControlTower.Integration, not referenced by this component)
  - Why: Certificates are looked up in the Windows certificate store (LocalMachine\My). On Linux the .NET X509Store is a per-user directory, empty in a fresh container.
  - Fix: Mount the certificate (PFX/PEM) from a Secret and load it from a file path; use cert-manager for TLS at the ingress.
  - Learn more: [learn.microsoft.com: cross platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography)
  - Evidence: `src/ControlTower.Integration/Customs/WcfCustomsGateway.cs:113: using var store = new X509Store(StoreName.My, location);`

### ControlTower.Tower.Api

`src/ControlTower.Tower.Api/ControlTower.Tower.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5180; entry=ControlTower.Tower.Api.dll; connection_strings=['ControlTower', 'RabbitMq']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/ControlTower.Tower.Api/ControlTower.Tower.Api.csproj: TargetFramework=net6.0`
- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/ControlTower.Tower.Api/web.config:15: <requestFiltering removeServerHeader="true" />`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/ControlTower.Tower.Api/Program.cs:122: if (!string.IsNullOrEmpty(folder)) Directory.CreateDirectory(folder);`
- ⚙ **SignalR without backplane** [config]
  - Why: With more than one replica, clients connected to other pods miss messages.
  - Fix: Add a Redis backplane or enable session affinity and run one replica.
  - Learn more: [learn.microsoft.com: scale](https://learn.microsoft.com/en-us/aspnet/core/signalr/scale)
  - Evidence: `src/ControlTower.Tower.Api/Program.cs:79: services.AddSignalR().AddJsonProtocol(o =>`
- · **Windows certificate store** [info] (in library ControlTower.Integration, not referenced by this component)
  - Why: Certificates are looked up in the Windows certificate store (LocalMachine\My). On Linux the .NET X509Store is a per-user directory, empty in a fresh container.
  - Fix: Mount the certificate (PFX/PEM) from a Secret and load it from a file path; use cert-manager for TLS at the ingress.
  - Learn more: [learn.microsoft.com: cross platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography)
  - Evidence: `src/ControlTower.Integration/Customs/WcfCustomsGateway.cs:113: using var store = new X509Store(StoreName.My, location);`
