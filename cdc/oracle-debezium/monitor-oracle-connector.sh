#!/bin/bash

# function :  检查oracle debezium connector pga，超过阈值，重启connector
# author   :  龚长华
# datetime :  2021-8-26 15:32:34
# usage    :  bash monitor-oracle-connector.sh connector
# debezium :  1.7.0 alpha

# datetime ：2021-8-27 08:34:34
# modification: bugfix - After connector was restarted successfully, monitor checks connector log immediately.
#                        Monitor discovers the latest pga utilization which was printed before connector restarted in connector log was greater than pga limit as well.
#                        Then monitor replay restarting the same connector, but connector was restarted a moment ago.

# datetime : 2021-8-30 14:00:29
# modification: enhancement - if connector service not started up, monitor failed to request connector url.

export PYTHONIOENCODING=utf8

if [ "X$1" == "X" ]; then
  echo "Usage: bash monitor-oracle-connector.sh connector"
  exit 2
fi

# connector名称
CONNECTOR_NAME=$1

# connector服务域名
CONNECTOR_DOMAIN="http://localhost:8083"
#CONNECTOR_DOMAIN="http://10.50.253.1:8083"

# PGA限制，单位MB
PGA_LIMIT=25

# connector日志绝对路径
CONNECT_LOG="/opt/kafka_2.12-2.7.0/logs/connect.log"

# connector配置json信息，用于执行重启connector，文件名称规范为connector_name.json，如devdbora0.json
CONNECT_CONFIG_DIR="/opt/kafka_2.12-2.7.0/connector-json"

# todo: add connector name to grep
# 获取最后条connect.log中含PGA关键字的信息
GREP_CONNECT_LOG="grep PGA $CONNECT_LOG|tail -n 1"

# todo: add connector name to grep
# the latest info including "Starting connector devdbora0"
GREP_STARTING_LOG="grep 'Starting connector $CONNECTOR_NAME' $CONNECT_LOG|tail -n 1"

# 日志时间戳，判定间隔，单位秒
INFO_INTERVAL=600

# Get http code of connector service
CONNECTOR_HTTP_CODE_CMD="curl -I -m 10 -o /dev/null -s -w %{http_code} ${CONNECTOR_DOMAIN}/connectors"

# 获取所有connector名称
CONNECTOR_NAME_CMD="curl -Ss -X GET ${CONNECTOR_DOMAIN}/connectors"

# 获取指定connector状态
CONNECTOR_STATUS_CMD="curl -Ss -X GET ${CONNECTOR_DOMAIN}/connectors/${CONNECTOR_NAME}/status"

# 获取指定connector配置
CONNECTOR_CONFIG_CMD="curl -Ss -X GET ${CONNECTOR_DOMAIN}/connectors/${CONNECTOR_NAME}/config"

# 删除connector，针对oracle cdc，必须删除才能释放pga
CONNECTOR_DEL_CMD="curl -Ss -X DELETE ${CONNECTOR_DOMAIN}/connectors/${CONNECTOR_NAME}"

# 添加并启动connector
CONNECTOR_START_CMD="curl -Ss -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d@${CONNECT_CONFIG_DIR}/$CONNECTOR_NAME.json ${CONNECTOR_DOMAIN}/connectors"

DT_FORMAT="+%Y-%m-%d %H:%M:%S"

# when restarting connector, add a lock by modifying tag
# tag: restarting, restarted
function process_tag() {
  tag=$1
  # if file not exists, then touch a tag file
  if [ $(find $CONNECT_CONFIG_DIR -type f -name "$CONNECTOR_NAME.$tag" | wc -l) -eq 0 ]; then
    touch $CONNECT_CONFIG_DIR/"$CONNECTOR_NAME"."$tag"
  fi

  # shellcheck disable=SC2166
  if [ "$tag" = "restarting" -a $(find $CONNECT_CONFIG_DIR -type f -name "$CONNECTOR_NAME.restarted" | wc -l) -eq 1 ]; then
    rm -f $CONNECT_CONFIG_DIR/"$CONNECTOR_NAME.restarted"
  fi

  # shellcheck disable=SC2166
  if [ "$tag" = "restarted" -a $(find $CONNECT_CONFIG_DIR -type f -name "$CONNECTOR_NAME.restarting" | wc -l) -eq 1 ]; then
    rm -f $CONNECT_CONFIG_DIR/"$CONNECTOR_NAME.restarting"
  fi
}

# find tag file
function find_process_tag() {
  tag=$1
  if [ $(find $CONNECT_CONFIG_DIR -type f -name "$CONNECTOR_NAME.$tag" | wc -l) -eq 1 ]; then
    echo 1
  else
    echo 0
  fi
}

# 重启指定connector，传入参数为connector名称
function delete_start_connector() {
  connector=$1
  if [ "1" = $(find_process_tag "restarting") ]; then
    echo "[$(date "$DT_FORMAT")] Discover connector is restarting, give up restarting"
    exit 10
  fi
  echo "[$(date "$DT_FORMAT")] Restarting connector $connector"
  process_tag "restarting"
  # 删除connector
  echo "$CONNECTOR_DEL_CMD" | bash
  sleep 2
  # 启动connector
  echo "$CONNECTOR_START_CMD" | bash >/dev/null

  sleep 3
  CONNECTOR_STATUS=$($CONNECTOR_STATUS_CMD | python -c "import sys, json; print json.load(sys.stdin)['connector']['state']")
  if [ "RUNNING" = "$CONNECTOR_STATUS" ]; then
    process_tag "restarted"
    echo "[$(date "$DT_FORMAT")] Restarted connector $connector successfully"
  else
    echo "[$(date "$DT_FORMAT")] Failed to restart connector $connector, you have to start it manually"
  fi

}

# 判断connector的配置信息是否存在，其为重启connector必要条件
IS_EXIST=$(find $CONNECT_CONFIG_DIR -name "$CONNECTOR_NAME".json | wc -l)
if [ "1" != "$IS_EXIST" ]; then
  echo "[$(date "$DT_FORMAT")] Connector $CONNECTOR_NAME config json not exists in $CONNECT_CONFIG_DIR"
  exit 3
fi

# request connector url to judge connector service whether to survive
if [ $($CONNECTOR_HTTP_CODE_CMD) != "200" ];then
  echo "[$(date "$DT_FORMAT")] Connector service may not be running, no response returned"
  exit 3
fi

# 判断是否存在该connector
IS_EXIST=$($CONNECTOR_NAME_CMD | python -c "import sys, json; res = 'YES' if '${CONNECTOR_NAME}' in json.load(sys.stdin) else 'NO'; print res")
if [ "NO" = "$IS_EXIST" ]; then
  # If connector not exists, but json file exits, then try to start it
  echo "[$(date "$DT_FORMAT")] Connector $CONNECTOR_NAME not exists, but config json exists"
  echo "[$(date "$DT_FORMAT")] Try to start connector $CONNECTOR_NAME by ${CONNECT_CONFIG_DIR}/$CONNECTOR_NAME.json"
  # 启动connector
  echo "$CONNECTOR_START_CMD" | bash >/dev/null
  echo "[$(date "$DT_FORMAT")] Started connector $CONNECTOR_NAME"
  exit 4
fi

# 判断任务状态，如果running，则获取connector类型
CONNECTOR_STATUS=$($CONNECTOR_STATUS_CMD | python -c "import sys, json; print json.load(sys.stdin)['connector']['state']")
if [ "RUNNING" != "$CONNECTOR_STATUS" ]; then
  echo "[$(date "$DT_FORMAT")] Connector $CONNECTOR_NAME may not be running"
  exit 5
else
  # as a indemnity
  process_tag "restarted"
fi

# 判断connector类型，必须为oracle connector
CONNECTOR_CLASS=$($CONNECTOR_CONFIG_CMD | python -c "import sys, json; print json.load(sys.stdin)['connector.class']")
if [ "io.debezium.connector.oracle.OracleConnector" != "$CONNECTOR_CLASS" ]; then
  echo "[$(date "$DT_FORMAT")] Connector $CONNECTOR_NAME class is $CONNECTOR_CLASS, not io.debezium.connector.oracle.OracleConnector"
  exit 6
fi

# 当该Connector的类型为oracle， 任务状态为running，则获取日志路径
# 获取connect.log所在的worker节点
WORKER_ID=$($CONNECTOR_STATUS_CMD | python -c "import sys, json; print json.load(sys.stdin)['connector']['worker_id']" | awk -F ":" '{print $1}')
# 过滤日志，并判断PGA大小，PGA超过阈值，则重启connector
# shellcheck disable=SC2029
LAST_PGA_INFO=$(ssh "$WORKER_ID" "$GREP_CONNECT_LOG")
# shellcheck disable=SC2029
LAST_STARTING_INFO=$(ssh "$WORKER_ID" "$GREP_STARTING_LOG")
#echo "[$(date "$DT_FORMAT")] $LAST_PGA_INFO"
#echo "[$(date "$DT_FORMAT")] $LAST_STARTING_INFO"
if [ "X$LAST_PGA_INFO" = "X" ]; then
  echo "[$(date "$DT_FORMAT")] No PGA information in $WORKER_ID $CONNECT_LOG"
  exit 7
fi

# 获取PGA大小和日志时间戳，并进行判断
LAST_PGA=$(echo "$LAST_PGA_INFO" | awk -F "PGA" '{print $2}' | awk -F " " '{print $1}' | awk -F "." '{print $1}' | sed 's/MB//')
#echo "$LAST_PGA"
# 日志的时间戳
LAST_PGA_TS=$(echo "$LAST_PGA_INFO" | awk -F "," '{print $1}' | sed 's/\[//')
LAST_STARTING_TS=$(echo "$LAST_STARTING_INFO" | awk -F "," '{print $1}' | sed 's/\[//')
#echo "$LAST_PGA_TS"
LAST_PGA_TS=$(date -d "$LAST_PGA_TS" +%s)
LAST_STARTING_TS=$(date -d "$LAST_STARTING_TS" +%s)
NOW_TS=$(date +%s)
# shellcheck disable=SC2004
#echo $(($NOW_TS-$LAST_PGA_TS))

# 获取最后次重启时间戳

# 1. 如果最后条含PGA关键字的信息时间戳与当前时间比较，在$INFO_INTERVAL范围内，则认定日志有效
# 2. 最后次重启时间戳如果大于最后条含有PGA关键字的时间戳，则认定connector仍在重启，则需保证重启时间戳小于最后条含有PGA关键字的时间戳
# 3. 当上述PGA值大于$PGA_LIMIT值时，执行重启connector
# shellcheck disable=SC2004
# shellcheck disable=SC2166
echo "[$(date "$DT_FORMAT")] $LAST_PGA_INFO"

# shellcheck disable=SC2166
# shellcheck disable=SC2004
if [ "$LAST_PGA" -gt $PGA_LIMIT -a $(($NOW_TS - $LAST_PGA_TS)) -le $INFO_INTERVAL -a $(($LAST_STARTING_TS - $LAST_PGA_TS)) -lt 0 ]; then
  echo "[$(date "$DT_FORMAT")] $LAST_STARTING_INFO"
  echo "[$(date "$DT_FORMAT")] $LAST_PGA_INFO"
  echo "[$(date "$DT_FORMAT")] Current oracle pga utilization $LAST_PGA MB, greater than $PGA_LIMIT MB"
  delete_start_connector "$CONNECTOR_NAME"
fi
