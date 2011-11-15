class AddCompletedToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :completed, :boolean, :default => false
  end
end
