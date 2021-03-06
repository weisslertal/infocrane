class CraneController < ApplicationController
  def index
    render status: :ok, json: Crane.all.pluck(:identifier)
  end

  def data_at_time
    if params['timestamp'].blank? || params['crane_id'].blank?
      render(status: 400, json: { message: 'Missing parameters' }) && return
    end

    timestamp = DateTime.strptime(params['timestamp'],'%s')
    crane = Crane.find_by(identifier: params['crane_id'])
    
    sensor_event = SensorEvent.find_by(occurrence_time: timestamp, crane_id: crane.id)
    cycle = crane&.cycles&.where("start_time < ?", timestamp)&.where("end_time > ?", timestamp)&.first
    step = cycle&.steps&.where("start_time < ?", timestamp)&.where("end_time > ?", timestamp)&.first

    if step.blank? || sensor_event.blank?
      render(status: 404, json: { message: 'Data not found for this timestamp' }) && return
    end

    render status: :ok, json: extract_data_from_objects(sensor_event, cycle, step, crane, timestamp)
  end

  def extract_data_from_objects(sensor_event, cycle, step, crane, timestamp)
    {
        image_url: sensor_event[:image_url],
        weight: sensor_event[:weight],
        altitude: sensor_event[:altitude],
        load_type: cycle.load_type[:name],
        load_type_category: cycle.load_type[:category],
        step_number: step.crane_operation[:number],
        step_name: step.crane_operation[:name],
        time: timestamp,
        crane_number: crane[:identifier]
    }
  end
end
