class Cycle < ApplicationRecord

  validates_uniqueness_of :cycles, scope: %i[start_time end_time crane_id]

end
