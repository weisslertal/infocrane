class CreateCraneOperations < ActiveRecord::Migration[5.1]
  def change
    create_table :crane_operations do |t|
      t.integer :number
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
