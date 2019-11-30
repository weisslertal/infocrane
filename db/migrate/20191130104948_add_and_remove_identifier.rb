class AddAndRemoveIdentifier < ActiveRecord::Migration[5.1]
  def change
    remove_column :cycles, :identifier, :integer
    add_column :steps, :identifier, :integer
  end
end
