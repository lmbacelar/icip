class RemoveLocatableIdFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :locatable_id
  end

  def down
    add_column :locations, :locatable_id, :integer
  end
end
