# Use the official Airflow image as base
FROM apache/airflow:2.5.1

# Switch to root user to perform system installations
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libev-dev \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the airflow user
USER airflow

# Copy requirements file into the container
COPY requirements.txt /requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt

# Copy DAGs and plugins
# COPY dags/ /opt/airflow/dags/
# COPY plugins/ /opt/airflow/plugins/

# Optional: Set work directory
# WORKDIR /opt/airflow