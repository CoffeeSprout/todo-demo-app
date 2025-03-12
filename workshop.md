# Todo Workshop Application Branch Guide

This guide explains the different branches available in the todo-demo-app repository and how to use them for your workshop experience.

## Branch Overview

| Feature | starter | db | reliability | main |
|---------|:-------:|:--:|:----------:|:----:|
| REST API | ✅ | ✅ | ✅ | ✅ |
| In-memory storage | ✅ | ❌ | ❌ | ❌ |
| Database (PostgreSQL) | ❌ | ✅ (single-node) | ✅ (multi-node) | ✅ (multi-node) |
| Audit Logging | ✅ | ✅ | ✅ | ✅ |
| Kubernetes Deployment | ✅ (basic) | ✅ (basic) | ✅ (advanced) | ✅ (advanced) |
| Horizontal Pod Autoscaler | ❌ | ❌ | ✅ | ✅ |
| Pod Disruption Budget | ❌ | ❌ | ✅ | ✅ |
| Prometheus Monitoring | ❌ | ❌ | ✅ | ✅ |
| Network Policies | ❌ | ❌ | ❌ | ✅ |
| GraphQL API | ❌ | ❌ | ❌ | ✅ |
| AI Integration | ❌ | ❌ | ❌ | ✅ |

## Getting Started

Clone the repository and check out your desired branch:

```
# Clone the repository
git clone https://github.com/CoffeeSprout/todo-demo-app.git
cd todo-demo-app

# Choose your branch based on the workshop level
git checkout starter    # For basic in-memory implementation
git checkout db         # For database integration
git checkout reliability # For monitoring and scaling features
git checkout main       # For all features including AI and security
```

## Branch Details

### Starter Branch

The most basic implementation with in-memory storage.

```
git checkout starter
```

**Key Features:**
- Simple REST API for managing todo items
- In-memory data storage (no database)
- Basic Kubernetes deployment configuration
- Minimal resource requirements

**Building & Running:**
```
# Local development
mvn compile quarkus:dev

# Build container image
cd src/main/kubernetes
./build-container.sh
# (Follow prompts to set your participant name)

# Deploy to Kubernetes
cd src/main/kubernetes
./deploy.sh
# (Follow prompts to set your namespace and participant name)
```

### DB Branch

Adds PostgreSQL database integration.

```
git checkout db
```

**Key Features:**
- REST API connected to a database
- Single-node PostgreSQL database
- JPA/Hibernate ORM with Panache
- Database initialization with sample data

**Differences from starter:**
- Uses real persistent storage instead of in-memory
- Adds database configuration
- Requires CloudNative PG operator in Kubernetes
- Handles database connection and credentials

### Reliability Branch

Adds monitoring and scaling capabilities.

```
git checkout reliability
```

**Key Features:**
- Multi-node PostgreSQL database
- Horizontal Pod Autoscaler for automatic scaling
- Pod Disruption Budget for high availability
- Prometheus monitoring integration
- Structured JSON logging

**Differences from db branch:**
- Higher resilience with multi-node database
- Automatic scaling based on resource usage
- Better monitoring and observability
- Improved operational capabilities

### Main Branch (All Features)

Complete implementation with all features.

```
git checkout main
```

**Key Features:**
- All reliability features
- Network policies for improved security
- GraphQL API for flexible data querying
- AI integration for todo suggestions
- Advanced Kubernetes configuration

**Differences from reliability branch:**
- Added security with network policies
- Alternative GraphQL API for data access
- AI-powered suggestions for new tasks
- Additional API endpoints and functionality

## Workshop Progression

For a structured learning experience, we recommend starting with the `starter` branch and progressively moving up:

1. **Start with the basics** (`starter` branch)
   ```
   git checkout starter
   ```
   
2. **Add database integration** (`db` branch)
   ```
   git checkout db
   ```
   
3. **Add reliability features** (`reliability` branch)
   ```
   git checkout reliability
   ```
   
4. **Add advanced features** (`main` branch)
   ```
   git checkout main
   ```

## Comparing Branches

To see what changes between branches, you can use Git's diff capabilities. This is especially useful when trying to understand what features were added in each progression level:

### Compare Implementation Differences

1. **See what changes from starter to db branch:**
   ```
   git checkout starter
   git diff starter..db
   ```

2. **See what changes from db to reliability branch:**
   ```
   git checkout db
   git diff db..reliability
   ```

3. **See what changes from reliability to main branch:**
   ```
   git checkout reliability
   git diff reliability..main
   ```

### Compare Specific Files

To see how a specific file evolves across branches:

```
# Compare Todo.java implementation between starter and db branch
git diff starter:src/main/java/io/quarkus/sample/Todo.java db:src/main/java/io/quarkus/sample/Todo.java

# Compare Kubernetes configuration between db and reliability branch
git diff db:src/main/kubernetes/kustomization.yaml reliability:src/main/kubernetes/kustomization.yaml
```

### See What Resources Were Added

To see files that exist in a higher branch but not in your current branch:

```
# Files in db branch that aren't in starter branch
git checkout starter
git diff --name-only --diff-filter=A starter..db

# Files in main branch that aren't in reliability branch
git checkout reliability
git diff --name-only --diff-filter=A reliability..main
```

## Building & Deploying

Each branch includes deployment scripts in the `src/main/kubernetes` directory:

- `build-container.sh` - Builds and pushes your container image
- `deploy.sh` - Deploys the application to Kubernetes

Make sure to:
1. Set your participant name in both scripts
2. Set your assigned namespace in the deploy script
3. Have access to the workshop Kubernetes cluster
4. Have either Docker or Podman installed

## Troubleshooting

If you encounter issues:

1. **Container build failures**
   - Check your registry credentials
   - If using Apple Silicon, ensure cross-platform builds are working

2. **Database connection issues**
   - Verify the database pod is running
   - Check connection string format in the deployment

3. **Network policy issues** (main branch only)
   - Check egress rules for external API connections
   - Verify ingress controller configuration

## Reference Implementation

The `main` branch contains the complete reference implementation. If you get stuck, you can always check the main branch to see how a feature should be implemented.