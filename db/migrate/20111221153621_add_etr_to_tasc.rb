class AddEtrToTasc < ActiveRecord::Migration
  def change
    add_column :tascs, :etr, :string
  end
end
