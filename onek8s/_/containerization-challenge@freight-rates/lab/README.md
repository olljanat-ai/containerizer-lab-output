# Lab services of containerization-challenge-freight-rates

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-freight-rates--cz-lab-sqlserver`).
- Database and login `containerization_challenge_freight_rates`, owner of that database only.
- **FreightRates.Api**: `ConnectionStrings__FreightRates`

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (every .sql file of deploy/sql/, by name), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `deploy/sql/create-logins.sql`

- deploy/sql/create-logins.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `IF DB_ID(N'FreightRates') IS NULL`; `USE FreightRates;`; `IF SUSER_ID(N'CORP\svc-freightrates') IS NULL`
