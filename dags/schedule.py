from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from datetime import timedelta
# Import utility functions from the separate file
from gen_realtime_data import generating_dummy_data

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=5),
}
def test():
    print(5)
# Create DAG
dag = DAG(
    'kafka_data_generator',
    default_args=default_args,
    description='Generate and send dummy data to Kafka every 5 seconds',
    schedule_interval=timedelta(seconds=10),  # Run every 5 seconds
    catchup=False,
)

# Define the task
generate_data_task = PythonOperator(
    task_id='generate_kafka_data',
    op_kwargs={'n_records': 5},  # Set your desired number of records here
    python_callable=generating_dummy_data,
    provide_context=True,
    dag=dag,
)
af_task = PythonOperator(
    task_id='af_task',
    python_callable=test,
    provide_context=True,
    dag=dag,
)
# Set task dependencies (if there are multiple tasks)
generate_data_task