#!/bin/bash

delim='|'

host=${REDIS_HOST:-localhost}
port=${REDIS_PORT:-6379}
db=${REDIS_DB:-0}
password=${REDIS_PASSWORD}

url=redis://${password:+"$password@"}${host}:${port}/${db}

function _connect {
    redis-cli -u ${url}
}

function _export {
    file=$1
    key_pattern=${2:-*}

    echo url: $url

    rm -f $file

    keys=`redis-cli -u ${url} --csv KEYS "${key_pattern}"`
    echo total keys: ${#keys[@]}

    for key in ${keys//,/ }
    do
        key=${key//\"}
        val=$(redis-cli -u ${url} GET $key | sed 's/"/\\"/g')
        ttl=$(redis-cli -u ${url} TTL $key)
        echo "${key}${delim}${val}${delim}${ttl}" >> $file
    done
}

function _import {
    file=$1

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
        _export $1 $2
        ;;
    import)
        _import $1
        ;;
    *)
        echo no such subcommand
        ;;
esac
