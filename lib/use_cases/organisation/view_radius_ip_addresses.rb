class ViewRadiusIPAddresses
  def execute
    validate_as_ip_addresses!(london_ips)
    validate_as_ip_addresses!(dublin_ips)

    { london: london_ips, dublin: dublin_ips }
  end

private

  def london_ips
    ENV.fetch('LONDON_RADIUS_IPS').split(',')
  end

  def dublin_ips
    ENV.fetch('DUBLIN_RADIUS_IPS').split(',')
  end

  def validate_as_ip_addresses!(addresses)
    addresses.each { |address| IPAddr.new(address) }
  end
end
