class RemoveLocatableTypeFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :locatable_type
  end

  def down
    add_column :locations, :locatable_type, :string
  end
end
