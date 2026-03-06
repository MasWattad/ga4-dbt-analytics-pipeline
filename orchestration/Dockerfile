FROM apache/airflow:slim-2.10.4-python3.10

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    libpq-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER airflow
RUN pip install --no-cache-dir \
    psycopg2-binary==2.9.9 \
    dbt-core==1.11.6 \
    dbt-bigquery==1.11.1