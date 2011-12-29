class RemoveNumberDescriptionFromCheckpoints < ActiveRecord::Migration
  def up
    remove_column :checkpoints, :number
    remove_column :checkpoints, :description
  end

  def down
    add_column :checkpoints, :description, :string
    add_column :checkpoints, :number, :string
  end
end
