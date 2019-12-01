class AddOperationToStep < ActiveRecord::Migration[5.1]
  def change
    add_reference :steps, :crane_operation
  end
end
