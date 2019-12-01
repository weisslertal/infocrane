class SensorEvent < ApplicationRecord
  validates_uniqueness_of :id, scope: %i[crane_id occurrence_time]
  
end
