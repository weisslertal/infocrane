class LoadType < ApplicationRecord
  has_many :cycles

  def self.find_or_create_by_name_and_category(name, category)
    LoadType.find_or_create_by!(name: name&.titleize, category: category&.titleize)
  end
end
