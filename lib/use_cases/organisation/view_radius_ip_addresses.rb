class ViewRadiusIPAddresses
  def execute
    validate_as_IP_addresses!(london_IPs)
    validate_as_IP_addresses!(dublin_IPs)

    { london: london_IPs, dublin: dublin_IPs }
  end

  private

  def london_IPs
    ENV.fetch('LONDON_RADIUS_IPS').split(',')
  end

  def dublin_IPs
    ENV.fetch('DUBLIN_RADIUS_IPS').split(',')
  end

  def validate_as_IP_addresses!(addresses)
    addresses.each{ |address| IPAddr.new(address) }
  end
end
