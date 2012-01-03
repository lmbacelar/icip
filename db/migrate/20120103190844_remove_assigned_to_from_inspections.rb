class RemoveAssignedToFromInspections < ActiveRecord::Migration
  def up
    remove_column :inspections, :assigned_to
  end

  def down
    add_column :inspections, :assigned_to, :string
  end
end
