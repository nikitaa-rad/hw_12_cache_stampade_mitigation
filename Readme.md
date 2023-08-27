# Cache Stampede Mitigation Testing

This project provides a setup to test the [cache stampede mitigation algorithm](https://en.wikipedia.org/wiki/Cache_stampede) using a Redis cluster with Sentinel and a Ruby application with a single endpoint.

You can replace the header in your existing `README.md` with the updated one above.
This project provides a setup to test the cache stampede mitigation algorithm using a Redis cluster with Sentinel and a Ruby application with a single endpoint.

## Project Structure

- **Redis Cluster**: Comprises of a master, a slave, and three sentinel instances.
- **Ruby Application**: Contains a single endpoint to test three different caching approaches.
- **MySQL Database**: Used as the primary database for the Ruby application.

## Setup

The entire stack is orchestrated using Docker Compose. The configuration can be found in the `docker-compose.yml` file.

### Services

- `users_service`: The main Ruby application.
- `db`: MySQL 8.0 database.
- `redis-master`: Redis master node.
- `redis-slave`: Redis slave node.
- `redis-sentinel`, `redis-sentinel2`, `redis-sentinel3`: Three Redis sentinel instances.

## Caching Approaches

The `UsersController` in the Ruby application implements three caching approaches:

1. **Classic Caching**: A traditional caching mechanism.
2. **Cache Stampede Mitigation**: Implements the cache stampede mitigation algorithm.
3. **Cache Stampede Mitigation with Flag**: Enhances the cache stampede mitigation algorithm with a flag to indicate ongoing recomputation.

## Mock Database Service

The actual database query is mocked using the `MockDatabaseService` to simulate a long-running database operation.

## Testing

To test the caching mechanisms, use the provided scripts:

- `testing/scripts/cache_stampede_mitigation.sh`
- `testing/scripts/cache_stampede_mitigation_with_flag.sh`
- `testing/scripts/classic_caching.sh`

Each script internally uses `siege` to simulate traffic to the respective endpoints. For example:

```
siege http://localhost:3000/users/classic_caching -c 25 -t 3m
```

## Results

The results of the benchmarking tests for the three caching strategies are as follows:

### 1. Classic Caching

- **Transactions**: 11359 hits
- **Availability**: 100.00%
- **Elapsed Time**: 180.53 secs
- **Response Time**: 0.40 secs
- **Transaction Rate**: 62.92 trans/sec
- **Concurrency**: 24.97
- **Longest Transaction**: 3.74 secs
- **Shortest Transaction**: 0.24 secs

**Database Hits**:
The `classic_caching` method had multiple database hits at intervals, indicating that when the cache expired, multiple requests went to the database simultaneously. Sample hits:
```
database hit at 2023-08-27 16:51:06 +0000
database hit at 2023-08-27 16:51:39 +0000
...
```

### 2. Cache Stampede Mitigation

- **Transactions**: 11514 hits
- **Availability**: 100.00%
- **Elapsed Time**: 180.12 secs
- **Response Time**: 0.39 secs
- **Transaction Rate**: 63.92 trans/sec
- **Concurrency**: 24.97
- **Longest Transaction**: 3.66 secs
- **Shortest Transaction**: 0.26 secs

**Database Hits**:
The `cache_stampede_mitigation` method had fewer simultaneous database hits, showcasing the effectiveness of the probabilistic early expiration strategy. Sample hits:
```
database hit at 2023-08-27 16:55:41 +0000
database hit at 2023-08-27 16:55:56 +0000
...
```

### 3. Cache Stampede Mitigation with Flag

- **Transactions**: 13162 hits
- **Availability**: 100.00%
- **Elapsed Time**: 180.79 secs
- **Response Time**: 0.34 secs
- **Transaction Rate**: 72.80 trans/sec
- **Concurrency**: 24.96
- **Longest Transaction**: 3.41 secs
- **Shortest Transaction**: 0.24 secs

**Database Hits**:
The `cache_stampede_mitigation_with_flag` method had the least simultaneous database hits, indicating that the flag effectively prevented multiple requests from accessing the database at the same time. Sample hits:
```
database hit at 2023-08-27 16:59:00 +0000
database hit at 2023-08-27 16:59:13 +0000
...
```

---

**Conclusion**:
The results indicate that the Cache Stampede Mitigation with Flag strategy is the most effective in preventing cache stampedes, as evidenced by the highest transaction rate and the least simultaneous database hits.