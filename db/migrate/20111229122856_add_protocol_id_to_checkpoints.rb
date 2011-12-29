class AddProtocolIdToCheckpoints < ActiveRecord::Migration
  def change
    add_column :checkpoints, :protocol_id, :integer
  end
end
