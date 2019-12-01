require 'sidekiq'
require 'csv'
require 'net/http'
require 'uri'

class EtlWorker
  include Sidekiq::Worker
  include EtlHelper

  def perform(sensor_url, cycles_url)
    Rails.logger.debug('Starting ETL...')
    puts 'Starting ETL'
    execute_etl(sensor_url, cycles_url)
  rescue => e
    logger.error "ETL Worker failed to load data due to: #{e.message} with backtrace: #{e.backtrace}"
  end
end