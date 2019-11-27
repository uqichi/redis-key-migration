# redis-key-migration

## Basic

```bash
export REDIS_PASSWORD=XXXXXXXXXX
```

```bash
redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0
```

## Connecting

```bash
./redis-mig.sh connect
```

## Exporting

```bash
FILE=keys.bak ./redis-mig.sh export
```

## Importing

```bash
FILE=keys.bak ./redis-mig.sh import
```

## Full Example


```bash
HOST=localhost PORT=6379 REDIS_PASSWORD=xxxxx DB=0 KEY_PATTERN="*user_tokens*" FILE=keys.bak ./redis-mig.sh export
