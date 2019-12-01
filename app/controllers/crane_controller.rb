class CraneController < ApplicationController
  def data_at_time
    timestamp = DateTime.strptime(params['timestamp'],'%s')

    sensor_event = SensorEvent.find_by(occurrence_time: timestamp)
    render(status: 404, json: { message: 'Sensor event not found' }) && return if sensor_event.blank?

    crane = Crane.find_by(identifier: params['crane_id'])
    render(status: 404, json: { message: 'Crane not found' }) && return if crane.blank?

    cycle = Cycle.where(crane_id: crane.id).where("start_time < ?", timestamp).where("end_time > ?", timestamp).first
    render(status: 404, json: { message: 'Cycle not found' }) && return if cycle.blank?

    step = Step.where(cycle_id: cycle.id).where("start_time < ?", timestamp).where("end_time > ?", timestamp).first
    render(status: 404, json: { message: 'Step not found' }) && return if step.blank?

    response = { image_url: sensor_event[:image_url],
                 weight: sensor_event[:weight],
                 altitude: sensor_event[:altitude],
                 load_type: cycle[:load_type_name],
                 load_type_category: cycle[:load_type_category_name],
                 step_number: step[:step_number],
                 time: timestamp,
                 crane_number: crane[:identifier]
    }

    render status: :ok, json: response
  end
end
