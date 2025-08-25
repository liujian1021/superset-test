FROM apache/superset:latest

# 可选: 安装额外依赖
USER root
RUN pip install --upgrade pip && pip install psycopg2-binary

EXPOSE 8088

CMD superset db upgrade && \
    superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@superset.com --password admin && \
    superset init && \
    superset run -h 0.0.0.0 -p 8088
