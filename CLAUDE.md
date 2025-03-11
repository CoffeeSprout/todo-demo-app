# Commands and Guidelines for Todo Demo App (Quarkus)

## Build/Test Commands
- Run in dev mode: `mvn compile quarkus:dev`
- Run tests: `mvn test`
- Run single test: `mvn -Dtest=TodoResourceTest#testGet test`
- Build package: `mvn package`
- Build native executable: `mvn clean package -Pnative`

## Code Style Guidelines
- **Java Version**: 21
- **Indentation**: 4 spaces
- **Imports**: Organize by groups (java, jakarta, project packages)
- **REST Endpoints**: Follow RESTful patterns in `TodoResource`
- **Persistence**: Use Panache Entity pattern for JPA entities
- **Testing**: Use JUnit 5 with RestAssured for API tests
- **Validation**: Use Jakarta validation annotations (@NotBlank, etc.)
- **OpenAPI**: Document endpoints with OpenAPI annotations
- **Error Handling**: Use JAX-RS exception mappers and appropriate HTTP status codes
- **Naming**: CamelCase for classes, camelCase for methods/variables

## Workshop Focus
- Application designed for instructional workshops
- Implementations must be simple and lightweight
- Create feature branches with reduced functionality for participants to complete
- Solutions should be straightforward for teaching purposes
- Code should be well-commented for educational value

## AI Integration
- Use TodoAiService for AI functionality
- OpenAI API key managed via configuration properties

## Known Issues and Solutions

### Kubernetes Deployment Issues

> **Advanced Troubleshooting Exercise**: A broken network policy has been saved in `src/main/kubernetes/challenges/broken-network-policy.yaml` for advanced users to troubleshoot. It contains common mistakes that result in 503 errors and hanging API calls.
- **Port Configuration**: Ensure container ports are set to 8080 in both Dockerfile and Kubernetes resources
- **Network Policy**: Must match your ingress controller type (HAProxy vs ingress-nginx)
- **Database Connection**: CloudNative PG requires proper JDBC URL format: `jdbc:postgresql://host:port/dbname`
- **OpenAI Integration Hanging**: 
  - Ensure network policy allows egress to external APIs (port 443)
  - Verify OpenAI API key is valid and rate limits are not exceeded
  - Check for properly configured timeouts (default: 60s)
  - For debugging, set `quarkus.langchain4j.log-requests=true` and `quarkus.langchain4j.log-responses=true`

### Multi-Architecture Container Builds
- When building on ARM (Mac M1/M2) for AMD64 deployment:
  ```bash
  # Using Docker Buildx
  docker buildx create --name mybuilder --use
  docker buildx build --platform linux/amd64 \
    -f src/main/docker/Dockerfile.jvm \
    -t registry.example.com/todo-demo-app:latest \
    --push .
  
  # OR using Podman
  podman build --platform=linux/amd64 \
    -f src/main/docker/Dockerfile.jvm \
    -t registry.example.com/todo-demo-app:latest .
  podman push registry.example.com/todo-demo-app:latest
  ```