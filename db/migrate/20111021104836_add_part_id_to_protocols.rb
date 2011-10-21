class AddPartIdToProtocols < ActiveRecord::Migration
  def change
    add_column :protocols, :part_id, :integer
  end
end
