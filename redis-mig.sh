#!/bin/bash

host=localhost
port=6379
password=${REDIS_PASSWORD}
db=0
url=redis://${password}@${host}:${port}/${db}

file=${FILE}

delim='|'

function _connect {
    redis-cli -u ${url}
}

function _export {
    rm -f $file

    keys=`redis-cli -u ${url} --csv KEYS "*:user_tokens:*"`

    for key in ${keys//,/ }
    do
        key=${key//\"}
        val=$(redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 GET $key | sed 's/"/\\"/g')
        ttl=$(redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 TTL $key)
        echo "${key}${delim}${val}${delim}${ttl}" >> $FILE
    done
}

function _import {
    while read row; do
        key=`echo ${row} | cut -d ${delim} -f 1`
        val=`echo ${row} | cut -d ${delim} -f 2`
        ttl=`echo ${row} | cut -d ${delim} -f 3`
        redis-cli -u ${url} SETEX $key $ttl $val
    done < $file
}

subcommand="$1"
shift

case $subcommand in
    connect)
        _connect
        ;;
    export)
        _export
        ;;
    import)
        _import
        ;;
    *)
        echo no such subcommand
        ;;
esac
