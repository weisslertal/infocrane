class Cycle < ApplicationRecord
  has_many :steps
  belongs_to :crane
  belongs_to :load_type
  validates_uniqueness_of :id, scope: %i[start_time end_time crane_id]

  def self.find_or_create!(cycle_params)
    self.where(start_time: cycle_params[:start_time],
                end_time: cycle_params[:end_time],
                crane_id: cycle_params[:crane_id]).first_or_create! do |cycle|
      cycle.load_type = LoadType.find_or_create_by_name_and_category(cycle_params[:load_type_name], cycle_params[:load_type_category_name])
    end
  end
end
