class CreateProtocols < ActiveRecord::Migration
  def change
    create_table :protocols do |t|
      t.integer :revnum
      t.string :author
      t.text :notes

      t.timestamps
    end
  end
end
