class AddImageIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :image_id, :integer
  end
end
