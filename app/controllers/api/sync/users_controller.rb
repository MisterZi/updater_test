class Api::Sync::UsersController < ApplicationController

  # GET /api/sync/users/count
  def count
    render json: { nil_shard_id_count: User.empty_shard_id_list.count }
  end
end