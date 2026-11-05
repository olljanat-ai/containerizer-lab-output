# Lab services of containerization-challenge-expense-claims

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-expense-claims--cz-lab-sqlserver`).
- Database and login `containerization_challenge_expense_claims`, owner of that database only.
- **ExpenseClaims.Api**: `ConnectionStrings__ExpenseClaims`
- **ExpenseClaims.Jobs**: `ConnectionStrings__ExpenseClaims`

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (in the order deploy/install-database.ps1 runs them), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `db/01-create-database.sql`
- `db/02-quartz-tables.sql`
- `db/03-expenseclaims-schema.sql`

- db/01-create-database.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `IF DB_ID(N'$(DatabaseName)') IS NULL`; `IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'expenses_app')`; `IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'expenses_jobs')`; `USE [$(DatabaseName)];`
