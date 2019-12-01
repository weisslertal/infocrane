class DeleteColumnLoadType < ActiveRecord::Migration[5.1]
  def change
    remove_column :cycles, :load_type_name, :string
    remove_column :cycles, :load_type_category_name, :string
  end
end
