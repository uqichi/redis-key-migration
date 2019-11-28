# redis-key-migration

## Basic use

```bash
redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0

or

redis-cli -h localhost -p 6379 -n 0 -a ${REDIS_PASSWORD}
```

## How to use

```bash
export REDIS_HOST // default: localhost
export REDIS_PORT // default: 6379
export REDIS_DB   // default: 0
export REDIS_PASSWORD
```

### Connect

```bash
./redis-mig.sh connect
```

### Export

```bash
./redis-mig.sh export ./keys.bak "*user_tokens*"
```

### Import

```bash
./redis-mig.sh import ./keys.bak
```
