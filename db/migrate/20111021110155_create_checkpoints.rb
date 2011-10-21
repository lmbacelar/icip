class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.string :number
      t.integer :checkpointable_id
      t.string :checkpointable_type

      t.timestamps
    end
  end
end
