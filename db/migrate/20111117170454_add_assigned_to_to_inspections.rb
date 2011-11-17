class AddAssignedToToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :assigned_to, :string
  end
end
