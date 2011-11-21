class CreateLocationAssignments < ActiveRecord::Migration
  def change
    create_table :location_assignments do |t|
      t.integer :location_id
      t.integer :locatable_id
      t.string :locatable_type

      t.timestamps
    end
  end
end
