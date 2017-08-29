class User < ApplicationRecord


  def self.empty_shard_id_list
    User.where.not(shard_id: nil)
  end

end
