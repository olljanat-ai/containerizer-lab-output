# Lab services of containerization-challenge-retail-backoffice

The appliance runs these services in namespace `containerizer-lab` (Admin -> Lab services). The app's configuration is overridden with environment variables; its code is unchanged. Credentials come from the secret store through External Secrets Operator.

## SQL Server

- Host `sqlserver.containerizer-lab.svc.cluster.local`, port 1433 (SQL Server 2025 Developer edition).
- Credentials: Secret `lab-sqlserver` (ExternalSecret, remote key `containerization-challenge-retail-backoffice--cz-lab-sqlserver`).
- Database and login `containerization_challenge_retail_backoffice`, owner of that database only.
- **VanArsdel.Allocation.Api**: `ConnectionStrings__Allocation`
- **VanArsdel.BackOffice**: `ConnectionStrings__DefaultConnection`
- **VanArsdel.Catalog.Api**: `ConnectionStrings__Catalog`
- **VanArsdel.Customers.Api**: `ConnectionStrings__Customers`
- **VanArsdel.Gateway**: `ConnectionStrings__DefaultConnection`
- **VanArsdel.Inventory.Api**: `ConnectionStrings__Inventory`
- **VanArsdel.Notifications**: `ConnectionStrings__Notifications`
- **VanArsdel.Orders.Api**: `ConnectionStrings__Orders`
- **VanArsdel.Pricing.Api**: `ConnectionStrings__Pricing`
- **VanArsdel.Returns.Api**: `ConnectionStrings__Returns`
- **VanArsdel.Scheduler**: `ConnectionStrings__Quartz`
- **VanArsdel.StoreOps.Api**: `ConnectionStrings__StoreOps`

## Needed but turned off

- **Redis** (VanArsdel.Allocation.Api, VanArsdel.BackOffice, VanArsdel.Catalog.Api, VanArsdel.Customers.Api, VanArsdel.Gateway, VanArsdel.Inventory.Api, VanArsdel.Notifications, VanArsdel.Orders.Api, VanArsdel.Pricing.Api, VanArsdel.Returns.Api, VanArsdel.Scheduler, VanArsdel.StoreOps.Api): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.
- **RabbitMQ** (VanArsdel.Allocation.Api, VanArsdel.BackOffice, VanArsdel.Catalog.Api, VanArsdel.Customers.Api, VanArsdel.Gateway, VanArsdel.Inventory.Api, VanArsdel.Notifications, VanArsdel.Orders.Api, VanArsdel.Pricing.Api, VanArsdel.Returns.Api, VanArsdel.Scheduler, VanArsdel.StoreOps.Api): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.
- **MongoDB** (VanArsdel.Customers.Api): turn it on under Admin -> Lab services and scan again; until then the app keeps its own settings.

## SQL Server: the repository's setup scripts

Found, but not run:
- `db/00-databases.sql`

- db/00-databases.sql: left out (the lab makes the database and the login itself, or it needs server-wide rights): `SET NOCOUNT ON;`
