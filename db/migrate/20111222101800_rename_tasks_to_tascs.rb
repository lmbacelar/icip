class RenameTasksToTascs < ActiveRecord::Migration
  def change
    rename_table  :tasks, :tascs
  end
end
