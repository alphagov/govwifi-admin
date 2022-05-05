class EmailGatewaySpy
  def not_sent?
    @last_used_parameters.nil?
  end

  attr_reader :last_used_parameters

  def last_confirmation_url
    @last_used_parameters.dig(:locals, :confirmation_url)
  end

  def last_invite_url
    @last_used_parameters.dig(:locals, :invite_url)
  end

  def send_email(opts)
    @last_used_parameters = opts
  end
end
