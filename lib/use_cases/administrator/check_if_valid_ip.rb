class CheckIfValidIp
  def execute(address)
    { success: address_valid?(address) }
  end

private

  def address_valid?(address)
    return false if address.nil?

    begin
      IPAddr.new(address)
      true
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end
