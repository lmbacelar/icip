class AddExecutionDateToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :execution_date, :timestamp
  end
end
