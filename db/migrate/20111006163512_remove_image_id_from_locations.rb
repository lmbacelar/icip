class RemoveImageIdFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :image_id
  end

  def down
    add_column :locations, :image_id, :integer
  end
end
