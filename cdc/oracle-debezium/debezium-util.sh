#!/bin/bash

# Insert a record into kafka topic in debezium scope.

# For connector oracle, to skip scn not found in v$archived_log.
# Step 1: Find mininum scn in $varchived_log by using following sql. 
#         SELECT MIN(FIRST_CHANGE#) AS FIRST_CHANGE# FROM v$archived_log WHERE DEST_ID IN (select dest_id FROM V$ARCHIVE_DEST_STATUS WHERE STATUS='VALID' AND TYPE='LOCAL') AND  status = 'A';
# Step 2: Reassign scn(in kafka message value) with scn in step 1 plusing one. for example, If scn in step one is 12345, then we should replace scn with 12346 (12345 + 1).
# Step 3: Replace kafka message key and message value content, then invoke the shell.

java -jar ./jars/debezium-util-1.0-SNAPSHOT-jar-with-dependencies.jar "datanode1:9093" "datanode1:2181/kafka_27" "connect-offsets" "[\"tft_ups\",{\"server\":\"tft_ups\"}]" "{\"commit_scn\":\"255512454410\",\"transaction_id\":null,\"scn\":\"255512454410\"}"
