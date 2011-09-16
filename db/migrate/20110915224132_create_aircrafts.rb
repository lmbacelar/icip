class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.string :registration, :limit => 10
      t.string :manufacturer, :limit => 50
      t.string :model,        :limit => 50

      t.timestamps
    end
  end
end
