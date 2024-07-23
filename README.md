# GKE-Powered Web Application Stack with Monitoring for ID.me interview

This project demonstrates how to build a scalable and monitored web application stack.
A live demo of the website is available at: http://id_me.andykras.us/

## Project Overview

This stack is designed for:

- **Scalability:**  Leverage Kubernetes to automatically scale your Node.js application and PostgreSQL database to handle increased traffic.
- **Reliability:** Ensure high availability through PostgreSQL replication and Kubernetes' self-healing mechanisms.
- **Monitoring:** Gain deep insights into your infrastructure and application performance with Prometheus and Grafana.
- **Automation:** Automate infrastructure provisioning and deployment using Terraform and GitHub Actions.

## Architecture

1. **GitHub Actions** triggers the deployment pipeline upon code changes.
2. **Terraform:** Provisions the GKE cluster, Persistent Disks and networking resources in GCP.
3. **Node.js App:** Fetches data from the PostgreSQL database.
4. **PostgreSQL:**  Stores application data and scales based on load.
5. **Prometheus:**  Collects metrics from the Node.js app and PostgreSQL.
6. **Grafana:** Visualizes metrics and provides dashboards for monitoring.
7. **HashiCorp Vault**: Securely stores and manages secrets and credentials.

## Technologies and Tools

- **Google Cloud Platform (GCP):** Cloud provider hosting the infrastructure.
- **Google Kubernetes Engine (GKE):** Managed Kubernetes service for container orchestration.
- **Terraform:** Infrastructure-as-code tool for provisioning and managing GCP resources.
- **GitHub Actions:**  CI/CD platform for automating workflows.
- **Node.js:**  JavaScript runtime for building the web application.
- **PostgreSQL:** Relational database for storing application data.
- **Prometheus:** Open-source monitoring and alerting toolkit.
- **Grafana:**  Open-source visualization and analytics platform.
- **Docker:**  Containerization platform for packaging and deploying the Node.js app.

## Enhanced Architecture(not implemented in this solution)

### PostgreSQL
- **Cluster**: Instead of a single PostgreSQL instance, we now have a cluster for high availability and fault tolerance. We'll use a replication-based setup with a primary and replica instances. The primary handles writes, and the replica asynchronously replicates data for redundancy.
- **GCP Managed PostgreSQ**L: For simplicity, we'll leverage Google Cloud SQL for PostgreSQL, a fully managed service that handles replication, backups, and maintenance.

## Monitoring & Alerting:
- **GKE Metrics**: Collect metrics on node resource usage (CPU, memory, disk), pod status, deployments, and events.
- **PostgreSQL Metrics**: Monitor database connections, query performance, replication lag, used\free space and other resource utilization.
- **Node.js** Metrics: Track request rates, response times, error rates, and custom application metrics (e.g., database query latency).
- **Grafana Dashboards**: Create insightful dashboards to visualize all collected metrics.
- **Grafana Alerts**: Set up alerts for critical conditions like high resource usage, pod failures, database unavailability, slow website response times, or error spikes.

## On Call Support Alerts:
- **Critical Errors**: Alert on critical errors like application crashes, database failures, or persistent node issues.
- **Resource Exhaustion**: Alert when resources approach their limits (e.g., high CPU usage, low disk space).
- **Security Events**: Alert on suspicious activity or security breaches.