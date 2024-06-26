class EmailGatewaySpy
  attr_reader :last_message

  def not_sent?
    @last_message.nil?
  end

  def last_confirmation_url
    @last_message.dig(:personalisation, :confirmation_url)
  end

  def last_invite_url
    @last_message.dig(:personalisation, :invite_url)
  end

  def last_reset_password_url
    @last_message.dig(:personalisation, :reset_url)
  end

  def send_email(opts)
    @last_used_parameters = opts
    @last_message = opts
  end
  end
end
