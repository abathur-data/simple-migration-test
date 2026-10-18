# Oracle Free → Logstash → OpenSearch: Apple Silicon local PoC

- Oracle `gvenzl/oracle-free:23.26.3-slim` (ARM64)
- Logstash `8.19.23` + OpenSearch output plugin
- OpenSearch `3.9.0` (ARM64)
- OJDBC `19.32.0.0` (downloaded separately)

> **Only for a local lab.** OpenSearch security is disabled and password examples are not secure. Both exposed ports are localhost-only.

## Requirements

Docker Desktop for Apple Silicon; allocate approximately 10–12 GB of memory. Run these commands from the directory containing `compose.yaml`.

## 1. Download OJDBC

```bash
curl -fL --retry 3 \
  -o logstash/ojdbc8.jar \
  https://repo.maven.apache.org/maven2/com/oracle/database/jdbc/ojdbc8/19.32.0.0/ojdbc8-19.32.0.0.jar
```

## 2. Start databases

```bash
docker compose up -d oracle opensearch
docker compose ps
curl http://localhost:9200
```

Wait until both services are `healthy`.

## 3. Load Oracle sample data **once**

```bash
docker compose exec -T oracle \
  sqlplus -s 'appuser/Test123!@//localhost:1521/FREEPDB1' < oracle/init.sql

docker compose exec -T oracle \
  sqlplus -s 'appuser/Test123!@//localhost:1521/FREEPDB1' <<'SQL'
SELECT COUNT(*) AS cnt FROM customers;
EXIT;
SQL
```

If you change the sample password in `.env`, change the quoted `sqlplus` connection argument accordingly. Do not run the CREATE TABLE script twice unless you first drop the table.

## 4. Start Logstash

```bash
docker compose up -d --build logstash
docker compose logs -f logstash
```

The JDBC query runs **every minute**. The Oracle `id` becomes the OpenSearch `_id`, avoiding duplicate documents on repeated loads.

## 5. Verify OpenSearch

```bash
curl 'http://localhost:9200/customers/_count?pretty'
curl 'http://localhost:9200/customers/_search?pretty'
```

Expect a count of `3` after the first successful Logstash polling cycle.

## 6. Clean up

```bash
docker compose down
```

Keeps named volumes. `docker compose down -v` **permanently deletes** Oracle and OpenSearch test data.
