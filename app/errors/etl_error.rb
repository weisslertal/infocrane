class EtlError < StandardError
  attr_reader :status, :message

  def initialize(status, message)
    @status = status
    @message_key = message
  end
end