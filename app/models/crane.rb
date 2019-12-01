class Crane < ApplicationRecord
  def self.get_or_create(crane_id)
    self.find_or_create_by!(identifier: crane_id.to_i)
  end
end
