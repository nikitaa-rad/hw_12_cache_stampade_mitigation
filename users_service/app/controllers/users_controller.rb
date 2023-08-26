class UsersController < ApplicationController
  def index
    age_param = params[:age].to_i

    query = -> { User.where("age > :age", age: age_param).count }

    users_count = CacheService.fetch(User.where("age > :age", age: age_param).to_sql, query)

    render json: users_count
  end
end
