class UsersController < ApplicationController
  TTL = 60

  def classic_caching
    age_param = params[:age].to_i
    key = User.where("age > :age", age: age_param).to_sql

    cached_data = RedisConnection.master.get(key)
    if cached_data
      users_count = JSON.parse(cached_data)["value"]
    else
      users_count = User.where("age > :age", age: age_param).count

      data = {
        value: users_count
      }.to_json
      RedisConnection.master.setex(key, TTL, data)
    end

    render json: users_count
  end

  def cache_stampede_mitigation
    age_param = params[:age].to_i

    query = -> { User.where("age > :age", age: age_param).count }

    users_count = CacheService.fetch(User.where("age > :age", age: age_param).to_sql, query, TTL)

    render json: users_count
  end

  def cache_stampede_mitigation_with_flag
    age_param = params[:age].to_i

    query = -> { User.where("age > :age", age: age_param).count }

    users_count = CacheWithFlagService.fetch(User.where("age > :age", age: age_param).to_sql, query, TTL)

    render json: users_count
  end
end
