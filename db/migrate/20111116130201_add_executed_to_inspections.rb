class AddExecutedToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :executed, :boolean, :default => false
  end
end
