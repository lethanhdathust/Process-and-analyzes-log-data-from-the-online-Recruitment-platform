FROM bitnami/spark:3.1.2

# Install useful tools
USER root
RUN apt-get update && apt-get install -y nano iputils-ping net-tools curl vim libffi6
# RUN apt-get update && apt-get install -y nano iputils-ping net-tools curl vim

# Switch back to Spark user
USER 1001

# ENV LD_PRELOAD=/opt/bitnami/common/lib/libnss_wrapper.so

# Copy custom spark-env.sh file
# Append environment variables to spark-env.sh
# ENV LD_PRELOAD=""
RUN echo "PYSPARK_DRIVER_PYTHON=/opt/bitnami/python/bin/python3" >> /opt/bitnami/spark/conf/spark-env.sh && \
    echo "PYSPARK_PYTHON=/opt/bitnami/python/bin/python3" >> /opt/bitnami/spark/conf/spark-env.sh
# Ensure the script has execution permissions
# RUN chmod +x /opt/bitnami/spark/conf/spark-env.sh