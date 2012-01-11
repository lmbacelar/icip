class RemoveClosingIdFromTascs < ActiveRecord::Migration
  def up
    remove_column :tascs, :closing_id
  end

  def down
    add_column :tascs, :closing_id, :integer
  end
end
