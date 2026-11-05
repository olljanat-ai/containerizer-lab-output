# Lab services of containerization-challenge-broker-quotes

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-broker-quotes--cz-lab-sqlserver`).
- Database and login `containerization_challenge_broker_quotes`, owner of that database only.
- **Humongous.Documents**: `ConnectionStrings__Quoting`

## Needed but turned off

- **RabbitMQ** (Humongous.Documents): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (every .sql file of deploy/sql/, by name), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `deploy/sql/001-databases-and-logins.sql`
- `deploy/sql/010-quoting-schema.sql`
- `deploy/sql/020-identity-schema.sql`
- `deploy/sql/030-reference-data.sql`

- deploy/sql/001-databases-and-logins.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `SET NOCOUNT ON;`; `IF DB_ID(N'HumongousIdentity') IS NULL`; `ALTER DATABASE HumongousQuoting SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;`; `IF SUSER_ID(N'hq_quoting') IS NULL`; `USE HumongousQuoting;` ...
