# containerization-challenge-batch-release: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 88/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| BatchRelease.Api | web | net8.0 | Ready with configuration (no code changes) | 88 | - |

### BatchRelease.Api

`src/BatchRelease.Api/BatchRelease.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; entry=BatchRelease.Api.dll; connection_strings=['BatchRelease']

- ⚙ **IIS modules configured in web.config** [config]
  - Why: URL rewrite, redirects, IP restrictions and request filtering in web.config are executed by IIS modules; Kestrel in a Linux container ignores them, so those rules silently stop applying.
  - Fix: Recreate as ingress-controller rules (NGINX/Gateway API) or ASP.NET Core middleware (UseRewriter can load IIS rewrite rules).
  - Learn more: [learn.microsoft.com: url rewriting](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/url-rewriting)
  - Evidence: `src/BatchRelease.Api/web.config:10: <requestFiltering>`
- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/BatchRelease.Api/appsettings.json:11: "BatchRelease": "Server=release-sql.corp.local;Database=BatchRelease;Integrated Security=true;Encrypt=true;TrustServerCertificate=false;Application Name=Batch R`
- ⚙ **Calls other services with the process's Windows credentials** [config] (in library BatchRelease.Contracts)
  - Why: HttpClient/WebClient/SmtpClient/proxy calls with UseDefaultCredentials or CredentialCache.DefaultCredentials authenticate as the Windows service account. A Linux container has no Windows logon: without a Kerberos ticket the calls go out anonymous and get 401/407, or mail relays reject them.
  - Fix: Use explicit credentials from a Secret (basic/OAuth/API key), or provide a Kerberos keytab plus krb5.conf and keep a ticket fresh (kinit sidecar) so Negotiate works.
  - Learn more: [learn.microsoft.com: windowsauth](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/windowsauth)
  - Evidence: `src/BatchRelease.Contracts/SigningHostClient.cs:138: UseDefaultCredentials = true,`

## Libraries with notable findings

- BatchRelease.Vault: NTFS ACLs / EFS encryption, Win32 kernel/OLE/system DLL native calls, Windows security / directory native APIs, Windows-specific target framework (-windows)
