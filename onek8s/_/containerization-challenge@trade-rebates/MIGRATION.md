# containerization-challenge-trade-rebates: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 88/100 · confidence 1.0  
Stateless: yes

3/3 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| TradeRebates.Api | web | net8.0 | Ready with configuration (no code changes) | 89 | - |
| TradeRebates.Portal | web | net8.0 | Ready with configuration (no code changes) | 88 | - |
| TradeRebates.StatementWorker | console | net8.0 | Ready with configuration (no code changes) | 87 | - |

### TradeRebates.Api

`src/TradeRebates.Api/TradeRebates.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/ping; entry=TradeRebates.Api.dll; connection_strings=['TradeRebates']

- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/TradeRebates.Api/web.config:14: <requestFiltering>`
- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/TradeRebates.Api/appsettings.json:3: "TradeRebates": "Server=rebates-sql.corp.local;Database=TradeRebates;Integrated Security=true;Encrypt=true;TrustServerCertificate=true;Application Name=TradeReb`

### TradeRebates.Portal

`src/TradeRebates.Portal/TradeRebates.Portal.csproj` · web · Ready with configuration (no code changes)

Facts: entry=TradeRebates.Portal.dll; connection_strings=['TradeRebates']

- ⚙ **Negotiate (Kerberos) authentication on ASP.NET Core** [config]
  - Why: Negotiate works on Linux only with Kerberos: a keytab for the service SPN mounted as a Secret, krb5.conf and the gss-ntlmssp/krb5 libraries in the image. Role (group) lookup on Linux needs LDAP settings.
  - Fix: Add krb5 libs to the image, mount KRB5_KTNAME keytab, configure EnableLdap; or switch to OIDC.
  - Learn more: [learn.microsoft.com: windowsauth](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/windowsauth)
  - Evidence: `src/TradeRebates.Portal/TradeRebates.Portal.csproj: package Microsoft.AspNetCore.Authentication.Negotiate 8.0.33`
- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/TradeRebates.Portal/appsettings.json:3: "TradeRebates": "Server=rebates-sql.corp.local;Database=TradeRebates;Integrated Security=true;Encrypt=true;TrustServerCertificate=true;Application Name=TradeReb`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/TradeRebates.Portal/Pages/Claims/Upload.cshtml.cs:39: Directory.CreateDirectory(options.Value.WorkbookUploadFolder);`

### TradeRebates.StatementWorker

`src/TradeRebates.StatementWorker/TradeRebates.StatementWorker.csproj` · console · Ready with configuration (no code changes)

Facts: entry=TradeRebates.StatementWorker.dll; connection_strings=['TradeRebates']

- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/TradeRebates.StatementWorker/appsettings.json:3: "TradeRebates": "Server=rebates-sql.corp.local;Database=TradeRebates;Integrated Security=true;Encrypt=true;TrustServerCertificate=true;Application Name=TradeReb`
- ⚙ **Windows file shares (UNC paths)** [config]
  - Why: UNC paths (\\server\share) only work on Windows with SMB credentials of the process identity.
  - Fix: Mount the share as a Kubernetes volume (SMB CSI driver with a credentials Secret) and point the setting to the mount path.
  - Learn more: [github.com: csi driver smb](https://github.com/kubernetes-csi/csi-driver-smb)
  - Evidence: `src/TradeRebates.StatementWorker/appsettings.json:9: "Root": "\\\\rebates-files.corp.local\\Rebates$\\Statements",`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/TradeRebates.StatementWorker/StatementFileWriter.cs:22: Directory.CreateDirectory(folder);`
