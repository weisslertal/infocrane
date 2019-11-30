class EtlController < ApplicationController
  def load
    EtlWorker.perform_async(params)

    render status: :accepted, json: { message: 'Request is being processed, this may take a few moments', status: 202 }
  end
end
