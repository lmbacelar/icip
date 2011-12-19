class CreateTascs < ActiveRecord::Migration
  def change
    create_table :tascs do |t|
      t.string :action
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
