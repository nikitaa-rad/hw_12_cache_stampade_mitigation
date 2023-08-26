class UsersController < ApplicationController
  def index
    users = RedisConnection.slave.get("users")

    unless users
      users = User.all.to_json

      RedisConnection.master.set("users", users)
    end

    render json: users
  end
end
