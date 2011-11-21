class RemoveKindFromItem < ActiveRecord::Migration
  def up
    remove_column :items, :kind
  end

  def down
    add_column :items, :kind, :string
  end
end
