# Lab services of containerization-challenge-furnace-records

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-furnace-records--cz-lab-sqlserver`).
- Database and login `containerization_challenge_furnace_records`, owner of that database only.
- **FurnaceRecords.Api**: `ConnectionStrings__FurnaceRecords`
- **FurnaceRecords.Worker**: `ConnectionStrings__FurnaceRecords`

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (every .sql file of deploy/sql/, by name), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `deploy/sql/01-create-database.sql`
- `deploy/sql/02-logins.sql`
- `deploy/sql/03-reference-data.sql`

- deploy/sql/01-create-database.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `IF DB_ID(N'FurnaceRecords') IS NULL`; `ALTER DATABASE [FurnaceRecords] SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;`; `USE [FurnaceRecords];`
- deploy/sql/02-logins.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [master];`; `IF SUSER_ID(N'$(WebAccount)') IS NULL CREATE LOGIN [$(WebAccount)] FROM WINDOWS;`; `USE [FurnaceRecords];`
- deploy/sql/03-reference-data.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [FurnaceRecords];`
