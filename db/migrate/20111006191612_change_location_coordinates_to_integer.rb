class ChangeLocationCoordinatesToInteger < ActiveRecord::Migration
  def up
    change_table :locations do |t|
      t.change :x1, :integer
      t.change :y1, :integer
      t.change :x2, :integer
      t.change :y2, :integer
    end
  end

  def down
    change_table :locations do |t|
      t.change :x1, :float
      t.change :y1, :float
      t.change :x2, :float
      t.change :y2, :float
    end
  end
end
