# Lab services of containerization-challenge-field-service-refactor-192

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-field-service-refactor-192--cz-lab-sqlserver`).
- Database and login `containerization_challenge_field_service_refactor_192`, owner of that database only.
- **FieldService.Web**: `ConnectionStrings__FieldService`
- **FieldService.Worker**: `ConnectionStrings__FieldService`

## Needed but turned off

- **Redis** (FieldService.Web): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.
