#!/bin/bash

delim='|'

file=${FILE:-keys.bak}

key_pattern=${KEY_PATTERN:-*}

host=${HOST:-localhost}
port=${PORT:-6379}
password=${REDIS_PASSWORD}
db=${DB:-0}

url=redis://${password:+"$password@"}${host}:${port}/${db}

function _connect {
    redis-cli -u ${url}
}

function _export {
    echo url: $url

    rm -f $file

    keys=`redis-cli -u ${url} --csv KEYS "${key_pattern}"`

    for key in ${keys//,/ }
    do
        key=${key//\"}
        val=$(redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 GET $key | sed 's/"/\\"/g')
        ttl=$(redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0 TTL $key)
        echo "${key}${delim}${val}${delim}${ttl}" >> $FILE
    done
}

function _import {
    echo url: $url

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
