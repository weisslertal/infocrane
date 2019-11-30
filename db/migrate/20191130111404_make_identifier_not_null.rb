class MakeIdentifierNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column :cranes, :identifier, :integer, null: false
  end
end
