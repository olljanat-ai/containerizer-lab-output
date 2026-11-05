# containerization-challenge-expense-claims: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 88/100 · confidence 1.0  
Stateless: yes

2/2 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| ExpenseClaims.Api | web | net6.0 | Ready with configuration (no code changes) | 89 | - |
| ExpenseClaims.Jobs | web | net10.0 | Ready with configuration (no code changes) | 88 | - |

### ExpenseClaims.Api

`src/ExpenseClaims.Api/ExpenseClaims.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5241; entry=ExpenseClaims.Api.dll; connection_strings=['ExpenseClaims']

- ⚙ **Out-of-support .NET runtime** [config]
  - Why: Targets an out-of-support .NET version. It can still be containerized without code changes by rolling forward onto the supported .NET 10 runtime (DOTNET_ROLL_FORWARD=Major) or by publishing with -p:TargetFramework=net10.0.
  - Fix: The generated Dockerfile builds with the .NET 10 SDK and runs on the .NET 10 runtime with roll-forward; retarget to net10.0 when convenient.
  - Learn more: [dotnet.microsoft.com: dotnet core](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), [learn.microsoft.com: selection](https://learn.microsoft.com/en-us/dotnet/core/versions/selection)
  - Evidence: `src/ExpenseClaims.Api/ExpenseClaims.Api.csproj: TargetFramework=net6.0`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/ExpenseClaims.Api/Services/ReceiptStore.cs:41: Directory.CreateDirectory(Path.GetDirectoryName(full)!);`
- ⚙ **Windows drive paths as defaults in code** [config]
  - Why: Paths like @"D:\Data\Import" are not paths on Linux: the whole string becomes one oddly named relative file in the (read-only) working directory, so reads fail with FileNotFound and writes fail. As option defaults or fallbacks (?? @"D:\...") they apply whenever the setting is not configured.
  - Fix: Set the corresponding settings to Linux paths on mounted volumes with environment variables (Section__Key=/data/...); better, change the defaults to relative or Linux-friendly paths.
  - Learn more: [learn.microsoft.com: system.io.path.directoryseparatorchar](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.directoryseparatorchar), [learn.microsoft.com: configuration](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/)
  - Evidence: `src/ExpenseClaims.Api/Services/ReceiptStore.cs:10: public string RootPath { get; set; } = @"D:\ExpenseReceipts";`

### ExpenseClaims.Jobs

`src/ExpenseClaims.Jobs/ExpenseClaims.Jobs.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5251; entry=ExpenseClaims.Jobs.dll; connection_strings=['ExpenseClaims']

- ⚙ **Windows certificate store** [config]
  - Why: Certificates are looked up in the Windows certificate store (LocalMachine\My). On Linux the .NET X509Store is a per-user directory, empty in a fresh container.
  - Fix: Mount the certificate (PFX/PEM) from a Secret and load it from a file path; use cert-manager for TLS at the ingress.
  - Learn more: [learn.microsoft.com: cross platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography)
  - Evidence: `src/ExpenseClaims.Jobs/Bank/BankGatewayClient.cs:55: using var store = new X509Store(StoreName.My, StoreLocation.LocalMachine);`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/ExpenseClaims.Jobs/Bank/PaymentRunService.cs:68: Directory.CreateDirectory(_options.OutboundFolder);`
- ⚙ **Calls other services with the process's Windows credentials** [config]
  - Why: HttpClient/WebClient/SmtpClient/proxy calls with UseDefaultCredentials or CredentialCache.DefaultCredentials authenticate as the Windows service account. A Linux container has no Windows logon: without a Kerberos ticket the calls go out anonymous and get 401/407, or mail relays reject them.
  - Fix: Use explicit credentials from a Secret (basic/OAuth/API key), or provide a Kerberos keytab plus krb5.conf and keep a ticket fresh (kinit sidecar) so Negotiate works.
  - Learn more: [learn.microsoft.com: windowsauth](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/windowsauth)
  - Evidence: `src/ExpenseClaims.Jobs/Program.cs:70: ? CredentialCache.DefaultNetworkCredentials`
