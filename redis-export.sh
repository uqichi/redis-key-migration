#!/bin/bash

rm -f $OUTPUT_FILE

keys=`redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 --csv KEYS "*:user_tokens:*"`

for key in ${keys//,/ }
do
  key=${key//\"}
  val=`redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 GET $key`
  echo "$key,$val" >> $OUTPUT_FILE
done
