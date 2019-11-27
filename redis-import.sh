#!/bin/bash

while read row; do
  column1=`echo ${row} | cut -d , -f 1`
  column2=`echo ${row} | cut -d , -f 2`

  echo "${column1}のvalueは${column2}です。"
done < $IMPORT_FILE
