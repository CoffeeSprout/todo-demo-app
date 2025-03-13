# Persisting Todo Items with a Database

## Objective
In this exercise, you'll migrate the Todo application from in-memory storage to a PostgreSQL database using Hibernate ORM with Panache. You'll modify the Todo entity, update the REST resource, and configure the database connection.

## What's Missing
The application has been partially migrated to use a database, but some key components are incomplete:

1. **Entity Mapping**:
   - The `Todo.java` file has been converted to a Panache entity
   - Some database-related methods are incomplete or missing

2. **Repository Layer**:
   - We're using the Active Record pattern with Panache
   - Some query methods need to be implemented

3. **Transaction Management**:
   - The REST endpoints need proper transaction annotations
   - Some operations are missing proper transaction handling

## Steps to Complete

1. Examine the database configuration:
   - Look at `src/main/kubernetes/cloudnativepg-database.yaml` to understand the database setup
   - Check `src/main/resources/application.properties` for database connection properties

2. Complete the Todo entity (Todo.java):
   - Review the existing Panache entity structure
   - Implement the missing database query methods that were in the in-memory version

3. Ensure proper transaction management in TodoResource.java:
   - Add missing `@Transactional` annotations where needed
   - Review existing database operations

4. Review and understand the import.sql file:
   - This file contains initial data loaded when the application starts
   - Note how the database sequence is managed

5. Deploy and test the application:
   ```bash
   ./src/main/kubernetes/build-container.sh
   ./src/main/kubernetes/deploy.sh
   ```

## Reference Information

### Hibernate Panache
- Active Record pattern: Entity classes have query methods built-in
- Panache provides a simple API for common database operations
- Documentation: https://quarkus.io/guides/hibernate-orm-panache

### Transaction Management
- Quarkus uses JTA for transaction management
- All database write operations should be within a transaction
- Documentation: https://quarkus.io/guides/transaction

### PostgreSQL Connection
- CloudNative PG operator manages the PostgreSQL database
- The connection is configured via environment variables in the deployment
- The database username and password are stored in Kubernetes secrets

## Helpful Commands
```bash
# Check if the database is running
kubectl get clusters.postgresql.cnpg.io -n YOUR_NAMESPACE

# View database logs
kubectl logs -n YOUR_NAMESPACE YOURNAME-todo-db-1

# Check application connection to database
kubectl logs -n YOUR_NAMESPACE deploy/YOURNAME-todo-demo-app | grep -i database

# Access the application
https://todo-YOURNAME.hacknight043.coffeesprout.dev
```

## Further Reading
- Quarkus Hibernate ORM: https://quarkus.io/guides/hibernate-orm
- Quarkus Panache: https://quarkus.io/guides/hibernate-orm-panache
- CloudNative PG: https://cloudnative-pg.io/documentation/current/

Good luck!