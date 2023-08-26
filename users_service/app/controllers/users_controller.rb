class UsersController < ApplicationController
  def index
    users = ::UserCacheService.fetch_all

    render json: users
  end
end
