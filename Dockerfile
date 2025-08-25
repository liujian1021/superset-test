FROM apache/superset:latest
USER root
RUN pip install --upgrade pip && \
    pip install psycopg2-binary
