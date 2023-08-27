class CacheService
  BETA = 1

  def self.fetch(key, query, ttl)
    value, delta, expiry = cache_read(key)

    if value.nil? || (Time.now.to_i - delta * BETA * Math.log(rand)) >= expiry
      start_time = Time.now.to_i

      value = query.call

      delta = Time.now.to_i - start_time

      cache_write(key, value, delta, ttl)
    end

    value
  end

  private

  def self.cache_read(key)
    cached_data = RedisConnection.slave.get(key)
    return [nil, nil, nil] unless cached_data

    data = JSON.parse(cached_data)
    [data["value"], data["delta"].to_i, data["expiry"].to_i]
  end

  def self.cache_write(key, value, delta, ttl)
    expiry = Time.now.to_i + ttl
    data = {
      value: value,
      delta: delta,
      expiry: expiry
    }.to_json

    RedisConnection.master.setex(key, ttl, data)
  end
end
