class CreateSensorEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :sensor_events do |t|
      t.string :name
      t.string :image_url
      t.decimal :weight
      t.decimal :altitude
      t.datetime :occurrence_time

      t.belongs_to :crane

      t.timestamps
    end
  end
end
