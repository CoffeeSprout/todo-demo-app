# TODO Application with Quarkus

This is an example application based on a Todo list where the different tasks are created, read, updated, or deleted from the database. This application uses `postgresql` as a database and that is provided with Quarkus Dev Services. When running in a 
non-dev mode you will have to provide the database yourself. 

## Development mode

```bash
mvn compile quarkus:dev
```
Then, open: http://localhost:8080/

## Compile and run on a JVM with PostgreSQL (in a container)

```bash
mvn package
```
Run:
```bash
docker run --ulimit memlock=-1:-1 -it --rm=true \
    --name postgres-quarkus-rest-http-crud \
    -e POSTGRES_USER=restcrud \
    -e POSTGRES_PASSWORD=restcrud \
    -e POSTGRES_DB=rest-crud \
    -p 5432:5432 postgres:14
java -jar target/quarkus-app/quarkus-run.jar
```

Then, open: http://localhost:8080/

## Using Docker Compose

For convenience, you can use Docker Compose to run both the application and the PostgreSQL database:

> **IMPORTANT FOR WORKSHOP PARTICIPANTS**: 
> Before using Docker/Podman Compose, edit the compose file to replace `yourname` with your name
> (e.g., alice, bob) to avoid container name conflicts with other participants.

```bash
# First build the application
mvn package

# Edit docker-compose.yml to replace 'yourname' with your actual name
# For example, change "todo-yourname" to "todo-alice"

# Then build and start the containers
docker-compose up -d

# To stop the containers
docker-compose down
```

## Using Podman Compose

If you're using Podman instead of Docker:

```bash
# First build the application
mvn package

# Edit podman-compose.yml to replace 'yourname' with your actual name
# For example, change "todo-yourname" to "todo-alice"

# Then build and start the containers
podman-compose -f podman-compose.yml up -d

# To stop the containers
podman-compose -f podman-compose.yml down
```

Both Docker and Podman Compose configurations will:
1. Build the application container using the JVM Dockerfile
2. Start a PostgreSQL container
3. Connect the application to the database
4. Expose the application on port 8080

### Custom Container Names for Workshop

When working in a shared environment with multiple participants, it's essential to use unique container names to avoid conflicts:

1. Each participant should customize the image and container names in the compose files
2. Replace all occurrences of `yourname` with your chosen identifier (e.g., your first name)
3. This prevents container name collisions when multiple participants build containers on the same host

Then, open: http://localhost:8080/

## Compile to Native and run with PostgresSQL ( in a container )

Compile:
```bash
mvn clean package -Pnative
```
Run:
```bash
docker run --ulimit memlock=-1:-1 -it --rm=true \
    --name postgres-quarkus-rest-http-crud \
    -e POSTGRES_USER=restcrud \
    -e POSTGRES_PASSWORD=restcrud \
    -e POSTGRES_DB=rest-crud \
    -p 5432:5432 postgres:14
./target/todo-backend-1.0-SNAPSHOT-runner
```
## Other links

- http://localhost:8080/q/health (Show the build in Health check for the datasource)
- http://localhost:8080/q/openapi (The OpenAPI Schema document in yaml format)
- http://localhost:8080/q/swagger-ui (The Swagger UI to test out the REST Endpoints)
- http://localhost:8080/graphql/schema.graphql (The GraphQL Schema document)
- http://localhost:8080/q/graphql-ui/ (The GraphiQL UI to test out the GraphQL Endpoint)
- http://localhost:8080/q/dev-ui/ (Show dev ui)
