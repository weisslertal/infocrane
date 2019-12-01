class CreateLoadTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :load_types do |t|
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
