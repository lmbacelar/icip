class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.integer :number
      t.string  :description, :limit => 255
      t.integer :aircraft_id

      t.timestamps
    end
  end
end
