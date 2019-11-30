class SensorEventController < ApplicationController
  require 'date'

  def altitude_from_range
    time_from = DateTime.strptime(params[:time_from],'%s')
    time_to = DateTime.strptime(params[:time_to],'%s')

    render status: 200, json: SensorEvent.where(occurrence_time: time_from..time_to).pluck(:altitude)
  end
end
