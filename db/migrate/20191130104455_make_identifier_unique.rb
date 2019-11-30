class MakeIdentifierUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :cranes, :identifier, unique: true
  end
end
