class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string  :name,                :limit => 2
      t.string  :description,         :limit => 50
      t.integer :inspection_interval
      t.integer :configuration_id

      t.timestamps
    end
  end
end
