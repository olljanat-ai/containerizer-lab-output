# Lab services of containerization-challenge-study-data

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-study-data--cz-lab-sqlserver`).
- Database and login `containerization_challenge_study_data`, owner of that database only.
- **StudyData.Sponsor.Api**: `ConnectionStrings__StudyData`

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (every .sql file of deploy/sql/, by name), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `deploy/sql/01-create-database.sql`
- `deploy/sql/02-logins.sql`
- `deploy/sql/03-audit-protection.sql`

- deploy/sql/01-create-database.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `IF DB_ID(N'StudyData') IS NULL`; `USE [StudyData];`
- deploy/sql/02-logins.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [master];`; `IF SUSER_ID(N'$(Domain)\svc-studydata-web') IS NULL CREATE LOGIN [$(Domain)\svc-studydata-web] FROM WINDOWS WITH DEFAULT`; `USE [StudyData];`
- deploy/sql/03-audit-protection.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE [StudyData];`
