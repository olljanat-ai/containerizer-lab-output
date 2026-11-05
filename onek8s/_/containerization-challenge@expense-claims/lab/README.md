# Lab services of containerization-challenge-expense-claims

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-expense-claims--cz-lab-sqlserver`).
- Database and login `containerization_challenge_expense_claims`, owner of that database only.
- **ExpenseClaims.Api**: `ConnectionStrings__ExpenseClaims`
- **ExpenseClaims.Jobs**: `ConnectionStrings__ExpenseClaims`
