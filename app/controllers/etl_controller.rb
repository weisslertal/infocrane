class EtlController < ApplicationController
  def load
    if params['sensor_data_url'].blank? || params['cycles_data_url'].blank?
      render(status: 400, json: { message: 'Missing parameters' }) && return
    end

    begin
      sensor_url = URI.parse(params['sensor_data_url'])
      cycle_url = URI.parse(params['cycles_data_url'])
    rescue URI::InvalidURIError => e 
      render(status: 400, json: { message: 'Invalid URL' }) && return 
    end

    Rails.logger.debug('Calling ETL worker...')
    EtlWorker.perform_async(sensor_url, cycle_url)

    render status: :accepted, json: { message: 'Request is being processed, this may take a while', status: 202 }
  end
end
