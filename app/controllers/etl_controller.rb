class EtlController < ApplicationController
  def load
    Rails.logger.debug('Calling ETL worker...')
    EtlWorker.perform_async(params['sensor_data_url'], params['cycles_data_url'])

    render status: :accepted, json: { message: 'Request is being processed, this may take a few moments', status: 202 }
  end
end
