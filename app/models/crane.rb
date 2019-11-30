class Crane < ApplicationRecord
  def self.get_or_create(crane_id)
    Rails.cache.fetch("crane #{crane_id}", expires_in: 1.minute) do
      Crane.find_or_create_by!(identifier: crane_id.to_i)
    end
  end
end
