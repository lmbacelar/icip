class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :x1, :default => 0
      t.float :y1, :default => 0
      t.float :x2, :default => 0
      t.float :y2, :default => 0
      t.integer :image_id
      t.integer :locatable_id
      t.string :locatable_type

      t.timestamps
    end
  end
end
