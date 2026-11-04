# Lab services of containerization-challenge-consumer-loans

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-consumer-loans--cz-lab-sqlserver`).
- Database and login `containerization_challenge_consumer_loans`, owner of that database only.
- **Lucerne.Lending.CustomerPortal**: `ConnectionStrings__PortalIdentity`
- **Lucerne.Lending.Documents**: `ConnectionStrings__Lending`
