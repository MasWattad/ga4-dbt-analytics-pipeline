from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_DIR = "/opt/airflow/dbt"
DBT_PROFILES_DIR = "/opt/airflow/dbt_profile"
DBT_TARGET = "dev" 

default_args = {
    "owner": "airflow",
    "retries": 1,
}

with DAG(
    dag_id="ga4_dbt_pipeline",
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",  
    catchup=False,
    tags=["dbt", "ga4"],
) as dag:

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command=(
            f"cd {DBT_DIR} && "
            f"dbt deps --profiles-dir {DBT_PROFILES_DIR} --target {DBT_TARGET}"
        ),
    )

    dbt_seed = BashOperator(
        task_id="dbt_seed",
        bash_command=(
            f"cd {DBT_DIR} && "
            f"dbt seed --full-refresh --profiles-dir {DBT_PROFILES_DIR} --target {DBT_TARGET}"
        ),
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=(
            f"cd {DBT_DIR} && "
            f"dbt run --profiles-dir {DBT_PROFILES_DIR} --target {DBT_TARGET}"
        ),
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=(
            f"cd {DBT_DIR} && "
            f"dbt test --profiles-dir {DBT_PROFILES_DIR} --target {DBT_TARGET}"
        ),
    )

    dbt_deps >> dbt_seed >> dbt_run >> dbt_test