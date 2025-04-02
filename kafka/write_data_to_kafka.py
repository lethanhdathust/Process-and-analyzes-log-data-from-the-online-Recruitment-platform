from pyspark.sql import functions as F
from pyspark.sql.types import *
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, IntegerType, StringType
from pyspark.sql.functions import col

scala_version = '2.11'  # TODO: Ensure this is correct
spark_version = '3.5.5'
packages = [
    f'org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.5',
    'org.apache.kafka:kafka-clients:3.3.1'
]

# Create Spark Session with Kafka dependencies
spark = SparkSession.builder \
    .appName("KafkaProducerExample") \
    .config("spark.jars.packages", ",".join(packages)) \
    .getOrCreate()

KAFKA_BROKER = "localhost:9092"
KAFKA_TOPIC = "test"

df = spark.read.csv('data_test.csv',header=True)
df.limit(1).selectExpr("CAST(id AS STRING) AS key", "to_json(struct(*)) AS value") \
.write.format("kafka") \
.option("kafka.bootstrap.servers", "localhost:9092") \
.option("topic", "test2") \
.save()

