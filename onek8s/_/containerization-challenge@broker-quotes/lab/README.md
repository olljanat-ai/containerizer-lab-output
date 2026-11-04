# Lab services of containerization-challenge-broker-quotes

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-broker-quotes--cz-lab-sqlserver`).
- Database and login `containerization_challenge_broker_quotes`, owner of that database only.
- **Humongous.Documents**: `ConnectionStrings__Quoting`

## Needed but turned off

- **RabbitMQ** (Humongous.Documents): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.
