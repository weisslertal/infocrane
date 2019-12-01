class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :crane_operations, :type, :operation_type
  end
end
