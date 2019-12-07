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
    cycles_csv = load_file_to_csv(cycles_url)
    sensor_csv = load_file_to_csv(sensor_url)

    persist_cycle_data(cycles_csv)
    persist_sensor_data(sensor_csv)
  end

  def load_file_to_csv(url)
    puts "load_file_to_csv: #{url}"
    sensor_data = Net::HTTP.get(URI.parse(url))
    CSV.parse(sensor_data, headers: true)
  end

  def persist_sensor_data(sensor_csv)
    puts 'persist_sensor_data'
    validate_headers(sensor_csv.headers, VALID_SENSOR_HEADERS)

    sensor_csv.each do |row|
      SensorEvent.create!({
                              identifier: row['id'].to_i,
                              image_url: row['image_url'],
                              weight: row['weight'].to_d,
                              altitude: row['altitude'].to_d,
                              occurrence_time: DateTime.parse(row['event_timestamp']),
                              crane_id: Crane.find_or_create_by!(identifier: row['crane_id']).id
                          })
    end
  end

  def persist_cycle_data(cycle_csv)
    puts 'persist_cycle_data'
    validate_headers(cycle_csv.headers, VALID_CYCLE_HEADERS)

    cycle_csv.each do |row|
      cycle = Cycle.find_or_create!({
                                        start_time: DateTime.parse(row['start_time']),
                                        end_time: DateTime.parse(row['end_time']),
                                        crane_id: Crane.find_or_create_by!(identifier: row['crane_id']).id,
                                        load_type: LoadType.find_or_create_by_name_and_category(row['load_type_name'], row['load_type_category_name'])
                                    })

      Step.create!({ start_time: DateTime.parse(row['step_start_time']),
                     end_time: DateTime.parse(row['step_end_time']),
                     crane_operation: CraneOperation.find_or_create_by(number: row['step_num'].to_i),
                     identifier: row['id'].to_i,
                     cycle: cycle
                   })


    end
  end

  def validate_headers(headers, valid_headers)
    raise ActionController::BadRequest.new('Invalid CSV file headers') unless (headers - valid_headers).empty?
  end
end
