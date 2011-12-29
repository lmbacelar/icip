class RemoveCheckpointableTypeAndCheckpointableIdFromCheckpoints < ActiveRecord::Migration
  def up
    remove_column :checkpoints, :checkpointable_type
    remove_column :checkpoints, :checkpointable_id
  end

  def down
    add_column :checkpoints, :checkpointable_id, :integer
    add_column :checkpoints, :checkpointable_type, :string
  end
end
