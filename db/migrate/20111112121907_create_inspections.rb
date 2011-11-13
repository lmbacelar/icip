class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.integer :zone_id

      t.timestamps
    end
  end
end
