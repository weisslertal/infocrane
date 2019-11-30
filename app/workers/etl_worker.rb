require 'sidekiq'
require 'csv'
require 'net/http'
require 'uri'

class EtlWorker
  include Sidekiq::Worker

  VALID_SENSOR_HEADERS = %w(
    id
    image_url
    weight
    altitude
    event_timestamp
    crane_id
  ).freeze

  VALID_CYCLE_HEADERS = %w(
    id
    crane_id
    start_time
    end_time
    load_type_name
    load_type_category_name
    step_num
    step_start_time
    step_end_time
  ).freeze

  def perform(params)
    logger.debug 'ETL start processing...'
    @params = params

    sensor_data = load_file('sensor')
    cycle_data = load_file('cycle')

    persist_sensor_data(sensor_data)
    persist_cycle_data(cycle_data)

  rescue EtlError => e
    render status: e.status, json: { message: e.message }
  rescue => e
    logger.error "ETL Worker failed to load data due to: #{e.inspect}"
    render status: :internal_server_error, json: { message: "Server error, please try again later" }
  end

  def persist_sensor_data(sensor_data)
    sensor_csv = CSV.parse(sensor_data, headers: true)
    validate_headers(sensor_csv.headers, VALID_SENSOR_HEADERS)
    sensor_csv.each do |row|
      SensorEvent.create!({
                              identifier: row['id'].to_i,
                              image_url: row['image_url'],
                              weight: row['weight'].to_d,
                              altitude: row['altitude'].to_d,
                              occurrence_time: DateTime.parse(row['event_timestamp']),
                              crane_id: Crane.get_or_create(row['crane_id']).id
                          })
    end
  end

  def validate_headers(headers, valid_headers)
    raise EtlError.new(:bad_request, 'Invalid CSV file headers') unless (headers - valid_headers).empty? 
  end

  def persist_cycle_data(cycle_data)
    cycle_csv = CSV.parse(cycle_data, headers: true)
    validate_headers(cycle_csv.headers, VALID_CYCLE_HEADERS)
    cycle_csv.each do |row|
      cycle = find_or_create_cycle(row)
      cycle.steps.create!({ start_time: DateTime.parse(row['step_start_time']),
                            end_time: DateTime.parse(row['step_end_time']),
                            step_number: row['step_num'].to_i,
                            identifier: row['id'].to_i
                          })


    end
  end

  def find_or_create_cycle(row)
    Cycle.where(start_time: DateTime.parse(row['start_time']),
                end_time: DateTime.parse(row['end_time']),
                crane_id: Crane.get_or_create(row['crane_id']).id).first_or_create! do |cycle|
      cycle.load_type_name = row['load_type_name']
      cycle.load_type_category_name = row['load_type_category_name']
    end
  end

  def load_file(file_name)
    url = @params["#{file_name}_data_url"]
    logger.debug "ETL loading file from url: #{url}"
    Net::HTTP.get(URI.parse(url))
  rescue URI::Error => e
    logger.error "Bad URI #{url}: #{e.message}"
    raise EtlError.new(:bad_request, "Invalid URL: #{url}")
  rescue URI::Error, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
    logger.error "Failed to load file from #{url} due to: #{e.inspect}"
    raise EtlError.new(:bad_request, "Couldn't upload file from #{url}")
  end
end