class Ip < ApplicationRecord
  belongs_to :user

  validates :address, presence: true
  validate :address_must_be_valid_ip

private

  def address_must_be_valid_ip
    checker = CheckIfValidIp.new
    valid_ip = checker.execute(self.address)[:success]
    errors.add(:address, 'must be valid IP address format') unless valid_ip
  end
end
