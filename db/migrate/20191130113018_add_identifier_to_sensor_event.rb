class AddIdentifierToSensorEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :sensor_events, :identifier, :integer, null: false
  end
end
