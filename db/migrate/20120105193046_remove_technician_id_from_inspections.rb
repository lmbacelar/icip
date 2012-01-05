class RemoveTechnicianIdFromInspections < ActiveRecord::Migration
  def up
    remove_column :inspections, :technician_id
  end

  def down
    add_column :inspections, :technician_id, :integer
  end
end
