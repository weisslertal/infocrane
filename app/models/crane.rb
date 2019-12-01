class Crane < ApplicationRecord
  has_many :sensor_events
  has_many :cycles
  validates_uniqueness_of :identifier
end
