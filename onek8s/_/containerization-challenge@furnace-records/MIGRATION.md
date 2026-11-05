# containerization-challenge-furnace-records: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 88/100 · confidence 1.0  
Stateless: yes

2/2 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| FurnaceRecords.Api | web | net8.0 | Ready with configuration (no code changes) | 90 | - |
| FurnaceRecords.Worker | worker | net8.0 | Ready with configuration (no code changes) | 87 | - |

### FurnaceRecords.Api

`src/FurnaceRecords.Api/FurnaceRecords.Api.csproj` · web · Ready with configuration (no code changes)

Facts: health=/health; port=5210; entry=FurnaceRecords.Api.dll; connection_strings=['FurnaceRecords']

- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/FurnaceRecords.Api/appsettings.json:10: "FurnaceRecords": "Server=sql01.corp.local;Database=FurnaceRecords;Integrated Security=true;TrustServerCertificate=true;Application Name=Furnace Records API"`

### FurnaceRecords.Worker

`src/FurnaceRecords.Worker/FurnaceRecords.Worker.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=FurnaceRecords.Worker.dll; connection_strings=['FurnaceRecords']

- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/FurnaceRecords.Worker/appsettings.json:10: "FurnaceRecords": "Server=sql01.corp.local;Database=FurnaceRecords;Integrated Security=true;TrustServerCertificate=true;Application Name=Furnace Records Worker"`
- ⚙ **Windows file shares (UNC paths)** [config]
  - Why: UNC paths (\\server\share) only work on Windows with SMB credentials of the process identity.
  - Fix: Mount the share as a Kubernetes volume (SMB CSI driver with a credentials Secret) and point the setting to the mount path.
  - Learn more: [github.com: csi driver smb](https://github.com/kubernetes-csi/csi-driver-smb)
  - Evidence: `src/FurnaceRecords.Worker/appsettings.json:17: "CertificateFolder": "\\\\files01.corp.local\\FurnaceRecords$\\Certificates",`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/FurnaceRecords.Worker/CalibrationReminder.cs:111: Directory.CreateDirectory(_options.MailPickupFolder);`
- ⚙ **Calls other services with the process's Windows credentials** [config]
  - Why: HttpClient/WebClient/SmtpClient/proxy calls with UseDefaultCredentials or CredentialCache.DefaultCredentials authenticate as the Windows service account. A Linux container has no Windows logon: without a Kerberos ticket the calls go out anonymous and get 401/407, or mail relays reject them.
  - Fix: Use explicit credentials from a Secret (basic/OAuth/API key), or provide a Kerberos keytab plus krb5.conf and keep a ticket fresh (kinit sidecar) so Negotiate works.
  - Learn more: [learn.microsoft.com: windowsauth](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/windowsauth)
  - Evidence: `src/FurnaceRecords.Worker/CalibrationReminder.cs:108: using var smtp = new SmtpClient(_options.SmtpHost, _options.SmtpPort) { UseDefaultCredentials = true };`
- ⚙ **Mail is dropped into a pickup folder** [config]
  - Why: On the Windows server an SMTP service (IIS SMTP / Exchange pickup) drained the folder. In the container nothing reads it: mail is silently never sent, and the folder must be writable.
  - Fix: Configure network delivery to an SMTP relay (host, port and credentials from a Secret); keep the pickup folder only for test environments, on a mounted volume.
  - Learn more: [learn.microsoft.com: system.net.mail.smtpdeliverymethod](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.smtpdeliverymethod)
  - Evidence: `src/FurnaceRecords.Worker/CalibrationReminder.cs:112: smtp.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory;`

## Libraries with notable findings

- FurnaceRecords.Acquisition: COM interop with a registered component, Code marked Windows-only by its authors, OPC DA over DCOM
