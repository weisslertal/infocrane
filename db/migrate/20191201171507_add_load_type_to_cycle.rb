class AddLoadTypeToCycle < ActiveRecord::Migration[5.1]
  def change
    add_reference :cycles, :load_type
  end
end
