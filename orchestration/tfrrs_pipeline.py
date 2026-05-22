from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

# Paths inside the Docker container (your tfrrs-dbt repo is mounted here)
PROJECT_ROOT = "/opt/airflow/tfrrs-dbt"
SCRIPTS_DIR = f"{PROJECT_ROOT}/src"

default_args = {
    "owner": "jamar",
    "depends_on_past": False,
    "email_on_failure": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="tfrrs_pipeline",
    default_args=default_args,
    description="Scrape NCAA track data, load to Snowflake, run dbt",
    schedule_interval=None,
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["tfrrs", "dbt"],
) as dag:

    generate_urls = BashOperator(
        task_id="generate_urls",
        bash_command=f"cd {SCRIPTS_DIR} && python generate_urls.py",
    )

    run_scraper = BashOperator(
        task_id="run_scraper",
        bash_command=f"cd {SCRIPTS_DIR} && python scraper.py",
        execution_timeout=timedelta(minutes=60),
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {PROJECT_ROOT} && dbt run",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {PROJECT_ROOT} && dbt test",
    )

    generate_urls >> run_scraper >> dbt_run >> dbt_test
