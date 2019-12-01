class SensorEventController < ApplicationController
  require 'date'

  def altitude_at_range
    time_from = DateTime.strptime(params[:time_from],'%s')
    time_to = DateTime.strptime(params[:time_to],'%s')

    crane = Crane.find_by(identifier: params[:crane_id])
    render(status: 404, json: { message: 'Crane not found' }) && return if crane.blank?

    render status: 200, json: SensorEvent.where(occurrence_time: time_from..time_to, crane_id: crane.id).pluck(:altitude)
  end
end
