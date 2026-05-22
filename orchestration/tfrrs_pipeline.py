from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.dbt.cloud.operators.dbt import DbtCloudRunJobOperator


# These arguments are team dependant.
default_args = {
    "owner" : "jamar",  # Label for who owns the pipeline
    "depends_on_past" : False,  # If set to true, task won't run unless previous task succeeded
    "retries" : 1,  # How many times airflow tries again before giving up
    "retry_delay" : timedelta(minutes=5),   # How long to wait before trying
}

with DAG(
    dag_id="tfrrs_pipeline",    # Name shown in airflow UI no spaces or special characters
    default_args=default_args,  # Passes in our dictionary above
    description="Scrape NCAA track data, load to snowflake, run dbt", # Shows in UI
    schedule_interval=None,     # None = manual trigger. @weekly = Sunday at midnight
    start_date=datetime(2025, 1, 1),    # Earliest date Airflow considers for scheduling usually set to past
    catchup=False,  #   If set schedule_interval="@weekly" and start_date was 6 months ago, Airflow would try to run 26 backfill runs to "catch up" on every week it missed
    tags=["tfrrs", "dbt"],  # Organizational labels for filtering usually meant for internal
) as dag:

    generate_urls = BashOperator(
        task_id="generate_urls",
        bash_command="cd /opt/airflow/tfrrs-scraper/src/ && PYTHONPATH=/opt/airflow/tfrrs-scraper python generate_urls.py",
    )

    run_scraper = BashOperator(
        task_id="run_scraper",
        bash_command="cd /opt/airflow/tfrrs-scraper/src/ && PYTHONPATH=/opt/airflow/tfrrs-scraper python scraper.py",
        execution_timeout=timedelta(minutes=60),
    )

    load_to_snowflake = BashOperator(
        task_id="load_to_snowflake",
        bash_command=(
            "cd /opt/airflow/tfrrs-scraper/src/ && "
            "PYTHONPATH=/opt/airflow/tfrrs-scraper "
            "SNOWFLAKE_USER=JAMARM "
            "SNOWFLAKE_ACCOUNT=ihc33676.us-east-1 "
            "SNOWFLAKE_PRIVATE_KEY_PATH=/opt/airflow/.ssh/snowflake_dbt_pkcs8.p8 "
            "python load_to_snowflake.py"
        ),
    )

    dbt_cloud_run = DbtCloudRunJobOperator(
        task_id="dbt_cloud_run",
        dbt_cloud_conn_id="dbt_cloud",
        job_id=70506183132138,
        wait_for_termination=True,
    )

    generate_urls >> run_scraper >> load_to_snowflake >> dbt_cloud_run


