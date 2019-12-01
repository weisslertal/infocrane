class Step < ApplicationRecord
  validates_uniqueness_of :id, scope: %i[cycle_id start_time]

  belongs_to :cycle
  belongs_to :crane_operation
end
