class CheckIfValidIp
  def execute(address)
    { success: address_valid_for_radius?(address) }
  end

private

  def address_valid_for_radius?(address)
    return false if address.nil?
    return false if address_is_subnet?(address)

    address_is_ipv4?(address)
  end

  def address_is_subnet?(address)
    address.include?("/")
  end

  def address_is_ipv4?(address)
    begin
      ip_object = IPAddr.new(address)
      ip_object.ipv4?
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end
