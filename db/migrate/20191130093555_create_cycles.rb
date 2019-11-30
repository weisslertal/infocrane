class CreateCycles < ActiveRecord::Migration[5.1]
  def change
    create_table :cycles do |t|
      t.string :load_type_name
      t.string :load_type_category_name
      t.integer :identifier
      t.datetime :start_time
      t.datetime :end_time

      t.belongs_to :crane

      t.timestamps
    end
  end
end
