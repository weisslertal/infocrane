class Cycle < ApplicationRecord
  validates_uniqueness_of :id, scope: %i[start_time end_time crane_id]

  def self.find_or_create!(cycle_params)
    self.where(start_time: cycle_params[:start_time],
                end_time: cycle_params[:end_time],
                crane_id: cycle_params[:crane_id]).first_or_create! do |cycle|
      cycle.load_type_name = cycle_params[:load_type_name]
      cycle.load_type_category_name = cycle_params[:load_type_category_name]
    end
  end
end
