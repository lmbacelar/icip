class AddTechnicianIdToInspection < ActiveRecord::Migration
  def change
    add_column :inspections, :technician_id, :integer
  end
end
