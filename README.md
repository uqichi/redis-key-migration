# redis-key-migration

## Setup

https://docs.aws.amazon.com/ja_jp/AmazonElastiCache/latest/red-ug/in-transit-encryption.html<Paste>

```bash
export REDIS_PASSWORD=XXXXXXXXXX
```

```bash
redis-cli -u redis://${REDIS_PASSWORD}@localhost:6379/0
```

## Exporting

```bash
FILE=keys.bak ./redis-mig.sh export
```

## Importing

```bash
FILE=keys.bak ./redis-mig.sh import
```
