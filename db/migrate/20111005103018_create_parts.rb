class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :number
      t.string :description

      t.timestamps
    end
  end
end
