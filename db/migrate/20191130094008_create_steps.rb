class CreateSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :steps do |t|
      t.integer :step_number
      t.datetime :start_time
      t.datetime :end_time

      t.belongs_to :cycle

      t.timestamps
    end
  end
end
