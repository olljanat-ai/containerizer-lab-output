# Lab services of containerization-challenge-control-tower

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-control-tower--cz-lab-sqlserver`).
- Database and login `containerization_challenge_control_tower`, owner of that database only.
- **ControlTower.CarrierGateway**: `ConnectionStrings__ControlTower`
- **ControlTower.Events**: `ConnectionStrings__ControlTower`
- **ControlTower.Telematics**: `ConnectionStrings__ControlTower`
- **ControlTower.Tower.Api**: `ConnectionStrings__ControlTower`

## Needed but turned off

- **RabbitMQ** (ControlTower.CarrierGateway, ControlTower.Events, ControlTower.Telematics, ControlTower.Tower.Api): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.
- **SFTP** (ControlTower.CarrierGateway, ControlTower.Events, ControlTower.Telematics, ControlTower.Tower.Api): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (every .sql file of db/, by name), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `db/00-Database.sql`
- `db/01-Schema.sql`
- `db/02-Logins.sql`
- `db/03-Hangfire.sql`
- `db/10-ReferenceData.sql`

- db/00-Database.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `EXEC sp_configure N'filestream access level', 2;`; `IF DB_ID(N'$(DatabaseName)') IS NULL`; `ALTER DATABASE [$(DatabaseName)] SET RECOVERY FULL;`; `IF DB_ID(N'ControlTowerIdentity') IS NULL`; `ALTER DATABASE [ControlTowerIdentity] SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;`
- db/01-Schema.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [ControlTower];`
- db/02-Logins.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [master];`; `DECLARE @logins TABLE (Name sysname, Pwd nvarchar(128));`; `USE [ControlTower];`; `USE [ControlTowerIdentity];`
- db/03-Hangfire.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [ControlTower];`
- db/10-ReferenceData.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [ControlTower];`
