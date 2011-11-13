class CreateClosings < ActiveRecord::Migration
  def change
    create_table :closings do |t|
      t.string :support_doc
      t.string :comments
      t.string :responsible

      t.timestamps
    end
  end
end
