class UsersController < ApplicationController

  # GET /api/sync/users/count
  def count
    render json: { nil_count: User.empty_shard_id_list.count }
  end
end