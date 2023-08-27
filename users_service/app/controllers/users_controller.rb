class UsersController < ApplicationController
  TTL = 30

  def classic_caching
    key = 'classic_caching'

    cached_data = RedisConnection.master.get(key)
    if cached_data
      users_count = JSON.parse(cached_data)["value"]
    else
      users_count = MockDatabaseService.long_running_query("#{key}.txt")

      data = {
        value: users_count
      }.to_json
      RedisConnection.master.setex(key, TTL, data)
    end

    render json: users_count
  end

  def cache_stampede_mitigation
    key = 'cache_stampede_mitigation'

    query = -> { MockDatabaseService.long_running_query("#{key}.txt") }

    users_count = CacheService.fetch(key, query, TTL)

    render json: users_count
  end

  def cache_stampede_mitigation_with_flag
    key = 'cache_stampede_mitigation_with_flag'

    query = -> { MockDatabaseService.long_running_query("#{key}.txt") }

    users_count = CacheWithFlagService.fetch(key, query, TTL)

    render json: users_count
  end
end
