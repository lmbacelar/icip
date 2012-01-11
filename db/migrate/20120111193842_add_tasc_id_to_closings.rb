class AddTascIdToClosings < ActiveRecord::Migration
  def change
    add_column :closings, :tasc_id, :integer
  end
end
