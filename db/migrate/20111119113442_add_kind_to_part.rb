class AddKindToPart < ActiveRecord::Migration
  def change
    add_column :parts, :kind, :string
  end
end
