# Confluent Kafka with Control Center UI

This setup uses Docker Compose to create a local Confluent Kafka environment with the Control Center UI for easy management and monitoring.

## Components

- **ZooKeeper**: Coordination service required by Kafka
- **Kafka Broker**: The actual Kafka message broker 
- **Schema Registry**: Manages Avro schemas for Kafka topics
- **Kafka Connect**: Framework for connecting Kafka with external systems
- **Control Center**: Web UI for managing and monitoring your Kafka cluster

## Getting Started

### Prerequisites

- Docker and Docker Compose installed on your system
- At least 4GB of RAM available for Docker

### Starting the Containers

1. Save the `docker-compose.yml` file to your local machine
2. Open a terminal and navigate to the directory containing the file
3. Run the following command:

```bash
docker-compose up -d
```

4. Wait for all services to start (this may take a minute or two)

### Accessing the Control Center UI

Once all containers are running, you can access the Confluent Control Center UI by opening a web browser and navigating to:

```
http://localhost:9021
```

The UI should load after a few seconds, showing you the Kafka cluster overview.

## Using the Control Center UI

Confluent Control Center provides a comprehensive interface for:

- Creating and managing Kafka topics
- Monitoring broker performance
- Tracking consumer groups
- Managing Kafka Connect connectors
- Creating source and sink connectors through a visual interface
- Viewing message streams
- Managing schema registry

### Pre-installed Kafka Connect Connectors

The Kafka Connect service comes with the following connectors pre-installed:

- **JDBC Connector**: Connect to databases (MySQL, PostgreSQL, etc.)
- **Debezium MySQL Connector**: Capture database changes (CDC)
- **Elasticsearch Connector**: Index data to Elasticsearch

You can add more connectors by modifying the docker-compose.yml file.

## Port Configuration

The following ports are exposed on your host machine:

- 2181: ZooKeeper client port
- 9092: Kafka broker external listener
- 8081: Schema Registry REST API
- 8083: Kafka Connect REST API
- 9021: Control Center web UI

## Stopping the Containers

To stop all containers while preserving their data:

```bash
docker-compose stop
```

To stop and remove all containers (this will delete all data):

```bash
docker-compose down
```

## Production Considerations

This setup is designed for development and testing. For production deployments:

- Configure security features (authentication, encryption)
- Increase replication factors
- Set up multiple brokers
- Configure proper resource allocation
- Use persistent volumes for data