class DeleteColumnStepNumber < ActiveRecord::Migration[5.1]
  def change
    remove_column :steps, :step_number, :integer
  end
end
