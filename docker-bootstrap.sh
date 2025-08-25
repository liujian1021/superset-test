#!/usr/bin/env bash
set -e

# 必要环境（也可在 Railway Variables 配）
: "${ADMIN_USERNAME:=admin}"
: "${ADMIN_EMAIL:=admin@superset.com}"
: "${ADMIN_PASSWORD:=admin}"

# 只在第一次容器启动时初始化
if [ ! -f "$SUPERSET_HOME/.bootstrapped" ]; then
  echo "Initializing Superset..."
  superset db upgrade
  superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname Superset --lastname Admin \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD"
  superset init
  touch "$SUPERSET_HOME/.bootstrapped"
  echo "Superset initialized."
fi

# 用 Gunicorn 正式启动（更稳定）
exec gunicorn "superset.app:create_app()" \
  --bind 0.0.0.0:8088 \
  --workers ${GUNICORN_WORKERS:-2} \
  --timeout ${GUNICORN_TIMEOUT:-120}
