class AddDescriptionToCheckpoints < ActiveRecord::Migration
  def change
    add_column :checkpoints, :description, :string
  end
end
