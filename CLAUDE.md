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