class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :action
      t.string :comment
      t.string :technician
      t.integer :inspection_id
      t.integer :item_id
      t.integer :checkpoint_id
      t.integer :closing_id

      t.timestamps
    end
  end
end
