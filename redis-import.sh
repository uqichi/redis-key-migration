#!/bin/bash

delim='|'

while read row; do
  key=`echo ${row} | cut -d $delim -f 1`
  val=`echo ${row} | cut -d $delim -f 2`
  redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 SET "$key" $val
done < $FILE
