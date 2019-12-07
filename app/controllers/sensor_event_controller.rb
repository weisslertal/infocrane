class SensorEventController < ApplicationController
  require 'date'

  def altitude_at_time_range
    if params['time_from'].blank? ||  params['time_to'].blank? || params['crane_id'].blank?
      render(status: 400, json: { message: 'Missing parameters' }) && return
    end

    time_from = DateTime.strptime(params[:time_from],'%s')
    time_to = DateTime.strptime(params[:time_to],'%s')

    crane = Crane.find_by(identifier: params[:crane_id])
    render(status: 404, json: { message: 'Crane not found' }) && return if crane.blank?
    events = SensorEvent.where(occurrence_time: time_from..time_to, crane_id: crane.id)

    response = {
      time: events.pluck(:occurrence_time).map{|t| t.to_time.to_i},
      altitude: events.pluck(:altitude)
    }

    render status: 200, json: response
  end
end
