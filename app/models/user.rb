class User < ApplicationRecord

  def self.empty_shard_id_list
    User.where(shard_id: nil)
  end

end
