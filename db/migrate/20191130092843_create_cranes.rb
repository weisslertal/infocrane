class CreateCranes < ActiveRecord::Migration[5.1]
  def change
    create_table :cranes do |t|
      t.integer :identifier

      t.timestamps
    end
  end
end
