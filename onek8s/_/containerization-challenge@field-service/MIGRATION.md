# containerization-challenge-field-service: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 88/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| FieldService.Worker | worker | net8.0 | Ready with configuration (no code changes) | 88 | - |

### FieldService.Worker

`src/FieldService.Worker/FieldService.Worker.csproj` · worker · Ready with configuration (no code changes)

Facts: entry=FieldService.Worker.dll; connection_strings=['FieldService']

- ⚙ **SQL Server Windows authentication** [config]
  - Why: Integrated Security uses the Windows service account. From Linux it needs Kerberos (keytab) or a switch to SQL/Entra authentication.
  - Fix: Switch to SQL authentication or Entra managed identity with the password from a Secret.
  - Evidence: `src/FieldService.Worker/appsettings.json:13: "FieldService": "Server=FSSQL01\\FIELDSERVICE;Database=FieldService;Integrated Security=true;TrustServerCertificate=true"`
- ⚙ **Windows file shares (UNC paths)** [config]
  - Why: UNC paths (\\server\share) only work on Windows with SMB credentials of the process identity.
  - Fix: Mount the share as a Kubernetes volume (SMB CSI driver with a credentials Secret) and point the setting to the mount path.
  - Learn more: [github.com: csi driver smb](https://github.com/kubernetes-csi/csi-driver-smb)
  - Evidence: `src/FieldService.Worker/appsettings.json:16: "InboxFolder": "\\\\fsfile01\\FieldService\\Inbox",`
- ⚙ **Writes to the local file system** [config]
  - Why: Files written in the container are lost on restart and not shared between replicas, and the image's app folder is read-only for the non-root user.
  - Fix: Mount volumes (emptyDir for scratch/logs, PVC or object storage for data) at the paths the app writes to; log to stdout.
  - Learn more: [kubernetes.io: volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
  - Evidence: `src/FieldService.Worker/Jobs/FolderLock.cs:17: Directory.CreateDirectory(folder);`
