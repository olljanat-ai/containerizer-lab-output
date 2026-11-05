# containerization-challenge-trade-rebates: containerization assessment

**Rating A** - Container-ready - modern, stateless stack; containers with configuration only, no code changes  
Readiness score 87/100 · confidence 1.0  
Stateless: yes

1/1 server components can run in Linux containers with configuration only.

## Components

| Component | Role | Target | Verdict | Score | Windows container stop-gap |
| --- | --- | --- | --- | --- | --- |
| TradeRebates.StatementWorker | console | net8.0 | Ready with configuration (no code changes) | 87 | - |

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
