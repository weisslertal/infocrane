class CraneOperation < ApplicationRecord
  has_many :steps
  validates_uniqueness_of :id, scope: %i[name category]
end
