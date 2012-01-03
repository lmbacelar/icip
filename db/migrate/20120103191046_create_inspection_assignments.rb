class CreateInspectionAssignments < ActiveRecord::Migration
  def change
    create_table :inspection_assignments do |t|
      t.integer :user_id
      t.integer :inspection_id

      t.timestamps
    end
  end
end
