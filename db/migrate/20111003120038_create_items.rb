class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :kind
      t.integer :zone_id
      t.integer :part_id

      t.timestamps
    end
  end
end
