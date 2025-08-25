FROM apache/superset:latest

# 如需外部数据库，保留这行；只用自带 SQLite 也没问题
USER root
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir psycopg2-binary

# 保存元数据与“已初始化”标记的目录
RUN mkdir -p /var/lib/superset && chown -R superset:superset /var/lib/superset
ENV SUPERSET_HOME=/var/lib/superset

USER superset
COPY docker-bootstrap.sh /app/docker-bootstrap.sh
RUN chmod +x /app/docker-bootstrap.sh

EXPOSE 8088
CMD ["/app/docker-bootstrap.sh"]
