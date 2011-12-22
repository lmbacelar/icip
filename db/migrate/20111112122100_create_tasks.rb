class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :action
      t.string :etr
      t.string :comment
      t.integer :technician_id
      t.integer :inspection_id
      t.integer :item_id
      t.integer :checkpoint_id
      t.integer :closing_id

      t.timestamps
    end
  end
end
