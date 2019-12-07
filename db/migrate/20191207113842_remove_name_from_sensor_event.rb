class RemoveNameFromSensorEvent < ActiveRecord::Migration[5.1]
  def change
    remove_column :sensor_events, :name, :string
  end
end
