class ViewRadiusIPAddresses
  def execute
    { london: london_IPs, dublin: dublin_IPs }
  end

  private

  def london_IPs
    ENV.fetch('LONDON_RADIUS_IPS').split(',')
  end

  def dublin_IPs
    ENV.fetch('DUBLIN_RADIUS_IPS').split(',')
  end
end
