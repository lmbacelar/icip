class RenameConfigurationsToKonfigurations < ActiveRecord::Migration
  def change
    rename_table  :configurations, :konfigurations
  end
end
