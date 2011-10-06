class CreateImageAssignments < ActiveRecord::Migration
  def change
    create_table :image_assignments do |t|
      t.integer :image_id
      t.integer :imageable_id
      t.string :imageable_type

      t.timestamps
    end
  end
end
