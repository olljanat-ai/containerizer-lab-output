# Lab services of containerization-challenge-city-permits

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-city-permits--cz-lab-sqlserver`).
- Database and login `containerization_challenge_city_permits`, owner of that database only.
- **CityPermits.Inspections**: `ConnectionStrings__Permits`
- **CityPermits.OpenData**: `ConnectionStrings__Permits`

## SQL Server: the repository's setup scripts

The lab agent runs these once into the app's database (in the order deploy/Install-Archive.ps1 runs them), as the app's own login, and again when they change or the database is made again. A batch that fails is reported on Admin -> Lab services and the rest goes on.
- `deploy/sql/03-filetable.sql`

- deploy/sql/03-filetable.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `USE CityPermits;`
