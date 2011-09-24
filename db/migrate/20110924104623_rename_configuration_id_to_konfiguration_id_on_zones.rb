class RenameConfigurationIdToKonfigurationIdOnZones < ActiveRecord::Migration
  def change
    rename_column :zones, :configuration_id, :konfiguration_id
  end
end
