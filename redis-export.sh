#!/bin/bash

delim='|'

rm -f $FILE

keys=`redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 --csv KEYS "*:user_tokens:*"`

for key in ${keys//,/ }
do
  key=${key//\"}
  val=$(redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 GET $key | sed 's/"/\\"/g')
  echo "${key}${delim}${val}" >> $FILE
done
