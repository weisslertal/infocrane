module EtlHelper
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

  def execute_etl(sensor_url, cycles_url)
    sensor_csv = load_file_to_csv(sensor_url)
    cycles_csv = load_file_to_csv(cycles_url)

    persist_sensor_data(sensor_csv)
    persist_cycle_data(cycles_csv)
  end

  def persist_sensor_data(sensor_csv)
    validate_headers(sensor_csv.headers, VALID_SENSOR_HEADERS)

    puts "Persist sensor data"
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
    raise ActionController::BadRequest.new('Invalid CSV file headers') unless (headers - valid_headers).empty?
  end

  def persist_cycle_data(cycle_csv)
    validate_headers(cycle_csv.headers, VALID_CYCLE_HEADERS)

    puts "Persist cycles data"
    cycle_csv.each do |row|
      cycle = Cycle.find_or_create!({
                                        start_time: DateTime.parse(row['start_time']),
                                        end_time: DateTime.parse(row['end_time']),
                                        crane_id: Crane.get_or_create(row['crane_id']).id,
                                        load_type_name: row['load_type_name'],
                                        load_type_category_name: row['load_type_category_name']
                                    })

      Step.create!({ start_time: DateTime.parse(row['step_start_time']),
                     end_time: DateTime.parse(row['step_end_time']),
                     step_number: row['step_num'].to_i,
                     identifier: row['id'].to_i,
                     cycle_id: cycle.id
                   })


    end
  end

  def load_file_to_csv(url)
    logger.debug "ETL loading file from url: #{url}"
    puts "ETL loading file from url: #{url}"
    sensor_data = Net::HTTP.get(URI.parse(url))
    CSV.parse(sensor_data, headers: true)
  end
end
