class User < ApplicationRecord

  def self.empty_shard_id_list
    User.where(shard_id: nil).order(:id)
  end

  def self.not_include(users = User.all, exclusion_ids)
    users.where('id NOT IN (?)', exclusion_ids)
  end

  def update_shard_id
    self.shard_id = rand(1..10)
    save!
  end

end
