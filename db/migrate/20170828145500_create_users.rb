class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :shard_id, :null => true

      t.timestamps
    end
  end
end
