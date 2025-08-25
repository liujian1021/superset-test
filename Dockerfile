FROM apache/superset:latest

# 先用 root 做需要的系统级操作
USER root

# 保持在 USER root 阶段
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
      pybigquery==0.10.4 \
      google-cloud-bigquery==3.* \
      google-auth \
      db-dtypes \
      pandas-gbq

# 确保 /app 目录存在
RUN mkdir -p /app

# 复制启动脚本到 /app，并直接赋权；同时把换行符转换为 LF（防止 CRLF 问题）
COPY docker-bootstrap.sh /app/docker-bootstrap.sh
RUN dos2unix /app/docker-bootstrap.sh || true && \
    chmod +x /app/docker-bootstrap.sh

# 准备 Superset 数据目录
RUN mkdir -p /var/lib/superset && chown -R superset:superset /var/lib/superset
ENV SUPERSET_HOME=/var/lib/superset

EXPOSE 8088

# 切回非特权用户
USER superset

# 用脚本启动
CMD ["/app/docker-bootstrap.sh"]
