class CreateClosings < ActiveRecord::Migration
  def change
    create_table :closings do |t|
      t.string :support_doc
      t.string :comments
      t.integer :engineer_id

      t.timestamps
    end
  end
end
