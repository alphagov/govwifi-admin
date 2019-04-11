class Ip < ApplicationRecord
  belongs_to :location

  validates :address, presence: true, uniqueness: true
  validate :address_must_be_valid_ip

  def available?
    created_at < Date.today.beginning_of_day
  end

private

  def address_must_be_valid_ip
    checker = UseCases::Administrator::CheckIfValidIp.new
    valid_ipv4 = checker.execute(self.address)[:success]
    valid_ipv6 = checker.execute(self.address)[:ipv6?]
    ipv6_message = "'#{self.address}' is an IPv6 address. Only IPv4 addresses can be added."
    return errors.add(:address, ipv6_message) if valid_ipv6

    message = "'#{self.address}' is not valid"
    errors.add(:address, message) unless valid_ipv4
  end
end
