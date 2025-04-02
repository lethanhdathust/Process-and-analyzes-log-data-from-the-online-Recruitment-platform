import random
import uuid
import pandas as pd
import mysql.connector
import datetime as dt
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
import cassandra.util
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_json, struct

# MySQL connection details
mysql_config = {
    "host": "mysql",  # Use 'mysql' if running in Docker, else provide the correct IP
    "port": 3306,
    "database": "mydb",
    "user": "root",
    "password": "bedanroot",
    "auth_plugin": "mysql_native_password"
}

# Cassandra connection details
cassandra_host = "cassandra"
cassandra_port = 9042
cassandra_username = "cassandra"
cassandra_password = "cassandra"

# Kafka configuration
KAFKA_BROKER = "broker:29092"
KAFKA_TOPIC = "gen_data7"

def get_spark_session():
    """Create and return a Spark session."""
    return SparkSession.builder \
        .appName("KafkaProducerExample") \
        .config("spark.driver.host", "spark-master") \
        .config("spark.driver.bindAddress", "0.0.0.0") \
        .config("spark.sql.shuffle.partitions", "4") \
        .config("spark.executor.memory", "1g") \
        .config("spark.driver.memory", "512m") \
        .master("local[*]") \
        .getOrCreate()


def get_data_from_mysql(query):
    """Retrieve data from MySQL and return as a Pandas DataFrame."""
    try:
        cnx = mysql.connector.connect(**mysql_config)
        cursor = cnx.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        
        # Get column names dynamically
        columns = [col[0] for col in cursor.description]

        # Convert to DataFrame
        df = pd.DataFrame(result, columns=columns)

        # Close the connection
        cnx.close()
        return df
    except mysql.connector.Error as e:
        print(f"❌ MySQL Error: {e}")
        return pd.DataFrame()

def generating_dummy_data(n_records=None, **kwargs):
    """Generate dummy tracking data and send to Kafka."""
    # Create a Spark session
    spark = get_spark_session()
        # Use provided n_records or generate a random number
    if n_records is None:
        n_records = random.randint(1, 2)
    # Set number of records to generate (can be random or fixed)
    print(f"🚀 Generating {n_records} records...")
    
    # Fetch reference data from MySQL
    publisher_df = get_data_from_mysql("SELECT DISTINCT(id) AS publisher_id FROM master_publisher")
    jobs_df = get_data_from_mysql("SELECT id AS job_id, campaign_id, group_id, company_id FROM job")

    if publisher_df.empty or jobs_df.empty:
        print("⚠️ Skipping data generation due to empty datasets.")
        return

    publisher_list = publisher_df["publisher_id"].tolist()
    job_list = jobs_df["job_id"].tolist()
    campaign_list = jobs_df["campaign_id"].tolist()
    group_list = jobs_df["group_id"].dropna().astype(int).tolist()
    
    # Generate data
    data_list = []
    for i in range(n_records):
        create_time = str(cassandra.util.uuid_from_time(dt.datetime.now()))
        record = {
            "create_time": create_time,
            "bid": random.randint(0, 1),
            "custom_track": random.choices(["click", "conversion", "qualified", "unqualified"], weights=[70, 10, 10, 10])[0],
            "job_id": random.choice(job_list),
            "publisher_id": random.choice(publisher_list),
            "group_id": random.choice(group_list),
            "campaign_id": random.choice(campaign_list),
            "ts": dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }
        print(f"Generated record: {record}")
        data_list.append(record)
    
    # Convert to Spark DataFrame and format for Kafka
    df = spark.createDataFrame(data_list).select(
        col("create_time").alias("key"),
        struct(
            col("bid"),
            col("custom_track"),
            col("job_id"),
            col("publisher_id"),
            col("group_id"),
            col("campaign_id"),
            col("ts")
        ).alias("value")
    )    
    df = df.withColumn("key", col("key"))
    df = df.withColumn("value", to_json(col("value")))
    df.show(2, False)
    
    # Write to Kafka
    df.write.format("kafka") \
        .option("kafka.bootstrap.servers", KAFKA_BROKER) \
        .option("topic", KAFKA_TOPIC) \
        .save()
        
    print(f"✅ Successfully sent {n_records} records to Kafka topic '{KAFKA_TOPIC}'.")