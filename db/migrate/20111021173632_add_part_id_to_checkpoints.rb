class AddPartIdToCheckpoints < ActiveRecord::Migration
  def change
    add_column :checkpoints, :part_id, :integer
  end
end
